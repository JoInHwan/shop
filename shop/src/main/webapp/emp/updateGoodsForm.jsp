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
	
%>
<%
	// MaraiDB연동 DAO 연결
	String goodsNum = request.getParameter("goodsNum");
	HashMap<String, String> goodsOne = GoodsDAO.getGoodsOne(goodsNum); 
	
	int iitemIndexerPage = 8;
	ArrayList<HashMap<String, Object>> goodsList = GoodsDAO.GoodsListBottom(iitemIndexerPage); 
	
	int updateSucceed = 0;
	
	if(request.getParameter("updateSucceed")!=null){
		updateSucceed = 1; 
	}
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
		padding-left:20px;
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
			<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
		</div> 
		<br>	
		<div class="in" style="text-align: center">
			<div style="display: inline-block;">
				<h2>상품수정</h2>
				<hr>
				<form method="post" action="/shop/action/updateGoodsAction.jsp">
				<input type="hidden" class="form-control" name="goodsNum" value='<%=(goodsOne.get("goodsNum"))%>'>
				<table style="text-align:left">
					<tr>
						<td rowspan="6" style=" border-right:solid;">
							<img src="/shop/upload/<%=(goodsOne.get("filename"))%>"	style="height:500px;"></img>
						</td>
						<td style="width:600px;">
							<label class="form-label"> <b>이름</b></label> 
							<input type="text" class="form-control" name="title" value='<%=(goodsOne.get("goodsTitle"))%>'>
						</td>
					</tr>
					<tr>
						<td>
							<label class="form-label"><b>카테고리</b></label> 
							<select	name="category" class="form-control">
								<option value='<%=(goodsOne.get("category"))%>'><%=(goodsOne.get("category"))%></option>
								<option value="맨시티">맨시티</option>
								<option value="맨유">맨유</option>
								<option value="리버풀">리버풀</option>
								<option value="아스날">아스날</option>
								<option value="토트넘">토트넘</option>
								<option value="축구공">축구공</option>
							</select>
						</td>
					</tr>
					<tr>
						<td style="color: red">
							<label class="form-label"><b>가격</b></label> 
							<input type="text" class="form-control" name="price" value='<%=(goodsOne.get("goods_price"))%>'>
						</td>
					</tr>
					<tr>
						<td><label class="form-label"><b>재고</b></label> 
						<input type="text" class="form-control" name="amount" value='<%=(goodsOne.get("goods_amount"))%>'></td>
					</tr>
					<tr>
						<td>
							<label class="form-label"><b>내용</b></label> 
							<textarea rows="3" cols="4" class="form-control" name="content"  ><%=(goodsOne.get("goods_content"))%></textarea>							
						</td>
					</tr>
					
					<tr>
						<td>
							<button type="submit" class="btn btn-primary">수정하기</button>
							&nbsp;
						<%
							if(updateSucceed==1){
						%>
							<span style="color:red; font-size:20px"> 상품이 수정되었습니다!</span>
						<%							
							}
						%>							
							
						</td>
					<tr>
				</table>
				</form>
			</div>
		</div>	
		<hr>
		<div style="font-size:14px; height:20px; padding-left:15%" > 다른 상품 </div>
			<div class="row">
		 		<div class="col-2" style="background-color:"></div>		
				<%	
					for (HashMap<String, Object> goodsMap : goodsList) { 
				%>						
					<div class="itemIndex col-1"  style="padding-top:1px;">
						<a class="item-wrapper" href="/shop/emp/updateGoodsForm.jsp?goodsNum=<%=(String)(goodsMap.get("goodsNum"))%>">		
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