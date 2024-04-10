<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
	if(session.getAttribute("loginEmp")==null){ //로그인이 안되어있으면
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
	int rowPerPage = 10;
	int startRow = ((currentPage-1)*rowPerPage);	
	
	
	//totalRow를 구하는 sql
	String sqlPaging = "select count(*) from emp";
	PreparedStatement stmtPaging = null;
	ResultSet rsPaging = null;
	stmtPaging = conn.prepareStatement(sqlPaging);
	rsPaging = stmtPaging.executeQuery();
	int totalRow = 0;
	
	if(rsPaging.next()){
		totalRow = rsPaging.getInt("count(*)");
	}
	System.out.println(totalRow+ "<-totalRow [empList]");	
	
	int lastPage = totalRow / rowPerPage; // 전체페이지수
	if(totalRow%rowPerPage !=0){   // 딱 나눠떨어지지않으면 한페이지가 새로 추가됌
		lastPage = lastPage+1;		
	}
	System.out.println(lastPage+ "<-lastPage [empList]");
%>

<%	
	// 특수한 형태의 데이터(RDBMS:mariaDB)
	// -> API사용 (JDBC API)하여 자료구조 (ResultSet)취득
	// -> 일반화된 자료구조 (ArrayList<HashMap>로 변경 -> 모델 취득	
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	String sql = "select emp_id empID,emp_name empName,emp_job empJob,hire_date hireDate,active from emp order by hire_date asc limit ?,?";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1,startRow);
	stmt.setInt(2,rowPerPage);
	rs = stmt.executeQuery(); // JDBC API 종속된 자료구조 모델 ResultSet -> 기본API 자료구조(ArrayList)로 변경	

	// ResultSet 변경-> ArrayList<HashMap<String, Object>>
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empId",rs.getString("empId"));
		m.put("empName",rs.getString("empName"));
		m.put("empJob",rs.getString("empJob"));
		m.put("hireDate",rs.getString("hireDate"));
		m.put("active",rs.getString("active"));
		list.add(m);
	}// JDBC API 사용이 끝났으므로 DB자원 반납 가능	
%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="/shop/SHOP.css" rel="stylesheet">
	<title>사원리스트</title>
	<style>
	table, th, td {
	  border: 1px solid;
	}
	
	</style>
</head>
<body class="container bg">
<div class="content">
	<!-- empMenu.jsp include : 주체(서버) vs redirect(주체:클라이언트) -->
	<div >
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	<div class="in">
	<h1> 사원 목록 </h1>	
	<a href="/shop/action/logout.jsp">로그아웃</a>
	<table>
		<tr>
			<th>회원ID</th>
			<th>이름</th>
			<th>직업</th>
			<th>고용날짜</th>
			<th>활성화상태</th>
		</tr>
	
		<%
			for(HashMap<String, Object>m : list){
		%>
			<tr style=border:solid>
				<td><%=(String)(m.get("empId"))%></td>
				<td><%=(String)(m.get("empName"))%></td>
				<td><%=(String)(m.get("empJob"))%></td>
				<td><%=(String)(m.get("hireDate"))%></td>
				<td>
				<%
				HashMap<String, Object> sm = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
				if((Integer)(sm.get("grade")) >= 10) {
				%>	<a href="/shop/actoin/modifyEmpActive.jsp?empId=<%=(String)(m.get("empId"))%>&active=<%=(String)(m.get("active"))%>"
					class="disabled">
					<%=(String)(m.get("active"))%>
					</a>					
				<%
				}
				%>	
				</td>
			</tr>		
		<%		
			}
		%>			
	</table>
	
	<div>
	<a href="/shop/emp/updateEmpForm.jsp>" class="btn btn-outline-info">추가</a>
	<a href="/shop/emp/updateEmpForm.jsp>" class="btn btn-outline-info">수정</a>
	<a href="/shop/action/deleteEmpAction.jsp>" class="btn btn-outline-info">삭제</a>
	
	</div>
	
	<ul>
	<%
		if(currentPage > 1) {
	%>
		<li>
			<a href="/shop/emp/empList.jsp?currentPage=1">처음페이지</a>
		</li>
		<li class="page-item">
			<a href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
		</li>																
	<%		
		} else {
	%>
		<li class="page-item disabled">
			<a href="/shop/emp/empList.jsp?currentPage=1">처음페이지</a>
		</li>
		<li>
			<a href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
		</li>
	<%		
		}				
		if(currentPage < lastPage) {
	%>
		<li>
			<a href="/shop/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음페이지</a>
		</li>
		<li>
			<a href="/shop/emp/empList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
		</li>
	<%		
		}
	%>
	</ul>
	</div>
	
</div>	
<%System.out.println("----------------------------------------");%>
</body>
</html>