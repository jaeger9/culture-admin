<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	pageContext.setAttribute("cr", "\r");
	pageContext.setAttribute("lf", "\n");
	pageContext.setAttribute("crlf", "\r\n");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
</head>
<body>
<div class="tableWrite">
	<div class="sTitBar">
		<h4>네이밍공모 조회</h4>
	</div>
	<div class="tableWrite">	
		<table summary="제안정보 조회">
			<caption>제안정보 조회</caption>
			<colgroup>
				<col style="width:15%" />
				<col style="width:35%" />
				<col style="width:15%" />
				<col style="width:35%" />
			</colgroup>
			<tbody>
				<tr>
					<th>번호</th>
					<td>${view.seq }</td>
					<th>접수일</th>
					<td>${view.reg_date }</td>
				</tr>
				<tr>
					<th scope="row">이름</th>
					<td colspan="3">${view.user_nm }</td>
				</tr>
				<tr>
					<th>이메일</th>
					<td>${view.email}</td>
					<th>전화번호</th>
					<td>${view.hp }</td>
				</tr>
				<tr>
					<th scope="row">네이밍</th>
					<td colspan="3">${view.title }</td>
				</tr>
				<tr>
					<th scope="row">네이밍 설명</th>
					<td colspan="3">${fn:replace(view.description,crlf,"<br>") }</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
<div class="btnBox textRight">
	<span class="btn gray"><a href="/addservice/naming/entryList.do" class="list_btn">목록</a></span>
</div>
</body>
</html>