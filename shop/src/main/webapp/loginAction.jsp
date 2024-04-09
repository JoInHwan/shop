<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%

	//로그인 인증 분기 : 세션변수 -> loginEmp
// 	if(session.getAttribute("loginEmp")!=null){ //로그인이 이미 되어있다면
// 		response.sendRedirect("/shop/emp/empList.jsp");
// 		return;
// 	}
%>
<%
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","java1234");

	//1. 요청값분석
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	String sql = "select id,name from customer where id =? and pw = password(?)";
	PreparedStatement stmt = null; 	
	ResultSet rs = null;
	stmt=conn.prepareStatement(sql);
	stmt.setString(1,id);
	stmt.setString(2,pw);
	rs = stmt.executeQuery();
	
	if(rs.next()){  // 로그인성공 (select문 결과값이 있을때)
		System.out.println("로그인성공");		
		// 하나의 세션변수에 여러개의 값을 저장하기 위해
		HashMap<String, Object> loginCustomer = new HashMap<String, Object>();
		loginCustomer.put("id", rs.getString("id"));
		loginCustomer.put("name", rs.getString("name"));
		
		session.setAttribute("loginCustomer", loginCustomer);
		
		HashMap<String, Object> loginmember = (HashMap<String, Object>)(session.getAttribute("loginCustomer"));
		System.out.println((String)(loginmember.get("id"))); // 로그인 된 empId
		System.out.println((String)(loginmember.get("name"))); // 로그인 된 name
		
		
		response.sendRedirect("/shop/emp/goods/goodsList.jsp");
				
	}else {		// 로그인실패
		System.out.println("로그인실패");
		String errMsg =  URLEncoder.encode("아이디와 비밀번호가 잘못되었습니다","utf-8");		
		response.sendRedirect("/shop/loginForm.jsp?errMsg="+errMsg); // 자동으로 로그인페이지로 넘어감
	}
	
	//자원반납
	rs.close();
	stmt.close();
	conn.close();
%>
