<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
// 	if(session.getAttribute("loginEmp")==null){ // 로그인이 안되어 있다면
// 		response.sendRedirect("/shop/emp/empLoginForm.jsp");
// 		System.out.println("로그인해야됌");	
// 		return;
// 	}
%>
<%
	
	HashMap<String,Object> loginMember	= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
	
	if(session.getAttribute("loginCustomer")==null && session.getAttribute("loginEmp")!=null){ // '직원'으로 로그인 하면 세션 loginMember에 loginEmp가 저장
		loginMember	= (HashMap<String,Object>)(session.getAttribute("loginEmp"));
	}
	if(session.getAttribute("loginCustomer")!=null && session.getAttribute("loginEmp")==null){ // '고객'으로 로그인 하면 세션 loginMember에 loginCustome이 저장
		loginMember	= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
	}
%>

<%
	//DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","java1234");
	
	// 페이징
	int currentPage = 1;													// 기본페이지 = 1
	if(request.getParameter("currentPage")!=null){								
		currentPage = Integer.parseInt(request.getParameter("currentPage"));    
	}		
	int itemPerPage = 12; 													// 한 페이지에 볼 아이템 수 기본값 12개
	
	String perPage = request.getParameter("perPage");						// 원하는 개수대로 아이템을 보도록 하는 변수 perPage
	
	System.out.println(perPage+ "<-perPage");									
	if(perPage == null || perPage.equals("null")) {
		itemPerPage = 12;
	    System.out.println("itemPerPage가 널일때 12로 초기화");					// perPage변수가 null이면 itemPerPage = 12
	} else {
		itemPerPage = Integer.parseInt(perPage);							// perPAge변수가 있으면 그 값을 itemPerPage에 저장
	}	
		
	int startItem = (currentPage-1)*itemPerPage;							// 페이지 별 제일 처음 시작되는 상품의 순서를 나타내는 변수 startItem 설정
	
	/*검색기능*/
	String searchWord = "";
	if(request.getParameter("searchWord")!=null){							// 검색한 단어 저장
		searchWord = request.getParameter("searchWord");
	}
	System.out.println("검색한것 : " + searchWord);	
	
	/*정렬기능*/	
	String order = request.getParameter("order");
	String array = request.getParameter("order"); // 페이징그룹의 a태그 안에 넣을 용도(위의 order변수와 달리 if문을 안거치고 받아온값을 그대로 이용하기 위함)
	System.out.println("ORDER : "+order );
	if( order == null || order.equals("null") ){ 							//  처음 페이지를 불러올때 || a태그로 order값에 null이란 문자가 들어올때
		order = "";
		System.out.println("받아온 order 값이 없어 빈 값으로 처리" );
	} else {
		order = ","+ order;
		System.out.println("쉼표 추가됨");      								// sql문에서 기본 order by ~ 에 ',' ~ 추가 
	}
	
	
	String category = request.getParameter("category"); 					// 카테고리 변수 받기	
	System.out.println("카테고리 : " +category);	
%>

<%
	PreparedStatement stmt1 = null;	
	ResultSet rs1 = null;
	
	String sql1 = "select category, count(*) cnt from goods group by category order by cnt desc"; // 카테고리별 개수를 나타내는 sql문
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
	if(category!=null && !category.equals("null") ){ 						// 카테고리 값이 선택되었을때 (null이 아닐때)에만 동작
// ↑'전체'보기하거나 처음페이지에 들어왔을때 && a태그로 category값에 null문자가 넘겨질때  	
		for(HashMap <String, Object>m : categoryList){    
			if(category.equals((String)(m.get("category")))){			 	// 받아온 category 값이 카테고리Table 의 것과 같다면
				totalItem = (Integer)(m.get("cnt"));						// 전체 아이템수 설정
			}			
		}
	}

