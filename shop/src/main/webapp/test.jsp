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
a
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