<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "shop.dao.CustomerDAO" %>
<%
	String errPwMsg = "";
	String errMsg2 = "";
	String pwValue = "";
	String cPwValue = "";	
	String cPwValue2 = "";	
	
	if(request.getParameter("errPwMsg")!=null){	
		errPwMsg = request.getParameter("errPwMsg");
	}
	
	if(request.getParameter("pwValue")!=null){		/*기입한 비밀번호 유지*/
		pwValue = request.getParameter("pwValue");
	}
	if(request.getParameter("cPwValue")!=null){		/*기입한 비밀번호재확인 유지*/
		cPwValue2 = request.getParameter("cPwValue");
	}	
	if(request.getParameter("cPwValue2")!=null){		/*기입한 비밀번호재확인 유지*/
		cPwValue2 = request.getParameter("cPwValue2");
	}
	
	if(request.getParameter("errMsg2")!=null){	 /*비밀번호가 일치하지 않습니다 문자 출력*/
		errMsg2 = request.getParameter("errMsg2");
	}
%>
<%
	String id = request.getParameter("id");	
	String name = request.getParameter("name");	
	System.out.println(id  + "<--  at updatePwForm ");
	System.out.println(name + "<-- name at updatePwForm ");
	
	
	boolean isDuplicate = false;
	isDuplicate = CustomerDAO.checkDuplicateID(id);
	
	if(isDuplicate==true){
		
	}else{	//존재하지 않을때
		System.out.println("해당 아이디가 없습니다");
		String errMsg =  URLEncoder.encode("해당 아이디가 없습니다.","utf-8");		
		response.sendRedirect("/shop/customer/checkIdForm.jsp?errMsg="+errMsg); 
		
	}	
	
%>


<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="/shop/SHOP.css" rel="stylesheet">
	<meta charset="UTF-8">
	<title>비밀번호초기화</title>
	<style>
	.inputInfo{
		border: 1px solid;
		border-color: red;
	}


	</style>
</head>
<body class="container bg">
<div class="row">
	<div class="col"></div>
	<div class="col-6 content shadow" style="text-align:centers; padding: 20px 50px; border-radius: 20px; margin:30px 0px">
		<span><a href="/shop/customer/findPwForm.jsp">뒤로</a></span>
		<h2 style="text-align: center;">비밀번호 변경</h2><hr><br>	
		<form class="row g-3" action="/shop/action/updatePwAction.jsp" enctype="multipart/form-data" method="post">	
			<input type="hidden" name="id" value="<%=id%>">
			<input type="hidden" name="name" value="<%=name%>">
			<div class="col-sm-12">
				기존 비밀번호: 
				<input type="password" name="pw" class="form-control form-control-lg inputInfo" value="<%=pwValue%>">
				<!-- 비밀번호가 틀릴경우 메시지 -->
				<div style="font-size: 20px; height:40px">
					<a style="color:red" href="/shop/customer/updatePwForm.jsp?name=<%=name%>&id=<%=id%>">&nbsp;<%=errPwMsg%></a>
				</div>	
			</div>	<br><br>	
			<div class="col-sm-12">
				비밀번호: 
				<input type="password" name="changePw" class="form-control form-control-lg inputInfo" 
				placeholder="새로운 비밀번호를 입력하세요" value="<%=cPwValue%>" >
			</div>
			<div class="col-sm-12" style="height:60px;">
				비밀번호 재확인:
				<input type="password" name="pwConfirm" class="form-control form-control-lg inputInfo" 
				placeholder="한번 더 입력하세요" value="<%=cPwValue2%>">			
			</div>	
			<!-- 비밀번호가 서로 다릅니다 메시지 -->
			<div style="font-size: 15px; height:40px;">
					<a style="color:red">&nbsp;&nbsp;<%=errMsg2%></a>
				</div>	
			<div align="center">
				 <a class="btn btn-secondary" href="/shop/customer/updatePwForm.jsp?name=<%=name%>&id=<%=id%>">다시쓰기</a>
			 </div> <br> <br><br>
			<div class="d-flex ">
		  	 	<div style="flex: 1;"> 
		      	  <a class="btn btn-danger btn-lg w-100 rounded-0" href="/shop/loginForm.jsp">취소</a>
		 	   </div>
		  	  	<div style="flex: 1;">
		      	  <button type="submit" class="form-control-lg btn btn-lg btn-primary w-100 rounded-0">다음</button>
		    	</div>
			</div>		
	</form>
	<br>	
	</div>
	<div class="col"></div>
</div>	
</body>
</html>

