package shop.dao;

import java.util.*;
import java.sql.*;


public class GoodsDAO { 
	
	// -----------------------------------------------------------------------------------------------
	public static ArrayList<HashMap<String, Object>> getGoodsList(String category, String searchWord, String order, int currentPage, int itemPerPage) 
	throws Exception {
	    ArrayList<HashMap<String, Object>> goodsList = new ArrayList<HashMap<String,Object>>();
	    Connection conn = null;
	    PreparedStatement stmt = null;
	    ResultSet rs = null;	    
	    
	    conn = DBHelper	.getConnection();
	    
	    
	    int startItem = (currentPage - 1) * itemPerPage;
	    
	    /*select (SELECT COUNT(*) FROM goods WHERE 1=1 and category = ? and goods_title LIKE ?)as wcnt, // 카테고리가 ?이고 이름에 ?가 포함된 상품의 수를 wnt라 지정 
		goods_title,filename,goods_price,goods_amount from goods 										// 여기서(주석)는 별칭(as) 제외
		 WHERE 1=1 and category = ? and goods_title LIKE ? 												// 카테고리가 ?이고 ?가 포함된 상품의 모든정보
		order by wcnt,? limit ?,?	*/	  				// 처음엔 모두 같은 값을 가지는 wcnt로 정렬(무의미)한 이후 카테고리가 없고 정렬한값이 없으면 그상태로 출력
			    	    
	    String sql = 
	    		"SELECT "
	    		+ "(SELECT count(*) FROM goods WHERE 1=1 ";
	    if (category != null && !category.equals("null")) {				// ()괄호 안 카테고리가 정해졌다면 category = ?의 where 조건이 추가된 상품의 '수'	
	        sql += 
	        	"AND category = ?";
	        System.out.println("카테고리가 널입니다1");
	    }   
	    sql += " AND goods_title LIKE ?)AS wcnt,"
	    		+ " goods_title AS goodsTitle,"
	    		+ " filename,"
	    		+ " goods_price AS goodsPrice,"
	    		+ " goods_amount AS goodsAmount,"
	    		+ " goods_num AS goodsNum"
	    		+ " FROM goods WHERE 1=1 ";
	   
	    if (category != null && !category.equals("null")) {				// 카테고리가 정해졌다면 category = ?의 where 조건이 추가된 상품의 모든 정보	
	    	sql += "AND category = ?";
	    	System.out.println("카테고리가 널입니다2");
	    }
	    sql += " AND goods_title LIKE ? ORDER BY wcnt"
	    		+ order + " LIMIT ?,?";
	    
	    stmt = conn.prepareStatement(sql);
	    if (category != null && !category.equals("null")) {
	    	stmt.setString(1,category);
		    stmt.setString(2,"%"+ searchWord +"%");
		    stmt.setString(3,category);
			stmt.setString(4,"%"+ searchWord +"%");	
			stmt.setInt(5,startItem);
			stmt.setInt(6,itemPerPage);
	    }else {
	    	stmt.setString(1,"%"+ searchWord +"%");
		    stmt.setString(2,"%"+ searchWord +"%");	
			stmt.setInt(3,startItem);
			stmt.setInt(4,itemPerPage);	    	
	    }		
		
		System.out.println(stmt);
	    rs = stmt.executeQuery();
	    
	    while (rs.next()) {
	        HashMap<String, Object> goods = new HashMap<>();
	        goods.put("wcnt", rs.getString("wcnt"));	     
	        goods.put("goodsTitle", rs.getString("goodsTitle"));
	        goods.put("filename", rs.getString("filename"));
	        goods.put("goodsPrice", rs.getString("goodsPrice"));
	        goods.put("goodsAmount", rs.getString("goodsAmount"));
	        goods.put("goodsNum", rs.getString("goodsNum"));
	        goodsList.add(goods);
	    }
	   
//	   try {
//		   if (rs != null) {rs.close();}
//		   if (stmt != null) {stmt.close();}
//		   if (conn != null) {conn.close();}
//	   } catch (Exception e) {	   e.printStackTrace();	   }
	   
	   rs.close();
	    stmt.close();
	    conn.close();
	    return goodsList;
	}
	// -----------------------------------------------------------------------------------------------
	//GoodsOne 
	public static HashMap<String, String> getGoodsOne(String goodsNum) 
									throws Exception {
		HashMap<String, String> GoodsOne = null;
	    Connection conn = null;
	    PreparedStatement stmt = null;
	    ResultSet rs = null;	    	    
	    conn = DBHelper	.getConnection();
	    String sql = "select * from goods where goods_num = ?";
	    stmt = conn.prepareStatement(sql);
	    stmt.setString(1,goodsNum);
	    rs = stmt.executeQuery();
	    while (rs.next()) {
	    	GoodsOne = new HashMap<String, String>();
	    	GoodsOne.put("goodsNum", rs.getString("goods_num"));
	        GoodsOne.put("goodsTitle", rs.getString("goods_title"));
	        GoodsOne.put("category", rs.getString("category"));   
	        GoodsOne.put("filename", rs.getString("filename"));
	        GoodsOne.put("goods_price", rs.getString("goods_price"));
	        GoodsOne.put("goods_amount", rs.getString("goods_amount"));
	        GoodsOne.put("goods_content", rs.getString("goods_content"));
	    }
	     
	    rs.close();
	    stmt.close();
	    conn.close();
	    return GoodsOne;
	}
	// GoodsOne 아래 
	public static ArrayList<HashMap<String, Object>> GoodsListBottom(int itemPerPage) 
			throws Exception {
	    ArrayList<HashMap<String, Object>> goodsList = new ArrayList<HashMap<String,Object>>();
	    Connection conn = null;
	    PreparedStatement stmt = null;
	    ResultSet rs = null;	    
	    
	    conn = DBHelper	.getConnection();
	    String sql = "select * from goods order by rand() limit ?";
	    
	    stmt = conn.prepareStatement(sql); 
	    stmt.setInt(1,itemPerPage);
	    rs = stmt.executeQuery();
	    
	    while (rs.next()) {
	        HashMap<String, Object> goods = new HashMap<>();
	        goods.put("goodsTitle", rs.getString("goods_title"));
	        goods.put("filename", rs.getString("filename"));
	        goods.put("goodsPrice", rs.getString("goods_price"));
	        goods.put("goodsNum", rs.getString("goods_num"));
	        goodsList.add(goods);
	    }	    
		    
	    rs.close();
	    stmt.close();
	    conn.close();
	    return goodsList;
	}

