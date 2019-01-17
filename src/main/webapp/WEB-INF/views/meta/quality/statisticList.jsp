<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

	var frm			=	$('form[name=frm]');
	var category	=	frm.find('select[name=category]');
	var keyword		=	frm.find('input[name=keyword]');
	var search_btn	=	frm.find('button[name=search_btn]');

	var search = function () {
		frm.submit();
	};

	search_btn.click(function () {
		search();
		return false;
	});

	$('.tmp1').each(function () {
		var v1 = $(this).next().text().replace(/[^0-9]/g, '');
		var v2 = $(this).text().replace(/[^0-9]/g, '');
		var v3 = 0;
		
		if (v1 == 0 && v2 == 0) {
			v3 = 0;
		} else if (v1 == 0 && v2 > 0) {
			v3 = 0;
		} else if (v1 > 0 && v2 == 0) {
			v3 = '∞';
		} else {
			v3 = ((v1 / v2) * 100).toFixed(2);
		}

		// console.log(v1 + ':' + v2);
		
		$(this).next().next().text( v3 + ' %' );
	});

});
</script>
</head>
<body>

<form name="frm" method="get" action="/meta/quality/list.do">
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
					<th scope="row">검색</th>
					<td>
						<select name="category">
							<option value="">전체</option>
							<option value="관광"		${paramMap.category eq '관광'		? 'selected="selected"' : '' }>관광</option>
							<option value="도서"		${paramMap.category eq '도서'		? 'selected="selected"' : '' }>도서</option>
							<option value="문화산업"	${paramMap.category eq '문화산업'	? 'selected="selected"' : '' }>문화산업</option>
							<option value="문화예술"	${paramMap.category eq '문화예술'	? 'selected="selected"' : '' }>문화예술</option>
							<option value="문화유산"	${paramMap.category eq '문화유산'	? 'selected="selected"' : '' }>문화유산</option>
							<option value="정책"		${paramMap.category eq '정책'		? 'selected="selected"' : '' }>정책</option>
							<option value="체육"		${paramMap.category eq '체육'		? 'selected="selected"' : '' }>체육</option>
						</select>

						<input type="text" name="keyword" value="${paramMap.keyword }" style="width:470px;" />

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
			<col style="width:70%;"/>
			<col style="width:15%;"/>
			<col />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">기관명</th>
				<th scope="col">일자</th>
				<th scope="col">카운트</th>
			</tr>
		</thead>
		<tbody>
<c:if test="${empty dataList}">
			<tr>
				<td colspan="3">검색된 결과가 없습니다.</td>
			</tr>
</c:if>
<c:if test="${not empty dataList}">
<c:set var="total" value='0' />
			<c:set var="rowCount" value='0' />			
			<c:forEach var="list" items="${dataList }" varStatus="sts">
				<tr>
					<td><a href='statisticView.do?group_id=<c:out value='${list.JOB_GROUP_ID }' />&qs=${paramMap.qs }' ><c:out value='${list.JOB_GROUP_NAME }' /></a></td>
					<td><c:out value='${list.REG_DATE }' /></td>
					<td><fmt:formatNumber pattern="#,###" value="${list.CNT }" /></td>
					<c:set var="total" value='${total + list.CNT }' />
					<c:set var="rowCount" value='${rowCount + 1 }' />
				</tr>
			</c:forEach>
				<tr style="background-color:#F0F0F0">
					<td>합계</td>
					<td><c:out value='${rowCount }' />개 기관</td>
					<td><fmt:formatNumber pattern="#,###"  value='${total }' /></td>
				</tr>
</c:if>
		</tbody>
	</table>
</div>

</form>

</body>
</html>