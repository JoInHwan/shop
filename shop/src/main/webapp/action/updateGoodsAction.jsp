<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "shop.dao.GoodsDAO" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp 
	if(session.getAttribute("loginEmp")==null){ 
		response.sendRedirect("/shop/loginForm.jsp");
	}	
%>
<%
	String title = request.getParameter("title");
	String category = request.getParameter("category");
	int price = Integer.parseInt(request.getParameter("price"));
	int amount = Integer.parseInt(request.getParameter("amount"));
	String content = request.getParameter("content");
	
	System.out.println("수정할 이름 : " +  title );
	System.out.println("수정할 카테고리 : " +  category );
	System.out.println("수정할 가격 : " +  price );
	System.out.println("수정할 양 :" +  amount );
	System.out.println("수정할 내용 : " +  content );
	
	
	
%>
<%
	int row = GoodsDAO.updateGoods(title,category,price,amount,content);

	//3. 결과분기
	if(row==1){
		response.sendRedirect("/shop/emp/updateGoodsForm.jsp?title="+title);
	}
%>