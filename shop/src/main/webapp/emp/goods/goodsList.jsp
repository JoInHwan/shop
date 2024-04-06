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
	int itemPerPage = 12; // 전체 아이템 수
	int startItem = (currentPage-1)*itemPerPage;
		
	String category = request.getParameter("category");
	System.out.println("카테고리 : " +category);	
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
		// 이상 전체 카테고리 및 개수
	
	int totalItem = 0;	
	// 카테고리 이름과 그 개수를 하나씩 가져와서 선택한 카테고리와 같을 때 cnt 값을 totalItem에 저장
	if(category!=null && !category.equals("null") ){ // 카테고리 값이 선택되었을때 (null이 아닐때)에만 동작
//  '전체'보기하거나 처음페이지에 들어왔을때 && 하단 페이징nav 로 category값이 a태그로 넘겨질때  	
		for(HashMap <String, Object>m : categoryList){    
			if(category.equals((String)(m.get("category")))){
				totalItem = (Integer)(m.get("cnt"));				
			}			
		}
	}
	
/* ------------------------------------------------- */		
	PreparedStatement stmt = null;
	ResultSet rs = null;	

	String sql="select goods_title goodsTitle,filename,goods_price goodsPrice,goods_amount goodsAmount from goods where category = ? order by goods_price asc limit ?,?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,category);
	stmt.setInt(2,startItem);
	stmt.setInt(3,itemPerPage);
	rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> g = new HashMap<String, Object>();
		g.put("goodsTitle",rs.getString("goodsTitle"));
		g.put("filename",rs.getString("filename"));
		g.put("goodsPrice",rs.getString("goodsPrice"));
		g.put("goodsAmount",rs.getString("goodsAmount"));
		list.add(g);
	}	// 이상 특정 카테고리 상품 출력 쿼리문 	
/* ------------------------------------------------- */
	String searchWord = "";
	if(request.getParameter("searchWord")!=null){
		searchWord = request.getParameter("searchWord");
	}
	System.out.println("검색한것 : " + searchWord);	
	PreparedStatement stmt0 = null;
	ResultSet rs0 = null;	
	
	String sql0 = 
	"select (SELECT COUNT(*) FROM goods WHERE goods_title LIKE ?)as wcnt, "+
	"goods_title goodsTitle,filename,goods_price goodsPrice,goods_amount goodsAmount from goods "
	+"WHERE  goods_title LIKE ? limit ?,?";  
	// 상뭄명에 '?'가 포함된 항목 수 를 cnt라 하고, 상품명에 '?'가 포함된 항목들의 각 요소들을 추출
	
	stmt0 = conn.prepareStatement(sql0);
	stmt0.setString(1,"%"+ searchWord +"%");
	stmt0.setString(2,"%"+ searchWord +"%");
	stmt0.setInt(3,startItem);
	stmt0.setInt(4,itemPerPage);
	rs0 = stmt0.executeQuery();
	ArrayList<HashMap<String, Object>> whole = new ArrayList<HashMap<String, Object>>();
	
	while(rs0.next()){
	HashMap<String, Object> b = new HashMap<String, Object>();
	b.put("wcnt",rs0.getString("wcnt"));
	b.put("goodsTitle",rs0.getString("goodsTitle"));
	b.put("filename",rs0.getString("filename"));
	b.put("goodsPrice",rs0.getString("goodsPrice"));
	b.put("goodsAmount",rs0.getString("goodsAmount"));
	whole.add(b);
	}	// 이상 전체 항목 및 검색문 쿼리문

