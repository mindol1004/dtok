<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="nexcore.framework.core.Constants"%>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
	IUserInfo userInfo = WebUtils.getSessionUserInfo(request);
	if(userInfo != null){
		response.sendRedirect("Main.jsp");
	}
%>
<html>
<head>
<title>[SAMPLE] - LOGIN - NEXCORE J2EE Framework</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/debug/common.css" type="text/css">
<script type="text/javascript" language="javascript">
	function doLogin(){
		document.MyForm.<%= Constants.TRANSACTION_ID %>.value="fwk.FWKSBase#fFWK09Login";
		document.MyForm.<%= Constants.TARGET %>.value="redirect:sample/Main.jsp";
		document.MyForm.target = "_self";
		document.MyForm.action = "<%=request.getContextPath()%>/login.cmd";
		document.MyForm.submit();
	}
</script>
</head>
<body>
<h1>[SAMPLE] - LOGIN</h1>
<h3>request.getContextPath() - [<%= request.getContextPath() %>]</h3>
<h3>Constants.TARGET - [<%= Constants.TARGET %>]</h3>
<h3>Constants.TRANSACTION_ID - [<%= Constants.TRANSACTION_ID %>]</h3>
<form name="MyForm" method="post">
<input type="hidden" name="<%= Constants.TRANSACTION_ID %>">
<input type="hidden" name="<%= Constants.TARGET %>">
<table width="100%" height="100%">
	<tr>
		<td valign="middle" align="center">
			<table width="500" border="0" cellpadding="0" cellspacing="0" align="center" class="login">
				<tr>
					<td width="1" height="1" style="background-color:gray;" nowrap></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align="center">
						<table border="0">
							<tr>
								<th>Username : </th>
								<td valign="middle"><input type="text" name="loginId" style="width:180;" class="txt" maxlength="20"></td>
							</tr>
							<tr>
								<th>Password : </th>
								<td valign="middle"><input type="password" name="loginPassword" style="width:180;" class="txt" maxlength="20"></td>
							</tr>
							<tr align="right">
								<td colspan="2" valign="middle"><button onClick="javascript:doLogin();">Login</button></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td width="1" height="1" style="background-color:gray;" nowrap></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</html>