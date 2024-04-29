<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "shop.dao.EmpDAO" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
	if(session.getAttribute("loginEmp")==null){ // 직원로그인이 안되어있으면
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
	HashMap<String,Object> loginMember 
	= (HashMap<String,Object>)(session.getAttribute("loginEmp"));
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
	int rowPerPage = 20;
	int startRow = ((currentPage-1)*rowPerPage);	
	
	int totalRow = 120;
	System.out.println(totalRow+ "<-totalRow [empList]");	
	
	int lastPage = 6; // 전체페이지수
	
	System.out.println(lastPage+ "<-lastPage [empList]");
	
	ArrayList<HashMap<String, Object>> empList = EmpDAO.getEmpList(startRow,rowPerPage);
%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
	<div class="content"><br><br>
	<div style="height:1px; display: flex; justify-content: center; align-items: center;">
	  <a href="/shop/goods/goodsList.jsp" style="text-decoration:none; color:black; display: flex; align-items: center;">
	  	<span style="height: 100%; "><img src="/shop/upload/sosom.png" style="width:40px; margin-top:10%;"></span>
	  	<span style="height: 100%; font-size: 40px;  font-weight: bold;  padding-left:5px;">SOSOM</span>
	  </a>	
	</div><br><br>
	<!-- empMenu.jsp include : 주체(서버) vs redirect(주체:클라이언트) -->
	<div >
		<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	<div class="in" style="text-align: center">
		<div style="height:10px" ></div>
		<h2> 사원 목록 </h2><hr>	
		<div style="display: inline-block;"> 
			<table class="table table-bordered" style="border: 3px" >
				<tr>
					<th>회원ID</th>
					<th>이름</th>
					<th>직업</th>
					<th>고용날짜</th>
					<th>등급</th>					
					<th>활성화상태</th>
				</tr>
				<%
					for(HashMap<String, Object>empMap : empList){
				%>
					<tr>
						<td><%=(String)(empMap.get("empId"))%></td>
						<td><%=(String)(empMap.get("empName"))%></td>
						<td><%=(String)(empMap.get("empJob"))%></td>
						<td><%=(String)(empMap.get("hireDate"))%></td>
						<td><%=(String)(empMap.get("grade"))%></td>
						<td>
						<%
							if((int)(loginMember.get("grade")) >= 10) {  // grade(등급)이 10보다 커야 활성화 상태 ON/OFF 변경 가능
						%>	<a href="/shop/action/modifyEmpActive.jsp?empId=<%=(String)(empMap.get("empId"))%>&active=<%=(String)(empMap.get("active"))%>" class="a">
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
		<%
			if ((int)loginMember.get("grade") >=10 ){				
		%>
			<div style="display: inline-block;">
				<a href="/shop/emp/empSignUpForm.jsp" class="btn btn-outline-info">새 직원 추가</a>
<!-- 				<a href="/shop/action/deleteEmpAction.jsp>" class="btn btn-outline-info">삭제</a> -->
			</div>
		<%		
			}
		%>	
		</div>
		<br>
		<nav aria-label="Page navigation example">
			<ul class="pagination justify-content-center">
			<%
				String firstPage = "";
				String endPage = "";
				if(currentPage == 1){
					firstPage = "disabled";
				} else if (currentPage == 6){
					endPage = "disabled";
				}
			%>
				<li class="page-item <%=firstPage%>">
					<a class ="page-link" href="/shop/emp/empList.jsp?currentPage=1">처음페이지</a>
				</li>
				<li class="page-item <%=firstPage%>">
					<a class ="page-link" href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
				</li>			
				<li class="page-item <%=endPage%>">
					<a class ="page-link" href="/shop/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음페이지</a>
				</li>
				<li class="page-item <%=endPage%>">
					<a class ="page-link" href="/shop/emp/empList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
				</li>
			</ul>
		</nav>
	</div>
</div>	
<%System.out.println("---------------------------------------------------");%>
</body>
</html>