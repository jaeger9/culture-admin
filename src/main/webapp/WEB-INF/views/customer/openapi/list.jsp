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
	var page_no				=	frm.find('input[name=page_no]');
	var category			=	frm.find('select[name=category]');
	var create_date_start	=	frm.find('input[name=create_date_start]');
	var create_date_end		=	frm.find('input[name=create_date_end]');
	var search_word			=	frm.find('input[name=search_word]');
	var search_btn			=	frm.find('button[name=search_btn]');
	
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

	new Datepicker(create_date_start, create_date_end);
	new Checkbox('input[name=idsAll]', 'input[name=ids]');

	search_word.keypress(function(event) {
		if (event.which == 13) {
			event.preventDefault();
			page_no.val(1);
			search();
		}
	});

	search_btn.click(function () {
		page_no.val(1);
		search();
		return false;
	});

	$('.delete_btn').click(function () {

		var ids = $('input[name=ids]:checked');

		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		if (ids.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}

		var param = {};

		if (ids.size() > 0) {
			param.ids = [];
			
			$('input[name=ids]:checked').each(function () {
				param.ids.push( $(this).val() );
			});
		}

		$.ajax({
			url			:	'/customer/openapi/delete.do'
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

<form name="frm" method="get" action="/customer/openapi/list.do">
<fieldset class="searchBox">
	<legend>검색</legend>
	
	<input type="hidden" name="page_no" value="${paramMap.page_no }" />
	
	<div class="tableWrite">
		<table summary="게시판 글 검색">
			<caption>게시판 글 검색</caption>
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">구분</th>
					<td>
						<select name="category">
							<option value="">전체</option>
<c:forEach items="${categoryList }" var="j">
							<option value="${j }" ${paramMap.category eq j ? 'selected="selected"' : '' }>${j }</option>
</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">등록일</th>
					<td>
						<input type="text" name="create_date_start" value="${paramMap.create_date_start }" />
						<span>~</span>
						<input type="text" name="create_date_end" value="${paramMap.create_date_end }" />
					</td>
				</tr>
				<tr>
					<th scope="row">검색어</th>
					<td>
						<input type="text" name="search_word" value="${paramMap.search_word }" style="width:470px;" />

						<span class="btn darkS">
							<button type="button" name="search_btn">검색</button>
						</span>
					</td>
				</tr> 
			</tbody>
		</table>
	</div>
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
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:4%" />
			<col style="width:8%" />
			<col style="width:18%" />
			<col />
			<col style="width:12%" />
			<col style="width:15%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="idsAll" /></th>
				<th scope="col">번호</th>
				<th scope="col">분야</th>
				<th scope="col">기관명</th>
				<th scope="col">등록일</th>
				<th scope="col">오퍼레이션 갯수</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
			<tr>
				<td colspan="6">검색된 결과가 없습니다.</td>
			</tr>
			</c:if>

			<c:forEach items="${list }" var="item" varStatus="status">
			<tr>
				<td>
					<input type="checkbox" name="ids" value="${item.id }" />
				</td>
				<td>
					<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
				</td>
				<td>
					${item.category }
				</td>
				<td class="subject">
					<a href="/customer/openapi/form.do?id=${item.id }&qs=${paramMap.qs }">
						${item.name }
					</a>
				</td>
				<td>
					${item.create_date }
				</td>
				<td>
					<a href="/customer/openapi/operation.do?openapi_id=${item.id }&qs=${paramMap.qs }">
						<fmt:formatNumber value="${item.operation_cnt }" pattern="###,###" />
					</a>
				</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<div id="pagination"></div>

<div class="btnBox">
	<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
	<span class="btn dark fr"><a href="/customer/openapi/form.do?qs=${paramMap.qs }">등록</a></span>
</div>
</form>

</body>
</html>