<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<%@ page import="java.sql.*"%>
<%@ page import="Procedures.*"%>
<%@ page import="oracle.jdbc.OracleTypes"%>



<%

System.out.println("");
System.out.println("Users/_del_group_user.jsp: ");

String id = request.getParameter("id");if (id==null){id="";}
String sku_sif = request.getParameter("sku_sif");if (sku_sif==null){sku_sif="";}
String all = request.getParameter("all");if (all==null||"".equals(all)){all="0";}

//int  _id= Integer.parseInt(id);
//int  _sku_sif= Integer.parseInt(sku_sif);

System.out.println("id: "+id);
System.out.println("sku_sif: "+sku_sif);
System.out.println("all: "+all);


	Connection conn = null;
	CallableStatement cstmt = null;
	String sql = null;

	String errid = null;
	String errmsg = null;

	try {
		

			sql = "begin " + ReadDBProperties.getProperty("conn_uname") + ".api_grants.del_user_groups(?,?,?,?,?); end;";
			conn = DBConnection.getConnection(session);
	
			cstmt = conn.prepareCall(sql);
			
			cstmt.setString(1, id); //  
			cstmt.setString(2, sku_sif); //
			cstmt.setString(3, all); // 
			cstmt.registerOutParameter(4, OracleTypes.VARCHAR); // 
			cstmt.registerOutParameter(5, OracleTypes.VARCHAR); // errid
	
			cstmt.execute();
	
			errid = cstmt.getString(4);
			errmsg = cstmt.getString(5);
	
	
		
		if (errmsg != null) {
			// handle error
			%>
            <div class="box-header text-left"><br>errid: <strong><%=errid%></strong><br>errmsg: <strong><%=errmsg%></strong><br><br></div>
            <%
			System.out.println("Users/_del_group_user.jsp: " + errmsg);
			cstmt.close();

		}
	} catch (SQLException e) {
		e.printStackTrace();

		try {
			if (cstmt != null) {
				cstmt.close();
			}
			return;
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
	} finally {
		try {
			if (cstmt != null) {
				cstmt.close();
			}
		} catch (SQLException e2) {
			e2.printStackTrace();
		}
	}


	//response.sendRedirect("ModuleList.jsp?"+query); 
	
%>



