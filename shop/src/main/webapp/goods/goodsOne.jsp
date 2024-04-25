<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "shop.dao.GoodsDAO" %>
<%@ page import = "shop.dao.OrderDAO" %>
<%@ page import = "shop.dao.ReviewDAO" %>
<%
	
	HashMap<String,Object> loginMember	= null;
	String id = null;
	
	if(session.getAttribute("loginCustomer")==null && session.getAttribute("loginEmp")!=null){ // '직원'으로 로그인 하면 세션 loginMember에 loginEmp가 저장
		loginMember	= (HashMap<String,Object>)(session.getAttribute("loginEmp"));
		id = (String)(loginMember.get("id"));
	}
	if(session.getAttribute("loginCustomer")!=null && session.getAttribute("loginEmp")==null){ // '고객'으로 로그인 하면 세션 loginMember에 loginCustome이 저장
		loginMember	= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
		id = (String)(loginMember.get("id"));
	}
%>
<%
	// MaraiDB연동 DAO 연결
	String goodsNum = request.getParameter("goodsNum");
	System.out.println("상품번호 : " + goodsNum);
	if(	goodsNum == null){ 				// 선택한 상품이 없으면 상품리스트 페이지로
		System.out.println("선택한 상품이 없음 " );  
		response.sendRedirect("/shop/goods/goodsList.jsp"); //적용안됌
		
	}else{		
		goodsNum = request.getParameter("goodsNum");	
	}
	
	HashMap<String, String> goodsOne = GoodsDAO.getGoodsOne(goodsNum); // GoodsOne 출력
	
	int itemIndexerPage = 8;
	ArrayList<HashMap<String, Object>> goodsList = GoodsDAO.GoodsListBottom(itemIndexerPage); // 하단 다른 상품목록 출력
	boolean reviewOk = false;				// 리뷰작성권한 확인
	
	HashMap<String, String> orderNumCheck = null; 
	String orderNum = null;
	
	if(session.getAttribute("loginCustomer")!=null){		//  고객로그인 되어있을때
		
		reviewOk = OrderDAO.orderCheck(id,goodsNum);		// 리뷰작성 가능/불가능 확인
		System.out.println("reviewOK : " + reviewOk);
		
		
		orderNumCheck = OrderDAO.orderNumCheck(id,goodsNum);
		if(orderNumCheck!=null){
		orderNum = orderNumCheck.get("orderNum");
		System.out.println(orderNum + "<-orderNum ");	
	
		}
	}
	
	ArrayList<HashMap<String, String>> reviewList = ReviewDAO.getReviewList(goodsNum); // 리뷰리스트 출력
	
	// 별점 알고리즘	
	String score = null;   // 점수 변수
	int sr = 0;      		// 점수를 flaot로 형변환 한뒤 10배 한 값 변수
	int fullStar = 0;	
	int halfStar = 0;
	int emptyStar = 0;	
	
	if(reviewList!=null){ 		 // 리뷰가 있으면
		for(HashMap<String, String>m : reviewList){		
				score =	m.get("score");   // DB의 score값 저장			
			float scoreF = Float.parseFloat(score); // float로 형변환
			//System.out.println("starF : " + scoreF);
			
		sr = Math.round(scoreF)*10; // 반올림 한 뒤 10배
		//System.out.println("sr : " + sr);
		fullStar = sr / 20;		   // 가득찬 별 수
		emptyStar = ((101-sr)/20); // 빈 별 수
		halfStar = 5 -( fullStar + emptyStar); //반쪽별 수
		
		//System.out.println("가득찬별 수 : " + fullStar);
		//System.out.println("빈 별 수 : " + emptyStar);
		
		 m.put("fullStar", String.valueOf(fullStar));
		 m.put("halfStar", String.valueOf(halfStar));
		 m.put("emptyStar", String.valueOf(emptyStar));
		}	
	}
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>상품 자세히</title>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<link href="/shop/SHOP.css?after" rel="stylesheet">
	<link rel="icon" href="/shop/favicon.ico">
