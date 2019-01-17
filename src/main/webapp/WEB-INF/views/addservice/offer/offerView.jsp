<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
</head>
<body>
<div class="tableWrite">
	<div class="sTitBar">
		<h4>제안정보 조회</h4>
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
					<th>아이디</th>
					<td>${view.user_id }</td>
					<th>성명</th>
					<td>${view.name }</td>
				</tr>
				<tr>
					<th>이메일</th>
					<td>${view.email }</td>
					<th>휴대폰번호</th>
					<td>${view.hp }</td>
				</tr>
				<tr>
					<th scope="row">제목</th>
					<td colspan="3">${view.title }</td>
				</tr>
				<tr>
					<th scope="row">현황 및 문제점</th>
					<td colspan="3">${view.current_state }</td>
				</tr>
				<tr>
					<th scope="row">제안 내용</th>
					<td colspan="3">${view.contents }</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
<div class="btnBox textRight">
	<span class="btn gray"><a href="/event/offer/offerList.do" class="list_btn">목록</a></span>
</div>
</body>
</html>