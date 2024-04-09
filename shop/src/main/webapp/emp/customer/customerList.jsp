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
	
	// 페이징
	int currentPage = 1;	
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 5;
	int startRow = ((currentPage-1)*rowPerPage);	
	
	
	//totalRow를 구하는 sql
	String sqlPaging = "select count(*) from customer";
	PreparedStatement stmtPaging = null;
	ResultSet rsPaging = null;
	stmtPaging = conn.prepareStatement(sqlPaging);
	rsPaging = stmtPaging.executeQuery();
	int totalRow = 0;
	
	if(rsPaging.next()){
		totalRow = rsPaging.getInt("count(*)");
	}
	//System.out.println(totalRow+ "<-totalRow");	
	
	int lastPage = totalRow / rowPerPage; // 전체페이지수
	if(totalRow%rowPerPage !=0){   // 딱 나눠떨어지지않으면 한페이지가 새로 추가됌
		lastPage = lastPage+1;		
	}
	System.out.println(lastPage+ "<-lastPage");
%>

<%	
	// 특수한 형태의 데이터(RDBMS:mariaDB)
	// -> API사용 (JDBC API)하여 자료구조 (ResultSet)취득
	// -> 일반화된 자료구조 (ArrayList<HashMap>로 변경 -> 모델 취득	
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	String sql = "select * from customer limit ?,?";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1,startRow);
	stmt.setInt(2,rowPerPage);
	rs = stmt.executeQuery(); // JDBC API 종속된 자료구조 모델 ResultSet -> 기본API 자료구조(ArrayList)로 변경	

	// ResultSet 변경-> ArrayList<HashMap<String, Object>>
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("id",rs.getString("id"));
		m.put("name",rs.getString("name"));
		m.put("birth",rs.getString("birth"));
		m.put("gender",rs.getString("gender"));
		m.put("create_date",rs.getString("create_date"));
		m.put("update_date",rs.getString("update_date"));
		m.put("pw",rs.getString("pw"));
		list.add(m);
	}// JDBC API 사용이 끝났으므로 DB자원 반납 가능	
%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="/shop/SHOP.css" rel="stylesheet">
	<title></title>
	<style>
	table, th, td {
	  border: 1px solid;
	  text-align:center;
	}
	
	</style>
</head>
<body class="container bg">
<div class="content">
	<div>
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	<div class="in">
	<h1> 고객 목록 </h1>	
	<a href="/shop/logout.jsp">로그아웃</a>
	<table style="margin-left: 10px" >
		<tr>
			<th>이름</th>
			<th>아이디</th>
			<th>성별</th>
			<th>생일</th>
			<th>생성날짜</th>
			<th>변경날짜</th>
			<th>비밀번호</th>
		</tr>
	
		<%
			for(HashMap<String, Object>m : list){
		%>
			<tr style=border:solid >
				<td><%=(String)(m.get("id"))%></td>
				<td><%=(String)(m.get("name"))%></td>
				<td><%=(String)(m.get("birth"))%></td>
				<td><%=(String)(m.get("gender"))%></td>
				<td><%=(String)(m.get("create_date"))%></td>
				<td><%=(String)(m.get("update_date"))%></td>
				<td><%=(String)(m.get("pw"))%></td>				
			</tr>		
		<%		
			}
		%>			
	</table>
	
	<div>
	<a href="/shop/emp/customer/customerList.jsp" class="btn btn-outline-info">추가</a>
	<a href="/shop/emp/customer/updateCustomerPassword.jsp" class="btn btn-outline-warning">비밀번호암호화</a>
	<a href="/shop/emp/customer/customerList.jsp" class="btn btn-outline-info">삭제</a>
	
	</div>
	<nav aria-label="Page navigation example">
	<ul class="pagination justify-content-center">
	<%
		if(currentPage > 1) {
	%>
		<li class="page-item">
			<a class ="page-link" href="/shop/emp/customer/customerList.jsp?currentPage=1">처음페이지</a>
		</li>
		<li class="page-item">
			<a class ="page-link" href="/shop/emp/customer/customerList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
		</li>																
	<%		
		} else {
	%>
		<li class="page-item disabled">
			<a class ="page-link" href="/shop/emp/customer/customerList.jsp?currentPage=1">처음페이지</a>
		</li>
		<li class="page-item">
			<a class ="page-link" href="/shop/emp/customer/customerList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
		</li>
	<%		
		}				
		if(currentPage < lastPage) {
	%>
		<li class="page-item">
			<a class ="page-link" href="/shop/emp/customer/customerList.jsp?currentPage=<%=currentPage+1%>">다음페이지</a>
		</li>
		<li class="page-item disabled">
			<a class ="page-link" href="/shop/emp/customer/customerList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
		</li>
	<%		
		}
	%>
	</ul>
	</nav>
	</div>
</div>	
</body>
</html>