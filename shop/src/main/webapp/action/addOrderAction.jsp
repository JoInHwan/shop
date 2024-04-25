<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "shop.dao.OrderDAO" %>
<%@ page import = "shop.dao.GoodsDAO" %>
<%
	
	//로그인 인증 분기 : 세션변수 -> loginCustomer
	if(session.getAttribute("loginCustomer")==null || session.getAttribute("loginEmp")!=null){ // 고객로그인 안되있으면(직원으로 로그인했으면)
		response.sendRedirect("/shop/loginForm.jsp");
	}
	HashMap<String,Object> loginMember	= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
%>

<%
	String id = request.getParameter("id");
	String goodsNum =request.getParameter("goodsNum");
	String amount =request.getParameter("amount");
	String pay =request.getParameter("pay");
	
	System.out.println(id + " <-- id | at addOrderAction");	
	System.out.println(goodsNum  + " <-- goodsNum | at addOrderAction");
	System.out.println(amount + " <-- amount | at addOrderAction" );
	System.out.println(pay + " <-- pay | at addOrderAction" );	
%>
<%
	//주문 추가 메서드
	int row = 0;
	row = OrderDAO.addOrder(id,goodsNum,amount);
	// 재고량 감소 메서드
	int amount2 = Integer.parseInt(amount);
	int row2 = 0;
	row2 = GoodsDAO.updateGoodsAmount(goodsNum,amount2);
	
	
	System.out.println(row + " <-- row | at addOrderAction (주문추가 성공)");
	System.out.println(row2 + " <-- row2 | at addOrderAction (재고량 감소 성공)");
	
	
	if(row==1 && row2==1){
		response.sendRedirect("/shop/customer/customerOne.jsp");
	}
%>
	