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
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="/shop/SHOP.css" rel="stylesheet">
	<meta charset="UTF-8">
	<title>회원로그인</title>
</head>

<body>
<div class="row">
	<div class="col"></div>
	<div class="col-6 content " style="text-align: center; padding-top: 50px">
	<h2>회원로그인</h2> <hr> <br>
		<div class="row">
		<div class="col"></div>
		<div class="co1-8">
			<form action="/shop/loginAction.jsp" method="post"> 	
				<input class="form-control form-control-lg" type="text" name="id" placeholder="아이디">
				<div style="heigth:40px">&nbsp;</div>
				<input class="form-control form-control-lg" type="password" name="pw" placeholder="비밀번호"> 	<br>	
			<div  style="height:30px">
				<%	
					String errMsg = request.getParameter("errMsg");		
					if(errMsg!=null){	// 에러메시지변수가 있다면 (로그인이 OFF상태라면) 출력	
				%>
					<a style="color:red;" href="/shop/loginForm.jsp"><%=errMsg %>	</a>		
				<%
					}
				%>		
			</div><br>		
			<button class="form-control form-control-lg btn btn-primary btn-lg" type="submit">로그인</button>			
			</form>	<br>
			<form action="/shop/emp/customer/signUp.jsp"> 					
				<button type="submit" class="form-control form-control-lg btn btn btn-outline-dark">회원가입</button>			
			</form>	
		</div>
		<div class="col"></div>			
	</div><br>			
	<a href="/shop/emp/empLoginForm.jsp">직원로그인하러가기 </a> <br>				
	<a href="/shop/emp/goods/goodsList.jsp">비로그인쇼핑하기</a>				
	</div>
	<div class="col"></div>		
</div>	
</body>
</html>