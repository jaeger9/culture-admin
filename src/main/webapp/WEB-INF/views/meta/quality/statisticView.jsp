<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- <script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script> -->
<script type="text/javascript">

$(function () {
	
	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
	// nhn.husky.EZCreator.createInIFrame( oEditorsOption );

	var frm			=	$('form[name=frm]');
	var group_id	=	frm.find('input[name=group_id]');
	var reg_start	=	frm.find('input[name=reg_start]');
	var reg_end		=	frm.find('input[name=reg_end]');
	var search_btn	=	frm.find('button[name=search_btn]');

	var search = function () {
		frm.submit();
	};

	new Datepicker(reg_start, reg_end);
	
	search_btn.click(function () {
		search();
		return false;
	});

	$('.list_btn').click(function () {
		history.back();
		return false;
	});
	
});
</script>
</head>
<body>

<form name="frm" method="get" action="/meta/quality/statisticView.do">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="group_id" value="${paramMap.group_id }" />

	<div class="tableWrite">
		<table summary="게시판 글 등록">
		<caption>게시판 글 등록</caption>
		<colgroup>
			<col style="width:18%" />
			<col />
		</colgroup>
		<tbody>
		<tr>
			<th scope="row">그룹명</th>
			<td>
				${viewName.JOB_GROUP_NAME }
			</td>
		</tr>
		<tr>
			<th scope="row">기간</th>
			<td>
				<input type="text" name="reg_start" value="${paramMap.reg_start }" />
				<span>~</span>
				<input type="text" name="reg_end" value="${paramMap.reg_end }" />

				<span class="btn darkS">
					<button type="button" name="search_btn">검색</button>
				</span>
			</td>
		</tr>
		</tbody>
		</table>
	</div>

</fieldset>
</form>

	<div class="tableList" style="margin-top:15px;">
		<table summary="게시판 글 목록">
			<caption>게시판 글 목록</caption>
			<colgroup>
				<col style="width:15%;"/>
				<col style="width:60%;"/>
				<col  />
				<col style="width:15%;"/>
			</colgroup>
			<thead>
				<tr>
					<th scope="col">일자</th>
					<th scope="col">수집명</th>
					<th scope="col">수집건수</th>
					<th scope="col">수집건수 합계</th>
				</tr>
			</thead>
			<tbody>

<c:if test="${empty dataList }">
				<tr>
					<td colspan="4">검색된 결과가 없습니다.</td>
				</tr>
</c:if>
<c:if test="${not empty dataList}">
			<c:set var="regdate" value='' />
			<c:set var="rowColor" value='' />
			<c:set var="rowColor2" value='' />
			<c:set var="dayTotal" value='0' />
			<c:set var="divNum" value='' />
			<c:forEach var="list" items="${dataList}" varStatus="sts">
				
				<c:if test='${empty regdate || regdate ne  list.REG_DATE}'>
					<c:choose>
						<c:when test='${rowColor eq "F0F0F0" }' ><c:set var="rowColor" value='ffffff' /></c:when>
						<c:otherwise><c:set var="rowColor" value='F0F0F0' /></c:otherwise>
					</c:choose>
				</c:if>
				<c:if test='${regdate ne  list.REG_DATE && sts.index ne 0}'>
					<c:choose>
						<c:when test='${rowColor eq "F0F0F0" }' ><c:set var="rowColor2" value='ffffff' /></c:when>
						<c:otherwise><c:set var="rowColor2" value='F0F0F0' /></c:otherwise>
					</c:choose>
				</c:if>
				
				<tr style="background-color:#<c:out value='${rowColor }' />">
					<c:choose>
					<c:when test='${empty regdate || regdate ne list.REG_DATE}'>
						<c:choose>
							<c:when test='${dayTotal ne "" || divNum ne ""}' >
								<script type="text/javascript" >
									$('#totalRow<c:out value="${divNum }" />').text('<fmt:formatNumber pattern="#,###" value="${dayTotal }" />');
								</script>
								<c:set var="dayTotal" value='${list.CNT }' />
								<c:set var="divNum" value='${sts.index }' />
							</c:when>
							<c:otherwise>
								<c:set var="dayTotal" value='${list.CNT }' />
								<c:set var="divNum" value='${sts.index }' />
							</c:otherwise>
						</c:choose>
						<c:set var="regdate" value='${list.REG_DATE }' />
						<td <c:if test='${list.ROWCNT ne "1" }'>rowspan="<c:out value='${list.ROWCNT }' />"</c:if>><c:out value='${list.REG_DATE }' /></td>
						<td><c:out value='${list.JOB_NAME }' /></td>
						<td><fmt:formatNumber pattern="#,###" value="${list.CNT }" /></td>
						<td <c:if test='${list.ROWCNT ne "1" }'>rowspan="<c:out value='${list.ROWCNT }' />"</c:if>><p id="totalRow<c:out value='${sts.index }' />"><c:out value='${sts.index }' /></p></td>
					</c:when>
					<c:otherwise>
						<td><c:out value='${list.JOB_NAME }' /></td>
						<td><fmt:formatNumber pattern="#,###" value="${list.CNT }" /></td>
						<c:set var="dayTotal" value='${dayTotal + list.CNT }' />
					</c:otherwise>
					</c:choose>
					
				</tr>
			</c:forEach>
			<script type="text/javascript" >
				$('#totalRow<c:out value="${divNum }" />').text('<fmt:formatNumber pattern="#,###" value="${dayTotal }" />');
			</script>
</c:if>
			</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn gray"><a href="/meta/quality/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</body>
</html>