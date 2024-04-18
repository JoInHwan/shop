<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "shop.dao.CustomerDAO" %>

<%
	//로그인 인증 분기 : 세션변수 -> loginCustomer
// 	if(session.getAttribute("loginCustomer")==null){ //로그인이 되어있지 않으면
// 		response.sendRedirect("/shop/loginForm.jsp");
// 		return;
// 	}
%>
<%
	HashMap<String,Object> loginMember	= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
	
		String loginId = null;
		String loginName = null;
	if(session.getAttribute("loginCustomer")!=null){ 
		loginId = (String) (loginMember.get("id"));
		loginName = (String) (loginMember.get("name"));		
	}
	
	
	if( request.getParameter("id")!=null && request.getParameter("name")!= null){
		loginId = request.getParameter("id");
		loginName = request.getParameter("name");
	}
	
	
	System.out.println("id : " + loginId);
	System.out.println("name : " + loginName);
	
	HashMap<String, String> customerInfo = CustomerDAO.CustomerOne(loginName,loginId);
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
<div class="row">
 <div class="col-1">
  	 	
  </div>	
	<div class="col-10"><br>
		<div style="text-align: center; height: 60px;">
			<div>
				<jsp:include page="/emp/inc/CommonBar.jsp"></jsp:include>
			</div>
		</div>
		<div style="height:10px" ></div>
		<div>
			<jsp:include page="/emp/inc/categoryBar.jsp"></jsp:include>
		</div> <br><br>
	</div>
	<div class="col-1" style="background-color:#"></div>
</div>
<div style="text-align: center">
	<h2>회원정보</h2>
	<div style="display: inline-block;">		
		<hr>
		
		<table>
			<tr>
				<td>아이디</td>
				<td><%=loginId%></td>			
			</tr>
			<tr>
				<td>이름</td>
				<td><%=loginName%></td>			
			</tr>	
			<tr>
				<td>생일</td>
				<td><%=customerInfo.get("birth")%></td>			
			</tr>
			<tr>
				<td>성별</td>
				<td><%=customerInfo.get("gender")%></td>			
			</tr>
			<tr>
				<td>주소</td>
				<td><%=customerInfo.get("address")%></td>			
			</tr>
			<tr>
				<td>회원가입일</td>
				<td><%=customerInfo.get("createDate")%></td>			
			</tr>
			<tr>
				<td>수정날짜</td>
				<td><%=customerInfo.get("updateDate")%></td>			
			</tr>
				
		</table>
		
		
		
					
	</div>
</div>
</body>
</html>