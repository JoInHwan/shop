<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.sql.*" %>
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

		<div id="buttonDiv">
    <button id="viewButton" type="button">보기</button>
</div>

<script>
// 페이지 로드 시 실행되는 함수
window.onload = function() {
    // '보내기' 버튼 숨기기
    document.getElementById("sendButton").style.display = "none";
    
    // '보기' 버튼에 클릭 이벤트 추가
    document.getElementById("viewButton").onclick = function() {
        // '보내기' 버튼 보이기
        document.getElementById("sendButton").style.display = "block";
    };
};
</script>

<form>
    <button id="sendButton" type="button">보내기</button>
</form>


<div style="font-size: 30px; font-weight: bold; height:10px; display: flex; justify-content: center; align-items: center;">
  <a href="/shop/goods/goodsList.jsp" style="text-decoration:none; color:black; padding-right:40px; display: flex; align-items: center;">
  	<span style="height: 100%;"><img src="/shop/upload/sosom.png" style="width:35px; margin-top:10%;"></span>
  	<span style="height: 100%; padding-left:3px;padding-bottom:8px;">SOSOM</span>
  </a>	
</div>	


<form action="/shop/action/addGoodsAction.jsp" enctype="multipart/form-data" method="post">
			<table border="1">
    <tr>
        <td>카테고리 : 
            <select name="category">
                <option value="">선택</option>
            </select> 
        </td>
        <td>상품사진 : <input type="file" name="goodsImg"></td>
    </tr>
    <tr>
        <td colspan="2">상품이름 : <input type="text" name="goodsTitle"></td>
    </tr>
    <tr>
        <td>상품가격 : <input type="number" name="goodsPrice"></td>
        <td> 재고 : <input type="number" name="goodsAmount"></td>
    </tr>
    <tr>
        <!-- 제품설명 텍스트를 상단으로 이동시킵니다. -->
        <td colspan="2" style="text-align:justify;">제품설명 : </td>
    </tr>
    <tr>
        <td colspan="2"><textarea rows="5" cols="70" name="content"></textarea></td>
    </tr>    
    <tr>
        <td colspan="2" style="text-align:center"><button type="submit">제품등록</button></td>
    </tr>       
</table>

			</form>
</body>
</html>