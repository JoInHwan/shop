<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "shop.dao.GoodsDAO" %>
<%
	
	HashMap<String,Object> loginMember	= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
	
	if(session.getAttribute("loginCustomer")==null && session.getAttribute("loginEmp")!=null){ // '직원'으로 로그인 하면 세션 loginMember에 loginEmp가 저장
		loginMember	= (HashMap<String,Object>)(session.getAttribute("loginEmp"));
	}
	if(session.getAttribute("loginCustomer")!=null && session.getAttribute("loginEmp")==null){ // '고객'으로 로그인 하면 세션 loginMember에 loginCustome이 저장
		loginMember	= (HashMap<String,Object>)(session.getAttribute("loginCustomer"));
	}
%>
<%
	// MaraiDB연동 DAO 연결
	String title = request.getParameter("goodsTitle");
	ArrayList<HashMap<String, Object>> GoodsOne = GoodsDAO.getGoodsOne(title); 
	
	
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>상품 자세히</title>
</head> 
<body class="container">
<div class="row">
 <div class="col-1">
  	 	
  </div>	
	<div class="col-10"><br>
		<div style="text-align: center; height: 60px;">
			<span style="font-size: 30px; font-weight: bold;">&nbsp;&nbsp;&nbsp;Welcome </span>
		<%	if (session.getAttribute("loginCustomer") == null && session.getAttribute("loginEmp") == null) { // customer,emp 모두 로그인x
		%>	<div style="display: inline-block; float: right;">
				<a class="btn btn-primary btn-login" style="width: 65px; font-size: 12px; margin-top: 16px;"href="/shop/loginForm.jsp">로그인</a>
			</div>
		<%	} else if (session.getAttribute("loginCustomer") != null && session.getAttribute("loginEmp") == null) { //손님로그인이 있다면
		%>	<div style="display: inline-block; float: right;">
				<span style="font-size: 12px; margin-top: 10px;">'<%=(String) (loginMember.get("name"))%>'님
				</span><br> <a class="btn btn-danger" style="width: 75px; font-size: 12px;"	href="/shop/action/logout.jsp"><span>로그아웃</span></a>
			</div>
		<%
		} else if (session.getAttribute("loginCustomer") == null && session.getAttribute("loginEmp") != null) { // 사원로그인이 있다면
		%>	<span style="background-color: #DC143C; font-size: 12px; padding: 4px; border-radius: 4px; color: white">직원용</span>
			<div style="display: inline-block; float: right;">
				<a class="btn btn-danger" style="width: 75px; font-size: 12px; margin-top: 16px;"href="/shop/action/logout.jsp"><span>로그아웃</span></a>
			</div>
		<%	}	%>
		</div>
			<!-- 메인메뉴 -->
		<!-- empMenu.jsp include : 주체(서버) vs redirect(주체:클라이언트) -->
		<!-- 주체가 서버이기 때문에 include할때는 절대주소가 /shop으로 시작하는게 아니라 /emp부터 시작 -->
		<!-- 사원로그인을 했을경우에만 -->
		<%if(session.getAttribute("loginEmp")!=null){ %> 		
		<div>
			<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
		</div> 
		<%} %><br>
		<div>
			<jsp:include page="/emp/inc/categoryBar.jsp"></jsp:include>
		</div> 
		<br>
	
		
		
		<div>
			<%
			for (HashMap<String, Object> goodsMap : GoodsOne) { 
			%>
				<img src="/shop/upload/<%=(String)(goodsMap.get("filename"))%>" style="width:200px;"></img><br>
				<%=(String)(goodsMap.get("goods_title"))%><br>
				<%=(String)(goodsMap.get("category"))%><br>
				<%=(String)(goodsMap.get("goods_price"))%><br>
				<%=(String)(goodsMap.get("goods_amount"))%><br>
				<%=(String)(goodsMap.get("goods_content"))%><br>
				
			<%
				}
			%>
		</div>	

	</div>
	<div class="col-1" style="background-color:#"></div>
</div>
<%System.out.println("----------------------------------------");%>
</body>
</html>