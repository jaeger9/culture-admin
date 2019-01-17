<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

	var frm				=	$('form[name=frm]');
	var page_no			=	frm.find('input[name=page_no]');
	var search_word		=	frm.find('input[name=search_word]');
	var search_btn		=	frm.find('button[name=search_btn]');
	
	var search = function () {
		frm.submit();
	};
	
	new Pagination({
		view		:	'#pagination',
		page_count	:	'${count }',
		page_no		:	'${paramMap.page_no }',
		callback	:	function(pageIndex, e) {
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});

	new Checkbox('input[name=arc_thm_idsAll]', 'input[name=arc_thm_ids]');

	$('.delete_btn').click(function () {

		var arc_thm_ids = $('input[name=arc_thm_ids]:checked');

		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		if (arc_thm_ids.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}

		var param = {};

		if (arc_thm_ids.size() > 0) {
			param.arc_thm_ids = [];
			
			$('input[name=arc_thm_ids]:checked').each(function () {
				param.arc_thm_ids.push( $(this).val() );
			});
		}

		$.ajax({
			url			:	'/addservice/archiveCategory/delete.do'
			,type		:	'post'
			,data		:	$.param(param, true)
			,dataType	:	'json'
			,success	:	function (res) {
				if (res.success) {
					alert("삭제가 완료 되었습니다.");
					location.reload();
				} else {
					alert("삭제 실패 되었습니다.");
				}
			}
			,error : function(data, status, err) {
				alert("삭제 실패 되었습니다.");
			}
		});

		return false;
	});

});
</script>
</head>
<body>

<form name="frm" method="get" action="/addservice/archiveCategory/list.do">
<fieldset class="searchBox">
	<legend>검색</legend>
	
	<input type="hidden" name="page_no" value="${paramMap.page_no }" />
	<input type="hidden" name="sKey" value="${paramMap.sKey }" />
	<input type="hidden" name="arc_thm_id" value="${paramMap.arc_thm_id }" />
	<input type="hidden" name="mst_class" value="${paramMap.mst_class }" />
</fieldset>

<div class="topBehavior">
	<p class="totalCnt">총 <span><fmt:formatNumber value="${count }" pattern="###,###" /></span>건</p>
<!--
	<ul class="sortingList">
		<li class="on"><a href="#url">최신순</a></li>
		<li><a href="#url">조회순</a></li>
	</ul>
-->
</div>

