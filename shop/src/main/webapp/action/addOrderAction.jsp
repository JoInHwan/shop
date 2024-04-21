<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "shop.dao.OrderDAO" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginCustomer
	if(session.getAttribute("loginCustomer")==null){ 
		response.sendRedirect("/shop/loginForm.jsp");
	}	
%>
<%
	String id = request.getParameter("id");
	String goodsNum =request.getParameter("goodsNum");
	String amount =request.getParameter("amount");
	String pay =request.getParameter("pay");
	
	System.out.println("id : " +  id );	
	System.out.println("goodsNum : " +  goodsNum );
	System.out.println("amount : " +  amount );
	System.out.println("pay : " +  pay );
	

	
%>
<%
	int row = 0;
	row = OrderDAO.addOrder(id,goodsNum,amount);
	System.out.println("row : " + row);
	
	if(row==1){
		response.sendRedirect("/shop/goods/goodsOne.jsp?goodsNum="+ goodsNum);
	}
%>
	