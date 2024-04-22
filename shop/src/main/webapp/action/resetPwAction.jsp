<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
<%@ page import = "shop.dao.CustomerDAO" %>
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
	
	String errMsg2 =  URLEncoder.encode("비밀번호가 다릅니다","utf-8");
	

		if(changePw.equals(pwConfirm)){  // 두 비밀번호가 같으면
			int row = CustomerDAO.resetPw(changePw,name,id,birth);
						
			if(row==1){						
				System.out.println("비밀번호 초기화 성공");
				response.sendRedirect("/shop/loginForm.jsp");
			}		
			}else{
				name = URLEncoder.encode( name ,"utf-8" );	
				System.out.println("비밀번호 불일치"); 			
				response.sendRedirect("/shop/customer/resetPwForm.jsp?name="+name+"&id="+id+"&birth="+birth+"&errMsg2="+errMsg2);
			
		}
	
%>