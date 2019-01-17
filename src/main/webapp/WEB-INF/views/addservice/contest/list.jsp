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
	var reg_dt_start	=	frm.find('input[name=reg_dt_start]');
	var reg_dt_end		=	frm.find('input[name=reg_dt_end]');
	var search_type		=	frm.find('select[name=search_type]');
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

	new Datepicker(reg_dt_start, reg_dt_end);

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

<form name="frm" method="get" action="/addservice/contest/list.do">
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
					<th scope="row">서비스</th>
					<td>
						<select name="category">
							<option value="">전체</option>
							<option value="DEV" ${paramMap.category eq 'DEV' ? 'selected="selected"' : '' }>제품개발</option>
							<option value="OFF" ${paramMap.category eq 'OFF' ? 'selected="selected"' : '' }>아이디어기획</option>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">등록일</th>
					<td>
						<input type="text" name="reg_dt_start" value="${paramMap.reg_dt_start }" />
						<span>~</span>
						<input type="text" name="reg_dt_end" value="${paramMap.reg_dt_end }" />
					</td>
				</tr>
				<tr>
					<th scope="row">검색어</th>
					<td>
						<select name="search_type">
							<option value="all">전체</option>
							<option value="name" ${paramMap.search_type eq 'name' ? 'selected="selected"' : '' }>이름</option>
							<option value="title" ${paramMap.search_type eq 'title' ? 'selected="selected"' : '' }>제목</option>
							<option value="description" ${paramMap.search_type eq 'description' ? 'selected="selected"' : '' }>설명</option>
						</select>

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
			<col style="width:5%;" />
			<col style="width:15%;" />
			<col style="width:15%;" />
			<col style="width:15%;" />
			<col />
			<col style="width:10%;" />				
			<col style="width:7%;" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">번호</th>
				<th scope="col">접수번호</th>
				<th scope="col">성명</th>
				<th scope="col">접수분야</th>
				<th scope="col">서비스제목</th>
				<th scope="col">접수일</th>					
				<th scope="col">파일</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
			<tr>
				<td colspan="7">검색된 결과가 없습니다.</td>
			</tr>
			</c:if>

			<c:forEach items="${list }" var="item" varStatus="status">
			<tr>
				<td>
					<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
				</td>
				<td>
					${item.receipt }
				</td>
				<td>
					${item.name }
				</td>
				<td>
					<c:choose>
						<c:when test="${item.category eq 'WEB' }">웹</c:when>
						<c:when test="${item.category eq 'MOB' }">모바일</c:when>
						<c:when test="${item.category eq 'OFF' }">아이디어기획</c:when>
						<c:when test="${item.category eq 'DEV' }">제품개발창업</c:when>
						<c:otherwise>기타</c:otherwise>
					</c:choose>
				</td>
				<td class="subject">
					<a href="/addservice/contest/form.do?seq=${item.seq }&qs=${paramMap.qs }">
						${item.title }
					</a>
				</td>
				<td>
					${item.reg_dt }
				</td>
				<td>
					<c:if test="${not empty item.file_sysname }">
						<c:url var="urlFile" value="http://www.culture.go.kr/download.do">
							<c:param name="filename" value="/contest/${item.file_sysname }" />
							<c:param name="orgname" value="${item.file_orgname }" />
						</c:url>
						<a href="${urlFile }" target="_blank">다운</a>
					</c:if>
					<c:if test="${empty item.file_sysname }">-</c:if>
				</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<div id="pagination"></div>

<div class="btnBox textRight">
	<span class="btn dark"><a href="/addservice/contest/excel.do" target="_blank">엑셀 다운로드</a></span>
</div>
</form>

</body>
</html>