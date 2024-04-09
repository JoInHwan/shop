<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>

<%
	HashMap<String,Object> loginMember 
	= (HashMap<String,Object>)(session.getAttribute("loginEmp"));

%>

<!DOCTYPE html>

<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Song Myung&display=swap" rel="stylesheet">
<link href="/shop/emp/SHOP.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" ></script>
	<style>
		
	</style>
	<title>홈 화면</title>
</head>
<body>
	<nav class="navbar navbar-expand-lg" style="background-color: #e3f2fd;" >  <!-- navbar-expand-lg -->
  <div class="container-fluid">  
   <a class="navbar-brand" href="/shop/emp/goods/goodsList.jsp">Home</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
 
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="/shop/emp/empList.jsp">사원관리</a>
        </li>
         <li class="nav-item">
          <a class="nav-link" aria-current="page" href="/shop/emp/customer/customerList.jsp">고객관리</a>
        </li>
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="/shop/emp/category/categoryList.jsp">카테고리관리</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" aria-current="page" href="/shop/emp/goods/goodsList.jsp">상품관리</a>
        </li>        
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="/shop/emp/goods/addGoodsForm.jsp">상품등록</a>	
        </li> 
        
        <li class="nav-item">
          <a class="nav-link" href="/shop/emp/empOne.jsp"> '<%=(String)(loginMember.get("empName"))%>'님 반갑습니다</a>
        </li>                 
        <li class="nav-item">
          <a class="nav-link disabled" aria-disabled="true" style="font-size:12px;">&nbsp;&nbsp; 임시바</a>
        </li>
       </ul>
      
    </div>
  </div>
  
  
</nav>	
</body>
</html>
