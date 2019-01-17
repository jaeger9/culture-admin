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
	var join_date_start	=	frm.find('input[name=join_date_start]');
	var join_date_end	=	frm.find('input[name=join_date_end]');
	var search_type		=	frm.find('select[name=search_type]');
	var search_word		=	frm.find('input[name=search_word]');
	var search_btn		=	frm.find('button[name=search_btn]');
	var grp_cer_flag	=	frm.find('select[name=grp_cer_flag]');

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

	new Datepicker(join_date_start, join_date_end);

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


function excelDown() {
	$('form[name=frm]').attr('action', 'letterExcel.do').submit();
}
function excelDown2() {
	$('form[name=frm]').attr('action', 'memberExcel.do').submit();
}
</script>
</head>
<body>

<form name="frm" method="get" action="/member/portal/list.do">
<fieldset class="searchBox">
	<legend>검색</legend>
	
	<input type="hidden" name="page_no" value="${paramMap.page_no }" />
	
	
	<div class="tableWrite">
		<table summary="게시판 글 검색">
			<caption>게시판 글 검색</caption>
			<colgroup>
				<col style="width:20%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">가입일</th>
					<td>
						<input type="text" name="join_date_start" value="${paramMap.join_date_start }" />
						<span>~</span>
						<input type="text" name="join_date_end" value="${paramMap.join_date_end }" />
					</td>
				</tr>
				<%-- <tr>
					<th scope="row">그래픽인증서비스<br/>가입여부</th>
					<td>
						<select name="grp_cer_check">
							<option value="all">전체</option>
							<option value="Y"	${paramMap.grp_cer_check eq 'Y'	? 'selected="selected"' : ''}>Y</option>
							<option value="N"	${paramMap.grp_cer_check eq 'N'	? 'selected="selected"' : ''}>N</option>
						</select>
					</td>
				</tr> --%>
				<tr>
					<th scope="row">2단계 인증<br/>사용여부</th>
					<td>
						<select name="sec_cer_check">
							<option value="all">전체</option>
							<option value="Y"	${paramMap.sec_cer_check eq 'Y'	? 'selected="selected"' : ''}>Y</option>
							<option value="N"	${paramMap.sec_cer_check eq 'N'	? 'selected="selected"' : ''}>N</option>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">검색어</th>
					<td>
						<select name="search_type">
							<option value="all">전체</option>
							<option value="user_id"	${paramMap.search_type eq 'user_id'	? 'selected="selected"' : '' }>아이디</option>
							<option value="name"	${paramMap.search_type eq 'name'	? 'selected="selected"' : '' }>이름</option>
							<option value="email"	${paramMap.search_type eq 'email'	? 'selected="selected"' : '' }>이메일</option>
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
			<col style="width:8%" />
			<col style="width:15%" />
			<col style="width:15%" />
			<col />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:12%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">번호</th>
				<th scope="col">아이디</th>
				<th scope="col">이름</th>
				<th scope="col">이메일</th>
				<th scope="col">포인트</th>
				<th scope="col">가입구분</th>
				<th scope="col">가입일</th>
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
					<a href="/member/portal/form.do?user_id=${item.user_id }&qs=${paramMap.qs }">
						${item.user_id }
					</a>
				</td>
				<td>
					<a href="/member/portal/form.do?user_id=${item.user_id }&qs=${paramMap.qs }">
						${item.name }
					</a>
				</td>
				<td class="subject">
					<a href="/member/portal/form.do?user_id=${item.user_id }&qs=${paramMap.qs }">
						${item.email }
					</a>
				</td>
				<td>
					<fmt:formatNumber value="${item.point }" pattern="###,###" />P
				</td>
				<td>
					<c:out value="${item.join_category_name }" default="-" />
				</td>
				<td>
					<c:out value="${item.join_date }" default="-" />
				</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<div id="pagination"></div>

<div class="btnBox textRight">
	<span class="btn dark"><a href="/member/portal/sendMail.do">안내메일 발송</a></span>
	<span class="btn dark"><a href="#url" onclick="excelDown(); return false;">웹진수신회원 다운로드</a></span>
	<span class="btn dark"><a href="#url" onclick="excelDown2(); return false;">회원정보 다운로드</a></span>
</div>
</form>

</body>
</html>