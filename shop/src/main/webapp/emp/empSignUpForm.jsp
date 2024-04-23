<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp , loginCustomer
	if(session.getAttribute("loginEmp")!=null || session.getAttribute("loginCustomer")!=null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/goods/goodsList.jsp");
		return;
	}	
%>
<%
	String errMsg="";
	String errMsg3="";
	if(request.getParameter("errMsg")!=null){	 /*이미존재하는 아이디입니다 문자 출력*/	
		errMsg = request.getParameter("errMsg");
	}
	
	if(request.getParameter("errMsg3")!=null){	 /*빈칸이 있을때 문자 출력*/
		errMsg3 = request.getParameter("errMsg3");
	}
%>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="/shop/SHOP.css" rel="stylesheet">
	<meta charset="UTF-8">
	<title></title>
	<style>
	.inputInfo{
		border: 1px solid;
		border-color: #A9A9A9;
	}
	</style>
</head>
<body class="container bg">
<div class="row">
	<div class="col"></div>
	<div class="col-6 content shadow" style="text-align:centers; padding: 20px 50px; border-radius: 20px; margin:30px 0px">
	<h2 style="text-align: center;">직원회원가입</h2><hr><br>	
	<form class="row g-3" action="/shop/action/empSignUpAction.jsp" enctype="multipart/form-data" method="post">	
		<div class="col-sm-12" style="height:70px;">
			아이디:
			<input type="text" name="id" class="form-control form-control-lg inputInfo">			
			<span style="font-size: 11px;"><a style="color:red" href="/shop/customer/signUpForm.jsp"><%=errMsg%></a></span>				
		</div>		
		<div class="col-sm-12">
			비밀번호: 
			<input type="password" name="pw" class="form-control form-control-lg inputInfo" aria-describedby="passwordHelpInline">
		</div>
		<div class="col-sm-12">
			이름:
			<input type="text" name="name" class="form-control form-control-lg inputInfo">
		</div>
		<div class="col-sm-12">
		    부서:
		    <select name="job" class="form-control form-control-lg inputInfo">
		        <option value="팀장">팀장</option>
		        <option value="사원">사원</option>
		        <option value="마케팅">마케팅</option>
		        <option value="인사">인사</option>
		        <option value="영업">영업</option>
		        <option value="개발">개발</option>
		    </select>
		</div>
		<div class="col-sm-12">
			고용날짜:
			<input type="date" name="hireDate" class="form-control form-control-lg inputInfo">
		</div>
		<span style="font-size: 20px;"><a style="color:red" href="#"><%=errMsg3%></a></span>
		 <div align="center">
		 <a class="btn btn-secondary" href="#">초기화</a>
		 </div>
		 <br>
		 <br><br>
		<div class="d-flex ">
		    <div style="flex: 1;"> 
		        <a class="btn btn-danger btn-lg w-100 rounded-0" href="/shop/action/logout.jsp">취소</a>
		    </div>
		    <div style="flex: 1;">
		        <button type="submit" class="form-control-lg btn btn-lg btn-primary w-100 rounded-0">가입하기</button>
		    </div>
		</div>		
	</form>
	<br>	
	</div>
	<div class="col"></div>
</div>	
</body>
</html>


