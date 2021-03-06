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
	<input type="hidden" name="type2" value="${paramMap.type2 }" />
	<input type="hidden" name="subType" value="${paramMap.subType }" />
	
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
						<c:choose>
							<c:when test="${paramMap.subType eq 1}">
								<input type="hidden" name="searchGubun" value="all" />
								<input type="text" name="keyword" value="${paramMap.searchKeyword }" />
							</c:when>
							<c:otherwise>
								<input type="text" name="searchKeyword" value="${paramMap.searchKeyword }" />
							</c:otherwise>
						</c:choose>
						
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
				</tr>
				<tr id="trData${status.index}" style="display:none;">
					<td>
						<input type="hidden" id="seq${status.index}" name="seq"	value="${item.seq }" />
						<input type="hidden" id="title${status.index}" name="title"	value="${item.title }" />
						<c:choose>
							<c:when test="${paramMap.subType eq '0'}">
								<input type="hidden" id="url${status.index}" name="url" value="${item.url}" />
							</c:when>
							<c:when test="${paramMap.subType eq '1'}">
								<input type="hidden" id="url${status.index}" name="url" value="/edu/educationView.do?seq=${item.seq}" />
							</c:when>
							<c:otherwise>
								<input type="hidden" id="url${status.index}" name="url" value="${item.url}" />
							</c:otherwise>
						</c:choose>
						<input type="hidden" id="uci${status.index}" name="uci" value="${item.uci}" />
						<input type="hidden" id="reg_date${status.index}" name="reg_date" value="${item.reg-date}" />
						<input type="hidden" id="rights${status.index}" name="rights" value="${item.rights}" />
						<input type="hidden" id="period${status.index}" name="period" value="${item.period}" />
						<input type="hidden" id="image${status.index}" name="image" value="${item.reference_identifier }" />
						<input type="hidden" id="cont_date${status.index}" name="cont_date" value="${item.cont_date }" />
						<input type="hidden" id="apply_date${status.index }" name="apply_date" value="${item.apply_date }" />
						
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