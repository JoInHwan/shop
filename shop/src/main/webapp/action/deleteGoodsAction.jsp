<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "shop.dao.GoodsDAO" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp 
	if(session.getAttribute("loginEmp")==null){ 
		response.sendRedirect("/shop/loginForm.jsp");
	}	
%>
<%
	int goodsNum = Integer.parseInt(request.getParameter("goodsNum"));
	System.out.println(goodsNum + " <--goodsNum | at deleteGoodsAction" );
	


	int row = GoodsDAO.deleteGoods(goodsNum);
	if(row==1){
		System.out.println("상품삭제성공");
		response.sendRedirect("/shop/emp/goodsListForEmp.jsp");		    
	} 
%>