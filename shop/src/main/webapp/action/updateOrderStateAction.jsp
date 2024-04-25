<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "shop.dao.OrderDAO" %>
<%

	String state = request.getParameter("state");
	String orderNum = request.getParameter("orderNum");
	System.out.println(state + " <-- state");
	System.out.println(orderNum + " <-- orderNum");
	
	int row = OrderDAO.UpdateState(state,orderNum);
	
	if(row == 1 ){
		
		response.sendRedirect("/shop/order/orderList.jsp");
		
	}

%>



