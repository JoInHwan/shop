<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "shop.dao.GoodsDAO" %>
<%@ page import = "shop.dao.OrderDAO" %>
<%@ page import = "shop.dao.CustomerDAO" %>
<%
	if((HashMap<String,Object>)(session.getAttribute("loginCustomer")) == null){
		response.sendRedirect("/shop/loginForm.jsp"); 
	} 
	else{

	HashMap<String,Object> loginMember	= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
	
		String loginId = null;
		String loginName = null;
	if(session.getAttribute("loginCustomer")!=null){   
		loginId = (String) (loginMember.get("id"));
		loginName = (String) (loginMember.get("name"));		
	}
		
	
	System.out.println("id : " + loginId);
	System.out.println("name : " + loginName);
		
%>
<%
	
	String goodsNum = request.getParameter("goodsNum");
	String id = request.getParameter("id");

	System.out.println("goodsNum : " + goodsNum );
	System.out.println("id : " +  id );	
	
	// 구매자 정보
	HashMap<String, String> customerInfo = CustomerDAO.CustomerOne(loginName,loginId);
	
	// 상품
	HashMap<String, String> goodsOne = GoodsDAO.getGoodsOne(goodsNum);
	
	// 주분
	int total_price = Integer.parseInt(goodsOne.get("goods_price"));
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>바로구매</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link href="/shop/SHOP.css" rel="stylesheet">
	<style>
		table,tr,td{
		width:90%
		}
		
		.tbLeft{
			text-align:right;
			background-color: #D3D3D3;
			width: 20%;
			padding:6px 16px;
			font-weight: bold;
		}
		.tbRight{
			padding:6px 16px;
		}
		
		.payBtn{
		 display: block;
        margin: 0 auto;
        width: 400px; 
        font-size: 28px; 
        border: 2px solid #000;
        border-radius: 5px; 
        }
	</style>
</head>
<body class="container">
	<br>
	
	<div style=" padding:0% 5%">	
		<h2><b>주문/결제</b></h2>
		<hr style="border: 2px solid black;"><br>	
		<span style="font-size:20px">구매자정보</span>
		<table style="border-top: 2px solid">
		<tr>
			<td class="tbLeft">이름</td>
			<td class="tbRight"><%=loginName%></td>			
		</tr>
		<tr>
			<td class="tbLeft">이메일</td>
			<td class="tbRight"><%=loginId%></td>
		</tr>
		<tr>
			<td class="tbLeft">휴대폰번호</td>
			<td class="tbRight"><%=customerInfo.get("phoneNum")%></td>			
		</tr>
	
		</table>
		
		<br><br>
		받는사람 정보
		<table style="border-top: 2px solid">		
			<tr>
				<td class="tbLeft">이름</td>
				<td class="tbRight">
				<input type= "text" value="<%=loginName%>"></td>			
			</tr>				
			<tr>
				<td class="tbLeft"> 주소</td>
				<td class="tbRight"><input type= "text" value="<%=customerInfo.get("address")%>" style="width:600px"></td>			
			</tr>
			<tr>
				<td class="tbLeft">연락처</td>
				<td class="tbRight"><input type= "text" value="<%=customerInfo.get("phoneNum")%>"></td>			
			</tr>			
		</table>
		<br><br>
		<form action="/shop/action/addOrderAction.jsp">
			상품
			<table style="border-top: 2px solid">	
			<tr>
				<td class="tbLeft">상품이름</td>
				<td class="tbRight"><%=(goodsOne.get("goodsTitle"))%></td>
				
			</tr>
			<tr>
				<td class="tbLeft">가격</td>			
				<td class="tbRight"><%=(goodsOne.get("goods_price"))%> 원</td>			
			</tr>
			<tr>
				<td class="tbLeft">개수</td>			
				<td class="tbRight">
					<input type="number" name="amount" value="1" min="1" style="padding-left:8px; width:60px" id="quantity" onchange="calculateTotal()"> 개
				</td>			
			</tr>			
			</table>
			<br>
		
	
			결제정보		
		<table style="border-top: 2px solid">	
			<tr>
				<td class="tbLeft">결제금액</td>
				<td class="tbRight"><span id="total_price" style="font-weight: bold"><%=total_price%></span>원</td>
			</tr>
			<tr>
				<td class="tbLeft">결제방법</td>
				<td class="tbRight">
					<input type="radio" name="pay" value="accountTransfer"> 계좌이체 &nbsp;
					<input type="radio" name="pay" value="creditCard"> 신용/체크카드 &nbsp;
					<input type="radio" name="pay" value="cpCreditCard"> 법인카드 &nbsp;
					<input type="radio" name="pay" value="phone"> 휴대폰 &nbsp;
					<input type="radio" name="pay" value="deposit"> 무통장입금(가상계좌)	&nbsp;	 			
				</td>
			</tr>
			
		</table> 
		<br><br><br>
		<input type="hidden" name="id" value="<%=loginId%>">
		<input type="hidden" name="goodsNum" value="<%=goodsNum%>">				
		<button type="submit" class="payBtn btn btn-primary btn-lg">결제하기</button>
		</form>
		<script>
		    function calculateTotal() {
		        var price = <%=(goodsOne.get("goods_price"))%>;		        
		        var quantity = document.getElementById("quantity").value;
		        var total_price = (price * quantity).toLocaleString('kr');
		        document.getElementById("total_price").innerText = total_price;
		    }
		</script>
	</div>
	<br><br><br><br><br><br><br>
</body>
</html>
<%}%>