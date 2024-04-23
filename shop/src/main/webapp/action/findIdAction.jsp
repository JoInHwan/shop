<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "shop.dao.*" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp , loginCustomer
	if(session.getAttribute("loginEmp")!=null || session.getAttribute("loginCustomer")!=null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/goods/goodsList.jsp");
		return;
	}	
%>
<%
	String name = request.getParameter("name");
	String birth = request.getParameter("birth");
	System.out.println(name);
	System.out.println(birth);
	
	
	String id = CustomerDAO.findId(name,birth);
	
	name =  URLEncoder.encode(name,"utf-8");
	
	if(id != null){		
		System.out.println("아이디 있음");			
		response.sendRedirect("/shop/customer/findIdForm.jsp?nameValue="+name+"&birthValue="+birth+"&id="+id);	
	} else {
		System.out.println("아이디 없음");	
		String errMsg =  URLEncoder.encode("가입한 아이디가 없습니다.","utf-8");	
		response.sendRedirect("/shop/customer/findIdForm.jsp?nameValue="+name+"&birthValue="+birth+"&errMsg="+errMsg);			
	}
%>