<!-- table list -->
<div class="tableList">

	<c:if test="${paramMap.sKey eq 'top' or empty paramMap.sKey }">
		<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:4%" />
			<col style="width:8%" />
			<col />
			<col style="width:30%" />
			<col style="width:15%" />
		</colgroup>
		<thead>
		<tr>
			<th scope="col"><input type="checkbox" name="arc_thm_idsAll" /></th>
			<th scope="col">번호</th>
			<th scope="col">분류</th>
			<th scope="col">경로</th>
			<th scope="col">중분류</th>
		</tr>
		</thead>
		<tbody>
		<c:if test="${empty list }">
		<tr>
			<td colspan="5">검색된 결과가 없습니다.</td>
		</tr>
		</c:if>

		<c:forEach items="${list }" var="item" varStatus="status">
		<tr>
			<td>
				<input type="checkbox" name="arc_thm_ids" value="${item.arc_thm_id }" />
			</td>
			<td>
				<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
			</td>
			<td style="text-align:left;">
				<a href="./form.do?sKey=top&arc_thm_id=${item.arc_thm_id }">
					${item.arc_thm_title }
				</a>
			</td>
			<td style="text-align:left;">
				${item.thm_ccm_path }
			</td>
			<td>
				<a href="./list.do?sKey=mid&arc_thm_id=${item.arc_thm_id }">
					중분류
					[${item.arc_thm_id }]
				</a>
			</td>
		</tr>
		</c:forEach>
		</tbody>
		</table>

	</c:if>
	<c:if test="${paramMap.sKey eq 'mid' }">

		<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:4%" />
			<col style="width:8%" />
			<col />
			<col style="width:15%" />
		</colgroup>
		<thead>
		<tr>
			<th scope="col"><input type="checkbox" name="arc_thm_idsAll" /></th>
			<th scope="col">번호</th>
			<th scope="col">분류</th>
			<th scope="col">중분류</th>
		</tr>
		</thead>
		<tbody>
		<c:if test="${empty list }">
		<tr>
			<td colspan="4">검색된 결과가 없습니다.</td>
		</tr>
		</c:if>

		<c:forEach items="${list }" var="item" varStatus="status">
		<tr>
			<td>
				<input type="checkbox" name="arc_thm_ids" value="${paramMap.arc_thm_id }_${item.mst_class }" />
			</td>
			<td>
				<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
			</td>
			<td style="text-align:left;">
				<a href="./form.do?sKey=mid&arc_thm_id=${item.arc_thm_id }&mst_class=${item.mst_class }">
					${item.mst_title }
				</a>
			</td>
			<td>
				<a href="./list.do?sKey=back&arc_thm_id=${item.arc_thm_id }&mst_class=${item.mst_class }">
					소분류
					[${item.arc_thm_id }]
					[${item.mst_class }]
				</a>
			</td>
		</tr>
		</c:forEach>
		</tbody>
		</table>

	</c:if>
	<c:if test="${paramMap.sKey eq 'back' }">

		<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:4%" />
			<col style="width:8%" />
			<col />
		</colgroup>
		<thead>
		<tr>
			<th scope="col"><input type="checkbox" name="arc_thm_idsAll" /></th>
			<th scope="col">번호</th>
			<th scope="col">분류</th>
		</tr>
		</thead>
		<tbody>
		<c:if test="${empty list }">
		<tr>
			<td colspan="3">검색된 결과가 없습니다.</td>
		</tr>
		</c:if>

		<c:forEach items="${list }" var="item" varStatus="status">
		<tr>
			<td>
				<input type="checkbox" name="arc_thm_ids" value="${paramMap.arc_thm_id }_${paramMap.mst_class }_${item.dtl_code }" />
			</td>
			<td>
				<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
			</td>
			<td style="text-align:left;">
				<a href="./form.do?sKey=back&arc_thm_id=${item.arc_thm_id }&mst_class=${item.mst_class }&dtl_code=${item.dtl_code }">
					${item.dtl_cde_title }
				</a>
			</td>
		</tr>
		</c:forEach>
		</tbody>
		</table>

	</c:if>
</div>

<div id="pagination"></div>

<div class="btnBox">
	<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
	
	<c:if test="${paramMap.sKey eq 'top' or empty paramMap.sKey }">
		<span class="btn dark fr"><a href="/addservice/archiveCategory/form.do">등록</a></span>
	</c:if>
	<c:if test="${paramMap.sKey eq 'mid' }">
		<span class="btn gray fr" style="margin-left:4px;"><a href="/addservice/archiveCategory/list.do">대분류</a></span>
		<span class="btn dark fr"><a href="/addservice/archiveCategory/form.do?sKey=mid&arc_thm_id=${paramMap.arc_thm_id }">등록</a></span>
	</c:if>
	<c:if test="${paramMap.sKey eq 'back' }">
		<span class="btn gray fr" style="margin-left:4px;"><a href="/addservice/archiveCategory/list.do">대분류</a></span>
		<span class="btn gray fr" style="margin-left:4px;"><a href="/addservice/archiveCategory/list.do?sKey=mid&arc_thm_id=${paramMap.arc_thm_id }">중분류</a></span>
		<span class="btn dark fr"><a href="/addservice/archiveCategory/form.do?sKey=back&arc_thm_id=${paramMap.arc_thm_id }&mst_class=${paramMap.mst_class }">등록</a></span>
	</c:if>
</div>
</form>

</body>
</html>