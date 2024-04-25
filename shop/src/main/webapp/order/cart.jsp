<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "shop.dao.CustomerDAO" %>
<%@ page import = "shop.dao.GoodsDAO" %>
<%@ page import = "shop.dao.OrderDAO" %>

<%	
	HashMap<String,Object> loginMember	= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
	
	if(session.getAttribute("loginCustomer")==null){ // 로그인이 안되어있으면
		response.sendRedirect("/shop/loginForm.jsp");
		return;
	}
	
	
	String id = null;
	String name = null;
	if(session.getAttribute("loginCustomer")!=null){     // 고객정보확인
		id = (String)(loginMember.get("id"));
		name = (String)(loginMember.get("name"));		
	}
	
	HashMap<String, String> customerInfo = CustomerDAO.CustomerOne(id,name);
	
	
%>
<%
	


%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>

</body>
</html>