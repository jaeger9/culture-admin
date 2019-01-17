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
	var mark_item	=	frm.find('input[name=mark_item]');
	var mark_count	=	frm.find('input[name=mark_count]');
	
	var mark_cnt	=	frm.find('input[name=mark_cnt]');

	frm.submit(function () {
		// frm.serialize()
		// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);

		var checks = mark_cnt.filter(':checked');
		var v = '';

		if (checks.size() == 0) {
			mark_item.val('');
			mark_count.val(0);
		} else {
			checks.each(function () {
				if (v == '') {
					v = $(this).val();
				} else {
					v += ',' + $(this).val();
				}
			});
			mark_item.val(v);
			mark_count.val(checks.size());
		}

		return true;
	});
	
	// 등록/수정
	$('.insert_btn').click(function () {
		frm.submit();
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


<form name="frm" method="POST" action="/meta/qualityItem/itemQualityEdit.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="group_id" value="<c:out value='${paramMap.group_id }' />" />
	<input type="hidden" name="job_id" value="<c:out value='${paramMap.job_id }' />" />

	<input type="hidden" name="mark_item" value="<c:out value='${EO.MARK_ITEM }' />" />
	<input type="hidden" name="mark_count" value="<c:out value='${EO.MARK_CNT }' />" />

<div class="tableList">
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:5%;"/>
			<col style="width:25%;"/>
			<col style="width:25%;"/>
			<col  />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">선택</th>
				<th scope="col">예상수집 항목</th>
				<th scope="col">수집 된 항목</th>
				<th scope="col">설명</th>
			</tr>
		</thead>
		<tbody>
<c:if test="${empty menuList}">
				<tr>
					<td colspan="4">해당 정보가 없습니다.</td>
				</tr>
</c:if>
<c:if test="${not empty menuList}">

			<c:forEach var="list" items="${menuList}" varStatus="sts">
				<tr>
					<td><input type="checkbox" name="mark_cnt" value="<c:out value='${list.COLUMN_IDX }' />" <c:if test='${not empty expMap[list.COLUMN_IDX] }'>checked="checked"</c:if> /></td>
					<td><c:out value='${list.COLUMN_NAME }' /></td>
					<c:choose>
						<c:when test='${not empty colMap[list.COLUMN_IDX] }'><td><c:out value='${colMap[list.COLUMN_IDX] }' /></td></c:when>
						<c:otherwise><td style="background-color:rgb(255, 60, 23);">수집 안됨</td></c:otherwise>
					</c:choose>
					<td><c:out value='${list.COLUMN_DESCRIPTION }' /></td>
				</tr>
			</c:forEach>
</c:if>
		</tbody>
	</table>
</div>

</fieldset>
</form>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">수정</a></span>
		<span class="btn gray"><a href="/meta/qualityItem/itemQualityList.do" class="list_btn">목록</a></span>
	</div>


</body>
</html>