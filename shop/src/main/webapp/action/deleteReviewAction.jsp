<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "shop.dao.ReviewDAO" %>
<%	
	int goodsNum = Integer.parseInt(request.getParameter("goodsNum"));
	int orderNum = Integer.parseInt(request.getParameter("orderNum"));
	String createDate = request.getParameter("createDate");
	
	System.out.println(goodsNum + "<-goodsNum");	
	System.out.println(orderNum + "<-orderNum");	
	System.out.println(createDate + "<-createDate");

	
	int row = 0;
	row = ReviewDAO.deleteReview(orderNum,createDate);
	System.out.println("row : " + row);
	
	if(row==1){
	
		response.sendRedirect("/shop/goods/goodsOne.jsp?goodsNum="+goodsNum);	
	}
%>