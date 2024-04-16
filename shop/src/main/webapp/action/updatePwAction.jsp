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
	String pw = request.getParameter("pw");	
	String name = request.getParameter("name");	
	String changePw = request.getParameter("changePw");
	String pwConfirm = request.getParameter("pwConfirm");
	
	
	System.out.println(id + " <-- id at updatePwAction");
	System.out.println(name + " <-- name at updatePwAction");
	System.out.println(pw + " <-- pw at updatePwAction");
	System.out.println(changePw + " <-- changePw at updatePwAction");
	System.out.println(pwConfirm + " <-- pwconfirm at updatePwAction");
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","java1234");
	//  비밀번호 확인 쿼리
	String sqlCheck = "select pw from customer where id = ? and name = ? and pw = password(?)";
	PreparedStatement stmtCheck = null; 	
	ResultSet rsCheck = null;
	stmtCheck=conn.prepareStatement(sqlCheck);
	stmtCheck.setString(1,id);
	stmtCheck.setString(2,name);
	stmtCheck.setString(3,pw);
	System.out.println(stmtCheck + "<-stmtCheck");
	rsCheck = stmtCheck.executeQuery();
		
	String errPwMsg =  URLEncoder.encode("비밀번호가 틀렸습니다.","utf-8");		
	
	name = URLEncoder.encode(name,"utf-8");		
	id = URLEncoder.encode(id,"utf-8");		
	pw = URLEncoder.encode(pw,"utf-8");		
	pwConfirm = URLEncoder.encode(pwConfirm,"utf-8");	
	String errMsg2 = null;
	
	if(rsCheck.next()){  // 해당 아이디와 비밀번호가 존재할때		
		if(changePw.equals(pwConfirm)){  // 두 비밀번호가 같으면
		
		System.out.println("검색결과있음");
		// 비밀번호 변경 쿼리문
		PreparedStatement stmt = null; 
		String sql = "update customer set pw = password(?) where id = ? and pw = password(?)" ;
		stmt = conn.prepareStatement(sql); 
		stmt.setString(1,changePw);
		stmt.setString(2,id);
		stmt.setString(3,pw);			
		System.out.println(stmt + "<-stmt");
		
		int row = 0;
		row = stmt.executeUpdate();
		
		System.out.println(row+"<-row");		
			if(row==1){							
			response.sendRedirect("/shop/loginForm.jsp");				
			}		
		}else{
			errMsg2 =  URLEncoder.encode("비밀번호가 일치하지 않습니다.","utf-8");						
			response.sendRedirect("/shop/customer/updatePwForm.jsp?name="+name+"&id=qwer&pwValue="+changePw+"&pw2Value="+pwConfirm+"&errMsg2="+errMsg2); 
							
		}	
	}else{	//존재하지 않을때
		
		System.out.println("비밀번호가 틀림");
		response.sendRedirect("/shop/customer/updatePwForm.jsp?name="+name+"&id="+id+"&errPwMsg="+errPwMsg);
	}	
%>
