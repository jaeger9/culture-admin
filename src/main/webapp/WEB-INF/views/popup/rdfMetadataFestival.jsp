<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

	var frm = $('form[name=frm]');
	var page_no = frm.find('input[name=page_no]');
	var search_word = frm.find('input[name=search_word]');
	var search_btn = frm.find('button[name=search_btn]');
	var close_btn = frm.find('.close_btn');
	
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

	$('.tableList #tableId a').click(function () {
		var data = $(this).parent().parent().data();

		if (window.opener && window.opener.callback && window.opener.callback.rdfMetadata) {
			window.opener.callback.rdfMetadata( data );
		}
		
		window.close();
		return false;
	});

});
</script>
</head>
<body>

<form name="frm" method="get" action="/popup/rdfMetadataFestival.do" style="padding:20px;">
<fieldset class="searchBox">
	<legend>검색</legend>
	
	<input type="hidden" name="page_no" value="${paramMap.page_no }" />
	
	<div class="tableWrite">
		<table summary="게시판 글 검색">
			<caption>게시판 글 검색</caption>
			<colgroup>
				<col style="width:17%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">검색</th>
					<td>
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
	<ul class="tab">
		<li>
			<a href="/popup/rdfMetadataFestival.do" class="focus">축제</a>
		</li>
		<li>
			<a href="/popup/rdfMetadataEvent.do">행사</a>
		</li>
	</ul>
	<table summary="게시판 글 목록" id="tableId">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:10%" />
			<col />
			<col style="width:28%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">번호</th>
				<th scope="col">제목</th>
				<th scope="col">기간</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
			<tr>
				<td colspan="4">검색된 결과가 없습니다.</td>
			</tr>
			</c:if>
			<c:forEach items="${list }" var="item" varStatus="status">
			<tr
				data-seq="${item.seq }"
				data-uci="${item.uci }"
				data-type="${item.type }"
				data-title="${fn:escapeXml(item.title) }"
				data-period="${item.period }"
				data-start-dt="${item.start_dt }"
				data-end-dt="${item.end_dt }"
				data-reference-identifier="${item.reference_identifier }"
				data-reference-identifier-org="${item.reference_identifier_org }"
				data-time="${fn:escapeXml(item.time) }"
				data-rights="${item.rights }"
				data-genre="${item.genre }"
				data-location="${item.location }"
				data-venue="${item.venue }"
				data-extent="${item.extent }"
				data-grade="${item.grade }"
				data-url="${item.url}">
				<td>
					<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
				</td>
				<td class="subject">
					<a href="#">
						${item.title }
					</a>
				</td>
				<td>
					${item.period }
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