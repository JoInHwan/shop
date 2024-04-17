<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "shop.dao.CustomerDAO" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
	if(session.getAttribute("loginCustomer")==null){ //로그인이 되어있지 않으면
		response.sendRedirect("/shop/loginForm.jsp");
		return;
	}
%>
<%
	HashMap<String,Object> loginMember	= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
	
	String name = (String) (loginMember.get("name"));
	String id = (String) (loginMember.get("id"));
	
%>



<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>

<h2>'<%=name%>'님  @@@ '<%=id%>'님 </h2>
</body>
</html>