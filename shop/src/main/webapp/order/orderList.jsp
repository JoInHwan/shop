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
		System.out.println(totalRow + "<-- totalRow");
		break;
	}
	
	System.out.println(totalRow+ "<-totalRow [OrderList]");
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
		table, th{
		  border: 1px solid;
		  text-align:center;
		}
		td{
			border: 1px solid;
			width:150px;
			border:1px solid;
		}
	
	</style>
</head>
<body class="bg">
<div class="container content">
	<div>
	<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	<div class="in" style="text-align: center">
		<div style="height:10px" ></div>
		<h2>주문목록</h2>
		<div style="display: inline-block;">
			<form action="/shop/action/updateOrderStateAction.jsp" id="updateState">
    <table>
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
            String orderNum = (String) m.get("orderNum");
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
                <% if (state.equals("배송중")) { %>
                <select name="state">    
                    <option value="배송중">배송중</option>
                    <option value="배송완료">배송완료</option>
                </select>
                <input type="hidden" name="orderNum" value="<%=orderNum%>">
                <button type="submit">수정</button>
                <% } else { %>
                <%=state%>                   
                <% } %>
            </td>
            <td><%=buyTime%></td>
        </tr>
        <% } %>
    </table>
</form>
	
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
</body>
</html>