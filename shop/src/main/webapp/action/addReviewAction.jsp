<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "shop.dao.ReviewDAO" %>
<%

	//로그인 인증 분기 : 세션변수 -> loginCustomer
	if(session.getAttribute("loginCustomer")==null){ 
		response.sendRedirect("/shop/loginForm.jsp");
	}	
%>
<%
	int orderNum = Integer.parseInt(request.getParameter("orderNum"));
	float score = Float.parseFloat(request.getParameter("score"));	
	String content = request.getParameter("content");
	int goodsNum = Integer.parseInt(request.getParameter("goodsNum"));
	
	System.out.println(orderNum + " <-- orderNum | at addReviewAction");
	System.out.println(score + " <-- score | at addReviewAction" );	
	System.out.println(content + "<-- content | at addReviewAction");
	
%>
<%
	int row = 0;
	row = ReviewDAO.addReview(orderNum,score,content);
	System.out.println("row : " + row);
	
	if(row==1){
		response.sendRedirect("/shop/goods/goodsOne.jsp?goodsNum="+ goodsNum);
	}
%>