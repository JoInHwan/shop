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
	<title></title>
</head>
<body>
	<form action="/shop/emp/empLoginAction.jsp"> 	
		<input type="text" name="empId" placeholder="아이디">	<br> 
		<input type="text" name="empPw" placeholder="비밀번호"> <br>				
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