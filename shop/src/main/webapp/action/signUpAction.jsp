<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "shop.dao.CustomerDAO" %>

<%
	//로그인 인증 분기 : 세션변수 -> loginEmp , loginCustomer
	if(session.getAttribute("loginEmp")!=null || session.getAttribute("loginCustomer")!=null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/goods/goodsList.jsp");
		return;
	}	
%>
<%
	//1. 요청값분석
	String id = URLEncoder.encode(request.getParameter("id"),"utf-8");
	String pw = request.getParameter("pw");
	String pwConfirm = request.getParameter("pwConfirm");
	
	String name =  request.getParameter("name");
	String birth = request.getParameter("birth");
	String gender = request.getParameter("gender");
	String address = request.getParameter("address");
	
	System.out.println(id);
	System.out.println(pw);
	System.out.println(pwConfirm);
	System.out.println(name + " <-- name | at signUpAction");
	System.out.println(birth);
	System.out.println(gender);	
	System.out.println(address);	

	
	
   	if(!pw.equals(pwConfirm)){  // 비밀번호와 비밀번호재입력 값이 다르면다시 회원가입 페이지로 넘어감	     
   		
		System.out.println("비밀번호 불일치");
		name =  URLEncoder.encode(name ,"utf-8");	
		String errMsg2 =  URLEncoder.encode("비밀번호가 일치하지 않습니다.","utf-8");		
		response.sendRedirect("/shop/customer/signUpForm.jsp?idValue="+id+"&pwValue="+pw+"&pw2Value="+pwConfirm+"&nameValue="+name+"&errMsg2="+errMsg2);				
	}else{	// 비밀번호와 비밀번호 확인이 같을 때
		if(	name == null || birth == null || gender == null || address == null 
			|| name.trim().equals("") || birth.trim().equals("") || gender.trim().equals("") || address.trim().equals("") ){ // 공백입력 
			
			String errMsg3 =  URLEncoder.encode("입력하지 않은 칸이 있습니다.","utf-8");	
			response.sendRedirect("/shop/customer/signUpForm.jsp?idValue="+id+"&pwValue="+pw+"&pw2Value="+pwConfirm+"&errMsg3="+errMsg3);	
		}else{ // 모든 칸이 정상적으로 입력되었을때 
			
			boolean isSuccess = CustomerDAO.insertCustomer(id, pw, name, birth, gender,address);					
			// 5. 회원가입 즉시 로그인됌
			if(isSuccess = true){
				
				response.sendRedirect("/shop/action/loginAction.jsp?id="+id+"&pw="+pw); 
			}					
		}				
	}
	

%>