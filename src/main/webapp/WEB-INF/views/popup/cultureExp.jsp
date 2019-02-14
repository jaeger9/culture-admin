<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {
//수정
	var frm = $('form[name=frm]');
	var page_no = frm.find('input[name=page_no]');
	var search_word = frm.find('input[name=search_word]');
	var search_btn = frm.find('button[name=search_btn]');
	var close_btn = frm.find('.close_btn');
	
	var search = function () {
		frm.submit();
	};
	
	var search_date	=	frm.find('input[name=search_date]');
	new Datepicker(search_date);
	
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
});

function onSelect(index){
	var data = new Array();
	
	$('#trData'+index).find('input').each(function(){
		data[$(this).attr("name")] = $(this).val();
	});
	data['gbn'] = $('input[name=gbn]').val();
	data['type'] = $('input[name=type]').val();
	window.opener.setVal(data); 
	
	window.close();
	return false;
}
</script>
</head>
<body>

<form name="frm" method="post" action="/popup/cultureExp.do" style="padding:20px;">
<fieldset class="searchBox">
	<legend>검색</legend>
	
	<input type="hidden" name="page_no" value="${paramMap.page_no }" />
	<input type="hidden" name="gbn" value="${paramMap.gbn }" />
	<input type="hidden" name="type" value="${paramMap.type }" />
	
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
						<!-- 검색어 : 명칭 -->
						<input type="text" name="search_word" value="${paramMap.search_word }" />
						
						<!-- 검색어 : 기간 -->
						<c:if test="${paramMap.gbn == 3}">
							<input type="text" name="search_date" placeholder="공연 시작일 선택" value="${paramMap.search_date }" />
						</c:if>
						
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

<div class="topBehavior">
	<p class="totalCnt">총 <span><fmt:formatNumber value="${count }" pattern="###,###" /></span>건</p>
</div>

<!-- table list -->
<div class="tableList">
	<ul class="tab">
		<li>
			<a href="/popup/cultureExp.do?gbn=1" ${paramMap.gbn == 1 ? 'class="focus"':''}>공연</a>
		</li>
		<li>
			<a href="/popup/cultureExp.do?gbn=2" ${paramMap.gbn == 2 ? 'class="focus"':''}>전시</a>
		</li>
		<li>
			<a href="/popup/cultureExp.do?gbn=3" ${paramMap.gbn == 3 ? 'class="focus"':''}>문화릴레이티켓</a>
		</li>
		<li>
			<a href="/popup/cultureExp.do?gbn=4" ${paramMap.gbn == 4 ? 'class="focus"':''}>할인티켓</a>
		</li>
		<li>
			<a href="/popup/cultureExp.do?gbn=5" ${paramMap.gbn == 5 ? 'class="focus"':''}>행사</a>
		</li>
		<li>
			<a href="/popup/cultureExp.do?gbn=6" ${paramMap.gbn == 6 ? 'class="focus"':''}>축제</a>
		</li>
	</ul>
	<table summary="게시판 글 목록">
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
				<td colspan="3">검색된 결과가 없습니다.</td>
			</tr>
			</c:if>
			<c:forEach items="${list }" var="item" varStatus="status">
				<tr>
					<td>
						<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
					</td>
					<td class="subject">
						<a href="#" onclick="javascript:onSelect('${status.index}');">${item.title }</a>
					</td>
					<td>
						${item.period }
					</td>
				</tr>
				<tr id="trData${status.index}" style="display:none;">
					<td>
						<input type="hidden" id="seq${status.index}" name="seq"	value="${item.seq }" />
						<input type="hidden" id="uci${status.index}" name="uci"	value="${item.uci }" />
						<input type="hidden" id="type${status.index}" name="type"value="${item.type }" />
						<input type="hidden" id="title${status.index}" name="title"	value="${item.title }" />
						<input type="hidden" id="period${status.index}" name="period" value="${item.period }" />
						<input type="hidden" id="start_dt${status.index}" name="start_dt" value="${item.start_dt }" />
						<input type="hidden" id="end_dt${status.index}" name="end_dt" value="${item.end_dt }" />
						<input type="hidden" id="reference_identifier${status.index}" name="reference_identifier"		value="${item.reference_identifier }" />
						<input type="hidden" id="reference_identifier_orgrefere${status.index}" name="reference_identifier_org"	value="${item.reference_identifier_org }" />
						<input type="hidden" id="time${status.index}" name="time" value="${item.time }" />
						<input type="hidden" id="rights${status.index}" name="rights" value="${item.rights }" />
						<input type="hidden" id="genre${status.index}" name="genre"	value="${item.genre }" />
						<input type="hidden" id="location${status.index}" name="location" value="${item.location }" />
						<input type="hidden" id="venue${status.index}" name="venue"	value="${item.venue }" />
						<input type="hidden" id="extent${status.index}" name="extent" value="${item.extent }" />
						<input type="hidden" id="grade${status.index}" name="grade"	value="${item.grade }" />
						<input type="hidden" id="url${status.index}" name="url"	value="${item.url }" />
						<input type="hidden" id="img_url${status.index}" name="img_url"	value="${item.img_url }" />
						<input type="hidden" id="place${status.index}" name="place"	value="${item.place }" />
						<input type="hidden" id="discount${status.index}" name="discount"	value="${item.discount }" />
						<input type="hidden" id="image${status.index}" name="image"	value="${item.image }" />
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

</body>
</html>