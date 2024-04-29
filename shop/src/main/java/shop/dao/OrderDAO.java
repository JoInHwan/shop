package shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

public class OrderDAO {
	
	// goodsOne페이지 리뷰작성권한확인
	public static boolean orderCheck(String id,String goods_num) throws Exception {
	        boolean possible= false;        
	        PreparedStatement stmt = null;
	        ResultSet rs = null;		
	
		// DB 접근
		Connection conn = DBHelper.getConnection();
		
		// 구매 여부 확인
		String sql = "select orders_num from orders where id = ? and goods_num = ? and state = '배송완료' limit 1";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1,id );
		stmt.setString(2,goods_num);
		rs = stmt.executeQuery();
		
		if(rs.next()){  
			System.out.println("리뷰 작성 가능");
			possible = true;
		}			
		 conn.close();
		 
		 return possible;
	}
	
	//  orderNum 확인 (로그인한 아이디와 상품번호 이용)
	public static HashMap<String, String> orderNumCheck(String id,String goods_num) throws Exception {
		HashMap<String, String> orderNum = null;
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;	    	    
		conn = DBHelper	.getConnection();
		String sql = "select orders_num from orders where id = ? and goods_num = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1,id);
		stmt.setString(2,goods_num);
		rs = stmt.executeQuery();
		while (rs.next()) {
		orderNum = new HashMap<String, String>();
		orderNum.put("orderNum", rs.getString("orders_num"));
		
		}
		
		rs.close();
		stmt.close();
		conn.close();
		
		return orderNum;
	}
		
		//  addOrderAction 주문추기
	public static int addOrder (String id,String goodsNum, String amount) 
			throws Exception {
		
		int row = 0;
		Connection conn = null;
	    PreparedStatement stmt = null;
	    conn = DBHelper	.getConnection();
	    String sql = "insert into orders( id, goods_num , amount, state, buyTime )"
	    		+ " values(?,?,?,'주문대기',NOW()) ";
	
		stmt = conn.prepareStatement(sql);
		stmt.setString(1,id);
		stmt.setString(2,goodsNum);
		stmt.setString(3,amount);	
		System.out.println(stmt);
		row = stmt.executeUpdate();		     
		   
	    stmt.close();
	    conn.close(); 
	    
		return row;
	} 
				
	// 개별orderList 출력
	public static ArrayList<HashMap<String, String>> getOrderList(String id) 
														throws Exception {
		ArrayList<HashMap<String, String>> OrderList = new ArrayList<HashMap<String,String>>();
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;	    	    
		conn = DBHelper	.getConnection();
		String sql = "SELECT g.goods_title,g.goods_num,filename, state, buyTime, amount, goods_price, orders_num"
					+ " FROM goods g INNER JOIN orders o"
					+ " ON g.goods_num = o.goods_num"
					+ " WHERE o.id = ? order by buyTime desc";	
		
		stmt = conn.prepareStatement(sql);		
		stmt.setString(1,id);
		rs = stmt.executeQuery();
		System.out.println(stmt);
		while (rs.next()) {
		HashMap<String,String>orderMap = new HashMap<>();
		orderMap.put("goodsTitle", rs.getString("goods_title"));
		orderMap.put("filename", rs.getString("filename"));
		orderMap.put("goodsPrice", rs.getString("goods_price"));
		orderMap.put("goodsNum", rs.getString("goods_num"));
		orderMap.put("orderNum", rs.getString("orders_num"));
		orderMap.put("buyTime", rs.getString("buyTime"));
		orderMap.put("state", rs.getString("state"));
		orderMap.put("amount", rs.getString("amount"));	
		OrderList.add(orderMap);
		}
		
		rs.close();
		stmt.close();
		conn.close();
		
		return OrderList;
	}
		
		
	// deleteReviewAction
	public static int deleteOrder (int orderNum) 
							throws Exception {
		int row = 0;
		Connection conn = null;
	    PreparedStatement stmt = null;
	    conn = DBHelper	.getConnection();
	    String sql = "delete from orders where orders_num = ? and state != '배송완료' ";	
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1,orderNum);	
		System.out.println(stmt);
		row = stmt.executeUpdate();		     
		   
	    stmt.close();
	    conn.close();    
		
	    return row;
	}
			
	// orderList
	public static ArrayList<HashMap<String, Object>> getWholeOrderList(int startRow,int rowPerPage) 
					throws Exception { 			
		ArrayList<HashMap<String, Object>> orderList = new ArrayList<HashMap<String,Object>>();
	    Connection conn = null;
	    PreparedStatement stmt = null;
	    ResultSet rs = null;	
	    
	    conn = DBHelper	.getConnection();
	    String sql = "select * , (select count(*) from orders)AS cnt from orders order by buyTime desc limit ?,?";
		stmt = conn.prepareStatement(sql);	
		stmt.setInt(1,startRow);
		stmt.setInt(2,rowPerPage);
		rs = stmt.executeQuery();
		
	    while (rs.next()) {
	        HashMap<String, Object> orderMap = new HashMap<>();
	        orderMap.put("orderNum",rs.getInt("orders_num"));
	        orderMap.put("id",rs.getString("id"));
	        orderMap.put("goodsNum",rs.getString("goods_num"));
	        orderMap.put("state",rs.getString("state"));
	        orderMap.put("buyTime",rs.getString("buyTime"));
	        orderMap.put("amount",rs.getString("amount"));
	        orderMap.put("cnt",rs.getInt("cnt"));
	        orderList.add(orderMap);
	    }
	    // JDBC API 사용이 끝났으므로 DB자원 반납 가능	
	    rs.close();
	    stmt.close();
	    conn.close();
	    
		return orderList;
	}
	
		
	
	//updatePwAction
	public static int UpdateState (String state, String orderNum) 
			throws Exception {
		int row = 0;
		Connection conn = null;
	    PreparedStatement stmt = null;
	    conn = DBHelper	.getConnection();
	    String sql = "update orders set state = ? where orders_num = ?" ;
		stmt = conn.prepareStatement(sql); 
		stmt.setString(1,state);
		stmt.setString(2,orderNum);
		System.out.println(stmt);
		row = stmt.executeUpdate();		     
		   
	    stmt.close();
	    conn.close();    
		return row;
	}	
}
