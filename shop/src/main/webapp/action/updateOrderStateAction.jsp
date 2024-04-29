<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "shop.dao.OrderDAO" %>
<%

	String state = request.getParameter("state");
	String orderNum = request.getParameter("orderNum");
	System.out.println(state + " <-- state | at updateOrderStateAction");
	System.out.println(orderNum + " <-- orderNum | at updateOrderStateAction");
	
	int row = OrderDAO.UpdateState(state,orderNum);
	
	if(row == 1 ){
		System.out.println("배송상태변경성공");
		response.sendRedirect("/shop/order/orderList.jsp");
		
	}

%>



