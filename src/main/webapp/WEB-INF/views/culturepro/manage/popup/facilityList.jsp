<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<style>
	.close-div {position:absolute;overflow:hidden;background:#444;top:610px;width:500px;height:20px;}
	.close-div span {float:right;}
	.close-div span a {color:#fff;font-weight:bold;font-size:14px;}
	.close-div span a:hover {text-decoration:none;}
</style>
<script type="text/javascript">
	$(function () {	
		var frm = $('form[name=frm]');
		var page_no = frm.find('input[name=page_no]');
		var search_btn = frm.find('button[name=search_btn]');
		var search_word = frm.find('input[name=search_word]');
		
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
		
		$('.tableList a').click(function () {
			var data = $(this).parent().parent().data();

			if (window.opener && window.opener.callback && window.opener.callback.facilityConn) {
				window.opener.callback.facilityConn( data );
			} else {
				alert('callback function undefined');
			}

			window.close();
			return false;
		});
	});

</script>
</head>
<body>

<form name="frm" method="get" action="facilityList.do" style="padding:20px;">
<fieldset class="searchBox">
	<legend>검색</legend>
	
	<input type="hidden" name="page_no" value="${paramMap.page_no }" />
	<input type="hidden" name="g_seq" value="${paramMap.g_seq }" />
	
	<div class="tableWrite">
		<table summary="게시판 글 검색">
			<caption>시설 검색</caption>
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">시설명</th>
					<td>
						<input type="text" name="keyword" style="width:200px;" value="${paramMap.keyword }" />
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
	<table summary="문화 이슈 카테고리 목록">
		<caption>문화 이슈 카테고리 목록</caption>
		<colgroup>
			<col width="10%" />
			<col width="40%" />
			<col />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">번호</th>
				<th scope="col">구분</th>
				<th scope="col">시설명</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
				<tr>
					<td colspan="3">검색된 게시물이 없습니다.</td>
				</tr>
			</c:if>
			<c:forEach var="item" items="${list }" varStatus="status">
				<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index }"/>
				<tr 
					data-type_code="${item.type_code}"
					data-facility_name="${item.facility_name}"
					data-gps_lat="${item.gps_lat}"
					data-gps_lng="${item.gps_lng}"
					data-g_seq="${item.g_seq}"
				>
					<td>${num }</td>
					<td><c:out value="${item.type_code_nm}"/></td>
					<td>
						<a href="#"><c:out value="${item.facility_name}" escapeXml="false" /></a></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<div id="pagination"></div>
</form>

<div class="close-div"><span><a href="#">닫기</a></span></div>

</body>
</html>