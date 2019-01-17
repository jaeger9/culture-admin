<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@	taglib prefix="tags" tagdir="/WEB-INF/tags"%>
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
		$('input[name=searchKeyword]').val($('input[name=search_word]').val());
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
});

function onSelect(index){
	var data = new Array();
	
	$('#trData'+index).find('input').each(function(){
		data[$(this).attr("name")] = $(this).val();
		if($(this).attr("name") == 'author_name' || $(this).attr("name") == 'source_name'){
			data['rights'] = (typeof(data['rights']) != "undefined" ? data['rights']+' ':'') + $(this).val();
		}
	});
	
	//data['gbn'] = $('input[name=gbn]').val();
	//data['type'] = $('input[name=type]').val();
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
	<input type="hidden" name="subType" value="${paramMap.subType }" />
	<input type="hidden" name="tab" value="${paramMap.tab}" />
	<input type="hidden" name="searchGubun" value="title" />
	<input type="hidden" name="searchKeyword"/>
	
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
	<ul class="tab" style="display:${paramMap.tab};">
	 	<li>
			<a href="/popup/cultureExp.do?subType=3&type=con" ${paramMap.subType eq '3' ? 'class="focus"':''}>이달의 문화이슈</a>
		</li>
		<li>
			<a href="/popup/cultureExp.do?subType=4&type=con" ${paramMap.subType eq '4' ? 'class="focus"':''}>공감리포트</a>
		</li>
		<li>
			<a href="/popup/cultureExp.do?subType=&type=con" ${empty paramMap.subType or paramMap.subType eq '5' ? 'class="focus"':''}>문화영상</a>
		</li>
		<li>
			<a href="/popup/cultureExp.do?subType=0&type=con" ${paramMap.subType eq '0' ? 'class="focus"':''}>문화TV</a>
		</li>
		<li>
			<a href="/popup/cultureExp.do?subType=1&type=con" ${paramMap.subType eq '1' ? 'class="focus"':''}>문화예보</a>
		</li>
		<li>
			<a href="/popup/cultureExp.do?subType=2&type=con" ${paramMap.subType eq '2' ? 'class="focus"':''}>인문학강연</a>
		</li>
	</ul>
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:10%" />
			<col />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">번호</th>
				<th scope="col">제목</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
			<tr>
				<td colspan="2">검색된 결과가 없습니다.</td>
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
				</tr>
				<tr id="trData${status.index}" style="display:none;">
					<td>
						<input type="hidden" id="idx${status.index}" name="idx"	value="${item.idx }" />
						<input type="hidden" id="title${status.index}" name="title"	value="${fn:replace(item.title,'"','&quot;') }" />
						<input type="hidden" id="source_name${status.index}" name="source_name"	value="${item.source_name}" />
						<input type="hidden" id="author_name${status.index}" name="author_name"	value="${item.author_name}" />
						<c:choose>
							<c:when test="${paramMap.subType eq '3'}">
								<input type="hidden" id="image${status.index}" name="image" value="/upload/issue/${item.img_url }" />
								<input type="hidden" id="thumb_url${status.index}" name="thumb_url" value="/upload/issue/${item.thumb_url }" />
								<input type="hidden" id="place${status.index}" name="place"	value="" />
							</c:when>
							<c:when test="${paramMap.subType eq '4'}">
								<input type="hidden" id="image${status.index}" name="image" value="/upload/recom/recom/${item.img_url }" />
								<input type="hidden" id="thumb_url${status.index}" name="thumb_url" value="/upload/recom/recom/${item.thumb_url }" />
								<input type="hidden" id="place${status.index}" name="place"	value="" />
							</c:when>
							<c:when test="${paramMap.subType eq '0'}">
								<input type="hidden" id="image${status.index}" name="image" value="${item.image }" />
								<input type="hidden" id="thumb_url${status.index}" name="thumb_url" value="" />
								<input type="hidden" id="place${status.index}" name="place"	value="${item.area_name} ${item.service_name}" />
							</c:when>
							<c:when test="${paramMap.subType eq '1'}">
								<input type="hidden" id="image${status.index}" name="image" value="${item.image }" />
								<input type="hidden" id="thumb_url${status.index}" name="thumb_url" value="" />
								<input type="hidden" id="place${status.index}" name="place"	value="${item.area_name} ${item.service_name}" />
							</c:when>
							<c:when test="${paramMap.subType eq '2'}">
								<input type="hidden" id="image${status.index}" name="image" value="${item.image }" />
								<input type="hidden" id="thumb_url${status.index}" name="thumb_url" value="" />
								<input type="hidden" id="place${status.index}" name="place"	value="${item.area_name} ${item.service_name}" />
							</c:when>
							<c:otherwise>
								<input type="hidden" id="image${status.index}" name="image" value="${item.image }" />
								<input type="hidden" id="thumb_url${status.index}" name="thumb_url" value="" />
								<input type="hidden" id="place${status.index}" name="place"	value="${item.area_name} ${item.service_name}" />
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${paramMap.subType eq '3'}">
								<input type="hidden" id="url${status.index}" name="url" value="/cultureissue/issueView.do?seq=${item.seq }" />
							</c:when>
							<c:when test="${paramMap.subType eq '4'}">
								<input type="hidden" id="url${status.index}" name="url" value="/culture/themeView.do?seq=${item.seq }" />
							</c:when>
							<c:when test="${paramMap.subType eq '0'}">
								<input type="hidden" id="url${status.index}" name="url" value="/mov/tvReviewList.do" />
							</c:when>
							<c:when test="${paramMap.subType eq '1'}">
								<input type="hidden" id="url${status.index}" name="url" value="/mov/forecastView.do?idx=${item.idx}" />
							</c:when>
							<c:when test="${paramMap.subType eq '2'}">
								<input type="hidden" id="url${status.index}" name="url" value="/mov/humanLectureList.do" />
							</c:when>
							<c:otherwise>
								<input type="hidden" id="url${status.index}" name="url" value="${item.url }" />
							</c:otherwise>
						</c:choose>
						<c:set var="summaryText"><tags:out text='${item.summary}' defaultValue='-' byteLength='1000' ellipsis='...' removeXml='true' escapeXml='true'/></c:set>
						<input type="hidden" id="summary${status.index}" name="summary" value="${summaryText}" />
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>
</form>

<div id="pagination"></div>

<div class="btnBox">
	<span class="btn dark fr"><a href="#" class="close_btn">닫기</a></span>
</div>

</body>
</html>