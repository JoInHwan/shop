<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>

<%
	//1. 요청값분석
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String pwConfirm = request.getParameter("pwConfirm");
	String name = request.getParameter("name");
	String birth = request.getParameter("birth");
	String gender = request.getParameter("gender");

	System.out.println(id);
	System.out.println(pw);
	System.out.println(pwConfirm);
	System.out.println(name);
	System.out.println(birth);
	System.out.println(gender);	

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","java1234");
	// 2. 중복된 아이디 확인
	String sqlCheck = "select id,name from customer where id =?";
	PreparedStatement stmtCheck = null; 	
	ResultSet rsCheck = null;
	stmtCheck=conn.prepareStatement(sqlCheck);
	stmtCheck.setString(1,id);
	rsCheck = stmtCheck.executeQuery();
	
	if(rsCheck.next()){  // 이미 아이디가 존재할때
		System.out.println("아이디 중복");
		String errMsg =  URLEncoder.encode("이미 존재하는 아이디입니다.","utf-8");		
		response.sendRedirect("/shop/customer/signUpForm.jsp?errMsg="+errMsg); 				
	}else{	// 3. pw와 pwconfirm이 서로 일치하는지 확인
		rsCheck.beforeFirst();
		if(!pw.equals(pwConfirm)){  // 비밀번호와 비밀번호재입력 값이 다르면다시 회원가입 페이지로 넘어감
			System.out.println("비밀번호 불일치");
			String errMsg2 =  URLEncoder.encode("아이디와 비밀번호가 잘못되었습니다","utf-8");		
			response.sendRedirect("/shop/customer/signUpForm.jsp?errMsg2="+errMsg2); 
		}else{	// 4. customer Table에 입력받은값 추가
			String sql = "insert into customer(id, originPw, pw, name, birth, gender, update_date, create_date) VALUES(?,?,PASSWORD(?), ?, ?, ?, now(), now())";
			PreparedStatement stmt = null;				
			int row = 0;				
			stmt = conn.prepareStatement(sql);
			stmt.setString(1,id );
			stmt.setString(2,pw );
			stmt.setString(3,pw );
			stmt.setString(4,name );
			stmt.setString(5,birth );
			stmt.setString(6,gender );
			System.out.println(stmt + "<-stmt");
			
			row = stmt.executeUpdate();
			// 5. 회원가입 즉시 로그인됌
			if(row==1){
				response.sendRedirect("/shop/action/loginAction.jsp?id="+id+"&pw="+pw); 
			}	
		}
	}

%>