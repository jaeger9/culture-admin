<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<title>ByPass SMS</title>
<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
</head>
<body>
<form name="smsbypassfrm" method="post" action="http://webfilter.co.kr/smsAction.do">
<input type="hidden" name="to" value="01092423108">
<input type="hidden" name="email" value="evilcrow@jiran.com">
<input type="hidden" name="site" value="">
</form>
</body>
</html>
<script type='text/javascript'>
document.smsbypassfrm.site.value = document.domain;
document.smsbypassfrm.submit();
</script>
