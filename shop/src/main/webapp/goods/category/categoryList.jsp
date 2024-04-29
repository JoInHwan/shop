<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "shop.dao.CategoryDAO" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
	if(session.getAttribute("loginEmp")==null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>
<% 
	ArrayList<HashMap<String, Object>> categoryList = CategoryDAO.getCategoryList();	
%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
<link href="/shop/SHOP.css" rel="stylesheet">
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="/shop/SHOP.css" rel="stylesheet">
	<title>카테고리목록</title>
	<style>

		
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
	<div>
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	<div class="in" style="text-align: center">
		<div style="height:10px" ></div>
		<div style="display: inline-block;">
			<h2> 카테고리 목록 </h2><hr>		
			<table class="table table-bordered" style="border: 3px">
				<tr>
					<th>카테고리</th>
					<th>만든사람</th>
					<th>만든날짜</th>
					<th>삭제</th>
				</tr>
		
			<%
				for(HashMap<String, Object>m : categoryList){
			%>
					<tr>
						<td><%=(String)(m.get("category"))%></td> 
						<td><%=(String)(m.get("empId"))%></td>		
						<td><%=(String)(m.get("createDate"))%></td>	
						<td>
						<%			
							if((Integer)(m.get("grade")) >= 1) {
						%>
							<a href="/shop/action/deleteCategoryAction.jsp?category=<%=(String)(m.get("category"))%>" class="btn btn-outline-danger">삭제</a>		
						<% 
							}
						%>
						</td>
					</tr>		
			<%		
				}
			%>			
			</table><br>		
			<div>
<!-- 			<a href="/shop/AddCategoryForm.jsp>" class="btn btn-outline-warning">추가</a>	 -->
			</div><br>
		</div>	
	</div>
</div>
<%System.out.println("----------------------------------------");%>
</body>
</html>