/* ------------------------------------------------- */
	String searchCount = null; // 검색결과 수 변수 초기화
	
	for (HashMap<String, Object> b : whole) {    
		searchCount = (String) b.get("wcnt");
	    break;							// 검색한 결과 항목마다 같은 wcnt(searchCount)값을 가지므로 한번만 실핼하고 종료		
	}
	System.out.println("검색 항목 수 : " + searchCount + "개");		 
	if(category==null || category.equals("null")){  // 첫 조건은 처음 출력할때, 두번째조건은 페이징할때 a태그로 categoty가 null로 넘겨질때
	totalItem = Integer.parseInt(searchCount);
	}
	
	int lastPage = totalItem/ itemPerPage;;
 	if(totalItem % itemPerPage != 0) {
		lastPage = lastPage + 1;
 	}	
	System.out.println("마지막 페이지 : "+lastPage );
	
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
	.itemImg{  /* 이미지 th */
		text-align: center;	
	}
	td{
	padding-left: 10%;	
	padding-right: 10%;	
	
	}					
	.price{		/* 가격 td */
		border: none;
		font-weight: bold;
		color: red;
	}
	.goodsBorder{	/*  th , td */
   	border:none   
	}	
	.itemTitle a {   /* 상품이름 안 a태그 */  
    display: block; /* 인라인 요소를 블록 요소로 변경하여 전체 영역을 차지하도록 함 */
    width: 100%; /* 테이블 셀 전체 크기로 확장 */   
    height: 100%; /* 테이블 셀 전체 크기로 확장 */  
    color: inherit; /* 링크 색상을 상속받음 */
    background-color: #E0E0E0;  
    padding-left: 10%; 
    height:45px;
	font-family: "Georgia", Serif;
	font-weight: bold;	
	}
	.itemEx a{ /* 상품 가격,재고 안 a태그 */  
	display: block;
	padding-left: 10%; 	
	}
	
	.test{
	color:blue;
	}
	</style>
