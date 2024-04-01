<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
	if(session.getAttribute("loginEmp")==null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>
<% 	
	// DB연동
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn= DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","0901");
	
	String sql = "select emp_name, emp_job from emp";
	PreparedStatement stmt = null;
	ResultSet rs = null;
	stmt = conn. prepareStatement(sql);
	rs = stmt.executeQuery();
		
	System.out.println("-------------------------------------------------------------------------------");
%>


<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	<h1> 사원 목록 </h1>	
	<a href="/shop/emp/empLogout.jsp">로그아웃</a>
	<table border="1">
		<tr>
			<td>이름</td>
			<td>직업</td>		
		</tr>
		<%
			while(rs.next()){
		%>
		<tr>
			<td><a href="shop/emp/empList.jsp?emp_name=<%=rs.getString("emp_name")%>">
			<%=rs.getString("emp_name")%></a></td>
			<td><a href="shop/emp/empList.jsp?emp_job=<%=rs.getString("emp_job")%>">
			<%=rs.getString("emp_job")%></a></td>							
		</tr>					
		<%
		}
		%>				
	</table>
	
	
</body>
</html>