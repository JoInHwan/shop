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
	<title></title>
	<style>
	table,th,td{
	  border: 1px solid;
	  text-align: center;
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
			<h2> 카테고리 목록 </h2><hr>		
			<table style="margin-left: 10px; margin-right: 20px;">
				<tr>
					<th style="text-align: center">카테고리</th>
					<th style="text-align: center">만든사람</th>
					<th style="text-align: center">만든날짜</th>
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
					if((Integer)(m.get("grade")) >= 1) {
					%>
					<td><a href="/shop/goods/category/updateyCategoryForm.jsp?category=<%=(String)(m.get("category"))%>" class="btn btn-outline-info">수정</a></td>
					<td><a href="/shop/action/deleteCategoryAction.jsp?category=<%=(String)(m.get("category"))%>" class="btn btn-outline-danger">삭제</a></td>		
					<% 
					}
					%>
				</tr>		
			<%		
				}
			%>			
			</table><br>		
			<div>
			<a href="/shop/AddCategoryForm.jsp>" class="btn btn-outline-warning">추가</a>	
			</div><br>
		</div>	
	</div>
</div>
<%System.out.println("----------------------------------------");%>
</body>
</html>