<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
// 	if(session.getAttribute("loginEmp")==null){ //로그인이 이미 되어있다면
// 		response.sendRedirect("/shop/emp/empLoginForm.jsp");
// 		return;
// 	}
%>

	<%//DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","java1234");

	String goodsTitle = request.getParameter("goodsTitle");
	System.out.println(goodsTitle+"<-goodsTitle");
	String sql="select * from goods WHERE goods_title = ?";
	
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,goodsTitle);
	
	ResultSet rs = null;
	rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("goods_title",rs.getString("goods_title"));
		m.put("category",rs.getString("category"));	
		m.put("filename",rs.getString("filename"));
		m.put("goods_price",rs.getString("goods_price"));
		m.put("goods_amount",rs.getString("goods_amount"));
		m.put("goods_content",rs.getString("goods_content"));
		list.add(m);
	}	
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>상품 자세히</title>
</head> 
<body class="container">
<h2>GoodsOne</h2>


<div>
	<%
		for(HashMap m : list){
	%>
		<img src="/shop/upload/<%=(String)(m.get("filename"))%>" style="width:200px;"></img><br>
		<%=(String)(m.get("goods_title"))%><br>
		<%=(String)(m.get("category"))%><br>
		<%=(String)(m.get("goods_price"))%><br>
		<%=(String)(m.get("goods_amount"))%><br>
		<%=(String)(m.get("goods_content"))%><br>
		
	<%
		}
	%>
</div>	
				
</body>
</html>