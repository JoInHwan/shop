<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp , loginCustomer
	if(session.getAttribute("loginEmp")!=null || session.getAttribute("loginCustomer")!=null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/goods/goodsList.jsp");
		return;
	}	
%>
<%
	String errMsg="";
	if(request.getParameter("errMsg")!=null){	 /* 해당하는 아이디가 없습니다 문자 출력*/	
	errMsg = request.getParameter("errMsg");
	}
	
	String nameValue="";
	String idValue="";
	String birthValue="";
	
	if(request.getParameter("nameValue")!=null){
		nameValue = request.getParameter("nameValue");
	}
	if(request.getParameter("idValue")!=null){
		idValue = request.getParameter("idValue");
	}
	if(request.getParameter("birthValue")!=null){
		birthValue = request.getParameter("birthValue");
	}
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>아이디 확인</title>
	<style>
	.inputInfo{
		border: 1px solid;
		border-color: red;
	}
	</style>
	
</head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="/shop/SHOP.css" rel="stylesheet">
<body class="container bg">
<div class="row">
	<div class="col"></div>
	<div class="col-6 content shadow" style="padding:20px 20px; margin-bottom: 20px; border-radius: 20px;" >
		<span><a href="/shop/loginForm.jsp">뒤로</a></span>
		<h3 style="text-align: center;">아이디 확인</h3> 
		<hr> <br><br><br><br>	
			<div class="col-sm-12" style="text-align:center">
			<img src="/shop/upload/findPw.png" style="width:500px;"></img>
			</div><br><br><br><br>
		<div align="center">
	    <form action="/shop/customer/resetPwForm.jsp" style="justify-content: center;">
	  		 <input class="form-control form-control-lg inputInfo" type="text" style="width:350px; margin-right: 10px;" name="name" value="<%=nameValue%>" placeholder="이름"><br>
	        <input class="form-control form-control-lg inputInfo" type="text" style="width:350px; margin-right: 10px;" name="id" value="<%=idValue%>" placeholder="아이디"><br>
	        <input class="form-control form-control-lg inputInfo" type="date" style="width:350px; margin-right: 10px;" name="birth" value="<%=birthValue%>"><br>
	        <button class="btn btn-secondary btn-lg" style="width:80px;" type="submit">다음</button>
	    </form>
		</div><br>
		<div class="col-sm-12" style="font-size:24px; text-align:center;">
			<a style="color:red" href="/shop/customer/findPwForm.jsp"><%=errMsg%></a>
		</div>
		
		<br> <br>
		
	</div>
	
	
	<div class="col"></div>
	<%System.out.println("----------------------------------------");%>		
</div>	
</body>
</html>