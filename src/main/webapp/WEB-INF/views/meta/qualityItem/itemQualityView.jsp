<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

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

	$('.list_btn').click(function () {
		history.back();
		return false;
	});
	
});
</script>
</head>
<body>

<div class="tableList">
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col  />
			<col style="width:35%;"/>
			<col style="width:9%;"/>
			<col style="width:9%;"/>
			<col style="width:9%;"/>
			<col style="width:9%;"/>
		</colgroup>
		<thead>
			<tr>
				<th scope="col">기관명</th>
				<th scope="col">수집명</th>
				<th scope="col">데이터 건수</th>
				<th scope="col">예상항목</th>
				<th scope="col">수집항목</th>
				<th scope="col">수집율</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><a href='/meta/quality/statisticView.do?group_id=<c:out value='${EO.JOB_GROUP_ID }' />' ><c:out value='${EO.JOB_GROUP_NAME }'  /></a></td>
				<td><c:out value='${EO.JOB_NAME }'  /></td>
				<td><fmt:formatNumber pattern="#,###.##" value='${EO.CNT }'  /></td>
				<td><fmt:formatNumber pattern="#,###.##" value='${EO.MARK_CNT }'  /></td>
				<td><fmt:formatNumber pattern="#,###.##" value='${EO.COLLECT_CNT }'  /></td>
				<td class="tmp" data-v1="${EO.MARK_CNT }" data-v2="${EO.COLLECT_CNT }">
<%-- 					<fmt:formatNumber pattern="#,###.##" value='${(EO.COLLECT_CNT/EO.MARK_CNT)*100 }'  />% --%>
				</td>
			</tr>
		</tbody>
	</table>
</div>

<div class="tableList" style="margin-top:15px;">
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:25%;"/>
			<col style="width:25%;"/>
			<col  />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">예상 항목</th>
				<th scope="col">수집 항목</th>
				<th scope="col">설명</th>
			</tr>
		</thead>
		<tbody>
<c:if test="${empty menuList}">
			<tr>
				<td colspan="3">해당 정보가 없습니다.</td>
			</tr>
</c:if>
<c:if test="${not empty menuList}">
			<c:forEach var="list" items="${menuList}" varStatus="sts">
				<c:if test='${ not empty expMap[list.COLUMN_IDX] || not empty colMap[list.COLUMN_IDX] }'>
				<tr>
					<c:choose><c:when test='${not empty expMap[list.COLUMN_IDX] }'><td><c:out value='${expMap[list.COLUMN_IDX] }' /></td></c:when><c:otherwise><td style="background-color:rgb(144, 250, 84);">예상항목에 없음</td></c:otherwise></c:choose>
					<c:choose><c:when test='${not empty colMap[list.COLUMN_IDX] }'><td><c:out value='${colMap[list.COLUMN_IDX] }' /></td></c:when><c:otherwise><td style="background-color:rgb(255, 60, 23);">수집 안됨</td></c:otherwise></c:choose>
					<td><c:out value='${list.COLUMN_DESCRIPTION }' /></td>
				</tr>
				</c:if>
			</c:forEach>
</c:if>
		</tbody>
	</table>
</div>


<div class="btnBox textRight">
	<span class="btn white"><a href="/meta/qualityItem/itemQualityEdit.do?group_id=<c:out value='${paramMap.group_id }' />&job_id=<c:out value='${paramMap.job_id }' />" class="insert_btn">수정</a></span>
	<span class="btn gray"><a href="#" class="list_btn">목록</a></span>
</div>


</body>
</html>