<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "shop.dao.GoodsDAO" %>
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
		response.sendRedirect("/shop/goods/goodsList.jsp");
		
	}else{		
		goodsNum = request.getParameter("goodsNum");	
	}
	
	HashMap<String, String> goodsOne = GoodsDAO.getGoodsOne(goodsNum); 
	
	int itemIndexerPage = 8;
	ArrayList<HashMap<String, Object>> goodsList = GoodsDAO.GoodsListBottom(itemIndexerPage); 
	
	
	HashMap<String, String> review = ReviewDAO.getReviewList(goodsNum); 
	
	
	// 별점 알고리즘
	
	int sr = 0;
	int fullStar = 0;
	int halfStar = 0;
	int emptyStar = 0;
	
	if(review!=null){ 		
		String score = review.get("score");   // DB의 score값 저장
		float star = Float.parseFloat(score); // float로 형변환
		System.out.println("star : " + star);
		
		sr = Math.round(star)*10; // 반올림 한 뒤 10배
		System.out.println("sr : " + sr);
		fullStar = sr / 20;		   // 가득찬 별 수
		emptyStar = ((101-sr)/20); // 빈 별 수
		halfStar = 5 -( fullStar + emptyStar); //반쪽별 수
		
		System.out.println("가득찬별 수 : " + fullStar);
		System.out.println("빈 별 수 : " + emptyStar);
	}
	
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>상품 자세히</title>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<Style>
	.item{
	/* 상품div */
			display: flex;
     		width:25%;     
/*    			width:200px;    */
			flex-wrap: wrap;
 			box-sizing: border-box; 
			float:left;
			border:none; 			
            transition: background-color 0.3s ease;
	}
	   .itemIndex:hover {
            background-color: #ccc;
        }
         .item-wrapper {
        display: block; /* div를 블록 레벨 요소로 변경 */
        text-decoration: none; /* 링크에 밑줄 제거 */
        color: inherit; /* 링크 색상 상속 */
    }
	
	
	.itemIndex{
	display:inline-block;
	}
	
	.indexTable{
	margin-top:5px;
	}
	
	.reviewTable{
	border:solid 1px;
	}
	.checked {
	  color: black;
	}
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
					<td> &nbsp; </td>
					<td colspan="2"><a href="" class="form-control-lg btn btn-outline-success">장바구니 담기 </a>&nbsp;
						<a href="" class="form-control-lg btn btn-primary"> 바로구매 </a>
					</td>
				<tr>			
				</table>
				
				<br><br>
				
				<table class="table table-hover" >
					<tr>								
						<th colspan="3" style="background-color: #A9A9A9">상품평</th>								
					</tr>
				<%
					if(review==null){ 				
				%>
					<tr>
						<td colspan="3"> 상품 구매 후 리뷰를 작성해 주세요!</td>												 
					</tr>
				<%
					}else if( review!=null){
				%>
					<tr>
						<th style= "width:20%; height:18px; font-size:13px; paddin ">평점</th>
						<td style="font-size:13px;">내용</td>
						<td style= "width:20%; font-size:13px;" >비고</td>
					</tr>
					<tr>
						<td> <%=review.get("score")%>
						
						<%
						for(int i=1;i<=fullStar;i++){
					%>
						<span class="fa fa-star checked"></span>
					<%	
						}
						
						if(halfStar == 1){
					%>
						<span class="fa fa-star-half-o checked"></span>
					<%		
						}
						if(emptyStar!=0){						
							for(int i=1;i<=emptyStar;i++){
						%>
							<span class="fa fa-star-o"></span>
						<%		
							}
						}
					%>
						
						
						
						
						
						
						
						
						
						
<!-- 							<span class="fa fa-star checked"></span> -->
<!-- 							<span class="fa fa-star checked"></span> -->
<!-- 							<span class="fa fa-star checked"></span> -->
<!-- 							<span class="fa fa-star-half-o checked"></span>  -->
<!-- 							<span class="fa fa-star-o"></span>  -->
							
						</td>
						<td >
							<%=review.get("content")%>
						</td>
						<td style="text-align: right;font-size:12px;"><%=review.get("createDate")%>
							<br> 작성자 : <%=review.get("id")%>							<a href="#"> 삭제 </a> 
						</td>						 
					</tr>	
									
				<% 				
					}
				%>
			</table>
				
				
			</div>
			
		</div>	
		
			
		
		<hr>
		<div style="font-size:14px; height:20px; padding-left:15%" > 함께 보면 좋을 상품 </div>
			<div class="row">
		 		<div class="col-2" style="background-color:"></div>		
				<%	
					for (HashMap<String, Object> goodsMap : goodsList) { 
				%>						
					<div class="itemIndex col-1"  style="padding-top:1px;">
						<a class="item-wrapper" href="/shop/goods/goodsOne.jsp?goodsNum=<%=(String)(goodsMap.get("goodsNum"))%>">		
							<table class="indexTable">
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
<%System.out.println("----------------------------------------");%>
</body>
</html>