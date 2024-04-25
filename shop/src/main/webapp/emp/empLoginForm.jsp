<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
	if(session.getAttribute("loginEmp")!=null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/emp/empList.jsp");
		return;
	}
%>
<%
	String idValue="";
	String pwValue="";
	String errMsg="";
	
	if(request.getParameter("idValue")!=null){
		System.out.println("a");
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
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="/shop/SHOP.css?after" rel="stylesheet">
<link rel="icon" href="/shop/favicon.ico">
	<title>직원로그인</title>
	<style>
	.inputInfo{
		border: 1px solid;
		border-color: #F4A460;
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
		<h2>직원로그인</h2><hr style="border: 2px solid black;"><br> 
		<div style="background-color: white; margin-left:15%; margin-right:15%;" >
			<form action="/shop/action/empLoginAction.jsp" method="post"> 
				<input class="form-control form-control-lg inputInfo" type="text" name="empId" value="<%=idValue%>" placeholder="admin">
				<div style="heigth:20px">&nbsp;</div>
				<input class="form-control form-control-lg inputInfo" type="text" name="empPw" value="<%=pwValue%>" placeholder="1234" > <br>
				<div style="height:30px">	
					<a style="color:red;"href="/shop/emp/empLoginForm.jsp"><%=errMsg %>	</a>			
				</div><br>				
				<button class="form-control btn btn-primary btn-lg" type="submit">로그인</button>			
			</form><br>
		</div><br>
		<a href="/shop/loginForm.jsp">일반로그인하러가기 </a> <br>				
		<a href="/shop/goods/goodsList.jsp">비로그인쇼핑하기</a><br><br><br>
		<span style="font-size: 12px;">made by 조인환 in goodee</span>				
	</div>
	<div class="col"></div>		
</div>	
<%System.out.println("----------------------------------------");%>
</body>
</html>