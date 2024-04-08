<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
	if(session.getAttribute("loginEmp")==null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>
<% 
	//DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","java1234");
	
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	String empId[] = null;
	
	String sql = "select category,create_date createDate,emp_id empId,grade from category";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery(); // JDBC API 종속된 자료구조 모델 ResultSet -> 기본API 자료구조(ArrayList)로 변경	
	ArrayList<HashMap<String,Object>> categoryList = new ArrayList<HashMap<String,Object>>();
	int i = 0;
	while (rs.next()){
		HashMap<String,Object> m = new HashMap<String,Object>();
		m.put("category",rs.getString("category"));
		m.put("createDate",rs.getString("createDate"));
		m.put("empId",rs.getString("empId"));
		m.put("grade",rs.getInt("grade"));
		
		categoryList.add(m);
	}	

	
	
%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title></title>
	<style>
	table{
	  border: 1px solid;
	}

	
	</style>
</head>
<body>
	<!-- empMenu.jsp include : 주체(서버) vs redirect(주체:클라이언트) -->
	<div>
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	<h1> 카테고리 목록 </h1>	
	<a href="/shop/emp/empLogout.jsp">로그아웃</a>
	<table border="1">
		<tr>
			<th>카테고리이름</th>
			<th>만든사람</th>
			<th>만든날짜</th>
		</tr>
	
		<%
			for(HashMap<String, Object>m : categoryList){
		%>
			<tr>
				<td><%=(String)(m.get("category"))%></td> 
				<td><%=(String)(m.get("empId"))%></td>		
				<td><%=(String)(m.get("createDate"))%></td>		
				<td>&nbsp;</td>
				<%			
				if((Integer)(m.get("grade")) > 0) {
				%>
				<td><a href="/diary/updateDiaryForm.jsp?category=<%=(String)(m.get("category"))%>" class="btn btn-outline-info">수정</a></td>
				<td><a href="/shop/emp/category/deleteCategoryAction.jsp?category=<%=(String)(m.get("category"))%>" class="btn btn-outline-danger">삭제</a></td>		
				<% 
				}
				%>
			</tr>		
		<%		
			}
		%>			
	</table>
	
	<div>
	<a href="/diary/updateCategoryForm.jsp>" class="btn btn-outline-warning">추가</a>	
	</div>
</body>
</html>