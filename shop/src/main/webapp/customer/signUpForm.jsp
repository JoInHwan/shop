<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
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
         border-color: #C0C0C0; 
     } 

    /* 선택된 라디오 버튼의 테두리 색상을 변경 */
    #male:checked + label.btn {
        border-color: #0000CD; /* 남자 선택 시 파란색 테두리 */
        #female + label.btn {
            border-color: #C0C0C0;
        }        
    }

    #female:checked + label.btn {
        border-color: #FF1493; /* 여자 선택 시 분홍색 테두리 */
        #male + label.btn {
            border-color: #C0C0C0;
        }
    }


	</style>
</head>
<body class="container">
<div class="row">
	<div class="col"></div>
	<div class="col-4 content " style="text-align: centers; padding-top: 10px">
	<h2 style="text-align: center;">회원가입</h2><hr><br>	
	<form class="row g-3" action="/shop/action/signUpAction.jsp" enctype="multipart/form-data" method="post">	
		<div class="col-sm-12" style="height:70px;">
			아이디:
			<input type="text" name="id" class="form-control form-control-lg inputInfo">
			<%	String errMsg = request.getParameter("errMsg");		
				if(errMsg!=null){	// 에러메시지변수가 있다면 (로그인이 OFF상태라면) 출력	
			%>
			<span style="font-size: 11px;"><a style="color:red" href="/shop/customer/signUpForm.jsp"><%=errMsg%></a></span>
			<%	}	%>		
		</div>		
		<div class="col-sm-12">
			비밀번호: 
			<input type="password" name="pw" class="form-control form-control-lg inputInfo" aria-describedby="passwordHelpInline">
		</div>
		<div class="col-sm-12" style="height:60px;">
			비밀번호 재확인:
			<input type="password" name="pwConfirm" class="form-control form-control-lg inputInfo">
			<%	String errMsg2 = request.getParameter("errMsg2");		
				if(errMsg2!=null){	// 에러메시지변수가 있다면 (로그인이 OFF상태라면) 출력	
			%>
			<span style="font-size: 11px;"><a style="color:red" href="/shop/customer/signUpForm.jsp"><%=errMsg2%></a></span>
			<%	}	%>	
		</div>
		<div>		
		</div>
		<div class="col-sm-12">
			이름:
			<input type="text" name="name" class="form-control form-control-lg inputInfo">
		</div>
		<div class="col-sm-12">
			생년월일:
			<input type="date" name="birth" class="form-control form-control-lg inputInfo">
		</div>
		<div class="col-sm-12">	 
			성별: <br>
			<input type="radio" class="btn-check gender" name="gender" id="male" value="남"  >
			<label class="btn" for="male" style="width:49%;">남자</label>			
			<input type="radio" class="btn-check gender" name="gender" id="female" value="여"  >
			<label class="btn" for="female" style="width:49%">여자</label> 
		</div>	
		
		 <div>
		 <input type="reset" >
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


