<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.nio.file.*" %>
<%@ page import = "shop.dao.GoodsDAO" %>

<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
	if(session.getAttribute("loginEmp")==null || session.getAttribute("loginCustomer")!= null){ // 직원로그인이 안되어있으면 (or고객으로 로그인했으면)
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
		HashMap<String,Object> loginMember	= (HashMap<String,Object>)(session.getAttribute("loginEmp"));	
%>


<%
//1. 요청분석
	String category = request.getParameter("category");
 	String empId = (String)(loginMember.get("empId"));
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
	
	System.out.println(category + " <-- category | at addGoodsAction");
	System.out.println(empId +  " <-- empId | at addGoodsAction");
	System.out.println(goodsTitle + " <-- goodsTitle | at addGoodsAction");
	System.out.println(goodsPrice + " <-- goodsPrice | at addGoodsAction");
	System.out.println(goodsAmount + " <-- goodsAmount | at addGoodsAction");
	System.out.println(content + "<--불러온 content 값");
	
	int row = 0;

	row = GoodsDAO.addGoods(category,empId,goodsTitle,filename,goodsPrice,goodsAmount,content);
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
	
	// 3. 결과분기
	if(row==1){
		response.sendRedirect("/shop/goods/goodsList.jsp");
	}else {
		
	}
%>
