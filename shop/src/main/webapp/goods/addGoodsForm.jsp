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
<!DOCTYPE html>
<html>
<head>
	<link href="/shop/SHOP.css" rel="stylesheet">
	<meta charset="UTF-8">
	<title></title>
	<style>
		table{
		text-align:left;
		}
		td{
		padding:5px;
		border: 1px solid black;
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
		<h2>상품등록</h2><hr>
		<div style="display: inline-block;"> 
			<form action="/shop/action/addGoodsAction.jsp" enctype="multipart/form-data" method="post">
			<table border="1">
			<tr>
				<td>카테고리 : </td>
				<td>	<select name="category">
						<option value="">선택</option>
						<%
							for(HashMap<String, Object> c : categoryList){
						%>
							<option value="<%=(String)(c.get("category"))%>"><%=(String)(c.get("category"))%></option>
						<%
							}
						%>
					</select> 
				</td>
				<td>상품사진 : <input type="file" name="goodsImg"></td>
			</tr>
			<tr>
				<td >상품이름 : </td>
				<td colspan="2"><input type="text" name="goodsTitle"></td>
			</tr>
			<tr>
			<tr>
				<td>상품가격 : </td>
				<td><input type="number" name="goodsPrice"></td>
				<td> 재고 : <input type="number" name="goodsAmount"></td>
			</tr>
			<tr><td >제품설명 : </td>
				<td colspan="2" style="text-align:justify;"><textarea rows="5" cols="70" name="content"></textarea></td>
			<tr>
			<tr>
				
			</tr>	
			<tr>
				<td colspan="3" style="text-align:center"><button type="submit">제품등록</button></td>
			</tr>		
			</table>
			</form><br>
		</div>
		<td></td>
	</div>
</div>	
</body>
</html>


