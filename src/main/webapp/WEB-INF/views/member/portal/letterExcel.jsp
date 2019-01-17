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

    response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode("뉴스레터회원 " + time, "UTF-8") + ".xls;"); 
%>
<html>
<head>
	<title>뉴스레터 회원 목록</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>

<h1>뉴스레터 회원 목록</h1>

<table border="1">
<tr>
	<th>번호</th>
	<th>아이디</th>
	<th>이름</th>
	<th>이메일</th>
</tr>
<c:if test="${empty list }">
	<tr>
		<td colspan="4">검색된 결과가 없습니다.</td>
	</tr>
</c:if>
<c:forEach items="${list }" var="item" varStatus="status">
	<tr>
		<td>${status.count}</td>
		<td>${item.user_id }</td>
		<td>${item.name }</td>
		<td>${item.email }</td>
	</tr>
</c:forEach>
</table>

</body>
</html>