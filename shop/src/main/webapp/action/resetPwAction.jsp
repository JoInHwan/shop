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
	
	String id = request.getParameter("id");	
	String name = request.getParameter("name");	
	String birth = request.getParameter("birth");	
	String changePw = request.getParameter("changePw");
	String pwConfirm = request.getParameter("pwConfirm");
	
	
	System.out.println(id + " <-- id at resetPwAction");
	System.out.println(name + " <-- name at resetPwAction");
	System.out.println(birth + " <-- birth at resetPwAction");
	System.out.println(changePw + " <-- changePw at resetPwAction");
	System.out.println(pwConfirm + " <-- pwconfirm at resetPwAction");
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","java1234");
		
	String errMsg2 =  URLEncoder.encode("비밀번호가 다릅니다","utf-8");
	name = URLEncoder.encode ( name ,"utf-8" );	
		
		if(changePw.equals(pwConfirm)){  // 두 비밀번호가 같으면
		
		// 비밀번호 변경 쿼리문
		PreparedStatement stmt = null; 
		String sql = "update customer set pw = password(?) where name = ? and id = ? and birth = ?" ;
		stmt = conn.prepareStatement(sql); 
		stmt.setString(1,changePw);
		stmt.setString(2,name);			
		stmt.setString(3,id);			
		stmt.setString(4,birth);			
		System.out.println(stmt + "<-stmt");
		
			
		int row = 0;
		
		row = stmt.executeUpdate();
		
		System.out.println(row+"<-row");		
			
		if(row==1){						
			response.sendRedirect("/shop/loginForm.jsp");
		}		
		}else{
			System.out.println("비밀번호 불일치"); 			
			String name1 = "abc";
			String birth1 = "abcd";
			String id1 = "abcde";
			String errMsg3 = "abcdef";
			response.sendRedirect("/shop/customer/resetPwForm.jsp?name="+name+"&id="+id+"&birth="+birth+"&errMsg2="+errMsg2);
		
		}
	
%>