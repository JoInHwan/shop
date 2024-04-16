package shop.dao;

import java.util.*;
import java.sql.*;


public class CustomerDAO {
	
	public static boolean checkDuplicateID(String id) throws Exception {
        boolean isDuplicate = false;        
        PreparedStatement stmtCheck = null;
        ResultSet rsCheck = null;		

	// DB 접근
	Connection conn = DBHelper.getConnection();
	
	// 2. 중복된 아이디 확인
	String sqlCheck = "select id,name from customer where id =?";
	stmtCheck = conn.prepareStatement(sqlCheck);
	stmtCheck.setString(1,id );
	rsCheck = stmtCheck.executeQuery();
	
		if(rsCheck.next()){  // 이미 아이디가 존재할때
			System.out.println("아이디 중복");
			isDuplicate = true;
		}
	 return isDuplicate;
	}
	
	public static  boolean insertCustomer(String id, String pw, String name, String birth, String gender) 
			throws Exception {

	
	boolean isSuccess = false;
	Connection conn = DBHelper.getConnection();
	String sql = "insert into customer(id, originPw, pw, name, birth, gender, update_date, create_date) VALUES(?,?,PASSWORD(?), ?, ?, ?, now(), now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,id );
	stmt.setString(2,pw );
	stmt.setString(3,pw );
	stmt.setString(4,name );
	stmt.setString(5,birth );
	stmt.setString(6,gender );	
	System.out.println(stmt);
	int row  = stmt.executeUpdate();		
	
		if(row==1) {
		isSuccess = true;			
		}
	 return isSuccess;	
	}
		
/*----------------------------------------------------------------------------*/	
	// HashMap<String, Object> : null 이면 로그인 실패, 아니면 성공
	// String empId,empPw : 로그인 폼에서 사용자가 입력한 id/pw
	
	// 호출 코드 HashMap<String, Object> m = EmpDAO.empLogin("admin","1234");
	public static HashMap<String, Object> login(String id,String pw)
														throws Exception{												
		HashMap<String, Object> resultMap = null;
		
		// DB 접근
		Connection conn = DBHelper.getConnection(); 
		
		String sql = "select id,name from customer where id = ? and pw = password(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,id);
		stmt.setString(2,pw);
		System.out.println(stmt);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()){
			System.out.println("쿼리성공");
			// 하나의 세션변수에 여러개의 값을 저장하기 위해
			resultMap = new HashMap<String, Object>();
			resultMap.put("id", rs.getString("id"));
			resultMap.put("name", rs.getString("name"));
			
			System.out.println((String)(resultMap.get("id")) + "<-로그인 된 id at CustomerDAO"); // 로그인 된 id
			System.out.println((String)(resultMap.get("name")) + "<-로그인 된 name at CustomerDAO"); // 로그인 된 name
		
		}else {
			System.out.println("쿼리실패");
		}
		conn.close();
		return resultMap;		
	}	
}
