<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "shop.dao.CustomerDAO" %>

<%
	//로그인 인증 분기 : 세션변수 -> loginEmp , loginCustomer
	if(session.getAttribute("loginEmp")!=null || session.getAttribute("loginCustomer")!=null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/goods/goodsList.jsp");
		return;
	}	
%>
<%
	String id = URLEncoder.encode(request.getParameter("id"),"utf-8");
	System.out.println(id);
	
	
	
	boolean isDuplicate = CustomerDAO.checkDuplicateID(id);
	 if (isDuplicate == true) {
         String errMsg =  URLEncoder.encode("이미 존재하는 아이디입니다.", "utf-8");
         response.sendRedirect("/shop/customer/signUpForm.jsp?idValue=" + id + "&errMsg=" + errMsg);
    } else{
    	 String errMsg =  URLEncoder.encode("가능한 아이디입니다", "utf-8");
         response.sendRedirect("/shop/customer/signUpForm.jsp?idValue=" + id + "&errMsg=" + errMsg);
	}





%>