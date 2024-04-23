<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "shop.dao.OrderDAO" %>
<%
	int orderNum = Integer.parseInt(request.getParameter("orderNum"));
	
	System.out.println(orderNum + "<-orderNum");
	
	int row = 0;
	row = OrderDAO.deleteOrder(orderNum);
	System.out.println("row : " + row);
	
	if(row==1){
		response.sendRedirect("/shop/customer/customerOne.jsp");	
	}
	System.out.println("--------------------------------------");
%>