<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%
	
	HashMap<String,Object> loginMember	= null;
	
	if(session.getAttribute("loginCustomer")==null && session.getAttribute("loginEmp")!=null){ // '직원'으로 로그인 하면 세션 loginMember에 loginEmp가 저장
		loginMember	= (HashMap<String,Object>)(session.getAttribute("loginEmp"));
	}
	if(session.getAttribute("loginCustomer")!=null && session.getAttribute("loginEmp")==null){ // '고객'으로 로그인 하면 세션 loginMember에 loginCustome이 저장
		loginMember	= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
	}
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
</head>
<body><br>
<div style="height:1px; display: flex; justify-content: center; align-items: center;">
  <a href="/shop/goods/goodsList.jsp" style="text-decoration:none; color:black; padding-right:40px; display: flex; align-items: center;">
  	<span style="height: 100%; "><img src="/shop/upload/sosom.png" style="width:40px; margin-top:10%;"></span>
  	<span style="height: 100%; font-size: 40px;  font-weight: bold;  padding-left:5px;">SOSOM</span>
  </a>	
</div>	
<div style="text-align: center; height: 60px; ">	
		<%	
			if (session.getAttribute("loginCustomer") == null && session.getAttribute("loginEmp") == null) { // customer,emp 모두 로그인x
		%>		<div style="display: inline-block; float: right;">
					<a class="btn btn-primary btn-login" style="width: 65px; font-size: 12px; margin-top: 16px;"href="/shop/loginForm.jsp">로그인</a>
				</div>
		<%	
			} else if (session.getAttribute("loginCustomer") != null && session.getAttribute("loginEmp") == null) { //손님로그인이 있다면
		%>		<div style="display: inline-block; float: right;"><br>
					<a class="btn btn-outline-info" style="width:; font-size: 12px; color:black; padding:6px 10px" href="/shop/customer/customerOne.jsp">
						<b>'<%=(String) (loginMember.get("name"))%>'님</b>
					</a>
					<a class="btn btn-danger" style="width: 80px; font-size: 12px;"	href="/shop/action/logout.jsp"><span>로그아웃</span></a>
				</div>
		<%
			} else if (session.getAttribute("loginCustomer") == null && session.getAttribute("loginEmp") != null) { // 사원로그인이 있다면
		%>					
				<div style="display: inline-block; float: right;  background-color: #DC143C;  font-size: 12px;  color: white;  padding: 4px; border-radius: 4px;  ">	
					직원용
				</div>	
		<%	
			}	
		%>
	</div>
		<!-- 메인메뉴 -->
	<!-- empMenu.jsp include : 주체(서버) vs redirect(주체:클라이언트) -->
		<!-- 주체가 서버이기 때문에 include할때는 절대주소가 /shop으로 시작하는게 아니라 /emp부터 시작 -->
		<!-- 사원로그인을 했을경우에만 -->
		<%	if(session.getAttribute("loginEmp")!=null){ %> 		
				<div>
					<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
				</div> 
		<%	} %>
			<div style="height:10px" ></div>
			<div>
				<jsp:include page="/emp/inc/categoryBar.jsp"></jsp:include>
			</div> 
</body>
</html>