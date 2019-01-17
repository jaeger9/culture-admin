<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<% 
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
	String time = sdf.format(new Date());

    response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode("회원통계 " + time, "UTF-8") + ".xls;"); 
%>
<html>
<head>
	<title>회원통계</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
<h1>회원통계</h1>

<table border="1">
<tr>
	<th scope="col">일자</th>
	<th scope="col">회원수(명)</th>
</tr>
<c:if test="${empty list }">
<tr>
	<td colspan="2">검색된 결과가 없습니다.</td>
</tr>
</c:if>

<c:forEach items="${list }" var="item" varStatus="status">
<tr>
	<td style="mso-number-format:'\@'">
		<c:out value="${item.dt }" default="-" />
	</td>
	<td>
		<fmt:formatNumber value="${item.cnt }" pattern="###,###" />
	</td>
</tr>
</c:forEach>
</table>

</body>
</html>