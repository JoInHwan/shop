<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
<%@ page import = "shop.dao.EmpDAO" %>
<%
	session.invalidate();
	
	//로그인 인증 분기 : 세션변수 -> loginEmp , loginCustomer
	if(session.getAttribute("loginEmp")!=null || session.getAttribute("loginCustomer")!=null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/goods/goodsList.jsp");
		return;
	}	
%>
<%
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String name =  request.getParameter("name");
	String job =  request.getParameter("job");
	String hireDate =  request.getParameter("hireDate");
	
	System.out.println(id + " <-- id | at empSignUpAction");
	System.out.println(pw + " <-- pw | at empSignUpAction");
	System.out.println(name + " <-- name | at empSignUpAction");
	System.out.println(job + " <-- job | at empSignUpAction");	
	System.out.println(hireDate + " <-- hireDate | at empSignUpAction");	
	
	
	
	boolean checkEmpId = EmpDAO.checkEmpID(id);
	int row = 0;
	
	
	if(checkEmpId ==true){ // 중복 아이디 검사
	   String errMsg =  URLEncoder.encode("이미 존재하는 아이디입니다.", "utf-8");
       response.sendRedirect("/shop/emp/empSignUpForm.jsp?errMsg="+ errMsg);
  	}else{
  		row =  EmpDAO.empSignUp(id,pw,name,job,hireDate);
  		if( row == 1 ){
  			response.sendRedirect("/shop/action/empLoginAction.jsp?empId="+id+"&empPw="+pw);
  		}
  	}
%>