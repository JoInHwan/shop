<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "shop.dao.CustomerDAO" %>
<%@ page import = "shop.dao.OrderDAO" %>

<%
	//로그인 인증 분기 : 세션변수 -> loginCustomer
// 	if(session.getAttribute("loginCustomer")==null){ //로그인이 되어있지 않으면
// 		response.sendRedirect("/shop/loginForm.jsp");
// 		return;
// 	}
%>
<%
	HashMap<String,Object> loginMember	= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
	
		String loginId = null;
		String loginName = null;
	if(session.getAttribute("loginCustomer")!=null){      // 고객으로 로그인 되어있어 본인 정보 볼 때 
		loginId = (String) (loginMember.get("id"));
		loginName = (String) (loginMember.get("name"));		
	}
	
	
	if( request.getParameter("id")!=null && request.getParameter("name")!= null){ // 직원으로 로그인해서 고객정보 볼 때
		loginId = request.getParameter("id");
		loginName = request.getParameter("name");
		System.out.println("id sssss: " + loginId);
		System.out.println("name : " + loginName);
		
	}
	
	System.out.println("id : " + loginId);
	System.out.println("name : " + loginName);
	
	HashMap<String, String> customerInfo = CustomerDAO.CustomerOne(loginName,loginId);

	ArrayList<HashMap<String, String>>orderInfo = OrderDAO.getOrderList(loginId);
	
	int orderTableNum = 1;
	int totalPrice = 0;
%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link href="/shop/SHOP.css" rel="stylesheet">
<link rel="icon" href="/shop/favicon.ico">	
	<meta charset="UTF-8">
	<title>내정보</title>
	<style>
		.tbLeft{
			text-align:right;
			background-color: #DCDCDC;
			width: 20%;
			padding:6px 16px;
			font-weight: bold;
		}
		.tbRight{
			text-align:left;
			padding:6px 16px;
			width:800px;
		}
		.udInfo{
			padding : 0px 10px ;
		}
	</style>
