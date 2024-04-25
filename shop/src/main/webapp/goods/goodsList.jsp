<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "shop.dao.GoodsDAO" %>
<%	
	HashMap<String,Object> loginMember	= null;
	
	if(session.getAttribute("loginCustomer")==null && session.getAttribute("loginEmp")!=null){ // '직원'으로 로그인 하면 세션 loginMember에 loginEmp가 저장
		loginMember	= (HashMap<String,Object>)(session.getAttribute("loginEmp"));
	}
	if(session.getAttribute("loginCustomer")!=null && session.getAttribute("loginEmp")==null){ // '고객'으로 로그인 하면 세션 loginMember에 loginCustome이 저장
		loginMember	= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
	}
%>

<%
	// 페이징
	int currentPage = 1;													// 기본페이지 = 1
	if(request.getParameter("currentPage")!=null){								
		currentPage = Integer.parseInt(request.getParameter("currentPage"));    
	}		
	int itemPerPage = 12; 													// 한 페이지에 볼 아이템 수 기본값 12개
	
	String perPage = request.getParameter("perPage");						// 원하는 개수대로 아이템을 보도록 하는 변수 perPage
	
	System.out.println( "perPage : " + perPage);									
	if(perPage == null || perPage.equals("null")) {
		itemPerPage = 12;													// perPage변수가 null이면 itemPerPage = 12
	} else {
		itemPerPage = Integer.parseInt(perPage);							// perPage변수가 있으면 그 값을 itemPerPage에 저장
	}	
		
	int startItem = (currentPage-1)*itemPerPage;							// 페이지 별 제일 처음 시작되는 상품의 순서를 나타내는 변수 startItem 설정
	
	/*검색기능*/
	String searchWord = "";
	if(request.getParameter("searchWord")!=null){							// 검색한 단어 저장
		searchWord = request.getParameter("searchWord");
	}
	System.out.println("searchWord : " + searchWord);	
	
	/*정렬기능*/	
	String order = request.getParameter("order");
	String array = request.getParameter("order"); // 페이징그룹의 a태그 안에 넣을 용도(위의 order변수와 달리 if문을 안거치고 받아온값을 그대로 이용하기 위함)
	System.out.println("ORDER : "+order );
	if( order == null || order.equals("null") ){ 							//  처음 페이지를 불러올때 || a태그로 order값에 null이란 문자가 들어올때
		order = "";  // "안에 ,rand() 넣으면 랜덤출력"
		System.out.println("order : null  ( 정렬조건없음 )" );
	} else {
		order = ","+ order;
		System.out.println("order : " + order + " (새로 정렬할 조건) ");      	// sql문에서 기본 order by ~ 에 ',' ~ 추가 
	} 
		
	String category = request.getParameter("category"); 					// 카테고리 변수 받기	
	System.out.println("category : " +category);	
%>

<%
	int totalItem = 0;	

	// 쿼리문에서 받아온 wcnt 값 이용해 페이징 
	String searchCount = null; // 검색결과 수 변수 초기화
	
	ArrayList<HashMap<String, Object>> goodsList = GoodsDAO.getGoodsList(category,searchWord,order,currentPage,itemPerPage) ; 
	for (HashMap<String, Object> goodsMap : goodsList) {    
		searchCount = (String) goodsMap.get("wcnt");
	    break;																// 모두 같은 wcnt(searchCount)값을 가지므로 한번만 실핼하고 종료		
	}
	
	System.out.println("검색 항목 수 : " + searchCount + "개");	 
	
	if(searchCount!=null){  												 // 검색결과가 없어 null값이 반환되는 예외 분리
	totalItem = Integer.parseInt(searchCount);	
	}
	System.out.println(totalItem+"<-totalItem");
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
	<link href="/shop/SHOP.css?after" rel="stylesheet">
	<link rel="icon" href="/shop/favicon.ico">	
		<meta charset="UTF-8">	
	<title>goodsList</title>	
</head>
<body>
<div class="row">
	<div class="col-1"> </div>	
	<div class="col-10"><br>
		<div>
			<jsp:include page="/emp/inc/CommonBar.jsp"></jsp:include>
		</div> 		
		<div style="text-align:center; padding:0px 10%; height: ; ">
			<jsp:include page="/emp/inc/img.jsp"></jsp:include> 
		</div><br>	
		<div style="margin-left: 30px; margin-right: 30px;" >
			<div style="display: flex; justify-content: space-between; align-items: center; width: 100%">
				<div>
					<h5>
					<%	if (searchWord != "") {  							// 검색을 했을경우에는 '~에대한 검색결과: x개' 표시
							if(category!=null&&!category.equals("null")){     // + 카테고리를 설정했을경우에는 앞에 ' y 카테고리의 ' 추가
						%>	'<%=category%>' 카테고리의
						<%	
							}
						%><b>'<%=searchWord%>'</b> 에 대한 검색결과 : <%=totalItem%>개
					<% } else {												// 검색을 하지 않은 경우에는 '총x개의 상품이 있습니다' 표시
					%> 	 총 <%=totalItem%>개의 상품이 있습니다.
					<% } %>
					</h5>
				</div>
				<form style="display: flex; align-items: center;">
					<input class="form-control me-2" style="width: 300px" name="searchWord" type="search" placeholder="원하시는 상품을 검색하세요"> 
					<input type="hidden" name="category" value="<%=category%>"> 
					<input type="hidden" name="perPage" value="<%=perPage%>"> 
					<input type="hidden" name="order" value="<%=array%>">
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
	<script>   // submit 버튼 없이 select의 옵션을 클릭했을때 작동되게 하는 스크립트
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
			for (HashMap<String, Object> goodsMap : goodsList) { 
		%>	
		
		 <a class="item-wrapper" href="/shop/goods/goodsOne.jsp?goodsNum=<%=(String)(goodsMap.get("goodsNum"))%>">	
			<div class="item">				
			<table style=" background-color:#F8F8F8; borders:1px solid " >
<!-- 이미지 -->	<tr><th class="goodsBorder itemImg"><img src="/shop/upload/<%=(String)(goodsMap.get("filename"))%>" style="width:140px; height:140px;"></img></th></tr> 
<!-- 상풍명 -->	<tr><td class="goodsBorder itemTitle" style="padding-left:8%"><%=(String)(goodsMap.get("goodsTitle"))%></td></tr>
<!-- 가격 -->		<tr><td class="price itemEx" style="padding-left:8%"><%=(String)(goodsMap.get("goodsPrice"))%>원</td></tr>
<!-- 재고 -->		<tr><td class="goodsBorder itemEx" style="padding-left:8%"><%=(String)(goodsMap.get("goodsAmount"))%>개</td></tr>				
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
			<%	String priviousTab = null;
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
			</ul>
		</nav>
	</div>
	<div class="col-1" style="background-color:#"></div>
	</div>	
	<%	
		System.out.println("----------------------------------------");
	%>		
	<div>
		<jsp:include page="/emp/inc/bottomInfo.jsp"></jsp:include>
	</div> 
</body>
	
</html>