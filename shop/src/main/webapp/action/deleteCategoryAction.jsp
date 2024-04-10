<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%	
	String category = request.getParameter("category");
	System.out.println(category + "<-category");	

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","java1234");
	
	// 해당 일기 삭제
		String sql = "delete from category where category = ?";
		PreparedStatement stmt = null;	
		stmt = conn.prepareStatement(sql);
		stmt.setString(1,category);
		
		int row= stmt.executeUpdate();
		System.out.println(row + "<-row");			
		
		response.sendRedirect("/shop/goods/category/categoryList.jsp");	
%>