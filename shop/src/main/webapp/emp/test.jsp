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
	
	int rowPerPage = 12; // 전체  항목 수
	int startRow = 1;	
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
int totalRow = 0;
//--------------------------------
String searchWord = "";
if(request.getParameter("searchWord")!=null){
	searchWord = request.getParameter("searchWord");
}

PreparedStatement stmt0 = null;
ResultSet rs0 = null;	

String sql0 = 
"select (SELECT COUNT(*) FROM goods WHERE goods_title LIKE ?)as wcnt, "+
"goods_title goodsTitle,filename,goods_price goodsPrice,goods_amount goodsAmount from goods "
+"WHERE  goods_title LIKE ? limit ?,?";

stmt0 = conn.prepareStatement(sql0);
stmt0.setString(1,"%"+ searchWord +"%");
stmt0.setString(2,"%"+ searchWord +"%");
stmt0.setInt(3,startRow);
stmt0.setInt(4,rowPerPage);
rs0 = stmt0.executeQuery();
ArrayList<HashMap<String, Object>> whole = new ArrayList<HashMap<String, Object>>();

System.out.println(" SQL 문 : "+stmt0);	
while(rs0.next()){
HashMap<String, Object> b = new HashMap<String, Object>();
b.put("wcnt",rs0.getString("wcnt"));
b.put("goodsTitle",rs0.getString("goodsTitle"));
b.put("filename",rs0.getString("filename"));
b.put("goodsPrice",rs0.getString("goodsPrice"));
b.put("goodsAmount",rs0.getString("goodsAmount"));
//	b.put("goodsImg",rs0.getString("goodsImg"));
whole.add(b);
}	// 이상 전체 랜덤 선택  쿼리문 랜덤 선택  쿼리문

%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link href="/shop/emp/SHOP.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" ></script>
	<meta charset="UTF-8">
	
	<title> 테스트 </title>
	<style>
	.item{   /* 상품div */
			display: flex;
     		width:25%;     
/*    			width:200px;    */
			flex-wrap: wrap;
 			box-sizing: border-box; 
			float:left;
			border:none; 			
	
	}
	.item>table{	/*상품 div>table*/
			width: 100%;
 			height: 91px; 			
			box-sizing: border-box;
			text-align: left;	
			border: none;
			margin-bottom: 60px;					
		}
	.test{	
		position: relative;
    display: block;
    padding: var(--bs-pagination-padding-y) var(--bs-pagination-padding-x);
    font-size: var(--bs-pagination-font-size);
    color: var(--bs-pagination-color);
    text-decoration: none;
    background-color: var(--bs-pagination-bg);
    border: var(--bs-pagination-border-width) solid var(--bs-pagination-border-color);
    transition: color .15s ease-in-out, background-color .15s ease-in-out, border-color .15s ease-in-out, box-shadow .15s ease-in-out;
	}	
	

	</style>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="row">
 	<div class="col-1"></div> 	
	<div class="col-11"><br>		
	<div>		
		
		<nav class="navbar navbar-expand-lg bg-warning" style="width:400px;height:40px;">
		  <div class="container-fluid">			  
		      <ul class="navbar-nav "> 
		        <li class="nav-item dropdown">
		          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
		            정렬기준
		          </a>
		          <ul class="dropdown-menu" style="width:60px;">
		            <li><div class="dropdown-item">이름순</div></li>
<li><a class="dropdown-item" href="/shop/emp/goods/goodsList.jsp?&order=goods_amount&searchWord=<%=searchWord%>">가격순</a></li>
		            <li><a class="dropdown-item" href="#">최신순</a></li>
		            <li><a class="dropdown-item" href="#">인기순</a></li>		            
		          </ul>
		        </li>  
		      </ul>		
		      <form class="d-flex" role="search">
      <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
      <button class="btn btn-outline-success" type="submit">Search</button>
    </form>
		         
		  </div>
		</nav>
	</div>
	
		<%	
			
				for(HashMap<String, Object>b : whole ){
			%>	
				<div class="item">				
				<table>
	<!-- 이미지 -->	<tr><th><img src="/shop/upload/<%=(String)(b.get("filename"))%>" style="width:180px;"></img></th></tr> 
	<!-- 상풍명 -->	<tr><td><%=(String)(b.get("goodsTitle"))%></td></tr>
	<!-- 가격 -->		<tr><td><a><%=(String)(b.get("goodsPrice"))%>원</a></td></tr>
	<!-- 재고 -->		<tr><td><a><%=(String)(b.get("goodsAmount"))%>개</a></td></tr>
					<tr><td><a><%=(String)(b.get("wcnt"))%>개</a></td></tr>
				</table>	
				</div>
			<%	}
			
			%>			
			
					
	</div>	
	<nav aria-label="Page navigation example">
			<ul class="pagination justify-content-center">	
			
			<%for(int i=0;i<6;i++){ %>
							
					<li class="page-item">
						<a class ="page-link tesst" style="" href="#"><%=i%> </a>
					</li>							
			<%} %>
			</ul>
			</nav>
					
	<div class="col-1" style="background-color:#"></div>		
</div>	
</body>
</html>