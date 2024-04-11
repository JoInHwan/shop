<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
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
	
	String errPwMsg =  URLEncoder.encode("비밀번호가 틀렸습니다.","utf-8");		
	
	
	int a = 0; // 새로운 비밀번호와 재확인이 다를떄
	int b = 0; //  새로운 비밀번호와 재확인이 같을때
	String errMsg2 = null;
		
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
				b=1;				
			}		
		}else{
				a = 1;			
		}	
	

	System.out.println(a + "<-a");
	System.out.println(b + "<-b");
	
%>
<!DOCTYPE html>
<html>
<head>		
	
	<%
		if(b==1){ System.out.println("비밀번호 변경 성공");
	%>
		<meta http-equiv="refresh" content="0;url=/shop/loginForm.jsp">
	<%		
		}
	%>
	
	<% if(a==1){ System.out.println("비밀번호 불일치2");
	%>	  
	   <meta http-equiv="refresh" content="0;url=/shop/customer/resetPwForm.jsp?name=<%=name%>&id=<%=id%>&birth=<%=birth%>>&errMsg2=비밀번호가다릅니다">
	   
	<%		
	}
	%>
</head>
<body>	
<!-- 			response.sendRedirect("/shop/loginForm.jsp");			 -->
</body>
</html>
