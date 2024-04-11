<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp , loginCustomer
	if(session.getAttribute("loginEmp")!=null || session.getAttribute("loginCustomer")!=null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/goods/goodsList.jsp");
		return;
	}	
%>
<%
	String idValue="";
	String pwValue="";
	String errMsg="";
	if(request.getParameter("idValue")!=null){
		idValue = request.getParameter("idValue");
	}
	if(request.getParameter("pwValue")!=null){
		pwValue = request.getParameter("pwValue");
	}
	if(request.getParameter("errMsg")!=null){	 /*에러메시지변수가 있다면 (로그인이 OFF상태라면) 출력*/	
		errMsg = request.getParameter("errMsg");
	}

%>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="/shop/SHOP.css" rel="stylesheet">
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
	<div class="col-6 content shadow" style="text-align: center; padding:20px 0px; margin-bottom: 20px; border-radius: 20px;" >
	<h2>회원로그인</h2> <hr> <br>
		<div style="background-color: white; margin-left:15%; margin-right:15%;" >
			<form action="/shop/action/loginAction.jsp" method="post"> 	
				<input class="form-control form-control-lg inputInfo" type="text" name="id" value="<%=idValue%>" placeholder="아이디" >
				<div style="heigth:40px">&nbsp;</div>
				<input class="form-control form-control-lg inputInfo" type="password" name="pw" value="<%=pwValue%>" placeholder="비밀번호"> <br>	
			<div style="height:30px">				
				<a style="color:red;" href="/shop/loginForm.jsp"><%=errMsg %></a>					
			</div><br>		
				<button class="form-control btn btn-primary btn-lg" type="submit">로그인</button>			
			</form>	<br>
			<form action="/shop/customer/signUpForm.jsp"> 					
				<button type="submit" class="form-control form-control-lg btn btn-lg btn-outline-dark">회원가입</button>			
			</form>		
	</div><br><br>			
	
	<div style="display: flex; justify-content: center;">
    <a href="/shop/customer/findIdForm.jsp" class="findID" style="" >아이디 찾기</a>
    <span style="margin: 0px 4%">|</span>
    <a href="/shop/customer/checkIdForm.jsp" class="findID" style="">비밀번호 찾기</a>
    <span style="margin: 0px 4%">|</span>
    <a href="/shop/customer/findPwForm.jsp" class="findID" style="">비밀번호 변경</a>
	</div> <br><br><br>

	
	<a href="/shop/emp/empLoginForm.jsp">직원로그인하러가기 </a> <br>				
	<a href="/shop/goods/goodsList.jsp">비로그인쇼핑하기</a><br><br>
	<span style="font-size: 12px;">made by 조인환 in goodee</span>			
	</div>
	<div class="col"></div>
	<%System.out.println("----------------------------------------");%>		
</div>	
</body>
</html>