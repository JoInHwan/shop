<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "shop.dao.CustomerDAO" %>
<%

	String address = request.getParameter("address");
	String phoneNum = request.getParameter("phoneNum");
	String id = request.getParameter("id");
	
	System.out.println(address + " <-address");
	System.out.println(phoneNum + " <-phoneNum");
	System.out.println(id + " <-id");
		
%>
<%
	int row = 0;
	row = CustomerDAO.updateCustomer(address,phoneNum,id);
	System.out.println("row : " + row);
	//3. 결과분기
	if(row==1){
		response.sendRedirect("/shop/customer/customerOne.jsp");
	}
%>