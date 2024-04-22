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
				카테고리 : 
				<select name="category">
					<option value="">선택</option>
					<%
						for(HashMap<String, Object> c : categoryList){
					%>
						<option value="<%=(String)(c.get("category"))%>"><%=(String)(c.get("category"))%></option>
					<%
						}
					%>
				</select>	
				상품이름:
				<input type="text" name="goodsTitle"> <br>
				
				상품사진:
				<input type="file" name="goodsImg"> <br>
			
				상품가격:
				<input type="number" name="goodsPrice"> 
			
				재고:
				<input type="number" name="goodsAmount"> <br>
			
				제품설명 :
				<textarea rows="5" cols="50" name="content"></textarea> <br>
				<button type="submit">제품등록</button>
			</form>
		</div>
	</div>
</div>	
</body>
</html>


