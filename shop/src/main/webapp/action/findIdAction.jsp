<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp , loginCustomer
	if(session.getAttribute("loginEmp")!=null || session.getAttribute("loginCustomer")!=null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/goods/goodsList.jsp");
		return;
	}	
%>
<%
	String name = request.getParameter("name");
	String birth = request.getParameter("birth");
	System.out.println(name);
	System.out.println(birth);
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","java1234");
	// 1. 아이디 확인
	String sqlFind = "select id from customer where name = ? and birth = ?";
	PreparedStatement stmtFind = null; 	
	ResultSet rsFind = null;
	stmtFind=conn.prepareStatement(sqlFind);
	stmtFind.setString(1,name);
	stmtFind.setString(2,birth);
	System.out.println(stmtFind + "쿼리");
	rsFind = stmtFind.executeQuery();
	
	
	if(rsFind.next()){		
		System.out.println("아이디 있음");			
		response.sendRedirect("/shop/customer/findIdForm.jsp?nameValue="+name+"&birthValue="+birth+"&id="+(rsFind.getString("id")));	
	} else{
		System.out.println("아이디 없음");	
		String errMsg =  URLEncoder.encode("가입한 아이디가 없습니다.","utf-8");	
		response.sendRedirect("/shop/customer/findIdForm.jsp?nameValue="+name+"&birthValue="+birth+"&errMsg="+errMsg);			
	}
	


%>