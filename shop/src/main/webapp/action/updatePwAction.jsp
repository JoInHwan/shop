<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
<%@ page import = "shop.dao.CustomerDAO" %>
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
	
	String errPwMsg =  URLEncoder.encode("비밀번호가 틀렸습니다.","utf-8");		
	String errMsg2 =  URLEncoder.encode("비밀번호가 일치하지 않습니다.","utf-8");	
	
%>	
<%
	//  비밀번호 확인 메서드	
	boolean checkPw = CustomerDAO.checkPw(id,name,pw);
	System.out.println(checkPw + "<-checkPw");
	
	if(checkPw==true){  // 해당 아이디와 비밀번호가 존재할때		
		if(changePw.equals(pwConfirm)){  // 두 비밀번호가 같으면		
		System.out.println("검색결과있음");
		// 비밀번호 변경 메서드
		int row = CustomerDAO.updatePw(changePw,id,pw);		
		
		System.out.println(row+"<-row");		
			if(row==1){							
			response.sendRedirect("/shop/customer/customerOne.jsp");				
			}		
		}else{		
			name = URLEncoder.encode(name,"utf-8");		
			id = URLEncoder.encode(id,"utf-8");	
			pw = URLEncoder.encode(pw,"utf-8");
			response.sendRedirect("/shop/customer/updatePwForm.jsp?" +
			"name="+name+"&id="+id+"&pwValue="+pw+"&errMsg2="+errMsg2); 							
		}	
	}else{	//존재하지 않을때
		name = URLEncoder.encode(name,"utf-8");		
		id = URLEncoder.encode(id,"utf-8");	
		changePw = URLEncoder.encode(changePw,"utf-8");			
		System.out.println("비밀번호가 틀림");
		response.sendRedirect("/shop/customer/updatePwForm.jsp?name="+name+"&id="+id+"&errPwMsg="+errPwMsg);
	}	
%>
