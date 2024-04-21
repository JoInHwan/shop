package shop.dao;
import java.util.*;
import java.sql.*;

public class ReviewDAO {
		// 리뷰 리스트 출력
		public static ArrayList<HashMap<String, String>> getReviewList(String goodsNum) 
					throws Exception {
		ArrayList<HashMap<String, String>> ReviewList = new ArrayList<HashMap<String,String>>();
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
		HashMap<String,String>reviewMap = new HashMap<>();
		reviewMap.put("score", rs.getString("score"));
		reviewMap.put("id", rs.getString("id"));
		reviewMap.put("buyTime", rs.getString("buyTime"));
		reviewMap.put("createDate", rs.getString("create_date"));
		reviewMap.put("content", rs.getString("content"));	
		ReviewList.add(reviewMap);
		}
		
		rs.close();
		stmt.close();
		conn.close();
		return ReviewList;
		}
	
		// 리뷰 작성
		public static int addReview (int orderNum,float score,String content) 
				throws Exception {
			int row = 0;
			Connection conn = null;
		    PreparedStatement stmt = null;
		    conn = DBHelper	.getConnection();
		    String sql = "insert into review( orders_num, score , content, create_date )"
		    		+ " values(?,?,?,NOW()) ";
		
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1,orderNum);
			stmt.setFloat(2,score);
			stmt.setString(3,content);	
			System.out.println(stmt);
			row = stmt.executeUpdate();		     
			   
		    stmt.close();
		    conn.close();    
			return row;
		} 
		
		// deleteReviewAction
		public static int deleteReview (int orderNum,String createDate) 
				throws Exception {
			int row = 0;
			Connection conn = null;
		    PreparedStatement stmt = null;
		    conn = DBHelper	.getConnection();
		    String sql = "delete from review where orders_num = ? and create_date = ?";
		
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1,orderNum);
			stmt.setString(2,createDate);	
			System.out.println(stmt);
			row = stmt.executeUpdate();		     
			   
		    stmt.close();
		    conn.close();    
			return row;
		} 
		
		
		
}
