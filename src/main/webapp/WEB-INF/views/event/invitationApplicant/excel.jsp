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

    response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode("문화초대이벤트 응모자 " + time, "UTF-8") + ".xls;"); 
%>
<html>
<head>
	<title>이벤트 참여자 목록</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
<c:if test="${empty win_yn }">
	<h1>이벤트 참여자 목록</h1>
</c:if>
<c:if test="${not empty win_yn }">
	<h1>이벤트 당첨자 목록</h1>
</c:if>
<table border="1">
<tr>
	<th>이벤트명</th>
	<td colspan="8">${paramMap.event_title }</td>
</tr>
<tr>
	<th>공연명</th>
	<td colspan="8">${paramMap.perform_title }</td>
</tr>
</table>

<br>

<table border="1">
<tr>
	<th>번호</th>
	<th>회원아이디</th>
	<th>회원명</th>
	<th>연락처</th>
	<th>이메일</th>
	<th>당첨횟수</th>
	<th>포인트</th>
	<th>주소</th>
	<th>내용</th>
	<th>등록일</th>
</tr>
</thead>
<c:if test="${empty list }">
	<tr>
		<td colspan="9">검색된 결과가 없습니다.</td>
	</tr>
</c:if>
<c:forEach items="${list }" var="item" varStatus="status">
	<tr>
		<td>${status.count}</td>
		<td>${item.user_id }</td>
		<td>${item.name }</td>
		<td>${item.hp }</td>
		<td>${item.email }</td>
		<td>${item.win_cnt }</td>
		<td>${item.point }</td>
		<td>${item.user_addr }</td>
		<td>${item.content }</td>
		<td>${item.reg_date }</td>
	</tr>
</c:forEach>
</table>

</body>
</html>