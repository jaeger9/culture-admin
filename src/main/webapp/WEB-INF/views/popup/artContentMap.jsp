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
	var close_btn		=	frm.find('.close_btn');
	
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
	
	close_btn.click(function () {
		window.close();
		return false;
	});
	
	$('a[data-vvm-seq]').click(function () {
		if (!confirm('가치 정보를 매핑하시겠습니까?')) {
			return false;
		}
		$.post('/popup/artContent/map/form.do', {
			vvm_seq_par		:	$('input[name=vvm_seq]').val()
			,vvi_seq_par	:	$('input[name=vvi_seq]').val()
			,vvm_seq		:	$(this).data().vvmSeq
		}, function (res) {
			if (res.success) {
				alert("매핑이 완료 되었습니다.");
			} else {
				alert("매핑이 실패 되었습니다.");
			}
		}).fail(function () {
			alert("매핑이 실패 되었습니다.");
		}).always(function () {
			if (window.opener) {
				window.opener.location.reload();
			}
			window.close();
		});
		return false;
	});

});
</script>
</head>
<body>
<form name="frm" method="get" action="/popup/artContent/map/form.do" style="padding:20px;">
<fieldset class="searchBox">
	<legend>검색</legend>

	<input type="hidden" name="page_no" value="${paramMap.page_no }" />
	<input type="hidden" name="vvm_seq" value="${paramMap.vvm_seq }" />
	<input type="hidden" name="vvi_seq" value="${paramMap.vvi_seq }" />

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
				<select name="search_type">
					<option value="all">전체</option>
					<option value="title"		${paramMap.search_type eq 'title'		? 'selected="selected"' : '' }>제목</option>
					<option value="content"		${paramMap.search_type eq 'content'		? 'selected="selected"' : '' }>내용</option>
					<option value="keyword"		${paramMap.search_type eq 'keyword'		? 'selected="selected"' : '' }>키워드</option>
				</select>

				<input type="text" name="search_word" value="${paramMap.search_word }" />

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
</div>

<!-- table list -->
<div class="tableList">
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:8%" />
			<col style="width:20%" />
			<col />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">번호</th>
				<th scope="col">구분</th>
				<th scope="col">작품/자료명</th>
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
					<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
				</td>
				<td>
					${item.ccm_name }
				</td>
				<td class="subject">
					<a href="#" data-vvm-seq="${item.vvm_seq }">${item.vvm_title }</a>
				</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<div id="pagination"></div>

<div class="btnBox">
	<span class="btn dark fr"><a href="#" class="close_btn">닫기</a></span>
</div>
</form>

</body>
</html>