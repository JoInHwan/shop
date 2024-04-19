package shop.dao;
import java.util.*;
import java.sql.*;

public class ReviewDAO {
	
		public static HashMap<String, String> getReviewList(String goodsNum) 
					throws Exception {
		HashMap<String, String> Review = null;
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;	    	    
		conn = DBHelper	.getConnection();
		String sql = "SELECT score, content , id , buyTime ,create_date"
				+ "	FROM review c INNER JOIN orders o"
				+ "	ON c.orders_num = o.orders_num"
				+ "	WHERE o.goods_num = ?";	
		
		stmt = conn.prepareStatement(sql);		
		stmt.setString(1,goodsNum);
		rs = stmt.executeQuery();
		System.out.println(stmt);
		while (rs.next()) {
		Review = new HashMap<String, String>();
		Review.put("score", rs.getString("score"));
		Review.put("id", rs.getString("id"));
		Review.put("buyTime", rs.getString("buyTime"));
		Review.put("createDate", rs.getString("create_date"));
		Review.put("content", rs.getString("content"));		
		}
		
		rs.close();
		stmt.close();
		conn.close();
		return Review;
		}
	

}
