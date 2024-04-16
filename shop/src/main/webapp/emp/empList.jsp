<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "shop.dao.EmpDAO" %>
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
	ArrayList<HashMap<String, Object>> empList = EmpDAO.getEmpList(startRow,rowPerPage);
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
	  text-align: center;
	}
	
	.a{ 
		text-decoration: none;	
		display:block;	
		
	}
	</style>
</head>
<body class="container bg">
<div class="content">
	<!-- empMenu.jsp include : 주체(서버) vs redirect(주체:클라이언트) -->
	<div >
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	<div class="in" style="text-align: center">
	<div style="height:10px" ></div>
	<h2> 사원 목록 </h2><hr>	
	<div style="display: inline-block;"> 
	<table>
		<tr>
			<th>회원ID</th>
			<th>이름</th>
			<th>직업</th>
			<th>고용날짜</th>
			<th>활성화상태</th>
		</tr>
	
		<%
			for(HashMap<String, Object>empMap : empList){
		%>
			<tr style=border:solid>
				<td><%=(String)(empMap.get("empId"))%></td>
				<td><%=(String)(empMap.get("empName"))%></td>
				<td><%=(String)(empMap.get("empJob"))%></td>
				<td><%=(String)(empMap.get("hireDate"))%></td>
				<td>
				<%
				HashMap<String, Object> sm = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
				if((Integer)(sm.get("grade")) >= 10) {
				%>	<a href="/shop/action/modifyEmpActive.jsp?empId=<%=(String)(empMap.get("empId"))%>&active=<%=(String)(empMap.get("active"))%>"
					class="disabled a">
					<%=(String)(empMap.get("active"))%>
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
		<div style="display: inline-block;">
			<a href="/shop/emp/updateEmpForm.jsp>" class="btn btn-outline-info">추가</a>
			<a href="/shop/emp/updateEmpForm.jsp>" class="btn btn-outline-info">수정</a>
			<a href="/shop/action/deleteEmpAction.jsp>" class="btn btn-outline-info">삭제</a>
		</div>		
	</div>
	<br>
	<nav aria-label="Page navigation example">
		<ul class="pagination justify-content-center">
		<%
			if(currentPage > 1) {
		%>
			<li class="page-item">
				<a class ="page-link" href="/shop/emp/empList.jsp?currentPage=1">처음페이지</a>
			</li>
			<li class="page-item">
				<a class ="page-link" href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
			</li>																
		<%		
			} else {
		%>
			<li class="page-item disabled">
				<a class ="page-link" href="/shop/emp/empList.jsp?currentPage=1">처음페이지</a>
			</li>
			<li class="page-item"> 
				<a class ="page-link" href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
			</li>
		<%		
			}				
			if(currentPage < lastPage) {
		%>
			<li class="page-item">
				<a class ="page-link" href="/shop/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음페이지</a>
			</li>
			<li class="page-item disabled">
				<a class ="page-link" href="/shop/emp/empList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
			</li>
		<%		
			}
		%>
		</ul>
	</nav>
	</div>
	
</div>	
<%System.out.println("----------------------------------------");%>
</body>
</html>