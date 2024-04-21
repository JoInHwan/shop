<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%

	




%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	
	<title> 테스트 </title>
	<style>
	

	</style>
</head>
<body>


<div style="text-align:center">
a
<table style="border:1px solid; display: inline-block;">
		<tr>
			<td style="border:1px solid">1</td>
			<td style="border:1px solid">2</td>
		</tr>
		<tr>
			<td style="border:1px solid">3</td>
			<td style="border:1px solid">4</td>
		</tr>		
		<tr>
			<td style="border:1px solid">5</td>
			<td style="border:1px solid"> 6</td>
		</tr>

</table>


<form method="post" class="form-control" action="/shop/action/addReviewAction.jsp" style="display: flex; flex-direction: row; align-items: center;">

    <div style="flex: 1;">
        <input type="range" min="0.0" max="10.0" step="0.1" value="5.0" id="slider" name="score" style="width:100px;">
        <p id="sliderValue">5.0 점</p>
    </div>

    <div style="flex: 1; margin-left: 10px;">
        <textarea name="content" class="form-control" placeholder="후기를 입력해주세요" rows="3"></textarea>
    </div>

    <script>
        // 슬라이더 요소를 가져옵니다.
        var slider = document.getElementById("slider");
        // 텍스트를 추가할 요소를 가져옵니다.
        var sliderValue = document.getElementById("sliderValue");

        // 슬라이더 값이 변경될 때마다 실행되는 함수를 정의합니다.
        slider.oninput = function() {
            // 슬라이더의 현재 값을 가져옵니다.
            var value = slider.value;
            // 텍스트를 설정합니다.
            sliderValue.innerHTML = value + " 점";
        };
    </script>

</form>

					<table>
    <tr>
        <td>빈칸으로 두어야함</td>
        <td>빈칸으로 두어야함</td>
        <td style="font-size: 12px; display: flex; align-items: center;">
            <div style="flex-grow: 1;">
                시간
                <br>
                작성자: dlsghks
            </div>
            <form action="/shop/action/deleteReviewActoin.jsp" method="post">
                <input type="hidden" name="orderNum">
                <input type="hidden" name="createDate">
                <input type="hidden" name="goodsNum">
                <button type="submit" class="btn btn-danger" style="font-size: 8px; width: 14px; padding: 0px; margin-left: 5px;">X</button>
            </form>
        </td>
    </tr>
</table>


<hr>

<table>
    <tr>
        <td>빈칸으로 두어야함</td>
        <td>빈칸으로 두어야함</td>
        <td style="font-size: 12px; display: flex; align-items: center;">
            
            <form action="/shop/action/deleteReviewActoin.jsp" method="post">
                <input type="hidden" name="orderNum">
                <input type="hidden" name="createDate">
                <input type="hidden" name="goodsNum">
                
                시간
                
            
                <button type="submit" class="btn btn-danger" style="font-size: 8px; width: 14px; padding: 0px; margin-left: 5px;">X</button>
            <br>
                작성자: dlsghks
            
            </form>
        </td>
    </tr>
</table>












</div>



<% int sr = 90;
	int fullStar = sr / 20;
	
	if( sr%20 == 10  ){
		
	}
	  int emptyStar = ((101-sr)/20);
%>	  
<%
	for(int i=0;i<=fullStar;i++){
%>
	<span class="fa fa-star checked"></span>
<%	
	}
	
	if(sr%20 == 10){
%>
	<span class="fa fa-star-half-o checked"></span>
<%		
	}
	for(int i=0;i<=emptyStar;i++){
%>
	<span class="fa fa-star-o"></span>
<%		
	}
%>















</body>
</html>