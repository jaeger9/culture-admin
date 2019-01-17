<%@page contentType="text/html;charset=utf-8" %>
<%@include file = "./include/session_check.jsp"%>
<%@include file = "manager_util.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>Namo CrossEditor : Admin</title>
	<script type="text/javascript"> var pe_mN = "pe_tU"; </script>
	<script type="text/javascript" src="../manage_common.js"></script>
	<script type="text/javascript" language="javascript" src="../../js/namo_cengine.js"></script>
	<script type="text/javascript" language="javascript" src="../manager.js"></script>
	<link href="../css/common.css" rel="stylesheet" type="text/css">
</head>

<body>

<%@include file = "../include/top.html"%>

<div id="pe_Sc" class="pe_ei">	
	<table class="pe_ly">
	  <tr>
		<td class="pe_ei">
		
			<table id="Info">
				<tr>
					<td style="padding:0 0 0 10px;height:30px;text-align:left">
					<font style="font-size:14pt;color:#3e77c1;font-weight:bold;text-decoration:none;"><span id="pe_tS"></span></font></td>
					<td id="InfoText"><span id="pe_pu"></span></td>
				</tr>
				<tr>
					<td colspan="2"><img id="pe_qs" src="../images/title_line.jpg" alt="" /></td>
				</tr>
			</table>
		
		</td>
	  </tr>
	  <tr>
		<td class="pe_ei">
			
				<form method="post" id="pe_agf" action="account_proc.jsp" onsubmit="return pe_J(this);">
				<table class="pe_hC" >
				  <tr>
					<td>

						<table class="pe_cb">
						  <tr><td class="pe_dv" colspan="3"></td></tr>
						</table>
						 
						<table class="pe_cb" >
						  <tr>
							<td class="pe_bX">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_rP"></span></b></td>
							<td class="pe_bP"></td>
							<td class="pe_bN">
								<input type="hidden" name="u_id" id="u_id" value="<%=detectXSSEx(session.getAttribute("memId").toString())%>" autocomplete="off"/>
								<input type="password" name="passwd" id="passwd" value="" class="pe_iR" autocomplete="off"/>
							</td>
						  </tr>
						  <tr>
							<td class="pe_bT" colspan="3"></td>
						  </tr>
						  <tr>
							<td class="pe_bX">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_zW"></span></b></td>
							<td class="pe_bP"></td>
							<td class="pe_bN">
								<input type="password" name="newPasswd" id="newPasswd" value="" class="pe_iR" autocomplete="off"/>
							</td>
						  </tr>
						  <tr>
							<td class="pe_bT" colspan="3"></td>
						  </tr>
						  <tr>
							<td class="pe_bX">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_zD"></span></b></td>
							<td class="pe_bP"></td>
							<td class="pe_bN">
								<input type="password" name="newPasswdCheck" id="newPasswdCheck" value="" class="pe_iR" autocomplete="off"/>
							</td>
						  </tr>
						</table>
					
						<table class="pe_cb">
						  <tr><td class="pe_dv" colspan="3"></td></tr>
						</table>
								
					</td>
				  </tr>
				  <tr id="pe_wQ">
					<td id="pe_wP">
						<ul style="margin:0 auto;width:170px;">
							<li class="pe_ec">
								<input type="submit" id="pe_ub" value="" class="pe_dY pe_di" style="width:66px;height:26px;" />
							</li>
							<li class="pe_ec"><input type="button" id="pe_pM" value="" class="pe_dY pe_di" style="width:66px;height:26px;"></li>
						</ul>
					</td>
				  </tr>
				</table>
				</form>
		
		</td>
	  </tr>
	</table>

</div>

<%@include file = "../include/bottom.html"%>

</body>
<script>
var webPageKind = '<%=detectXSSEx(session.getAttribute("webPageKind").toString())%>'
topInit();
pe_z();
</script>

</html>

	
	

