<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "shop.dao.CustomerDAO" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
	if(session.getAttribute("loginEmp")==null){ //직원으로 로그인이 안되어있으면
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>
<% 
	// 페이징
	int currentPage = 1;	
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 15;
	int startRow = ((currentPage-1)*rowPerPage);	
	int totalRow = 0;
	
	
%>

<%	ArrayList<HashMap<String, Object>> customerList = CustomerDAO.getCustomerList(startRow,rowPerPage);
	
	for(HashMap<String, Object>m : customerList){
		totalRow = (int)(m.get("cnt"));
		System.out.println(totalRow + "<-- totalRow");
		break;
	}
	
	System.out.println(totalRow+ "<-totalRow [categoryList]");
	int lastPage = totalRow / rowPerPage; // 전체페이지수
	if(totalRow%rowPerPage !=0){   // 딱 나눠떨어지지않으면 한페이지가 새로 추가됌
		lastPage = lastPage+1;		
	}
	
	String firstPage = "";
	String endPage = "";
	if(currentPage == 1) {
		firstPage = "disabled";
	}else if (currentPage == lastPage){
		endPage = "disabled";  
	}	
	
	
	System.out.println(lastPage+ "<-lastPage [categoryList]");
%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="/shop/SHOP.css" rel="stylesheet">
	<title></title>
	<style>
	table, th{
	  border: 1px solid;
	  text-align:center;
	}
	
	.td{
		border: 1px solid;
		padding : 0px 5px;
	}
	</style>
</head>
<body class="container bg">
<div class="content">
	<div>
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	<div class="in" style="text-align: center">
	<div style="height:10px" ></div>
	<div style="display: inline-block;"> 
	<h2> 고객 목록 </h2><hr>
	
	<table style="margin-left: 10px; margin-right: 20px; font-size: 14px"  >
		<tr>
			<th>아이디</th>
			<th>이름</th>
			<th>성별</th>
			<th>생일</th>			
			<th>주소</th>
			<th>생성날짜</th>
			<th>변경날짜</th>
			<th>전화번호</th>
			<th>자세히</th>
		</tr>
		<%
			for(HashMap<String, Object>m : customerList){
				String id = (String) m.get("id");
				String name = (String) m.get("name");
				String birth = (String) m.get("birth");
				String gender = (String) m.get("gender");
				String address = (String) m.get("address");
				String phoneNum = (String) m.get("phoneNum");
				String createDate = (String) m.get("create_date");
				String updateDate = (String) m.get("update_date");				
				birth = birth.substring(2, 4) + "년" + birth.substring(5, 7) + "월" + birth.substring(8, 10) + "일";
				createDate = createDate.substring(0, 4) + "년" + createDate.substring(5, 7) + "월" + createDate.substring(8, 10) + "일";
				updateDate = updateDate.substring(0, 4) + "년" + updateDate.substring(5, 7) + "월" + updateDate.substring(8, 10) + "일";
				
				
				createDate = createDate.substring(2);	// yyyy-mm-dd 를 yy-mm-dd 로 출력		
				updateDate = updateDate.substring(2);
		%>
			<tr>
				<td class="td"><%=id%></td>
				<td class="td"><%=name%></td>
				<td class="td"><%=gender%>자</td>
				<td class="td"><%=birth%></td>
				<td class="td"><%=address%></td>	
				<td class="td"><%=createDate%></td>
				<td class="td"><%=updateDate%></td>				
				<td class="td"><%=phoneNum%></td>				
				<td><a href="/shop/customer/customerOne.jsp?id=<%=id%>&name=<%=name%>">자세히</a></td>			
			</tr>		
		<%		
			}
		%>					
	</table>
		<div>
			<a href="/shop/customer/signUpForm.jsp" class="btn btn-outline-info">추가</a>
			<a href="/shop/action/updateCustomerPassword.jsp" class="btn btn-outline-warning">비밀번호암호화</a>
			<a href="/shop/customer/deleteCustomerList.jsp" class="btn btn-outline-info">삭제</a>
		</div>
	</div>	
	<nav aria-label="Page navigation example">
		<ul class="pagination justify-content-center">
		<%	
		
		%>
			<li class="page-item <%=firstPage%>">
				<a class ="page-link" href="/shop/customer/customerList.jsp?currentPage=1">처음페이지</a>
			</li>
			<li class="page-item <%=firstPage%>">
				<a class ="page-link" href="/shop/customer/customerList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
			</li>	
			<li class="page-item <%=endPage%>">
				<a class ="page-link" href="/shop/customer/customerList.jsp?currentPage=<%=currentPage+1%>">다음페이지</a>
			</li>
			<li class="page-item <%=endPage%>">
				<a class ="page-link" href="/shop/customer/customerList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
			</li>
	
		</ul>
	</nav>
	</div>
	<%System.out.println("----------------------------------------");%>
</div>	
</body>
</html>