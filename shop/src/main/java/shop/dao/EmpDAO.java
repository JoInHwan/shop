package shop.dao;

import java.util.HashMap;
import java.sql.*;


public class EmpDAO {
	
	// HashMap<String, Object> : null 이면 로그인 실패, 아니면 성공
	// String empId,empPw : 로그인 폼에서 사용자가 입력한 id/pw
	
	// 호출 코드 HashMap<String, Object> m = EmpDAO.empLogin("admin","1234");
	public static HashMap<String, Object> empLogin(String empId,String empPw)
														throws Exception{
												
		HashMap<String, Object> resultMap = null;
		
		// DB 접근
		Connection conn = DBHelper.getConnection(); 
		
		String sql = "select emp_id empId,emp_name empName,grade from emp where active = 'ON' and emp_id =? and emp_pw = password(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,empId);
		stmt.setString(2,empPw);
		System.out.println(stmt);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()){
			// 하나의 세션변수에 여러개의 값을 저장하기 위해
			resultMap = new HashMap<String, Object>();
			resultMap.put("empId", rs.getString("empId"));
			resultMap.put("empName", rs.getString("empName"));
			resultMap.put("grade", rs.getInt("grade"));	
			
			System.out.println((String)(resultMap.get("empId")) + "<-로그인 된 empId at EmpDAO"); // 로그인 된 empId
			System.out.println((String)(resultMap.get("empName")) + "<-로그인 된 empName at EmpDAO"); // 로그인 된 empName
			System.out.println((Integer)(resultMap.get("grade")) + "<-로그인 된 grade at EmpDAO"); // 로그인 된 grade
		}
		conn.close();
		return resultMap;		
	}	
}
