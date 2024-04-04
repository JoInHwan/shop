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
	
		PreparedStatement stmt0 = null;
		ResultSet rs0 = null;	
	
		String sql0 = 
		"select goods_title goodsTitle,goods_price goodsPrice,goods_amount goodsAmount,goods_img goodsImg from goods ORDER BY RAND() limit ?,?";
		stmt0 = conn.prepareStatement(sql0);
		stmt0.setInt(1,startRow);
		stmt0.setInt(2,rowPerPage);
		rs0 = stmt0.executeQuery();
		ArrayList<HashMap<String, Object>> whole = new ArrayList<HashMap<String, Object>>();
		while(rs0.next()){
			HashMap<String, Object> b = new HashMap<String, Object>();
			b.put("goodsTitle",rs0.getString("goodsTitle"));
			b.put("goodsPrice",rs0.getString("goodsPrice"));
			b.put("goodsAmount",rs0.getString("goodsAmount"));
			b.put("goodsImg",rs0.getString("goodsImg"));
			whole.add(b);
		}	// 이상 전체 랜덤 선택  쿼리문
/* ------------------------------------------------- */	
	String searchWord = "";
	if(request.getParameter("searchWord")!=null){
		searchWord = request.getParameter("searchWord");
	}
	System.out.println(searchWord+"<-");
	String sql2="select count(*) wcnt from goods where goods_title like ?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,"%"+ searchWord +"%");
	rs2 = stmt2.executeQuery();
	int totalRow = 0;
	if(rs2.next()){
		totalRow = rs2.getInt("wcnt");
	}
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}	
	System.out.println(rs2.getInt("wcnt")+"<-wcnt");
	System.out.println(lastPage+"<-lastPage");
		
		
		
		
		
%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link href="/shop/emp/SHOP.css" rel="stylesheet">
	<meta charset="UTF-8">
	<title>goodsList</title>
	<style>
	.item{
			display: flex;
     			width:25%;     
/*    			width:200px;    */
			flex-wrap: wrap;
			box-sizing: border-box;
			float:left;
/* 			border:1px solid; */			
	
	}
	.item>table{	
			width: 100%;
 			height: 91px; 			
			box-sizing: border-box;
			text-align: center;
			border-color: black;	
		}	
			
	.price{
		border: none; 
		color: red;
	}		
	</style>
</head>
<body>
<div class="row">
	<div class="col-1"></div>
	<div class="col-1" style="background-color:#E0E0E0; border:1px solid">
		<br>
		<div>
			<a href="/shop/emp/addGoodsForm.jsp">상품등록</a>	
		</div><hr>
		<h5>카테고리</h5>
		<!-- 	서브메뉴  카테고리별 상품리스트	 -->
		<div>
		
			<a href="/shop/emp/goodsList.jsp">전체</a><br>
			<%
				for(HashMap m : categoryList){
			%>	<a href="/shop/emp/goodsList.jsp?category=<%=(String)(m.get("category"))%>">
				<%=(String)(m.get("category"))%>(<%=(Integer)(m.get("cnt")) %>) <br>
				</a>
			<%
				}
			%>
		</div>	
	</div>	
	<div class="col-9">
	<br><div style="font-size: 30px; font-weight: bold; text-align: center;	">Welcome </div><br>
		<!-- 메인메뉴 -->
		<div>
			<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
		</div>
	
		<div class="row">
		<div class="col"></div>
		<div class="col-11">
		
			
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
			%>
					
			<table>
			<tr><td><img src=<%=photo%> style="width:200px;"></img></td></tr>
			<tr><th><%=(String)(g.get("goodsTitle"))%></th></tr>
			<tr><td class="price"><%=(String)(g.get("goodsPrice"))%>원   </td></tr>
			<tr><td><%=(String)(g.get("goodsAmount"))%>개</td></tr>
			</table>	
		</div>
		<%}%>	
		<!-- ------------------------------------ -->
		<%	
		if(category==null || category.equals("null")){  // 첫 조건은 처음 출력할때, 두번째조건은 a태그안 categoty가 null 일때
			for(HashMap<String, Object>g : whole ){
		%>	
			<div class="item">
		<% 
				String photo = "/shop/emp/uniform/Ball.jpeg";		  
		%>				
				<table>
					<tr><td><img src=<%=(String)(g.get("goodsImg"))%> style="width:200px;"></img></td></tr>
					<tr><th style="height:51px;"><%=(String)(g.get("goodsTitle"))%></th></tr>
					<tr><td class="price"><%=(String)(g.get("goodsPrice"))%>원</td></tr>
					<tr><td><%=(String)(g.get("goodsAmount"))%>개</td></tr>
				</table>	
			</div>
		<%	}
		}
		%>				
		<div style="width:80px">&nbsp;</div>
		<nav aria-label="Page navigation example">
				<ul class="pagination justify-content-center">
	
					<%
						if(currentPage / 6 == 0 ) {
					%>
							<li class="page-item disabled">
								<a class ="page-link" href="/shop/emp/goodsList.jsp?category=<%=category%>&currentPage=5"> &lt; </a>
							</li>	
						
					<%
							for(int i=1;i<=5;i++){				
					%>
							<li class="page-item">
								<a class ="page-link" href="/shop/emp/goodsList.jsp?category=<%=category%>&currentPage=<%=i%>"><%=i%> </a>
							</li>
						
					<%		
							}
					%>
						<li class="page-item">
							<a class ="page-link" href="/shop/emp/goodsList.jsp?category=<%=category%>&currentPage=6">&gt;</a>
						</li>
																					
					<%		
						} else if (currentPage / 6 == 1){				
							for(int i=1;i<=5;i++){				
					%>
							<li class="page-item">
								<a class ="page-link" href="/shop/emp/goodsList.jsp?category=<%=category%>&currentPage=<%=i+5%>"><%=i+5%> </a>
							</li>
						
					<%						
							}
					%>									
							
					<%		
						}
					
					%>
				</ul>
		</nav>	
		
	</div>	
	<div class="col"></div>
	</div>
	</div>
	
	<div class="col-1" style="background-color:#"></div>		
</div>	
</body>
</html>