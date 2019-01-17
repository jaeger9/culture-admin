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

    response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode("컨테스트 " + time, "UTF-8") + ".xls;"); 
%>
<html>
<head>
	<title>컨테스트</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<style>
		br {mso-data-placement:same-cell;}
		.xl24 {mso-number-format:"\@";}    
	</style>
</head>
<body>

<h1>컨테스트 목록</h1>

<table border="1">
<tr>
	<th>순번</th>

	<th>고유번호</th>
	<th>성명</th>
	<th>팀원</th>
	<th>소속</th>
	<th>접수번호</th>

	<th>이메일</th>
	<th>연락처(자택)</th>
	<th>연락처(핸드폰)</th>
	<th>주소</th>
	<th>서비스 제목</th>

	<th>서비스 분야</th>
	<th>서비스 유형</th>
	<th>서비스 설명</th>
	<th>활용기관(분야명,기관명)</th>
	<th>첨부파일링크</th>
</tr>
<c:if test="${empty list }">
	<tr>
		<td colspan="16">검색된 결과가 없습니다.</td>
	</tr>
</c:if>
<c:forEach items="${list }" var="item" varStatus="status">
<tr>
	<td>${status.count }</td>

	<td>${item.seq }</td>
	<td>${item.name }</td>
	<td>${item.team }</td>
	<td>${item.attach }</td>
	<td class="xl24">${item.receipt }</td>

	<td>${item.email }</td>
	<td>${item.tel }</td>
	<td>${item.hp }</td>
	<td>
		${item.zipcode }
		${item.addr }
		${item.addr_detail }
	</td>
	<td>${item.title }</td>

	<td>
		<c:choose>
			<c:when test="${item.category eq 'WEB' }">웹</c:when>
			<c:when test="${item.category eq 'MOB' }">모바일</c:when>
			<c:when test="${item.category eq 'OFF' }">아이디어기획</c:when>
			<c:when test="${item.category eq 'DEV' }">제품개발창업</c:when>
			<c:otherwise>기타</c:otherwise>
		</c:choose>
	</td>
	<td>
		<c:choose>
			<c:when test="${item.category eq 'ON' }">온라인</c:when>
			<c:when test="${item.category eq 'OFF' }">오프라인</c:when>
			<c:when test="${item.category eq 'APP' }">모바일앱웹</c:when>
			<c:when test="${item.category eq 'DEV' }"></c:when>
			<c:otherwise></c:otherwise>
		</c:choose>
	</td>
	<td>
		${item.serviceinfo }
	</td>
	<td>
		${item.agents }
	</td>
	<td>
		<c:url var="urlFile" value="http://www.culture.go.kr/download.do">
			<c:param name="filename" value="/contest/${item.file_sysname }" />
			<c:param name="orgname" value="${item.file_orgname }" />
		</c:url>
		${urlFile }
	</td>
</tr>
</c:forEach>
</table>

</body>
</html>