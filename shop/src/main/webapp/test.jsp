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
</body>
</html>