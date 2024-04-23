<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "shop.dao.EmpDAO" %>
<%
	String empId = request.getParameter("empId");
	String active = request.getParameter("active");

	System.out.println(empId + " <- empId ");
	System.out.println(active + " <- active");
	
	int row = EmpDAO.modifyActive(empId,active);
	// 3. 결과분기
	if(row==1){
		response.sendRedirect("/shop/emp/empList.jsp");
	}
%>