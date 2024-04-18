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
	// MaraiDB연동 DAO 연결
	String title = request.getParameter("goodsTitle");
	HashMap<String, String> goodsOne = GoodsDAO.getGoodsOne(title); 
	
	int iitemIndexerPage = 8;
	ArrayList<HashMap<String, Object>> goodsList = GoodsDAO.GoodsListBottom(iitemIndexerPage); 
	
	
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>상품 자세히</title>
<Style>
<style>
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
	.item>.itemIndex>.table{	
		width: 100%;
		height: 60px; 			
		box-sizing: border-box;
		text-align: left;	
		border: none;
		margin-bottom: 40px;
		margin-top: 20px;		
		}
	
	.itemIndex{
	display:inline-block;
	}
	td{
		border:solid 1px;
	}
	
	.indexTable{
	margin-top:5px;
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
		<div class="in" style="text-align: center">
			<div style="display: inline-block;">	
				<table>
			
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
						<a class="item-wrapper" href="/shop/goods/goodsOne.jsp?goodsTitle=<%=(String)(goodsMap.get("goodsTitle"))%>">		
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