<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>페이지 오류</title>
	<link href="/css/error.css" rel="stylesheet" type="text/css" />
<script>
alert('<c:out value="${exception.errorMessage">');
var url = '<c:out value="${exception.redirectUrl">';
if(url == ""){
	if(self.opener){
		self.close();
	}else{
		history.go(-1);
	}
}else{
	location.href = url;
}
</script>
</head>
<body>
</body>
</html>