</head>
<body>
<div class="row">
 	<div class="col-1"></div> 
	<div class="col-1" style="background-color:#E0E0E0; border:1px solid">
		<br>
		<div>
			<a href="/shop/emp/goods/addGoodsForm.jsp">상품등록</a>	
		</div><hr>
		<h5>카테고리</h5>
		<!-- 	서브메뉴  카테고리별 상품리스트	 -->
		<div>
		
			<a href="/shop/emp/goods/goodsList.jsp">전체</a><br>
			<%
				for(HashMap <String, Object>m : categoryList){
			%>	<a href="/shop/emp/goods/goodsList.jsp?category=<%=(String)(m.get("category"))%>">
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
		<!-- empMenu.jsp include : 주체(서버) vs redirect(주체:클라이언트) -->
		<!-- 주체가 서버이기 때문에 include할때는 절대주소가 /shop으로 시작하는게 아니라 /emp부터 시작 -->
		<div>
			<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
		</div> 
	
		<div class="row">
		<div class="col"></div>
		<div class="col-11"><br>
		<div> 		
		 <%=totalItem%>개의 검색결과가 있습니다		 
		</div><br>
		
		<!--  카테고리가 있을때 출력  -->	
		<%for(HashMap<String, Object>g : list){%>	
		
		<div class="item">			
			<table>
			<tr><th><img src="/shop/upload/<%=(String)(g.get("filename"))%>" style="width:180px;"></img></th></tr>
			<tr><td><%=(String)(g.get("goodsTitle"))%></td></tr>
			<tr><td><%=(String)(g.get("goodsPrice"))%>원 </td></tr>
			<tr><td><%=(String)(g.get("goodsAmount"))%>개</td></tr>
			</table>	
		</div>
		<%}%>	
		<!-- ---- 카테고리 선택없이 전체출력&&검색어가 포함된 상품 출력 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  -->
		<%	
		if(category==null || category.equals("null")){  // 첫 조건은 처음 출력할때, 두번째조건은 페이징할때 a태그로 categoty가 null로 넘겨질때
			for(HashMap<String, Object>b : whole ){
		%>	
			<div class="item">				
			<table>
<!-- 이미지 -->	<tr><th class="goodsBorder itemImg"><img src="/shop/upload/<%=(String)(b.get("filename"))%>" style="width:180px;"></img></th></tr> 
<!-- 상풍명 -->	<tr><td class="goodsBorder itemTitle">
				<a href="/shop/emp/goods/goodsOne.jsp?goodsTitle=<%=(String)(b.get("goodsTitle"))%>"><%=(String)(b.get("goodsTitle"))%>	</a>
				</td></tr>
<!-- 가격 -->		<tr><td class="price itemEx"><a><%=(String)(b.get("goodsPrice"))%>원</a></td></tr>
<!-- 재고 -->		<tr><td class="goodsBorder itemEx"><a><%=(String)(b.get("goodsAmount"))%>개</a></td></tr>
				
			</table>	
			</div>
		<%	}
		}
		%>		
		<!-- 페이징 nav -->
		<div style="width:80px">&nbsp;</div>
		<nav aria-label="Page navigation example">
			<ul class="pagination justify-content-center">	
			<%			
			
			int pagingGroup = 5;  //기본 페이징 그룹은 5개씩
			int c = (currentPage-1) /5 ; // 현재페이지의 페이징그룹 번호: currentPage 가 (1,2,3,4,5)일땐 0 , (6,7,8,9,10)일땐 1 . . . 
			
			if(c == (lastPage-1)/5){ // 현재페이징 그룹이 마지막 페이징그룹일땐
				pagingGroup = lastPage % 5;    // 페이징그룹의 수가 5로나눈 나머지값으로 설정   
				if(pagingGroup==0){   		   // 단, 페이지번호가 5의배수일땐 다시 5개로 설정 
					pagingGroup = 5;
				}
			}		
			%>
			<%
			String priviousTab = null;
			String nextTab = null;
			if(c==0){				 // 	0번째페이징그룹일때에는 이전으로 넘길수 없음
				priviousTab = "disabled";
			}									
			
			if(c == (lastPage-1)/5){ // 마지막 페이징그룹일때에는 다음으로 넘길수 없음
				nextTab = "disabled";
			}	
			%>
			<li class="page-item <%=priviousTab%>">
				<a class ="page-link" style="color:black;"
				href="/shop/emp/goods/goodsList.jsp?category=<%=category%>&searchWord=<%=searchWord%>&currentPage=1"> &lt;&lt; </a>
			</li>
			<li class="page-item <%=priviousTab%>">
				<a class ="page-link" style="color:black;"
				href="/shop/emp/goods/goodsList.jsp?category=<%=category%>&searchWord=<%=searchWord%>&currentPage=<%=c*5%>"> &lt; </a>
			</li>	
			<%			
				
				// 현재 페이지에 따라 (1,2,3,4,5)or (6,7,8,9,10) 로 페이지를 넘길 수 있도록 출력
				for(int i=1;i<=pagingGroup;i++){
					String currentPageItem=null;  // 페이징그룹에서 현재페이지만 파란글씨에 테루리가 보이게 하는 알고리즘
					if(currentPage%pagingGroup==i || (currentPage % pagingGroup == 0 && i == pagingGroup) ){ 
						// 현재페이지를 페이징 그룹으로 나눈 나머지가 i 일때와 딱 나눠떨어질때 
						currentPageItem= "font-weight: bold; color:blue; border:solid 1px ; margin:1px ";
					}				
			%>					
					<li class="page-item">
						<a class ="page-link test" style="color:black; <%=currentPageItem%>" 
			href="/shop/emp/goods/goodsList.jsp?category=<%=category%>&searchWord=<%=searchWord%>&currentPage=<%=c*5+i%>"><%=c*5+i%> </a>
					</li>							
			<%		
				}  
			%>  
			<li class="page-item <%=nextTab%>">
				<a class ="page-link" style="color:black;"
				href="/shop/emp/goods/goodsList.jsp?category=<%=category%>&searchWord=<%=searchWord%>&currentPage=<%=(c+1)*5+1%>">&gt;</a>
			</li>
			<li class="page-item <%=nextTab%>">
				<a class ="page-link" style="color:black;"
				href="/shop/emp/goods/goodsList.jsp?category=<%=category%>&searchWord=<%=searchWord%>&currentPage=<%=lastPage%>">&gt;&gt;</a>
			</li>						
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