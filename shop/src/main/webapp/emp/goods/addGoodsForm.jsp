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
	String category = request.getParameter("category");
%>
<%
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	
	String sql1 = "select category from category";
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery(); // JDBC API 종속된 자료구조 모델 ResultSet -> 기본API 자료구조(ArrayList)로 변경	
	ArrayList<String> categoryList = new ArrayList<String>();
	
	while (rs1.next()){
		categoryList.add(rs1.getString("category"));
		
	}
	
	System.out.println(categoryList);	// 이상 전체 카테고리 및 개수
/* ------------------------------------------------- */
	
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
	<div class="in">
	<h1>상품등록</h1>
	
	<form action="/shop/emp/goods/addGoodsAction.jsp" enctype="multipart/form-data" method="post">
		카테고리 : 
		<select name="category">
			<option value="">선택</option>
			<%
				for(String c : categoryList){
			%>
				<option value="<%=c%>"><%=c%></option>
			<%
				}
			%>
		</select>	
		상품이름:
		<input type="text" name="goodsTitle"> <br>
		
		상품사진:
		<input type="file" name="goodsImg"> <br>
	
		상품가격:
		<input type="text" name="goodsPrice"> 
	
		재고:
		<input type="text" name="goodsAmount"> <br>
	
		제품설명 :
		<textarea rows="5" cols="50" name="content"></textarea> <br>
		<button type="submit">제품등록</button>
	</form>
	</div>
</div>	
</body>
</html>


