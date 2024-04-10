<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// session.removeAttribute("loginMember");	
	session.invalidate(); // 세션 공간 초기화(포맷)	
	response.sendRedirect("/shop/loginForm.jsp");
	
%>