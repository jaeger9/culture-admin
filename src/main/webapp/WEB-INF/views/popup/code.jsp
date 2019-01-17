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
	var search_btn = frm.find('button[name=search_btn]');
	var search_word = frm.find('input[name=name]');
	
	var close_btn = frm.find('.close_btn');
	
	var search = function () {
		frm.submit();
	};
	
	/* new Pagination({
		view		:	'#pagination',
		page_count	:	'${count }',
		page_no		:	'${paramMap.page_no }',
		callback	:	function(pageIndex, e) {
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	}); */

	if('${paramMap.common_code_type}')$("select[name=common_code_type]").val('${paramMap.common_code_type}').attr("selected", "selected");
	if('${paramMap.common_code_pcode}')$("select[name=common_code_pcode]").val('${paramMap.common_code_pcode}').attr("selected", "selected");
	
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

	$('.tableList a').click(function () {
		var data = $(this).parent().parent().data();

		if (window.opener && window.opener.callback && window.opener.callback.code) {
			window.opener.callback.code( data );
		} else 
			alert('callback function undefined')
		
		window.close();
		return false;
	});
	
	
	trim = function(data) {
	    return data.replace(/(^\s*)|(\s*$)/gi, "");
	}
/* 	String.prototype.trim = function() {
	    return this.replace(/(^\s*)|(\s*$)/gi, "");
	} */
});
</script>
</head>
<body>

<form name="frm" method="get" action="/popup/code.do" style="padding:20px;">
<fieldset class="searchBox">
	<legend>검색</legend>
	
	<input type="hidden" name="page_no" value="${paramMap.page_no }" />
	
	<div class="tableWrite">
		<table summary="게시판 글 검색">
			<caption>공연장 검색</caption>
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">코드 타입</th>
					<td>
						<select name="common_code_type">
							<option value="">전체</option>
							<c:forEach items="${codeTypeList}" var="codeTypeList" varStatus="status">
								<option value="${codeTypeList.type}">${codeTypeList.name}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">부모 코드 값</th>
					<td>
						<select name="common_code_pcode">
							<option value="">전체</option>
							<c:forEach items="${parentCodeList}" var="parentCodeList" varStatus="status">
								<option value="${parentCodeList.code}">${parentCodeList.name}</option>
							</c:forEach>
						</select>
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
	<table summary="기관/단체명 목록">
		<caption>기관/단체명 목록</caption>
		<colgroup>
			<col style="width:25%" />
			<col style="width:25%" />
			<col style="width:25%" />
			<col style="width:25%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">코드</th>
				<th scope="col">코드명</th>
				<th scope="col">값</th>
				<th scope="col">타입</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
				<tr>
					<td>검색된 게시물이 없습니다.</td>
				</tr>
			</c:if>
			<c:forEach items="${list }" var="item" varStatus="status">
				<tr
					data-seq="${item.seq}"
					data-name="${item.name}"
					data-value="${item.value}"
					data-type="${item.type}"
				>
					<td>
						<a href="#">
							<c:out value="${item.code}"/>
						</a>
					</td>
					<td>
						<a href="#">
							<c:out value="${item.name}"/>
						</a>
					</td>
					<td>
						<a href="#">
							<c:out value="${item.value}"/>
						</a>
					</td>
					<td>
						<a href="#">
							<c:out value="${item.type}"/>
						</a>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<!-- <div id="pagination"></div> -->

<div class="btnBox">
	<span class="btn dark fr"><a href="#" class="close_btn">닫기</a></span>
</div>
</form>

</body>
</html>