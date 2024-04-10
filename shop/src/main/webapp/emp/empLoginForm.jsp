<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
	if(session.getAttribute("loginEmp")!=null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/emp/empList.jsp");
		return;
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="/shop/SHOP.css" rel="stylesheet">
	<title>직원로그인</title>
</head>
<body class="container">
<div class="row">
	<div class="col"></div>
	<div class="col-6 content " style="text-align: center; padding-top: 50px">
	<h2>직원로그인</h2><hr> <br>
		<div style="background-color: white; margin-left:15%; margin-right:15%;" >
			<form action="/shop/action/empLoginAction.jsp" method="post"> 
				<input class="form-control form-control-lg" type="text" name="empId" placeholder="admin">
				<div style="heigth:20px">&nbsp;</div>
				<input class="form-control form-control-lg" type="text" name="empPw" placeholder="1234" > <br>
	<div style="height:30px">			
		<%	
			String errMsg = request.getParameter("errMsg");		
			if(errMsg!=null){	// 에러메시지변수가 있다면 (로그인이 OFF상태라면) 출력	
		%>
			<a style="color:red;"href="/shop/emp/empLoginForm.jsp"><%=errMsg %>	</a>		
		<%
			}
		%>		
	</div><br>				
		<button class="form-control btn btn-primary btn-lg" type="submit">로그인</button>			
	</form>	<br>
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