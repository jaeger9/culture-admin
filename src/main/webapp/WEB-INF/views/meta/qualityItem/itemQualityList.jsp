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

	$('.tmp').each(function () {
		var data = $(this).data();
		var v1 = data.v1;
		var v2 = data.v2;
		var v3 = 0;
		
		if (v1 == 0 && v2 == 0) {
			v3 = 0;
		} else if (v1 == 0 && v2 > 0) {
			v3 = 0;
		} else if (v1 > 0 && v2 == 0) {
			v3 = '∞';
		} else {
			v3 = ((v2 / v1) * 100).toFixed(2);
		}

		// console.log(v1 + ':' + v2);
		
		$(this).text( v3 + ' %' );
	});

});
</script>
</head>
<body>

<form name="frm" method="get" action="/meta/qualityItemItem/itemQualityList.do">
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
</form>

<!-- table list -->
<div class="tableList">
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col  />
			<col style="width:27%;"/>
			<col style="width:10%;"/>
			<col style="width:10%;"/>
			<col style="width:10%;"/>
		</colgroup>
		<thead>
			<tr>
				<th scope="col">기관명</th>
				<th scope="col">수집명</th>
				<th scope="col">예상항목</th>
				<th scope="col">수집항목</th>
				<th scope="col">수집율</th>
			</tr>
		</thead>
		<tbody>
<c:if test="${empty dataList}">
			<tr>
				<td colspan="5">검색된 결과가 없습니다.</td>
			</tr>
</c:if>
<c:if test="${not empty dataList}">

<c:set var="mark_cnt" value='0' />
			<c:set var="collect_cnt" value='0' />
			<c:set var="rowCount" value='0' />			
			<c:set var="rowCount2" value='0' />
			<c:set var="job_group" value='' />
			<c:set var="rowColor" value='ffffff' />
			<c:forEach var="list" items="${dataList}" varStatus="sts">
				<c:if test='${empty job_group || job_group ne list.JOB_GROUP_ID}'>
					<c:choose>
						<c:when test='${rowColor eq "F0F0F0" }' ><c:set var="rowColor" value='ffffff' /></c:when>
						<c:otherwise><c:set var="rowColor" value='F0F0F0' /></c:otherwise>
					</c:choose>
				</c:if>
				<c:if test='${job_group ne list.JOB_GROUP_ID && sts.index ne 0}'>
					<c:choose>
						<c:when test='${rowColor eq "F0F0F0" }' ><c:set var="rowColor2" value='ffffff' /></c:when>
						<c:otherwise><c:set var="rowColor2" value='F0F0F0' /></c:otherwise>
					</c:choose>
				</c:if>
				<c:choose>
					<c:when test='${empty job_group || job_group ne list.JOB_GROUP_ID}'>
				<tr style="background-color:#<c:out value='${rowColor }' />">
						<td rowspan="<c:out value='${list.ROW_CNT }' />">
							<a href='/meta/quality/statisticView.do?group_id=<c:out value='${list.JOB_GROUP_ID }' />&qs=${paramMap.qs }' >
								<c:out value='${list.JOB_GROUP_NAME }' />
							</a>
						</td>
						<c:set var="job_group" value='${list.JOB_GROUP_ID }' />
						<c:set var="rowCount2" value='${rowCount2 + 1 }' />
					</c:when>
					<c:otherwise>
				<tr style="background-color:#<c:out value='${rowColor }' />">
					</c:otherwise>
					</c:choose>
					
					<td>
						<a href="itemQualityView.do?group_id=<c:out value='${list.JOB_GROUP_ID }' />&job_id=<c:out value='${list.JOB_ID }' />" >
							<c:out value="${list.JOB_NAME }" />
						</a>
					</td>
					<td>
						<a href="itemQualityEdit.do?group_id=<c:out value='${list.JOB_GROUP_ID }' />&job_id=<c:out value='${list.JOB_ID }' />" >
							<fmt:formatNumber pattern="#,###" value="${list.MARK_CNT }" />
						</a>
					</td>
					<td>
						<fmt:formatNumber pattern="#,###" value="${list.COLLECT_CNT }" />
					</td>
					<td class="tmp" data-v1="${list.MARK_CNT }" data-v2="${list.COLLECT_CNT }">
<%-- 						<fmt:formatNumber pattern="#,###.##"  value="${(list.COLLECT_CNT / list.MARK_CNT) * 100 }" /> % --%>
					</td>

					<c:set var="mark_cnt" value='${mark_cnt + list.MARK_CNT }' />
					<c:set var="collect_cnt" value='${collect_cnt + list.COLLECT_CNT }' />
					<c:set var="rowCount" value='${rowCount + 1 }' />
				</tr>
			</c:forEach>
				<tr style="background-color:#F0F0F0">
					<td colspan="2"><c:out value='${rowCount2 }' />개 기관 / <c:out value='${rowCount }' />개 수집</td>
					<td><fmt:formatNumber pattern="#,###"  value='${mark_cnt }' /></td>
					<td><fmt:formatNumber pattern="#,###"  value='${collect_cnt }' /></td>
					<td class="tmp" data-v1="${mark_cnt }" data-v2="${collect_cnt }">
<%-- 						<fmt:formatNumber pattern="#,###.##" value='${(collect_cnt / mark_cnt) * 100}' />% --%>
					</td>
				</tr>

</c:if>
		</tbody>
	</table>
</div>


</body>
</html>