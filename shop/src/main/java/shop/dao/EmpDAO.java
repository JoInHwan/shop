package shop.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.sql.*;

//empLoginForm.jsp
public class EmpDAO { 
	
	// HashMap<String, Object> : null 이면 로그인 실패, 아니면 성공
	// String empId,empPw : 로그인 폼에서 사용자가 입력한 id/pw
	
	// 호출 코드 HashMap<String, Object> m = EmpDAO.empLogin("admin","1234");
	public static HashMap<String, Object> empLogin(String empId,String empPw)
			throws Exception{
												
		HashMap<String, Object> resultMap = null;
		
		// DB 접근
		Connection conn = DBHelper.getConnection(); 
		
		String sql = "select emp_id empId,emp_name empName,grade from emp where emp_id =? and emp_pw = password(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,empId);
		stmt.setString(2,empPw);
		System.out.println(stmt);
		ResultSet rs = stmt.executeQuery();
		if (rs.next()){
			// 하나의 세션변수에 여러개의 값을 저장하기 위해
			resultMap = new HashMap<String, Object>();
			resultMap.put("empId", rs.getString("empId"));
			resultMap.put("empName", rs.getString("empName"));
			resultMap.put("grade", rs.getInt("grade"));	
			
			System.out.println((String)(resultMap.get("empId")) + "<-로그인 된 empId at EmpDAO"); // 로그인 된 empId
			System.out.println((String)(resultMap.get("empName")) + "<-로그인 된 empName at EmpDAO"); // 로그인 된 empName
			System.out.println((Integer)(resultMap.get("grade")) + "<-로그인 된 grade at EmpDAO"); // 로그인 된 grade
		}
		rs.close();
	    stmt.close();
		conn.close();
		return resultMap;		
	}	
	 
	// -----------------------------------------------------------------------------------------------
	// empList.jsp
	public static ArrayList<HashMap<String, Object>> getEmpList(int startRow,int rowPerPage) 
			throws Exception {
		// 특수한 형태의 데이터(RDBMS:mariaDB)
		// -> API사용 (JDBC API)하여 자료구조 (ResultSet)취득
		// -> 일반화된 자료구조 (ArrayList<HashMap>로 변경 -> 모델 취득				
		ArrayList<HashMap<String, Object>> empList = new ArrayList<HashMap<String,Object>>();
	    Connection conn = null;
	    PreparedStatement stmt = null;
	    ResultSet rs = null;	    	    
	    
	    conn = DBHelper	.getConnection();
	    String sql = "select emp_id empID,emp_name empName,emp_job empJob,hire_date hireDate,grade,active from emp order by hire_date limit ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1,startRow);
		stmt.setInt(2,rowPerPage);
		
		rs = stmt.executeQuery();// JDBC API 종속된 자료구조 모델 ResultSet -> 기본API 자료구조(ArrayList)로 변경
	
		// ResultSet 변경-> ArrayList<HashMap<String, Object>>
	    while (rs.next()) {
	        HashMap<String, Object> empMap = new HashMap<>();
	        empMap.put("empId",rs.getString("empId"));
	        empMap.put("empName",rs.getString("empName"));
	        empMap.put("empJob",rs.getString("empJob"));
			empMap.put("hireDate",rs.getString("hireDate"));
			empMap.put("grade",rs.getString("grade"));
			empMap.put("active",rs.getString("active"));
			
	        empList.add(empMap);
	    }
	 // JDBC API 사용이 끝났으므로 DB자원 반납 가능	
	    rs.close();
	    stmt.close();
	    conn.close();
	    return empList;
	}
	  
	// -----------------------------------------------------------------------------------------------
		// modify.jsp
	public static int modifyActive(String empId,String active) 
			throws Exception {
		
		int row = 0;
		Connection conn = null;
	    PreparedStatement stmt = null;
	    conn = DBHelper	.getConnection();
	    String sql = null;
		
		if(active.equals("ON")){
		 	sql = "update emp set active='OFF' where emp_id ='"+empId+"'";
		 	System.out.println("ON -> OFF 변경");
		}else {
			sql = "update emp set active='ON' where emp_id ='"+empId+"'";	
			System.out.println("OFF -> ON 변경");
		}
		
		stmt = conn.prepareStatement(sql);	
		row = stmt.executeUpdate();		   
		    
	    stmt.close();
	    conn.close();    
		return row;
	}
	
	
	// empSignUpAction
	public static boolean checkEmpID(String id) throws Exception {
		
        boolean checkEmpId = false;        
        PreparedStatement stmtCheck = null;
        ResultSet rsCheck = null;		

	// 1. DB 접근
		Connection conn = DBHelper.getConnection();
		
		// 2. 중복된 아이디 확인
		String sqlCheck = "select emp_id from emp where emp_id =?";
		stmtCheck = conn.prepareStatement(sqlCheck);
		stmtCheck.setString(1,id );
		rsCheck = stmtCheck.executeQuery();
	
		if (rsCheck.next()) {  // 이미 아이디가 존재할때
			System.out.println("아이디 존재");
			checkEmpId = true;
		}
		
		 conn.close();	
		 return checkEmpId;
	}
	
	
	// empSignupAction
	public static  int empSignUp(String id, String pw, String name, String job, String hireDate) 
			throws Exception {
		
		int row = 0;
		Connection conn = DBHelper.getConnection();
		String sql = "insert into emp(emp_id, emp_pw, emp_name, emp_job, hire_date) VALUES(?,PASSWORD(?),?,?,?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,id );
		stmt.setString(2,pw );
		stmt.setString(3,name );
		stmt.setString(4,job );
		stmt.setString(5,hireDate );
		System.out.println(stmt);
		row  = stmt.executeUpdate();		
	
		if (row==1) {
			row = 1;			
		}	
	    stmt.close();
	    conn.close();	
	    
	    return row;	
	}
	
	
}
