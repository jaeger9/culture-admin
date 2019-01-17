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
	
});
</script>
</head>
<body>

<form name="frm" method="get" action="/addservice/artCopyright/list.do">
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
			<col style="width:8%" />
			<col style="width:15%" />
			<col />
			<col style="width:12%" />
			<col style="width:12%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">번호</th>
				<th scope="col">구분</th>
				<th scope="col">작품명</th>
				<th scope="col">등록여부</th>
				<th scope="col">등록일</th>
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
					<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
				</td>
				<td>
					<c:if test="${item.vvm_gubun eq 'K'}">어린이</c:if>
					<c:if test="${item.vvm_gubun eq 'E'}">교육</c:if>
					<c:if test="${item.vvm_gubun eq 'A'}">아카이브</c:if>
					<c:if test="${item.vvm_gubun eq 'C'}">컬쳐</c:if>
				</td>
				<td class="subject">
					<a href="/addservice/artCopyright/form.do?vvm_seq=${item.vvm_seq }&vvm_gubun=${item.vvm_gubun }&qs=${paramMap.qs }">
						${item.vvm_title }
					</a>
				</td>
				<td>
					<c:if test="${item.vvm_copyright eq 'Y'}">
						<c:if test="${item.vvm_copyright eq 'Y'}">등록완료</c:if>
						<c:if test="${item.vvm_copyright eq 'N'}">등록필요</c:if>
					</c:if>
					<c:if test="${item.vvm_copyright eq 'N'}">저작권 대상 없음</c:if>
					<c:if test="${item.vvm_copyright eq 'D'}">소멸</c:if>
					<c:if test="${item.vvm_copyright eq 'O'}">공문대체</c:if>
					<c:if test="${item.vvm_copyright eq 'S'}">자체제작</c:if>
					<c:if test="${item.vvm_copyright eq 'P'}">공개자료</c:if>
				</td>
				<td>
					${item.vvm_reg_date }
				</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<div id="pagination"></div>

<%--
<div class="btnBox">
	<span class="btn white"><a href="#" class="approval_y_btn">승인</a></span>
	<span class="btn white"><a href="#" class="approval_n_btn">미승인</a></span>
	<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
	<span class="btn dark fr"><a href="/addservice/artCopyright/form.do?qs=${paramMap.qs }">등록</a></span>
</div>
--%>
</form>

</body>
</html>