<Style>
	
		
</Style>	
	
	
</head> 
<body>
<div class="row">
 <div class="col-1">
  	 	
  </div>	
	<div class="col-10"><br>		
		<div>
			<jsp:include page="/emp/inc/CommonBar.jsp"></jsp:include>
		</div> 
		<br><br>	
		<div style="text-align: center">
			<div style="display: inline-block; width:80%">	
				<!-- goodsOne 출력 -->
				<table style="display: inline-block;">			
				<tr>
					<td rowspan="6">
						<img src="/shop/upload/<%=(goodsOne.get("filename"))%>" style="width:300px;"></img>
					</td>
					<td style="font-size:12px; width:80px;">이름 : </td>
					<td style=""><b><%=(goodsOne.get("goodsTitle"))%></b></td>
				</tr>
				<tr>
					<td style="font-size:12px;"> 카테고리 : </td>
					<td><%=(goodsOne.get("category"))%></td>
				</tr>			
				<tr>
					<td style="font-size:12px;"> 가격 : </td>
					<td style="color:red"><%=(goodsOne.get("goods_price"))%>원</td>
				</tr>
				<tr>
					<td style="font-size:12px;">재고 : </td>
					<td ><%=(goodsOne.get("goods_amount"))%>개</td>
				</tr>
				<tr>
					<td style="font-size:12px;">정보 : </td>
					<td style="width:300px"><%=(goodsOne.get("goods_content"))%></td>
				</tr>
				<tr>
				    <td>&nbsp;</td>
					    <td colspan="2" style="display: flex;   justify-content: center;">
