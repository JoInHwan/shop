<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
	if(session.getAttribute("loginEmp")==null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>
<% 
	//DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","java1234");	
%>

<%	
	PreparedStatement stmt = null;
	ResultSet rs = null;	
	String sql = "select originPw from customer ";
	stmt = conn.prepareStatement(sql);	
	rs = stmt.executeQuery();
	
	
	// and pw not like '*%'
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	String key = null;
	while(rs.next()){
		key = rs.getString("originPw"); 
	
	String sql2 = "update customer set pw = password(?) where originPw = ?  ";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,key);
	stmt2.setString(2,key);
	rs2 = stmt2.executeQuery();
	
	}
	System.out.println(stmt2);
	response.sendRedirect("/shop/emp/customer/customerList.jsp");	
%>

