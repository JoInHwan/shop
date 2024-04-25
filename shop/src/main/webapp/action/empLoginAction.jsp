<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@	page import = "shop.dao.*" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp , loginCustomer
//	if(session.getAttribute("loginEmp")!=null || session.getAttribute("loginCustomer")!=null){ //로그인이 이미 되어있다면
//		response.sendRedirect("/shop/emp/empList.jsp");
//		return;
//	}	
%>
<%
	// 요청값분석 (controller)
	String empId = request.getParameter("empId");
	String empPw = request.getParameter("empPw");
	
	System.out.println(empId + " <-- empId | at empLoginAction");
	System.out.println(empPw + " <-- empPw | at empLoginAction");
	
	// 모델 호출하는 코드
	HashMap<String, Object> loginEmp =  EmpDAO.empLogin(empId, empPw);
	System.out.println(loginEmp);
	if(loginEmp != null){// 로그인성공 (select문 결과값이 있을때)
		
	System.out.println("로그인성공");		
	session.setAttribute("loginEmp", loginEmp);	
	response.sendRedirect("/shop/goods/goodsList.jsp");
				
	}else {  // 로그인실패		
		
	System.out.println("로그인실패 at empLoginAction");
	String errMsg =  URLEncoder.encode("아이디와 비밀번호가 잘못되었습니다","utf-8");		
	response.sendRedirect("/shop/emp/empLoginForm.jsp?idValue="+empId+"&pwValue="+empPw+"&errMsg="+errMsg); // 자동으로 로그인페이지로 넘어감
	
	}
%>
