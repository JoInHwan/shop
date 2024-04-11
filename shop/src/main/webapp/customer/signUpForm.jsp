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
	String idValue="";
	String pwValue="";
	String errMsg="";
	String errMsg2="";
	String pw2Value="";
	String nameValue="";	
	
	if(request.getParameter("idValue")!=null){		/*기입한 아이디 유지*/
		idValue = request.getParameter("idValue");
	}
	if(request.getParameter("pwValue")!=null){		/*기입한 비밀번호 유지*/
		pwValue = request.getParameter("pwValue");
	}
	if(request.getParameter("pw2Value")!=null){		/*기입한 비밀번호재확인 유지*/
		pw2Value = request.getParameter("pw2Value");
	}
	if(request.getParameter("nameValue")!=null){		/*기입한 이름 유지*/
		nameValue = request.getParameter("nameValue");
	}		
	if(request.getParameter("errMsg")!=null){	 /*이미존재하는 아이디입니다 문자 출력*/	
		errMsg = request.getParameter("errMsg");
	}
	if(request.getParameter("errMsg2")!=null){	 /*비밀번호가 일치하지 않습니다 문자 출력*/
		errMsg2 = request.getParameter("errMsg2");
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

 	/* 선택되지 않은 라디오 버튼의 테두리 색상을 회색으로 설정 */ 
     label.btn { 
        border: 2px solid #C0C0C0;
        
     } 
	#male:hover + label.btn {
        border-color: blue; /* 남자 버튼 마우스 올릴시 파란색 테두리 */  
                   
    }
    #female:hover + label.btn {
        border-color: #FF1493; /* 여자 버튼 마우스 올릴시 빨간 테두리 */                
    }

    /* 선택된 라디오 버튼의 테두리 색상을 변경 */
    #male:checked + label.btn {
        border-color: #0000CD; /* 남자 선택 시 파란색 테두리 */
        #female + label.btn {
            border-color: #C0C0C0;
        }        
    }    

    #female:checked + label.btn {
        border-color: #FF1493; /* 여자 선택 시 빨간색 테두리 */
        #male + label.btn {
            border-color: #C0C0C0;
        }
    }


	</style>
</head>
<body class="container bg">
<div class="row">
	<div class="col"></div>
	<div class="col-6 content shadow" style="text-align:centers; padding: 20px 50px; border-radius: 20px; margin:30px 0px">
	<h2 style="text-align: center;">회원가입</h2><hr><br>	
	<form class="row g-3" action="/shop/action/signUpAction.jsp" enctype="multipart/form-data" method="post">	
		<div class="col-sm-12" style="height:70px;">
			아이디:
			<input type="text" name="id" class="form-control form-control-lg inputInfo" value="<%=idValue%>" >			
			<span style="font-size: 11px;"><a style="color:red" href="/shop/customer/signUpForm.jsp"><%=errMsg%></a></span>				
		</div>		
		<div class="col-sm-12">
			비밀번호: 
			<input type="password" name="pw" class="form-control form-control-lg inputInfo" value="<%=pwValue%>" aria-describedby="passwordHelpInline">
		</div>
		<div class="col-sm-12" style="height:60px;">
			비밀번호 재확인:
			<input type="password" name="pwConfirm" class="form-control form-control-lg inputInfo" value="<%=pw2Value%>">			
			<span style="font-size: 11px;"><a style="color:red" href="/shop/customer/signUpForm.jsp"><%=errMsg2%></a></span>			
		</div>
		<div>		
		</div>
		<div class="col-sm-12">
			이름:
			<input type="text" name="name" class="form-control form-control-lg inputInfo" value="<%=nameValue%>">
		</div>
		<div class="col-sm-12">
			생년월일:
			<input type="date" name="birth" class="form-control form-control-lg inputInfo" >
		</div>
		<div class="col-sm-12">	 
			성별: <br>
			<input type="radio" class="btn-check gender" name="gender" id="male" value="남"  >
			<label class="btn" for="male" style="width:49%;">남자</label>			
			<input type="radio" class="btn-check gender" name="gender" id="female" value="여"  >
			<label class="btn" for="female" style="width:49%">여자</label> 
		</div>	
		
		 <div align="center">
		 <a class="btn btn-secondary" href="/shop/customer/signUpForm.jsp">초기화</a>
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


