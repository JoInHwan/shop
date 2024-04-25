<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp , loginCustomer
	if(session.getAttribute("loginEmp")!=null || session.getAttribute("loginCustomer")!=null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/goods/goodsList.jsp");
		return;
	}	
	session.invalidate();
%>
<%
	String idValue = "";
	String pwValue = "";
	String errMsg = "";
	
	
	if(request.getParameter("idValue")!=null){  /* 에러메시지가 뜰때 기존에 기입했던 정보들 유지하기 위함 */
		idValue = request.getParameter("idValue");
		//System.out.println( idValue + " <--idValue at | loginForm");
	}
	if(request.getParameter("pwValue")!=null){
		pwValue = request.getParameter("pwValue");
		//System.out.println( pwValue + " <--pwValue at | loginForm");
	}
	if(request.getParameter("errMsg")!=null){	 /* 아이디와 비밀번호가 잘못되었습니다 메시지 */	
		errMsg = request.getParameter("errMsg");
		//System.out.println( errMsg + " <--errMsg at | loginForm");
	}

	String goodsNum = "";
	if(request.getParameter("goodsNum")!=null){
		goodsNum = request.getParameter("goodsNum");
		//System.out.println( goodsNum + " <--goodsNum at | loginForm");
	}	 
%>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="/shop/SHOP.css?after" rel="stylesheet">
<link rel="icon" href="/shop/favicon.ico">
	<meta charset="UTF-8">
	<title>회원로그인</title>
	<style>
	.inputInfo{
		border: 1px solid;
		border-color: #B0C4DE;
	}
	
	.findID{
		color: black
	}
	</style>
</head>
<body class="container bg">
<div class="row">
	<div class="col"></div>
	<div class="col-6 content shadow lgPgCenterDiv"><br>
		<div class="ssmDiv">
		  <a href="/shop/goods/goodsList.jsp" class="ssmAlink">
		  	<span style="margin-left:5%" ><img src="/shop/upload/sosom.png" style="width:40px; margin-top:10%;"></span>
		  	<span class="ssmSpan">SOSOM</span>
		  </a>	
		</div>
		<br><br>
		<h2>회원로그인</h2><hr style="border: 2px solid black;"><br> 
		<div style="background-color: white; margin-left:15%; margin-right:15%;" >
			<form action="/shop/action/loginAction.jsp?goodsNum=<%=goodsNum%>" method="post"> <!--비로그인상태에서 상품구매클릭후 로그인하면 보던 해당상품 구매페이지로 넘어가기 위함 -->		
				<input class="form-control form-control-lg inputInfo" type="text" name="id" value="<%=idValue%>" placeholder="아이디" >
				<div style="heigth:40px">&nbsp;</div>
				<input class="form-control form-control-lg inputInfo" type="password" name="pw" value="<%=pwValue%>" placeholder="비밀번호"> <br>
					
				<div style="height:30px">				
					<a style="color:red;" href="/shop/loginForm.jsp"><%=errMsg %></a>					
				</div>
				<br>	
				<button class="form-control btn btn-primary btn-lg" type="submit">로그인</button>							
			</form><br>
			<form action="/shop/customer/signUpForm.jsp"> 					
				<button type="submit" class="form-control form-control-lg btn btn-lg btn-outline-dark">회원가입</button>			
			</form>		
		</div>
		
		<br><br>
			
		<div style="display: flex; justify-content: center;">
	    	<a href="/shop/customer/findIdForm.jsp" class="findID" style="" >아이디 찾기</a>
	   		<span style="margin: 0px 4%">|</span>
	   		<a href="/shop/customer/findPwForm.jsp" class="findID" style="">비밀번호 찾기</a>
		</div>
		<br><br><br>
		<a href="/shop/emp/empLoginForm.jsp">직원로그인하러가기 </a> <br>				
		<a href="/shop/goods/goodsList.jsp">비로그인쇼핑하기</a><br><br>
		<span style="font-size: 12px;">made by 조인환 in goodee</span>			
	</div>
	<div class="col"></div>
	<%System.out.println("----------------------------------------");%>		
</div>	
</body>
</html>