<!-- 					        <a href="" class="form-control-lg btn btn-outline-success" style="margin-left: 20px;">장바구니 담기</a> -->
					        <form action="/shop/goods/purchaseGoodsForm.jsp" method="post" style="margin-left: 20px;">
					        	<input type="hidden" name="goodsNum" value="<%=goodsNum%>">
					        	<input type="hidden" name="id" value="<%=id%>">					        	
					            <button type="submit" class="form-control-lg btn btn-primary">바로 구매</button>
					        </form>
					    </td>
					<tr>			
				</table>
				<!--------------  리뷰 리스트 출력 코드 ------------------>
				<br><br>
				
				<table class="table table-hover" >
					<tr>								
						<th colspan="3" style="background-color: #A9A9A9">상품평</th>								
					</tr>
				<%
					if(reviewList==null){ 		// 리뷰가 없을때
				%>
					<tr>
						<td colspan="3"> 리뷰가 없습니다 </td>												 
					</tr>
				<%
					}else if( reviewList!=null){						
				%>
					<tr>
						<th style= "width:20%; height:18px; font-size:13px; paddin ">평점</th>
						<td style="font-size:13px;">내용</td>
						<td style= "width:20%; font-size:13px;" >비고</td>
					</tr>
				<%		
						for(HashMap<String, String>m : reviewList){  //리뷰리스트 출력
				%>
					
					<tr>
						<td> <%=m.get("score")%>						
					<%
						for(int i=1; i<=Integer.parseInt(m.get("fullStar")); i++){
					%> 
						<span class="fa fa-star checked"></span>
					<%	
						}
						
						if( Integer.parseInt(m.get("halfStar")) == 1){
					%>
						<span class="fa fa-star-half-o checked"></span>
					<%		
						}
						if(emptyStar!=0){						
							for(int i=1; i<=Integer.parseInt(m.get("emptyStar")) ; i++){
					%>
							<span class="fa fa-star-o"></span>
					<%		
							}
						}
					%>	
						</td>
						<td>
							<%=m.get("content")%>
						</td>
						<td style="text-align: right;font-size:12px;">	
								<form action="/shop/action/deleteReviewAction.jsp" method="post">
									<input type="hidden" name="orderNum" value="<%=orderNum%>">
									<input type="hidden" name="createDate" value="<%=m.get("createDate")%>">
									<input type="hidden" name="goodsNum" value="<%=goodsNum%>">
										<%=m.get("createDate")%>								
									<%
										if(reviewOk==true&& m.get("id").equals(id) ){	// 리뷰작성권한이 있고 리뷰를작성한 id와 로그인한 id가 같아야 삭제 가능			
									%>		
										<button type="submit" class="btn btn-danger" style="font-size:8px; width:14px; padding:0px "> X </button>																					
									<%
										}
									%>									
										<br> 작성자 : <%=m.get("id")%>									
								</form>	
						</td>						 
					</tr>			
				<% 				
						}
					}
				%>
			</table>
			<form method="post" class="form-control" action="/shop/action/addReviewAction.jsp" style="display: flex; flex-direction: row; align-items: center;">
				<input type="hidden" name="goodsNum" value="<%=goodsNum%>">
				<input type="hidden" name="orderNum" value="<%=orderNum%>">
				<div style="flex: 4; margin-left: 10px;">
			        <textarea name="content" class="form-control" placeholder="후기를 입력해주세요" rows="3"></textarea>
			    </div>
			    <div style="flex: 1;">
			        <input type="range" min="0.0" max="10.0" step="0.1" value="5.0" id="slider" name="score" style="width:70%;">
			        <p id="sliderValue" style="font-size:12px">평점 : 5.0 점</p>					
					    <script>
					        // 슬라이더 요소를 가져옵니다.
					        var slider = document.getElementById("slider");
					        // 텍스트를 추가할 요소를 가져옵니다.
					        var sliderValue = document.getElementById("sliderValue");
					
					        // 슬라이더 값이 변경될 때마다 실행되는 함수를 정의합니다.
					        slider.oninput = function() {
					            // 슬라이더의 현재 값을 가져옵니다.
					            var value = slider.value;
					            // 텍스트를 설정합니다.
					            sliderValue.innerHTML = "평점 : " + value + " 점";
					        };1111
					    </script>
					<%
						if(reviewOk==true){				
					%>	
						<button class="btn btn-outline-info" type="submit">리뷰등록</button>						
					<%
						}else {
					%>
						<button class="btn" disabled data-bs-toggle="button" >리뷰등록</button>
					<%		
						}
					%>
				</div>
			</form>
			</div>
		</div>		
		<hr>
		<div style="font-size:14px; height:20px; padding-left:18%" > 함께 보면 좋을 상품 </div>
			<div class="row">
		 		<div class="col-2" style="background-color:"></div>		
			<%	
				for (HashMap<String, Object> goodsMap : goodsList) { 
			%>						
					<div class="itemIndex col-1"  style="padding-top:1px; display:flex;justify-content: center;">
						<a class="item-wrapper" href="/shop/goods/goodsOne.jsp?goodsNum=<%=(String)(goodsMap.get("goodsNum"))%>">		
							<table class="indexTable" >
			<!-- 이미지 -->	<tr><th><img src="/shop/upload/<%=(String)(goodsMap.get("filename"))%>" style="width:80px;"></img></th></tr> 
			<!-- 상풍명 -->	<tr><td style="font-size: 10px; text-align: center;"><%=(String)(goodsMap.get("goodsTitle"))%></td></tr>
			<!-- 가격 -->		<tr><td style="font-size: 12px; color:red; text-align: center;"><%=(String)(goodsMap.get("goodsPrice"))%>원</td></tr>				
							</table>	
						</a>
					</div>		
			<%	
				}
			%>
				<div class="col-2" style="background-color:"></div>
				
			</div><br><br><br>
	</div>
	<div class="col-1" style="background-color:#"></div>
</div>
<div>
		<jsp:include page="/emp/inc/bottomInfo.jsp"></jsp:include>
</div> 
<%System.out.println("----------------------------------------");%>
</body>
</html>