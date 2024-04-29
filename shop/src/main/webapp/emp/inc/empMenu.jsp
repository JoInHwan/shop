<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>

<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
	if(session.getAttribute("loginEmp")==null){ //직원으로 로그인이 안되어있으면
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
	HashMap<String,Object> loginMember 
	= (HashMap<String,Object>)(session.getAttribute("loginEmp"));

%>

<!DOCTYPE html>

<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- <link href="https://fonts.googleapis.com/css2?family=Song Myung&display=swap" rel="stylesheet"> -->
<!-- <link href="/shop/emp/SHOP.css" rel="stylesheet"> -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" ></script>
	<style>
		.nav-link {
		color:black;
		}
		 .nav-item .nav-link {
            font-size: 12px; /* 원하는 크기로 설정 */
            color: black; /* 원하는 색상으로 설정 */
        }
	</style>
	<title>홈 화면</title>
</head>
<body>
	<nav class="navbar navbar-expand-lg" style="background-color: #e3f2fd; padding-left: %; height:40px " >
  <div class="container-fluid">  
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
 
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
      	<li class="nav-item">
          <a class="nav-link" aria-current="page" href="/shop/goods/goodsList.jsp" style="font-size:14px">Home</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" aria-current="page" href="/shop/emp/empList.jsp">사원관리</a>
        </li>
         <li class="nav-item">
          <a class="nav-link" aria-current="page" href="/shop/customer/customerList.jsp">고객관리</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" aria-current="page" href="/shop/goods/category/categoryList.jsp">카테고리관리</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" aria-current="page" href="/shop/order/orderList.jsp">주문관리</a>
        </li>               
        <li class="nav-item">
          <a class="nav-link" aria-current="page" href="/shop/goods/addGoodsForm.jsp">상품등록</a>	
        </li>
        <li class="nav-item">
          <a class="nav-link" aria-current="page" href="/shop/emp/goodsListForEmp.jsp">상품수정</a>
        </li>          
      </ul>
      <ul class="navbar-nav ml-auto">
        <li class="nav-item">
          <a class="nav-link" href="#"> '<%=loginMember.get("empName")%>'님 반갑습니다</a>
        </li>  
		
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" style="font-size:14px; color:red"  href="/shop/action/logout.jsp">로그아웃</a>	
        </li>
      </ul>
    </div>
  </div>
</nav>


	
</body>
</html>
