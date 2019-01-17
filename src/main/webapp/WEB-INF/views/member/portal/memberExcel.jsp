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

    response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode("회원 " + time, "UTF-8") + ".xls;"); 
%>
<html>
<head>
	<title>회원 목록</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>

<h1>회원 목록</h1>

<table border="1">
<tr>
	<th>번호</th>
	<th>아이디</th>
	<th>가입일</th>
	<th>가입구분</th>
	<th>이름</th>
	<th>성별</th>
	<th>생년월일</th>
	<th>전화번호</th>
	<th>휴대전화번호</th>
	<th>이메일</th>
	<th>뉴스레터 수신여부</th>
	<th>주소</th>
	<th>직업구분</th>
	<th>관심분야</th>
	<th>가입경로</th>
	<th>문화포털포인트</th>
</tr>
<c:if test="${empty list }">
	<tr>
		<td colspan="16">검색된 결과가 없습니다.</td>
	</tr>
</c:if>
<c:forEach items="${list }" var="item" varStatus="status">
	<tr>
		<td>${status.count}</td>
		<td>${item.user_id }</td>
		<td>${item.join_date }</td>
		<td>${item.join_category }</td>
		<td>${item.name }</td>
		<td>${item.sex }</td>
		<td>${item.birth }</td>
		<td>${item.tel }</td>
		<td>${item.hp }</td>
		<td>${item.email }</td>
		<td>${item.newsletter_yn }</td>
		<td>${item.addr }</td>
		<td>
			<c:forEach items="${jobList }" var="j">
				${item.job eq j.value ? j.name : '' }
			</c:forEach>
		</td>
		<td>
			<c:forEach items="${favorList }" var="j">
				${fn:indexOf(item.favor_portal, j.value) > -1 ? j.name : '' }
			</c:forEach>
		</td>
		<td>
			<c:forEach items="${pathList }" var="j">
				${item.join_path eq j.code ? j.name : '' }
			</c:forEach>
			${item.join_path_desc }
		</td>
		<td>${item.point }</td>
	</tr>
</c:forEach>
</table>

</body>
</html>