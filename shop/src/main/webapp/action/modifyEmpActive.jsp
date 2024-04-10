<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	String empId = request.getParameter("empId");
	String active = request.getParameter("active");

	System.out.println(empId + " <-변경할 empId ");
	System.out.println(active + " <-현재 active 상태");
	
	//DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","java1234");
	
	PreparedStatement stmt = null;
	int row = 0;
	
	String sql = null;
	
	if(active.equals("ON")){
	 	sql = "update emp set active='OFF' where emp_id ='"+empId+"'";
	 	System.out.println("ON -> OFF 변경");
	}else {
		sql = "update emp set active='ON' where emp_id ='"+empId+"'";	
		System.out.println("OFF -> ON 변경");
	}
	
	stmt = conn.prepareStatement(sql);	
	row = stmt.executeUpdate();
	// 3. 결과분기
	if(row==1){
		response.sendRedirect("/shop/emp/empList.jsp");
	}
%>