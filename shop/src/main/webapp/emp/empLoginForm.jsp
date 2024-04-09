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
	<title>직원로그인</title>
</head>
<h2>직원로그인</h2>
<body class="container">
	<form action="/shop/emp/empLoginAction.jsp" method="post"> 	
		<input type="text" name="empId" placeholder="admin">	<br> 
		<input type="text" name="empPw" placeholder="1234" > <br>				
		<button type="submit">로그인</button>			
	</form>	
	
	<div>
		<%	
			String errMsg = request.getParameter("errMsg");		
			if(errMsg!=null){	// 에러메시지변수가 있다면 (로그인이 OFF상태라면) 출력	
		%>
			<a href="/shop/emp/empLoginForm.jsp"><%=errMsg %>	</a>		
		<%
			}
		%>		
	</div>
	

</body>
</html>