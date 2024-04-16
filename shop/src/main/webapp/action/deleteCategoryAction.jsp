<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "shop.dao.CategoryDAO" %>
<%	
	String category = request.getParameter("category");
	System.out.println(category + "<-category");	

	int deleteCategory = CategoryDAO.deleteCategory(category);		
		
		response.sendRedirect("/shop/goods/category/categoryList.jsp");	
%>