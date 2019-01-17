<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {
	//	
});
</script>
</head>
<body>

<h1>문화초대이벤트 통계</h1>

<h2>일별 등록건수</h2>
<c:if test="${empty listByDailyRegdate }">
	일별 등록건수가 없습니다.
</c:if>
<c:forEach items="${listByDailyRegdate }" var="item" varStatus="status">
	<div>
		${item.reg_date }
		${item.cnt }
		${item.per }
	</div>
</c:forEach>

<h2>일별 가입자수</h2>
<c:if test="${empty listByDailyJoinMember }">
	가입자가 없습니다.
</c:if>
<c:forEach items="${listByDailyJoinMember }" var="item" varStatus="status">
	<div>
		${item.join_date }
		${item.cnt }
		${item.per }
	</div>
</c:forEach>


</body>
</html>