package shop.dao;

import java.util.*;
import java.sql.*;


public class CustomerDAO { // signUpForm
	
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
		
	 conn.close();	
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
    stmt.close();
    conn.close();	
	 return isSuccess;	
	}
		
/*----------------------------------------------------------------------------*/	
	// HashMap<String, Object> : null 이면 로그인 실패, 아니면 성공
	// String empId,empPw : 로그인 폼에서 사용자가 입력한 id/pw
	
	// 호출 코드 HashMap<String, Object> m = EmpDAO.empLogin("admin","1234");
	public static HashMap<String, Object> login(String id,String pw) // loginForm
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
		rs.close();
		stmt.close();
	    conn.close();
		return resultMap;		
	}	
	
	public static ArrayList<HashMap<String, Object>> getCustomerList(int startRow,int rowPerPage ) 
			throws Exception { // customerList.jsp
	// 특수한 형태의 데이터(RDBMS:mariaDB)
	// -> API사용 (JDBC API)하여 자료구조 (ResultSet)취득
	// -> 일반화된 자료구조 (ArrayList<HashMap>로 변경 -> 모델 취득				
	ArrayList<HashMap<String, Object>> customerList = new ArrayList<HashMap<String,Object>>();
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;	    	    
    
    conn = DBHelper	.getConnection();
    String sql = "select *,(select count(*) from customer)AS cnt from customer limit ?,?";
    
	stmt = conn.prepareStatement(sql);	
	stmt.setInt(1,startRow);
	stmt.setInt(2,rowPerPage);
	System.out.println(stmt);
	rs = stmt.executeQuery();// JDBC API 종속된 자료구조 모델 ResultSet -> 기본API 자료구조(ArrayList)로 변경
	
	// ResultSet 변경-> ArrayList<HashMap<String, Object>>
    while (rs.next()) {
        HashMap<String, Object> customerMap = new HashMap<>();
        customerMap.put("id",rs.getString("id"));
        customerMap.put("name",rs.getString("name"));
		customerMap.put("birth",rs.getString("birth"));
		customerMap.put("gender",rs.getString("gender"));
		customerMap.put("create_date",rs.getString("create_date"));
		customerMap.put("update_date",rs.getString("update_date"));
		customerMap.put("pw",rs.getString("pw"));
        customerMap.put("cnt",rs.getInt("cnt"));
        customerList.add(customerMap);
    }
    // JDBC API 사용이 끝났으므로 DB자원 반납 가능	
    rs.close();
    stmt.close();
    conn.close();
	return customerList;
	}
	
}
