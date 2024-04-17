<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>파일첨부 테스트</title>
    </head>
    <body>
    <form action="./action.jsp" method="post" enctype="multipart/form-data">
		<input type="text" name="title" />
		<input type="file" name="file"/>
		<input type="submit" value="저장" />
    </form>
    </body>
</html>