/* 두번째 쿼리------------------------------------------------ */
	PreparedStatement stmt0 = null;
	ResultSet rs0 = null;	
	// 상뭄명에 '?'가 포함된 항목 수 를 wcnt라 하고, 상품명에 '?'가 포함된 항목들의 각 요소들을 추출
	
	/*select (SELECT COUNT(*) FROM goods WHERE 1=1 and category = ? and goods_title LIKE ?)as wcnt, // 카테고리가 ?이고 이름에 ?가 포함된 상품의 수를 wnt라 지정 
	goods_title,filename,goods_price,goods_amount from goods 										// 여기서(주석)는 별칭(as) 제외
	 WHERE 1=1 and category = ? and goods_title LIKE ? 												// 카테고리가 ?이고 ?가 포함된 상품의 모든정보
	order by wcnt,? limit ?,?	*/	  				// 처음엔 모두 같은 값을 가지는 wcnt로 정렬(무의미)한 이후 카테고리가 없고 정렬한값이 없으면 그상태로 출력
	
	String sql0 = 
	"select (SELECT COUNT(*) FROM goods WHERE 1=1 ";
	if(category!=null&&!category.equals("null")){	// ()괄호 안 카테고리가 정해졌다면 category = ?의 where 조건이 추가된 상품의 '수'
		sql0+= "and category = '"+category+"'" ;
	}
	sql0+= " and goods_title LIKE ?)as wcnt,goods_title goodsTitle,filename,goods_price goodsPrice,goods_amount goodsAmount from goods WHERE 1=1 "; 
	if(category!=null&&!category.equals("null")){	// 카테고리가 정해졌다면 category = ?의 where 조건이 추가된 상품의 모든 정보
		sql0+= "and category = '"+category+"'" ;
	}
	sql0+=" and goods_title LIKE ? order by wcnt";  	
	
	if( array==null||array.equals("null") ){       // 받아온 order 값이 없다면 무작위로 배열 
		sql0+= ",RAND()";
	}
	sql0+=order+" limit ?,?";                
	
	stmt0 = conn.prepareStatement(sql0);
	
	stmt0.setString(1,"%"+ searchWord +"%");
	stmt0.setString(2,"%"+ searchWord +"%");	
	stmt0.setInt(3,startItem);
	stmt0.setInt(4,itemPerPage);
	System.out.println(stmt0 );	
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

