<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp , loginCustomer
	if(session.getAttribute("loginEmp")!=null || session.getAttribute("loginCustomer")!=null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/goods/goodsList.jsp");
		return;
	}	
%>
<%
	String id = "";
	String nameValue="";
	String birthValue="";
	String errMsg="";
	
	if(request.getParameter("id")!=null){
		id = request.getParameter("id");
	}	
	
	if(request.getParameter("nameValue")!=null){
		nameValue = request.getParameter("nameValue");
	}
	if(request.getParameter("birthValue")!=null){
		birthValue = request.getParameter("birthValue");
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
	<title>아이디찾기</title>
	<style>

	
	</style>
</head>
<body class="container bg">
<div class="row">
	<div class="col"></div>
	<div class="col-6 content shadow" style="padding:20px 50px; margin-bottom: 20px; border-radius: 20px;" >

	<span><a href="/shop/loginForm.jsp">뒤로</a></span>
	
		<h3 style="text-align: center;">아이디찾기</h3> <hr> <br>	
		<form class="row g-3" action="/shop/action/findIdAction.jsp" enctype="multipart/form-data" method="post">
			<div class="col-sm-12">
			이름:
			<input type="text" name="name" class="form-control form-control-lg findPageInput" value="<%=nameValue%>">
		</div>
		<div class="col-sm-12">
			생년월일:
			<input type="date" name="birth" class="form-control form-control-lg findPageInput" >
		</div>
			<button class="form-control btn btn-secondary btn-lg" type="submit">아이디찾기</button>		
			<a href="/shop/customer/findPwForm.jsp" class="form-control btn btn-outline-secondary btn-lg">비밀번호 찾기</a>
		</form>
			
		<br> <br>
		<div style="height:40px"> 	
		<%
			if(request.getParameter("id")!=null){
		%>
		아이디는 <%=id%> 입니다.
		<%
			}
		%>
		
		<%
			if(request.getParameter("errMsg")!=null){
		%>
		<span style="color:red"><%=errMsg%></span>
		<%
			}
		%>
		</div>
	</div>
	
	
	<div class="col"></div>
	<%System.out.println("----------------------------------------");%>	
		
</div>	
</body>
</html>