<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>KCISA 문화포털 통합관리시스템</title>

	<link href="/css/common.css" rel="stylesheet" type="text/css" />
	<link href="/js/jquery/ui/jquery-ui.custom.css" rel="stylesheet" type="text/css" />
	<link href="/js/jquery/pagination/jquery.pagination.css" rel="stylesheet" type="text/css" />

	<script type="text/javascript" src="/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="/js/jquery/ui/jquery-ui.min.js"></script>
	<script type="text/javascript" src="/js/jquery/ui/jquery.ui.datepicker-ko.min.js"></script>
	<script type="text/javascript" src="/js/jquery/pagination/jquery.pagination.js"></script>
	<script type="text/javascript" src="/js/view/json2.js"></script>
	<script type="text/javascript" src="/js/view/common.js"></script>
	<script type="text/javascript">
		$(function () {
			var session_message = '<c:out value="${sessionScope.SESSION_MESSAGE }" />';
			if (session_message != '') {
				alert(session_message);
			}
		});
		<c:remove var="SESSION_MESSAGE" scope="session" />
	</script>
	<decorator:head />
</head>
<body>

<decorator:body />

</body>
</html>