	// updateGoodsAction
	
	public static int updateGoods (String title,String category,int price,int amount, String content, int goodsNum) 
			throws Exception {
		int row = 0;
		Connection conn = null;
	    PreparedStatement stmt = null;
	    conn = DBHelper	.getConnection();
	    String sql = "update goods set goods_title = ?,category = ?,goods_price = ?,goods_amount = ?,goods_content = ? "
	    		+ "where goods_num = ?";		
	
		stmt = conn.prepareStatement(sql);	
		stmt.setString(1,title);
		stmt.setString(2,category);
		stmt.setInt(3,price);
		stmt.setInt(4,amount);
		stmt.setString(5,content);
		stmt.setInt(6,goodsNum);
		System.out.println(stmt);
		row = stmt.executeUpdate();		     
		   
	    stmt.close();
	    conn.close();    
		return row;
	}      
	

	//  addOrderAction 페이지에서 재품수량 감소
		public static int updateGoodsAmount (String goodsNum, int amount) 
			throws Exception {
			int row = 0;
			Connection conn = null;
		    PreparedStatement stmt = null;
		    conn = DBHelper	.getConnection();
		    String sql = "update goods set goods_amount = goods_amount - ? where goods_num = ? ";
		
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1,amount);
			stmt.setString(2,goodsNum);
			System.out.println(stmt);
			row = stmt.executeUpdate();		     
			   
		    stmt.close();
		    conn.close();    
			return row;
		} 
	// addGoodsAction
		public static int addGoods (String category,String empId,String goodsTitle,String filename,String goodsPrice,String goodsAmount,String content) 
				throws Exception {
				int row = 0;
				Connection conn = null;
			    PreparedStatement stmt = null;
			    conn = DBHelper	.getConnection();
			    String sql = "insert into goods (category,emp_id,goods_title, filename,goods_price,goods_amount,goods_content) VALUES(?,?,?,?,?,?,?)";
			
				stmt = conn.prepareStatement(sql);
				stmt.setString(1,category );
				stmt.setString(2,empId );
				stmt.setString(3,goodsTitle );
				stmt.setString(4,filename );
				stmt.setString(5,goodsPrice );
				stmt.setString(6,goodsAmount );
				stmt.setString(7,content );
				System.out.println(stmt);
				row = stmt.executeUpdate();		     
				   
			    stmt.close();
			    conn.close();    
				return row;
			} 
		
	//deleteGoodsAction
		public static int deleteGoods (int goodsNum) 
				throws Exception {
				int row = 0;
				Connection conn = null;
			    PreparedStatement stmt = null;
			    conn = DBHelper	.getConnection();
			    String sql = "delete from goods where goods_num = ?";
			
				stmt = conn.prepareStatement(sql);
				stmt.setInt(1,goodsNum );				
				System.out.println(stmt);				
				row = stmt.executeUpdate();		     
				   
			    stmt.close();
			    conn.close();    
				return row;
			} 
		
	
}