<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="java.util.*" %>
<html>
<head>
<title>Insert title here</title>
</head>
<body>
<%
	// enctype = "application/x-www/form-urlencoded" : 문자열 -> 문자열 반환
	// enctype = "multipart/form-data" 바이너리 -> 문자열로 변환 -> 문자열로 반환
	String title = request.getParameter("title");	
	System.out.println(title);

	Part part = request.getPart("file"); // 파일의 바이너리(메타정도) 그대로 받아 part객체안에 저장
	// 업로드된 원본 파일 이름
	String originalName = part.getSubmittedFileName();
	
	
	// 저장될 위치를 현재 프로젝트(톰켓 컨텍스트)안으로 지정
	String uploadPath = request.getServletContext().getRealPath("upload");
	System.out.println(uploadPath);
	
	File file = new File(uploadPath, originalName);
	InputStream inputStream = part.getInputStream(); // part객체안에 파일(바이너리)을 메모로리 불러 옴
	OutputStream outputStream = Files.newOutputStream(file.toPath()); // 메모리로 불러온 파일(바이너리)을 빈파일에 저장
	inputStream.transferTo(outputStream);
	
	inputStream.close();
	outputStream.close();
%>
</body>
</html>