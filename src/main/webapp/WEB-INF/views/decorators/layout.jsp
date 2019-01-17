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

<%--
	<sec:authentication property="principal.username" var="currentUserName"/>
	<sec:authentication property="principal.authorities" var="currentUserauthorities"/>
--%>

<c:set var="currentMenuIdTop" value="" />
<c:set var="currentMenuIdParent" value="" />
<c:set var="currentMenuId" value="" />
<c:set var="currentMenuActive" value="0" />

<c:if test="${not empty currentMenu }">
	<c:set var="currentMenuIdTop" value="${currentMenu.parentTopMenuId }" />
	<c:set var="currentMenuIdParent" value="${currentMenu.menu_pid }" />
	<c:set var="currentMenuId" value="${currentMenu.menu_id }" />
</c:if>

<div id="wrap">
	<div id="header">
		<h1 class="logo"><a href="/index.do"><img src="/images/layout/logo.jpg" alt="KCISA 문화포털 통합관리시스템" /></a></h1>

		<div class="loginInfo">
			<span class="name"><strong><c:out value="${sessionScope.admin_id }" /></strong>님</span>
			<a href="/logout">로그아웃</a>
		</div>

		<c:if test="${empty allMenuTree }">
			<ul class="gnb">
				<li><a href="#void" class="focus">기타 서비스</a></li>
			</ul>
		</c:if>
		<c:if test="${not empty allMenuTree }">
			<ul class="gnb">
				<c:forEach items="${allMenuTree }" var="dep1">
					<li>
						<a href="${dep1.firstUrl }"${dep1.menu_id eq currentMenuIdTop ? ' class="focus"' : '' }>
							${dep1.menu_name }
						</a>
					</li>
				</c:forEach>
			</ul>
		</c:if>

	</div>
	<div id="container">
		<div id="lnb">
			<c:if test="${empty allMenuTree }">
						<h2><a href="#void">기타 서비스</a></h2>
						<ul class="depth1">
							<li><a href="#void">기타 서비스</a></li>
						</ul>
			</c:if>
			<c:if test="${not empty allMenuTree }">
				<c:forEach items="${allMenuTree }" var="dep1">
					<c:if test="${dep1.menu_id eq currentMenuIdTop }">
						<c:set var="currentMenuActive" value="1" />

						<h2>
							<a href="${dep1.firstUrl }">
								${dep1.menu_name }
							</a>
						</h2>

						<c:if test="${not empty dep1.childMenuList }">
							<ul class="depth1">
								<c:forEach items="${dep1.childMenuList }" var="dep2">
									<li>
										<a href="${dep2.firstUrl }"${dep2.menu_id eq currentMenuIdParent or dep2.menu_id eq currentMenuId ? ' class="focus"' : '' }>
											${dep2.menu_name }
										</a>
										
										<c:if test="${not empty dep2.childMenuList }">
											<ul class="depth2" style="display:block">
												<c:forEach items="${dep2.childMenuList }" var="dep3">
													<li>
														<a href="${dep3.firstUrl }"${dep3.menu_id eq currentMenuId ? ' class="focus"' : '' }>
															${dep3.menu_name }
														</a>
													</li>
												</c:forEach>
											</ul>
										</c:if>
									</li>
								</c:forEach>
							</ul>
						</c:if>

					</c:if>
				</c:forEach>
				
				<c:if test="${currentMenuActive eq 0 }">
					<h2><a href="#void">기타 서비스</a></h2>
					<ul class="depth1">
						<li><a href="#void" class="focus">기타 서비스</a></li>
					</ul>
				</c:if>
			</c:if>

		</div>
		<div id="contentWrap">
			<div id="content">
				<c:if test="${empty currentMenu }">
					<h3 class="title01">기타 서비스</h3>
					<div class="location">
						<span class="home">home</span>
						<strong>기타 서비스</strong>
					</div>
				</c:if>
				<c:if test="${not empty currentMenu }">
					<h3 class="title01">
						${currentMenu.menu_name }
					</h3>

					<div class="location">
						<span class="home">home</span>
	
						<c:forEach items="${currentMenu.parentMenuNameList }" var="item" varStatus="status">
							<c:if test="${not status.last }">
								<span>${item }</span>
							</c:if>		
							<c:if test="${status.last }">
								<strong>${item }</strong>
							</c:if>		
						</c:forEach>
					</div>
				</c:if>

				<decorator:body />
			</div>
		</div>
	</div>
	<div id="footer">
		<p class="copyright">Copyrightⓒ 2014 <strong>Korea Culyure Infotmation Service Agency</strong> All Rights Reserved.</p>
	</div>
</div>
</body>
</html>