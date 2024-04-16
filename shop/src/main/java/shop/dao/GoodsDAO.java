package shop.dao;

import java.util.*;
import java.sql.*;


public class GoodsDAO { 
	
	public static  ArrayList<HashMap<String, Object>> getCategoryList()
			throws Exception {	
		ArrayList<HashMap<String,Object>> categoryList = new ArrayList<HashMap<String,Object>>();	
	    Connection conn1 = null;
	    PreparedStatement stmt1 = null;
	    ResultSet rs1 = null;    
	    
	    conn1 = DBHelper.getConnection();
	    
	    String sql1 = "select category, count(*) cnt from goods group by category order by cnt desc";
	    stmt1 = conn1.prepareStatement(sql1);
		rs1 = stmt1.executeQuery(); // JDBC API 종속된 자료구조 모델 ResultSet -> 기본API 자료구조(ArrayList)로 변경	
		
	    
		while (rs1.next()){
			HashMap<String,Object> categoryMap = new HashMap<>();
			categoryMap.put("category",rs1.getString("category"));
			categoryMap.put("cnt",rs1.getInt("cnt"));
			categoryList.add(categoryMap);
		}
			
		conn1.close();		
	    return categoryList;
	}
	
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
			    	    
	    String sql = "SELECT (SELECT COUNT(*) FROM goods WHERE 1=1 ";
	    if (category != null && !category.equals("null")) {				// ()괄호 안 카테고리가 정해졌다면 category = ?의 where 조건이 추가된 상품의 '수'	
	        sql += "AND category = ?";
	        System.out.println("카테고리가 널입니다1");
	    }
	    sql += " AND goods_title LIKE ?) AS wcnt, goods_title AS goodsTitle, filename, goods_price AS goodsPrice, goods_amount AS goodsAmount FROM goods WHERE 1=1 ";
	    if (category != null && !category.equals("null")) {				// 카테고리가 정해졌다면 category = ?의 where 조건이 추가된 상품의 모든 정보	

        sql += "AND category = ?";
        System.out.println("카테고리가 널입니다2");
	    }
	    sql += " AND goods_title LIKE ? ORDER BY wcnt";
	    
	    if (order == null || order.equals("null")) {					 // 받아온 order 값이 없다면 무작위로 배열 
	        sql += ",RAND()";
	        System.out.println("order가 널입니다");
	    }
	    sql += order + " LIMIT ?,?";
	    
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
	        goodsList.add(goods);
	    }
	   
	   try {
		   if (rs != null) {rs.close();}
		   if (stmt != null) {stmt.close();}
		   if (conn != null) {conn.close();}
	   } catch (Exception e) {
		   e.printStackTrace();
	   }
	    
	    return goodsList;
	}
}