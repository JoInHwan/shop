<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%

	//로그인 인증 분기 : 세션변수 -> loginEmp
	if(session.getAttribute("loginEmp")!=null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/emp/empList.jsp");
		return;
	}
%>
<%
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","0901");

	//1. 요청값분석
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	
	String sql = "select emp_id empId from emp where active = 'ON' and emp_id =? and emp_pw = password(?)";
	PreparedStatement stmt = null; 	
	ResultSet rs = null;
	stmt=conn.prepareStatement(sql);
	stmt.setString(1,empId);
	stmt.setString(2,empPw);
	rs = stmt.executeQuery();
	
	if(rs.next()){  // 로그인성공 (select문 결과값이 있을때)
		System.out.println("로그인성공");			
		session.setAttribute("loginEmp", rs.getString("empId"));	
		response.sendRedirect("/shop/emp/empList.jsp");
				
	}else {		// 로그인실패
		System.out.println("로그인실패");
		String errMsg =  URLEncoder.encode("아이디와 비밀번호가 잘못되었습니다","utf-8");		
		response.sendRedirect("/shop/emp/empLoginForm.jsp?errMsg="+errMsg); // 자동으로 로그인페이지로 넘어감
	}
	
	//자원반납
	rs.close();
	stmt.close();
	conn.close();
%>
