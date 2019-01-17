<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>KCISA 문화포털 통합관리시스템</title>

	<link href="/css/login.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="/js/jquery/jquery.js"></script>
	<script type="text/javascript">
		$(function() {
			var frm = $('form[name=loginForm]');
			var id = frm.find('input[name=j_username]');
			var pw = frm.find('input[name=j_password]');

			frm.submit(function () {
				if (id.val() == '') {
					alert('아이디를 입력해 주세요.');
					return false;
				}

				if (pw.val() == '') {
					alert('비밀번호를 입력해 주세요.');
					return false;
				}	

				return true;
			});

			// session message
			var session_message = '<c:out value="${sessionScope.SESSION_MESSAGE }" />';
			if (session_message != '') {
				alert(session_message);
			}
			<c:remove var="SESSION_MESSAGE" scope="session" />
		});
	</script>
</head>
<body>
<div id="wrap">
	<div id="header">
		<h1><img src="/images/layout/logo_login.jpg" alt="KCISA 문화포털 통합관리시스템" /></h1>
	</div>

	<div id="content">
		<div class="loginForm">
			<form name="loginForm" method="post" action="<c:url value='j_spring_security_check' />" >
			<fieldset>
				<legend>로그인</legend>
				<!-- focus될경우 class="focus" -->
				<div class="inputId focus">
					<!-- class="placeholder" 추가 -->
					<input type="text" name="j_username" class="placeholder" title="아이디 입력" placeholder="아이디 입력" value="postcorea">
				</div>
				<!-- focus될경우 class="focus" -->
				<div class="inputPw">
					<input type="password" name="j_password" title="비밀번호 입력" placeholder="비밀번호 입력" value="plan227">
				</div>
				<!-- 로그인 버튼 : S -->
				<div class="btnLogin"><input type="image" name="loginButton" src="/images/layout/btn_login.jpg" alt="로그인"></div>
				<!-- 로그인 버튼 : E -->
			</fieldset>
			</form>
		</div>
	</div>

	<div id="footer">
		<p class="copyright">Copyrightⓒ  2014 <strong>Korea Culture Infotmation Service Agency</strong> All Rights Reserved.</p>
	</div>
</div>	
</body>
</html>