/* 쿼리문에서 받아온 wcnt 값 이용해 페이징 마무리 ------------------------------------------------- */

	String searchCount = null; // 검색결과 수 변수 초기화
	
	for (HashMap<String, Object> b : whole) {    
		searchCount = (String) b.get("wcnt");
	    break;												// 모두 같은 wcnt(searchCount)값을 가지므로 한번만 실핼하고 종료		
	}
	System.out.println("검색 항목 수 : " + searchCount + "개");		 
	
	
	rs0.beforeFirst();											// rs커서 복귀
	if(rs0.next()){												 // searchWord 검색결과가 있을경우에만 실행
		totalItem = Integer.parseInt(searchCount);				
	}
	
	int lastPage = totalItem / itemPerPage;;
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
	<link href="/shop/SHOP.css" rel="stylesheet">
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
            transition: background-color 0.3s ease;
	}
	   .item:hover {
            background-color: #ccc;
        }
         .item-wrapper {
        display: block; /* div를 블록 레벨 요소로 변경 */
        text-decoration: none; /* 링크에 밑줄 제거 */
        color: inherit; /* 링크 색상 상속 */
    }
	.item>table{	/*상품 div>table*/
			width: 100%;
 			height: 80px; 			
			box-sizing: border-box;
			text-align: left;	
			border: none;
			margin-bottom: 40px;
			margin-top: 20px;		
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
	
	.category{
	text-decoration: none;	
	display:block;
	color:black;
	border: 1px solid;
	padding:5px;
	border-radius: 10px;
	}
	
	input[type=text] {
 	border-style: none;
		}
	
    
    .btn-login{
    ;
    }
	</style>
</head>
<body >
<div class="row">
 <div class="col-1">
  	 	
  </div>	
	<div class="col-10"><br>
		<div style="text-align: center; height: 60px;">
			<span style="font-size: 30px; font-weight: bold;">&nbsp;&nbsp;&nbsp;Welcome </span>
		<%	if (session.getAttribute("loginCustomer") == null && session.getAttribute("loginEmp") == null) { // customer,emp 모두 로그인x
		%>	<div style="display: inline-block; float: right;">
				<a class="btn btn-primary btn-login" style="width: 65px; font-size: 12px; margin-top: 16px;"href="/shop/loginForm.jsp">로그인</a>
			</div>
		<%	} else if (session.getAttribute("loginCustomer") != null && session.getAttribute("loginEmp") == null) { //손님로그인이 있다면
		%>	<div style="display: inline-block; float: right;">
				<span style="font-size: 12px; margin-top: 10px;">'<%=(String) (loginMember.get("name"))%>'님
				</span><br> <a class="btn btn-danger" style="width: 75px; font-size: 12px;"	href="/shop/action/logout.jsp"><span>로그아웃</span></a>
			</div>
		<%
		} else if (session.getAttribute("loginCustomer") == null && session.getAttribute("loginEmp") != null) { // 사원로그인이 있다면
		%>	<span style="background-color: #DC143C; font-size: 12px; padding: 4px; border-radius: 4px; color: white">직원용</span>
			<div style="display: inline-block; float: right;">
				<a class="btn btn-danger" style="width: 75px; font-size: 12px; margin-top: 16px;"href="/shop/action/logout.jsp"><span>로그아웃</span></a>
			</div>
		<%	}	%>
		</div>
			<!-- 메인메뉴 -->
		<!-- empMenu.jsp include : 주체(서버) vs redirect(주체:클라이언트) -->
		<!-- 주체가 서버이기 때문에 include할때는 절대주소가 /shop으로 시작하는게 아니라 /emp부터 시작 -->
		<!-- 사원로그인을 했을경우에만 -->
		<%if(session.getAttribute("loginEmp")!=null){ %> 		
		<div>
			<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
		</div> 
		<%} %><br>
		<div>
			<jsp:include page="/emp/inc/categoryBar.jsp"></jsp:include>
		</div> <br>
		<div style="text-align:center; padding-left:20%; padding-right: 20%; ">
<%-- 				<jsp:include page="/emp/inc/img.jsp"></jsp:include> --%>
			</div><br>
		
		
	<div style="margin-left: 30px; margin-right: 30px;" >
			
	<div style="display: flex; justify-content: space-between; align-items: center; width: 100%">
		<div>
			<h5>
			<%
				if (searchWord != "") {  							// 검색을 했을경우에는 '~에대한 검색결과: x개' 표시
					if(category!=null&&!category.equals("null")){     // + 카테고리를 설정했을경우에는 앞에 ' y 카테고리의 ' 추가
					%>
					'<%=category%>' 카테고리의
					<%	
					}
			%>	 <b>'<%=searchWord%>'</b> 에 대한 검색결과 : <%=totalItem%>개
			<% } else {												// 검색을 하지 않은 경우에는 '총x개의 상품이 있습니다' 표시
			%> 	 총 <%=totalItem%>개의 상품이 있습니다.
			<% } %>
			</h5>
		</div>
		<form style="display: flex; align-items: center;">
			<input class="form-control me-2" style="width: 300px"
				name="searchWord" type="search" placeholder="원하시는 상품을 검색하세요"> <input
				type="hidden" name="category" value="<%=category%>"> <input
				type="hidden" name="perPage" value="<%=perPage%>"> <input
				type="hidden" name="order" value="<%=array%>">
			<button class="btn btn-outline-success" type="submit">Search</button>
		</form>
	</div>
	<hr>
	<div style="display: flex; justify-content: flex-end;">
			<!-- 있었음 -->			
		<div style="width:90px">
		<form id="orderForm" action="/shop/goods/goodsList.jsp"	method="GET">
			<input type="hidden" name="category" value="<%=category%>">
			<input type="hidden" name="searchWord" value="<%=searchWord%>">
			<input type="hidden" name="perPage" value="<%=perPage%>">
			<select name="order" onchange="submitOrderForm(this.value)" style="font-size: 12px;">
				<option>정렬기준</option>
				<option value="goods_title">이름순</option>
				<option value="goods_price">낮은가격순</option>
				<option value="goods_price desc">높은가격순</option>
				<option value="update_date desc">최신순</option>
				<option value="goods_amount">인기순</option>
			</select>
		</form>
		</div>
			<form id="perPageForm" action="/shop/goods/goodsList.jsp" method="GET">
			<input type="hidden" name="category" value="<%=category%>">
			<input type="hidden" name="searchWord" value="<%=searchWord%>">
			<input type="hidden" name="order" value="<%=array%>"> 
			<select name="perPage" onchange="submitPerPageForm(this.value)" style="font-size: 12px;">
				<%
				if (perPage != null && !perPage.equals("null")) {
				%>
				<option value="<%=perPage%>"><%=perPage%>개씩	</option>
				<%
				}
				%>
				<option value="12">12개씩</option>
				<option value="4">4개씩</option>
				<option value="8">8개씩</option>
				<option value="16">16개씩</option>
				<option value="20">20개씩</option>
			</select>
		</form>
		</div>
		
	</div>
					<br>
	<script>
		function submitOrderForm(value) {
			document.getElementById("orderForm").action = "/shop/goods/goodsList.jsp?order="
					+ value;
			document.getElementById("orderForm").submit();
		}

		function submitPerPageForm(value) {
			document.getElementById("perPageForm").action = "/shop/goods/goodsList.jsp?perPage="
					+ value;
			document.getElementById("perPageForm").submit();
		}
	</script>	
		<!-- ---- 카테고리 선택없이 전체출력&&검색어가 포함된 상품 출력 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  -->
		<%	
//  		if(category==null || category.equals("null")){  
			// 첫 조건은 처음 출력할때, 두번째조건은 페이징할때 a태그로 categoty가 null로 넘겨질때
			for(HashMap<String, Object>b : whole ){
		%>	
		
		 <a class="item-wrapper" href="/shop/goods/goodsOne.jsp?goodsTitle=<%=(String)(b.get("goodsTitle"))%>">	
			<div class="item">				
			<table>
<!-- 이미지 -->	<tr><th class="goodsBorder itemImg"><img src="/shop/upload/<%=(String)(b.get("filename"))%>" style="width:140px;"></img></th></tr> 
<!-- 상풍명 -->	<tr><td class="goodsBorder itemTitle"><%=(String)(b.get("goodsTitle"))%></td></tr>
<!-- 가격 -->		<tr><td class="price itemEx"><%=(String)(b.get("goodsPrice"))%>원</td></tr>
<!-- 재고 -->		<tr><td class="goodsBorder itemEx"><%=(String)(b.get("goodsAmount"))%>개</td></tr>				
			</table>	
			</div>
			</a>
		<%	}
		//}
		%>		
		<!-- 페이징 nav -->
	<div style="width:80px">&nbsp;</div>
		<nav aria-label="Page navigation example">
			<ul class="pagination justify-content-center">
				<%
				int pagingGroup = 5; //기본 페이징 그룹은 5개씩
				int c = (currentPage - 1) / 5; // 현재페이지의 페이징그룹 번호: currentPage 가 (1,2,3,4,5)일땐 0 , (6,7,8,9,10)일땐 1 . . . 

				if (c == (lastPage - 1) / 5) { // 현재페이징 그룹이 마지막 페이징그룹일땐
					pagingGroup = lastPage % 5; // 페이징그룹의 수가 5로나눈 나머지값으로 설정   
					if (pagingGroup == 0) { // 단, 페이지번호가 5의배수일땐 다시 5개로 설정 
						pagingGroup = 5;
					}
				}
				%>
				<%String priviousTab = null;
				  String nextTab = null;
				if (c == 0) { // 	0번째페이징그룹일때에는 이전으로 넘길수 없음
					priviousTab = "disabled";
				}

				if (c == (lastPage - 1) / 5) { // 마지막 페이징그룹일때에는 다음으로 넘길수 없음
					nextTab = "disabled";
				}
				%>

				<li class="page-item <%=priviousTab%>"><a class="page-link"	style="color: black;  "
					href="/shop/goods/goodsList.jsp?category=<%=category%>&searchWord=<%=searchWord%>&order=<%=array%>&perPage=<%=perPage%>&currentPage=1">First</a></li>
				<li class="page-item <%=priviousTab%>"><a class="page-link"	style="color: black; margin-right: 1px;"
					href="/shop/goods/goodsList.jsp?category=<%=category%>&searchWord=<%=searchWord%>&order=<%=array%>&perPage=<%=perPage%>&currentPage=<%=c*5%>">Back</a></li>
				<%
				// 현재 페이지에 따라 (1,2,3,4,5)or (6,7,8,9,10) 로 페이지를 넘길 수 있도록 출력
				int temp = pagingGroup;
				for (int i = 1; i <= pagingGroup; i++) {
					String currentPageItem = null; // 페이징그룹에서 현재페이지만 파란글씨에 테루리가 보이게 하는 알고리즘
					if (currentPage % 5 == i || (currentPage % 5 == 0 && i == 5)) {
						// 현재페이지를 5로 나눈 나머지가 i 일때와 딱 나눠떨어질때 
						
						System.out.println(pagingGroup + "<-페이징그룹");
						currentPageItem = " font-weight: bold; color:blue; border:solid 1px;  ";
					}
				%>
				<li class="page-item" style="margin:1px; "><a class="page-link "	style="color:black; <%=currentPageItem %>"
					href="/shop/goods/goodsList.jsp?category=<%=category%>&searchWord=<%=searchWord%>&order=<%=array%>&perPage=<%=perPage%>&currentPage=<%=c * 5 + i%>"><%=c * 5 + i%>
					</a></li>
				<%
				}
				%>
				<li class="page-item <%=nextTab%>"><a class="page-link"	style="color: black;margin-left: 1px;"
					href="/shop/goods/goodsList.jsp?category=<%=category%>&searchWord=<%=searchWord%>&order=<%=array%>&perPage=<%=perPage%>&currentPage=<%=(c + 1) * 5 + 1%>">Next</a>
				</li>
				<li class="page-item <%=nextTab%>"><a class="page-link"	style="color: black; "
					href="/shop/goods/goodsList.jsp?category=<%=category%>&searchWord=<%=searchWord%>&order=<%=array%>&perPage=<%=perPage%>&currentPage=<%=lastPage%>">Last</a>
				</li>
			</ul>  <!--   	&laquo;   &raquo;-->
		</nav>
	</div>
	<div class="col-1" style="background-color:#"></div>
	</div>	
	
	<%
	//자원반납
	rs0.close(); rs1.close();
	stmt0.close(); stmt1.close(); 
	conn.close();
	System.out.println("----------------------------------------");
	%>		
</body>
</html>