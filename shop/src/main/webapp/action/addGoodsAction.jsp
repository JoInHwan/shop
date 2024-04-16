<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.nio.file.*" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
	if(session.getAttribute("loginEmp")==null){ //로그인이 이미 되어있다면
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>

<%
//1. 요청분석
	String category = request.getParameter("category");
// 	String empId = request.getParameter("empId");
	String goodsTitle = request.getParameter("goodsTitle");	
	String goodsPrice = request.getParameter("goodsPrice");
	String goodsAmount = request.getParameter("goodsAmount");
	String content = request.getParameter("content");
	
	Part part = request.getPart("goodsImg");
	 String originalName = part.getSubmittedFileName();
    // 원본이름에서 확장자만 분리
    int dotIdx = originalName.lastIndexOf(".");
    String ext = originalName.substring(dotIdx); // .png
	UUID uuid = UUID.randomUUID();
	String filename = uuid.toString().replace("-", "");
	filename = filename + ext;
	
	System.out.println(category + "<--불러온 category 값");
//	System.out.println(empId + "");
	System.out.println(goodsTitle + "<--불러온 goodsTitle 값");
	System.out.println(goodsPrice + "<--불러온 goodsPrice 값");
	System.out.println(goodsAmount + "<--불러온 goodsAmount 값");
	System.out.println(content + "<--불러온 content 값");
	// 2.DB데이터 수정
	String sql = "insert into goods (emp_id,category,goods_title, filename,goods_price,goods_amount,goods_content) VALUES('admin',?,?,?,?,?,?)";
	Connection conn = null;
	PreparedStatement stmt = null;	

	int row = 0;	
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","java1234");
	
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,category );
	stmt.setString(2,goodsTitle );
	stmt.setString(3,filename );
	stmt.setString(4,goodsPrice );
	stmt.setString(5,goodsAmount );
	stmt.setString(6,content );
	System.out.println(stmt + "<-stmt");
	
	row = stmt.executeUpdate();
	// part -> inputStream -> outStream -> 빈파일
	if(row == 1) { // insert 성공하면 파일업로드
    	// part -> 1)is -> 2)os -> 3)빈파일
		// 1)
    	InputStream is = part.getInputStream();
    	// 3)+ 2)
		String filePath = request.getServletContext().getRealPath("upload");
		File f = new File(filePath, filename); // 빈파일
		OutputStream os = Files.newOutputStream(f.toPath()); // os + file
		is.transferTo(os);
		
		os.close();
		is.close();
    }
	
// 	File df = new File(filePath, rs.getString("filename"));
// 	df.delete();
	
	// 3. 결과분기
	if(row==1){
		response.sendRedirect("/shop/goods/goodsList.jsp");
	}else {
		
	}
%>
