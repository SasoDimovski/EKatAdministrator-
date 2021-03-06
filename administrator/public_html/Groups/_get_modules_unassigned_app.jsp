<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8");%>
<%@ page import="java.sql.*"%>
<%@ page import="Procedures.*"%>
<%@ page import="oracle.jdbc.OracleTypes"%>



<%
    String sif   = request.getParameter("sif");if (sif==null){sif="";}
    String prava   ="0";

	System.out.println("");
	System.out.println("Groups/_get_modules_unassigned_app.jsp: ");
	
	System.out.println("sif: " + sif);
	System.out.println("prava: " + prava);
	
	Connection conn = null;
	CallableStatement cstmt = null;
	ResultSet rs = null;
	String sql = null;
	
	String APL_SIF = null;
	String APL_NAZIV = null;



	try {
		sql = "begin " + ReadDBProperties.getProperty("conn_uname")+ ".api_codes.get_group_grant_applications(?,?,?,?,?,?); end;";
		conn = DBConnection.getConnection(session);

		//System.out.println("sql: " + sql);
		
		cstmt = conn.prepareCall(sql);

		
		cstmt.setString(1, sif);
		cstmt.setString(2, prava);
		cstmt.registerOutParameter(3, OracleTypes.CURSOR); // list
		cstmt.registerOutParameter(4, OracleTypes.VARCHAR); // vkupno
		cstmt.registerOutParameter(5, OracleTypes.VARCHAR); // errid
		cstmt.registerOutParameter(6, OracleTypes.VARCHAR); // errmsg

		cstmt.execute();

		String vkupno = cstmt.getString(4);
		String errid = cstmt.getString(5);
		String errmsg = cstmt.getString(6);


		if (errmsg == null) {
			rs = (ResultSet) cstmt.getObject(3);
			%>

<!-- =============================================================================================================================== -->
<div class="box-header with-border">
	<i class="fa fa-object-group"></i>
	<h5 class="box-title">
		Недоделени привилегии<%if (!"0".equals(vkupno)) {%>, апликации&nbsp;&nbsp;<span class="label label-success pull-right"><%=vkupno%></span>
	<%
		}
	%>

	</h5>

	<%
		if (!"0".equals(vkupno)) {
	%>
	<div class="box-tools pull-right">
		<a class="btn btn-success btn-xs"
			onClick="insModulesGroup('<%=sif%>','','','get_modules_unassigned_app_sub','<%=prava%>')"
			title="Додели ги сите недоделени привилегии (апликации)"><i
			class="fa fa-hand-o-left"></i></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a
			class="btn btn-box-tool btn-xs" data-widget="collapse"
			id="get_modules_unassigned_app_but"><i class="fa fa-plus"></i></a>
	</div>
	<%
		}
	%>

</div>
<!-- =============================================================================================================================== -->

<div class="box-body "    id="get_modules_unassigned_app_sub">
	<%
			if (!"0".equals(vkupno)) {

%>
	<!-- =============================================================================================================================== -->


		<!-- =============================================================================================================================== -->

		<%
		while (rs.next()) {
			APL_SIF = rs.getString("SIF");if (APL_SIF==null){APL_SIF="";}
			APL_NAZIV = rs.getString("NAZIV");if (APL_NAZIV==null){APL_NAZIV="";}

			
			//System.out.println("IME"+IME);

	%>
	<div class="box box-success collapsed-box box-solid" id="get_modules_unassigned_app_sub<%=APL_SIF%>">
		<div class="box-header with-border">
			<i class="fa fa-list-alt"></i>
			<h5 class="box-title"><%=APL_NAZIV%></h5>, <small> id=<%=APL_SIF%></small>

			<div class="box-tools pull-right">
				<a class="btn btn-btn-xs"
					onClick="insModulesGroup('<%=sif%>','<%=APL_SIF%>','','get_modules_unassigned_app<%=APL_SIF%>','<%=prava%>')"
					title="Додели ги сите привилегии од апликацијата: <%=APL_NAZIV%>"><i
					class="fa fa-hand-o-left"></i></a>&nbsp;&nbsp;&nbsp; <a
					class="btn btn-btn-xs" data-widget="collapse"  id="get_modules_unassigned_app_but<%=APL_SIF%>"
					onClick="getModulesApp('<%=sif%>','<%=APL_SIF%>','','get_modules_unassigned_app<%=APL_SIF%>','<%=prava%>')"><i
					class="fa fa-plus"></i></a>
			</div>
			<!-- /.box-tools -->
		</div>
		<!-- /.box-header -->
		<div class="box-body" id="get_modules_unassigned_app<%=APL_SIF%>" lang="0"></div>
		<!-- /.box-body -->
	</div>
	<!-- /.box -->

	<%
		}
	%>

		<!-- =============================================================================================================================== -->


	<!-- =============================================================================================================================== -->
	<%
	} else {
%>
	<div class="box-header text-left"><strong>Нема записи !</strong></div>

	<%
	}

			rs.close();
			cstmt.close();
			// conn.close();
		} else {
		
		%>

	<div class="box-header text-left">
		<br>errid: <strong><%=errid%></strong><br>errmsg: <strong><%=errmsg%></strong><br>
		<br>
	</div>
	<%
           cstmt.close();
           
		}
	} catch (SQLException e) {
		e.printStackTrace();
		try {
			if (rs != null) {
				rs.close();
			}
			if (cstmt != null) {
				cstmt.close();
			}
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
	} finally {
		try {
			if (rs != null) {
				rs.close();
			}
			if (cstmt != null) {
				cstmt.close();
			}
		} catch (SQLException e2) {
			e2.printStackTrace();
		}
	}
%>
</div>