</head>
<body>
	<div class="row">
		<div class="col-1"></div>	
		<div class="col-10"><br>
			<div style="text-align: center; height: 60px;">
				<div>
					<jsp:include page="/emp/inc/CommonBar.jsp"></jsp:include>
				</div>
			</div>
			<div style="height:10px" ></div>
			<br><br>
		</div>
		<div class="col-1" style="background-color:#"></div>
	</div>
	<%
		if(session.getAttribute("loginCustomer")!=null && session.getAttribute("loginEmp")==null){ // '고객'으로 로그인 했을때
	%>
		<div class = "container" style="text-align: center">	
			<div style="display: inline-block;  width:70%">	<br>
				<h2>회원정보</h2>	
				<hr>
				<form action = "/shop/action/updateCustomerAction.jsp" >
				<table border="1" style="display: inline-block; margin-right:">
					<tr>
						<td class="tbLeft">아이디</td>
						<td class="tbRight"><%=loginId%></td>			
					</tr>
					<tr>
						<td class="tbLeft">이름</td>
						<td class="tbRight"><%=loginName%></td>			
					</tr>	
					<tr>
						<td class="tbLeft">생일</td>
						<td class="tbRight"><%=customerInfo.get("birth")%></td>			
					</tr>
					<tr>
						<td class="tbLeft">성별</td>
						<td class="tbRight"><%=customerInfo.get("gender")%></td>			
					</tr>
					<tr>
						<td class="tbLeft">주소</td>
						<td class="tbRight"><input type="text" name="address" value="<%=customerInfo.get("address")%>" class="udInfo" style="width:500px;"></td>			
					</tr>
					<tr>
						<td class="tbLeft">전화번호</td>
						<td class="tbRight"><input type="text" name="phoneNum" value="<%=customerInfo.get("phoneNum")%>" class="udInfo"></td>			
					</tr>
					<tr>
						<td class="tbLeft">회원가입일</td>
						<td class="tbRight"><%=customerInfo.get("createDate")%></td>			
					</tr>
					<tr>
						<td class="tbLeft">수정날짜</td>
						<td class="tbRight"><%=customerInfo.get("updateDate")%></td>			
					</tr>
					<tr>
						<td class="tbLeft">개인정보 변경</td>
						<td class="tbRight">
							<input type="hidden" name="id" value="<%=loginId%>">
							<button type="submit" class="btn btn-info btn-sm " style="color:white">정보수정</button>
							<a href="/shop/customer/checkIdForm.jsp" class="btn btn-dark btn-sm">비밀번호 변경</a>
							<button id="viewButton" type="button" class="btn btn-sm btn-danger">회원탈퇴</button>
						</td>		
					</tr>	
					<tr>
						<td colspan="2">
							<div id="confirmation" style="display:none;">정말 탈퇴하시겠습니까? &nbsp;
							<a id="submitButton" href="/shop/action/deleteCusotmerAction.jsp?id=<%=loginId%>" class="btn btn-danger">예</a>
							</div>
						</td>
					</tr>	
				</table>
			</form>
			<script>
			// 페이지 로드 시 실행되는 함수
			window.onload = function() {
			    // '회원탈퇴' 버튼에 클릭 이벤트 추가
			    document.getElementById("viewButton").onclick = function() {
			        // '정말로 탈퇴하시곘습니가' 텍스트와 '예' 버튼 보이기
			        document.getElementById("confirmation").style.display = "inline-block";
			    };
			};
			</script>
			<br>
			<hr style="border: 2px solid black;">
			<h2>구매정보</h2>	<br>
		<%	
			if(	orderInfo.isEmpty() ){ // 구매이력이 없을 때
		%>
				<table style="display: inline-block;">
					<tr>
						<td colspan="3" style="text-align:left"> 구매 이력이 없습니다</td>
					</tr>
				</table>
		<%
			}
			for (HashMap<String, String> m : orderInfo) { 		
		%>	
				<form class="form-control" style="margin-bottom : 50px;  border:solid 2px; background-color: #B0C4DE;">
					<div style="height:1px; text-align:right;"><%= orderTableNum%>번</div> 
					<div style="text-align:left;">
						<span style="font-size: 25px; font-weight: bold">
						<%String buyDate = m.get("buyTime").substring(0,4)+"."+ m.get("buyTime").substring(5,7)+ "." + m.get("buyTime").substring(8,10);%>				
						<%=buyDate%> 주문</span>  
					</div>
					<div class="form-control" style="margin-bottom : 10px;  border:solid 1px">					
						<table style="width:100%;  text-align:left">
							<tr>
								<td colspan="4" style="font-size:25px; font-weight: bold; padding:10px 15px;"><%= m.get("state")%> </td>
								<td rowspan="3" style="text-align:center; padding: 10px 10px; border-left:1px solid; height:250px; width:15%; background-color:#FFFFF0;"> 
							<%
								if( m.get("state").equals("결제대기")){
							%>			
									<a href="#" class="btn btn-success">결제하기</a> <br>			
							<%	
								}						
							%>		
								<a href="#" class="btn btn-outline-warning" style="margin:10px 0px; color:black;">배송조회</a> <br>
							<%
								if( m.get("state").equals("배송완료")){
							%>			
									<a href="/shop/goods/goodsOne.jsp?goodsNum=<%=m.get("goodsNum")%>" class="btn btn-outline-info" style="color:black">리뷰작성</a> <br>
							<%	
								}else {
							%>			
									<a href="/shop/action/deleteOrderAction.jsp?orderNum=<%=m.get("orderNum")%>" class="btn btn-outline-danger">주문취소</a>
							<%	
								}
							%>	
								</td>
							</tr>
							<tr>
								<td rowspan="2" style="text-align:center; width:20%"> <img src="/shop/upload/<%=(m.get("filename"))%>" style="width:100%;"></img></td>
								<td colspan="3" style="font-size:20px; padding:0px 10px" ><%= m.get("goodsTitle")%></td>
							</tr>
							<tr>
								<td colspan="2" style="font-size:16px; padding:5px 10px"><%= m.get("goodsPrice")%>원 &nbsp;/&nbsp; <%= m.get("amount")%>개	</td>
								<td style="text-align:right; padding-right:10px;"><a href="#" class="btn btn-sm	btn-light">장바구니담기</a></td>
							</tr>
						</table>
					</div>
				</form>
				<script>
					// 숫자에 쉼표 추가하는 JavaScript 함수
					function addCommas(num) {
					    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
					}
					
					// 페이지 로드 시 가격 출력
					document.getElementById("formattedPrice<%= orderTableNum %>").innerText = addCommas(<%= totalPrice %>);
				</script>  	
			<%
					orderTableNum++;			
				}
			%>		
		</div>
	</div>
<%}%>
<!-- -------------------------------------------------------------------------------------------------------------------------------------------------------------- -->
<%
	if(request.getParameter("id")!=null && request.getParameter("name")!= null){ // '고객'으로 로그인 했을때
%>	
<div class = "container" style="text-align: center">	
			<div style="display: inline-block;  width:70%">	<br><br><br>
				<h2>회원정보</h2>	
				<hr>
				<form action = "/shop/action/updateCustomerInfo.jsp" >
				<table border="1" style="display: inline-block; margin-right:">
					<tr>
						<td class="tbLeft">아이디</td>
						<td class="tbRight"><%=loginId%></td>			
					</tr>
					<tr>
						<td class="tbLeft">이름</td>
						<td class="tbRight"><%=loginName%></td>			
					</tr>	
					<tr>
						<td class="tbLeft">생일</td>
						<td class="tbRight"><%=customerInfo.get("birth")%></td>			
					</tr>
					<tr>
						<td class="tbLeft">성별</td>
						<td class="tbRight"><%=customerInfo.get("gender")%></td>			
					</tr>
					<tr>
						<td class="tbLeft">주소</td>
						<td class="tbRight"><%=customerInfo.get("address")%></td>			
					</tr>
					<tr>
						<td class="tbLeft">전화번호</td>
						<td class="tbRight"><%=customerInfo.get("phoneNum")%></td>			
					</tr>
					<tr>
						<td class="tbLeft">회원가입일</td>
						<td class="tbRight"><%=customerInfo.get("createDate")%></td>			
					</tr>
					<tr>
						<td class="tbLeft">수정날짜</td>
						<td class="tbRight"><%=customerInfo.get("updateDate")%></td>			
					</tr>
				</table>
			</form>
			
			<br>
			<hr style="border: 2px solid black;">
			<h2>구매정보</h2>	
		<%	
			if(	orderInfo.isEmpty() ){ // 구매이력이 없을 때
		%>
				<table style="display: inline-block;">
					<tr>
						<td colspan="3" style="text-align:left"> 구매 이력이 없습니다</td>
					</tr>
				</table>
		<%
			}
			for (HashMap<String, String> m : orderInfo) { 		
		%>	
				<form class="form-control" style="margin-bottom : 50px;  border:solid 2px; background-color: #B0C4DE;">
					<div style="height:1px; text-align:right;"><%= orderTableNum%>번</div> 
					<div style="text-align:left;">
						<span style="font-size: 25px; font-weight: bold">
						<%String buyDate = m.get("buyTime").substring(0,4)+"."+ m.get("buyTime").substring(5,7)+ "." + m.get("buyTime").substring(8,10);%>				
						<%=buyDate%> 주문</span>  
					</div>
					<div class="form-control" style="margin-bottom : 10px;  border:solid 1px">					
						<table style="width:100%;  text-align:left">
							<tr>
								<td colspan="4" style="font-size:25px; font-weight: bold; padding:10px 15px;"><%= m.get("state")%> </td>
								<td rowspan="3" style="text-align:center; padding: 10px 10px; border-left:1px solid; height:250px; width:15%; background-color:#FFFFF0;"> 
								
								<a href="#" class="btn btn-outline-warning" style="margin:10px 0px; color:black;">배송조회</a> <br>
								<a href="/shop/goods/goodsOne.jsp?goodsNum=<%=m.get("goodsNum")%>" class="btn btn-outline-info" style="color:black">리뷰보기</a> <br>
								</td>
							</tr>
							<tr>
								<td rowspan="2" style="text-align:center; width:20%"> <img src="/shop/upload/<%=(m.get("filename"))%>" style="width:100%;"></img></td>
								<td colspan="3" style="font-size:20px; padding:0px 10px" ><%= m.get("goodsTitle")%></td>
							</tr>
							<tr>
								<td colspan="2" style="font-size:16px; padding:5px 10px"><%= m.get("goodsPrice")%>원 &nbsp;/&nbsp; <%= m.get("amount")%>개	</td>
								<td style="text-align:right; padding-right:10px;"><a href="#" class="btn btn-sm	btn-light">장바구니담기</a></td>
							</tr>
						</table>
					</div>
				</form>
				<script>
					// 숫자에 쉼표 추가하는 JavaScript 함수
					function addCommas(num) {
					    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
					}
					
					// 페이지 로드 시 가격 출력
					document.getElementById("formattedPrice<%= orderTableNum %>").innerText = addCommas(<%= totalPrice %>);
				</script>  	
			<%
					orderTableNum++;			
				}
			%>	
		<br>				
		</div>
	</div>
		
<%	
	}
%>
	<div>
		<jsp:include page="/emp/inc/bottomInfo.jsp"></jsp:include>
	</div> 
</body>
</html>