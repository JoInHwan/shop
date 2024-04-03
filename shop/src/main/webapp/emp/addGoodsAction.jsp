<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
	if(session.getAttribute("loginEmp")==null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>

<%
	HashMap<String, Object> loginMember = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
%>

<%
//1. 요청분석
	String category = request.getParameter("category");
	String goodsTitle = request.getParameter("goodsTitle");
	String goodsPrice = request.getParameter("goodsPrice");
	String goodsAmount = request.getParameter("goodsAmount");
	String content = request.getParameter("content");	
	
	System.out.println(category + "<--불러온 category 값");
	System.out.println(goodsTitle + "<--불러온 goodsTitle 값");
	System.out.println(goodsPrice + "<--불러온 goodsPrice 값");
	System.out.println(goodsAmount + "<--불러온 goodsAmount 값");
	System.out.println(content + "<--불러온 content 값");
	// 2.DB데이터 수정
	String sql = "insert into goods (emp_id,category,goods_title,goods_price,goods_amount,goods_content) VALUES('admin',?,?,?,?,?)";
	Connection conn = null;
	PreparedStatement stmt = null;	

	int row = 0;	
	
	Class.forName("org.mariadb.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","java1234");
	
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,category );
	stmt.setString(2,goodsTitle );
	stmt.setString(3,goodsPrice );
	stmt.setString(4,goodsAmount );
	stmt.setString(5,content );
	System.out.println(stmt + "<-stmt");
	
	row = stmt.executeUpdate();
	// 3. 결과분기
	if(row==1){
		response.sendRedirect("/shop/emp/goodsList.jsp");
	}else {
		
	}
	
	//성공 :
	//실패 : 
%>
