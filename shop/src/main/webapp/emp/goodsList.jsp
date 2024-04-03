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
	// 페이징	
	int rowPerPage = 12; // 전체 아이템 수
	int startRow = ((currentPage-1)*rowPerPage);
		
	String category = request.getParameter("category");
	System.out.println(category+"<-category");	
%>

<%
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	
	String sql1 = "select category, count(*) cnt from goods group by category order by category";
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery(); // JDBC API 종속된 자료구조 모델 ResultSet -> 기본API 자료구조(ArrayList)로 변경	
	ArrayList<HashMap<String,Object>> categoryList = new ArrayList<HashMap<String,Object>>();
	
	while (rs1.next()){
		HashMap<String,Object> m = new HashMap<String,Object>();
		m.put("category",rs1.getString("category"));
		m.put("cnt",rs1.getInt("cnt"));
		categoryList.add(m);
	}
	
	System.out.println(categoryList);	// 이상 전체 카테고리 및 개수
/* ------------------------------------------------- */
	PreparedStatement stmt = null;
	ResultSet rs = null;
	

	String sql="select goods_title goodsTitle,goods_price goodsPrice,goods_amount goodsAmount from goods where category = ? order by goods_price asc limit ?,?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,category);
	stmt.setInt(2,startRow);
	stmt.setInt(3,rowPerPage);
	rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> g = new HashMap<String, Object>();
		g.put("goodsTitle",rs.getString("goodsTitle"));
		g.put("goodsPrice",rs.getString("goodsPrice"));
		g.put("goodsAmount",rs.getString("goodsAmount"));
		list.add(g);
	}	// 이상 특정 카테고리 상품 출력 쿼리문 
/* ------------------------------------------------- */	

%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
	<link href="/shop/emp/SHOP.css" rel="stylesheet">
	<meta charset="UTF-8">
	<title>goodsList</title>
	<style>
	.item{
			display: flex;
 			width:24%; 
			flex-wrap: wrap;
			box-sizing: border-box;
			float:left;
			border:1px solid;
			margin:1px
	
	}
	.item>table{	
			width: 100%;
 			height: 91px; */
			
			box-sizing: border-box;
			text-align: center;	
		}		
	</style>
</head>
<body>
	<!-- 메인메뉴 -->
	<div>
		<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	
	<div>
		<a href="/shop/emp/addGoodsForm.jsp">상품등록</a>	
	</div>
	<!-- 	서브메뉴  카테고리별 상품리스트	 -->
	<div>
	
		<a href="/shop/emp/goodsList.jsp">전체</a><br>
		<%
			for(HashMap m : categoryList){
		%>	<a href="/shop/emp/goodsList.jsp?category=<%=(String)(m.get("category"))%>">
			<%=(String)(m.get("category"))%>(<%=(Integer)(m.get("cnt")) %>) &nbsp;&nbsp;
			</a>
		<%
			}
		%>
	</div>			
	
	<%for(HashMap<String, Object>g : list){%>	
	<div class="item">
		<% String photo = null;
		  if (category.equals("리버풀")){
			  photo = "/shop/emp/uniform/Liverpool.png";
		 } else if(category.equals("맨시티")){
			 photo = "/shop/emp/uniform/Mancity.jpg";
		 } else if(category.equals("맨유")){
			 photo = "/shop/emp/uniform/Manu.jpg";
		 } else if(category.equals("아스날")){
			 photo = "/shop/emp/uniform/Arsenal.jpg";
		 } else if(category.equals("토트넘")){
			 photo = "/shop/emp/uniform/Tottenham.jpg";
		 }
		
		  System.out.println(photo+"<-photo");
		%>
				
		<table>
		<tr><td><img src=<%=photo%> style="width:200px;"></img></td></tr>
		<tr><th><%=(String)(g.get("goodsTitle"))%></th></tr>
		<tr><td><%=(String)(g.get("goodsPrice"))%>원</td></tr>
		<tr><td><%=(String)(g.get("goodsAmount"))%>개</td></tr>
		</table>	
	</div>
	<%}%>	
	
	<div style="width:80px">  <a href="/shop/emp/goodsList.jsp?category=<%=category%>&currentPage=<%=currentPage-1%>">이전</a>
	<a href="/shop/emp/goodsList.jsp?category=<%=category%>&currentPage=<%=currentPage+1%>">다음</a></div>
	
	
</body>
</html>

