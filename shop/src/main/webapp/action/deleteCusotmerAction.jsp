<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "shop.dao.CustomerDAO" %>
<%

	 String id = request.getParameter("id");

	int row = 0;
	row = CustomerDAO.deleteCustomer(id);
	System.out.println("row : " + row);
	
	if(row==1){
		session.invalidate(); // 세션 공간 초기화(포맷)	
		response.sendRedirect("/shop/goods/goodsList.jsp");	
	}
	System.out.println("--------------------------------------");
%>