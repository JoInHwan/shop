<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@	page import = "shop.dao.*" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp , loginCustomer
	if(session.getAttribute("loginEmp")!=null || session.getAttribute("loginCustomer")!=null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/goods/goodsList.jsp");
		return;
	}	
%>
<%
	
	//1. 요청값분석 (controller)
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");	
	
	
	String goodsNum = "";
	if(request.getParameter("goodsNum")!=null){
		goodsNum = request.getParameter("goodsNum");
	}
	System.out.println(goodsNum + " <-goodsNum");
	
	
	// 모델 호출하는 코드
	HashMap<String, Object> login =  CustomerDAO.login(id, pw);
	
	if( login!= null){  // 로그인성공 (select문 결과값이 있을때)
		
		System.out.println("로그인성공");	
		session.setAttribute("loginCustomer", login);
		if(goodsNum==null || goodsNum.equals("")){
		response.sendRedirect("/shop/goods/goodsList.jsp");	
		}else{
		System.out.println(goodsNum);	
		response.sendRedirect("/shop/goods/purchaseGoodsForm.jsp?goodsNum="+goodsNum);
		}
		
				
	}else {		// 로그인실패
		System.out.println("로그인실패");
		String errMsg =  URLEncoder.encode("아이디와 비밀번호가 잘못되었습니다","utf-8");
		response.sendRedirect("/shop/loginForm.jsp?idValue="+id+"&pwValue="+pw+"&errMsg="+errMsg); // 자동으로 로그인페이지로 넘어감
	}

%>
