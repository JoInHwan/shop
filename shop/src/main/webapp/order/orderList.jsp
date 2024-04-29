<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "shop.dao.OrderDAO" %>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
		if(session.getAttribute("loginEmp")==null){ //직원으로 로그인이 안되어있으면
			response.sendRedirect("/shop/emp/empLoginForm.jsp");
			return;
		}

%>
<%
	//페이징
	int currentPage = 1;	
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 20;
	int startRow = ((currentPage-1)*rowPerPage);	
	int totalRow = 0;

	ArrayList<HashMap<String, Object>> orderList = OrderDAO.getWholeOrderList(startRow,rowPerPage);
	
	
	for (HashMap<String, Object> m : orderList) {
		totalRow = (int)(m.get("cnt"));
		System.out.println(totalRow + "<-- totalRow [OrderList]");
		break;
	}
	
	int lastPage = totalRow / rowPerPage; // 전체페이지수
	if(totalRow%rowPerPage !=0){   // 딱 나눠떨어지지않으면 한페이지가 새로 추가됌
		lastPage = lastPage+1;		
	}
	
	String firstPage = "";
	String endPage = "";
	if(currentPage == 1) {
		firstPage = "disabled";
	}else if (currentPage == lastPage){
		endPage = "disabled";  
	}

%>


<!DOCTYPE html>
<html>
<head>
	
	<meta charset="UTF-8">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link href="/shop/SHOP.css" rel="stylesheet">
	<title>주문목록</title>
	<style>
			
	</style>
</head>
<body class="bg">
<div class="container content"><br><br>
	<div style="height:1px; display: flex; justify-content: center; align-items: center;">
	  <a href="/shop/goods/goodsList.jsp" style="text-decoration:none; color:black; display: flex; align-items: center;">
	  	<span style="height: 100%; "><img src="/shop/upload/sosom.png" style="width:40px; margin-top:10%;"></span>
	  	<span style="height: 100%; font-size: 40px;  font-weight: bold;  padding-left:5px;">SOSOM</span>
	  </a>	
	</div><br><br>
	<div>
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	<div class="in" style="text-align: center">
		<div style="height:10px" ></div>
		<h2>주문목록</h2>
		<div style="display: inline-block;">
		
			    <table class="table table-bordered" style="border: 3px"  >
			        <tr>
			            <th>주문번호</th>
			            <th>아이디</th>
			            <th>상품번호</th>
			            <th>수량</th>
			            <th>주문상태</th>
			            <th>구매시간</th>                        
			        </tr>   
			        <% for (HashMap<String, Object> m : orderList) {
			            String id = (String) m.get("id");
			            int orderNum = (int) m.get("orderNum");				          
			            String goodsNum = (String) m.get("goodsNum");
			            String state = (String) m.get("state");
			            String buyTime = (String) m.get("buyTime");
			            String amount = (String) m.get("amount");    
			
			            buyTime = buyTime.substring(2, 4) + "/" + buyTime.substring(5, 7) + "/" + buyTime.substring(8, 10) + "  " + buyTime.substring(11, 13) + ":" + buyTime.substring(14, 16) + "";
			        %>
			        <tr>
			            <td><%=orderNum%></td>
			            <td style="width:250px"><%=id%></td>
			            <td><%=goodsNum%></td>
			            <td><%=amount%></td>
			            <td>
			            	<form action="/shop/action/updateOrderStateAction.jsp">
			            
			                <%
			                	if (state.equals("배송중")) { 
			                %>
			                <select name="state">    
			                    <option value="배송중">배송중</option>
			                    <option value="배송완료">배송완료</option>
			                </select>
			                <input type="hidden" name="orderNum" value="<%=orderNum%>">
			                <button type="submit">수정</button>
			                <% 
			                	} else if(state.equals("주문대기")) { 
			                %>
			                <select name="state">    
				                <option value="주문대기">주문대기</option>
				                <option value="배송중">배송중</option>
				            </select>
				            <input type="hidden" name="orderNum" value="<%=orderNum%>">
				            <button type="submit">수정</button>
				            <% 
				            	} else {   
			                %>
			                <%=state%>                   
			                <% } %>
			                
			                
			               </form> 
			                
			            </td>
			            <td><%=buyTime%></td>
			        </tr>
			        <% } %>
			    </table>
			
	
		</div>
		<nav aria-label="Page navigation example">
		<ul class="pagination justify-content-center">
		<%	
		
		%>
			<li class="page-item <%=firstPage%>">
				<a class ="page-link" href="/shop/order/orderList.jsp?currentPage=1">처음페이지</a>
			</li>
			<li class="page-item <%=firstPage%>">
				<a class ="page-link" href="/shop/order/orderList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
			</li>	
			<li class="page-item <%=endPage%>">
				<a class ="page-link" href="/shop/order/orderList.jsp?currentPage=<%=currentPage+1%>">다음페이지</a>
			</li>
			<li class="page-item <%=endPage%>">
				<a class ="page-link" href="/shop/order/orderList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
			</li>
	
		</ul>
	</nav>
		
			
	</div>		
</div>	
<%System.out.println("-------------------------------------------------------------------------");%>
</body>
</html>