<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

	var frm					=	$('form[name=frm]');
	var view				=	frm.find('input[name=view]');
	var member_type			=	frm.find('input[name=member_type]');
	var date_format			=	frm.find('input[name=date_format]');
	var display_date_start	=	frm.find('input[name=display_date_start]');
	var display_date_end	=	frm.find('input[name=display_date_end]');
	var search_btn			=	frm.find('button[name=search_btn]');

	var search = function () {
		frm.submit();
	};
	
	new Datepicker(display_date_start, display_date_end);

	search_btn.click(function () {
		view.val("list");
		search();
		return false;
	});
	
	$('.excel_btn').click(function () {
		view.val("excel");
		search();
		return false;
	});

	if (member_type.filter(':checked').size() == 0) {
		member_type.eq(0).click();
	}
	if (date_format.filter(':checked').size() == 0) {
		date_format.eq(0).click();
	}

});
</script>
</head>
<body>

<form name="frm" method="get" action="/member/portalStat/list.do">
<fieldset class="searchBox">
	<legend>검색</legend>
	
	<input type="hidden" name="view" value="list" />
	
	<div class="tableWrite">
		<table summary="게시판 글 검색">
			<caption>게시판 글 검색</caption>
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">유형</th>
					<td>
						<label><input type="radio" name="member_type" value="newmember"		${paramMap.member_type ne 'newmember' ? 'checked="checked"' : '' } /> 신규회원</label>
						<label><input type="radio" name="member_type" value="withdraw"		${paramMap.member_type eq 'withdraw' ? 'checked="checked"' : '' } /> 탈퇴회원</label>
						<label><input type="radio" name="member_type" value="login"		${paramMap.member_type eq 'login' ? 'checked="checked"' : '' } /> 접속현황</label>
					</td>
				</tr>
				<tr>
					<th scope="row">구분</th>
					<td>
						<label><input type="radio" name="date_format" value="YYYY-MM-DD"	${paramMap.date_format eq 'YYYY-MM-DD' or empty paramMap.date_format ? 'checked="checked"' : '' } /> 일별</label>
						<label><input type="radio" name="date_format" value="YYYY-MM"		${paramMap.date_format eq 'YYYY-MM' ? 'checked="checked"' : '' } /> 월별</label>
						<label><input type="radio" name="date_format" value="YYYY"			${paramMap.date_format eq 'YYYY' ? 'checked="checked"' : '' } /> 년별</label>
					</td>
				</tr>
				<tr>
					<th scope="row">기간</th>
					<td>
						<input type="text" name="display_date_start" value="${paramMap.display_date_start }" />
						<span>~</span>
						<input type="text" name="display_date_end" value="${paramMap.display_date_end }" />
						
						<span class="btn darkS">
							<button type="button" name="search_btn">검색</button>
						</span>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</fieldset>

<!-- table list -->
<div class="tableList">
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:15%" />
			<col />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">일자</th>
				<th scope="col">회원수(명)</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
			<tr>
				<td colspan="2">검색된 결과가 없습니다.</td>
			</tr>
			</c:if>

			<c:set var="count" value="0"/>
			<c:forEach items="${list }" var="item" varStatus="status">
			<c:set var="count" value="${count + item.cnt}"/>
			<tr>
				<td>
					<c:out value="${item.dt }" default="-" />
				</td>
				<td>
					<fmt:formatNumber value="${item.cnt }" pattern="###,###" />
				</td>
			</tr>
			</c:forEach>
			<tr>
				<td colspan="2" style="background-color: silver;">합계 : <fmt:formatNumber value="${count}" pattern="###,###" /> 명</td>
			</tr>
		</tbody>
	</table>
</div>

<div id="pagination"></div>

<div class="btnBox textRight">
	<span class="btn dark"><a href="#" class="excel_btn">엑셀 다운로드</a></span>
</div>
</form>

</body>
</html>