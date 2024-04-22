package shop.dao;
import java.sql.*;
import java.util.*;

// categoryList, addGoodsForm .jsp
public class CategoryDAO {  
	public static ArrayList<HashMap<String, Object>> getCategoryList() 
			throws Exception { // categoryList.jsp
	// 특수한 형태의 데이터(RDBMS:mariaDB)
	// -> API사용 (JDBC API)하여 자료구조 (ResultSet)취득
	// -> 일반화된 자료구조 (ArrayList<HashMap>로 변경 -> 모델 취득				
	ArrayList<HashMap<String, Object>> categoryList = new ArrayList<HashMap<String,Object>>();
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;	    	    
    
    conn = DBHelper	.getConnection();
    String sql = "select category,create_date createDate,emp_id empId,grade,count(*) cnt from category order by create_date";
	stmt = conn.prepareStatement(sql);	
	
	rs = stmt.executeQuery();// JDBC API 종속된 자료구조 모델 ResultSet -> 기본API 자료구조(ArrayList)로 변경

	// ResultSet 변경-> ArrayList<HashMap<String, Object>>
    while (rs.next()) {
        HashMap<String, Object> categoryMap = new HashMap<>();
        categoryMap.put("category",rs.getString("category"));
        categoryMap.put("createDate",rs.getString("createDate"));
        categoryMap.put("empId",rs.getString("empId"));
        categoryMap.put("grade",rs.getInt("grade"));
        categoryMap.put("cnt",rs.getInt("cnt"));
        categoryList.add(categoryMap);
    }
    // JDBC API 사용이 끝났으므로 DB자원 반납 가능	
    rs.close();
    stmt.close();
    conn.close();
	return categoryList;
	}
	
	
	//--------------------------------------------
	//deleteCategoryAction
	public static int deleteCategory(String category) 
			throws Exception{
		int row = 0;
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","java1234");
		
		// 해당 일기 삭제
			String sql = "delete from category where category = ? and grade != 0 ";
			PreparedStatement stmt = null;	
			stmt = conn.prepareStatement(sql);
			stmt.setString(1,category);
			
			row= stmt.executeUpdate();
			System.out.println("카테고리 삭제 성공");	
	
		stmt.close();
	    conn.close();
		return row;
	}
	
	
}
