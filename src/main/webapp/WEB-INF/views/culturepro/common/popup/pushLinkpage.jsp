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
	
	
	//paging
	var p = new Pagination({
		view		:	'#pagination',
		page_count	:	'${count }',
		page_no		:	'${paramMap.page_no }',
		callback	:	function(pageIndex, e) {
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});

	//검색
	$('button[name=searchButton]').click(function(){
		$('input[name=page_no]').val('1');
		$('form[name=frm]').submit();
	});
	
	search = function() { 
		frm.submit();
	}
	
});

//해당하는 내부 링크 선택 
function selectLink(value, title) {
	if (window.opener && window.opener.callback && window.opener.callback.setInLink) {
		window.opener.callback.setInLink(value, title);
	}else{
		alert('callback function undefined');
	}
	window.close();
		return false;
}
</script>
</head>
<body>

	<form name="frm" method="get" action="/popup/archive/content/form.do">
	<!-- 검색 필드 -->
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="PUSH 검색">
					<caption>PUSH 검색</caption>
					<colgroup>
						<col style="width:13%" />
						<col style="width:%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">제목</th>
							<td>
								<input type="text" name="keyword" title="검색어 입력" value="${paramMap.keyword}"/>
								<span class="btn darkS">
									<button name="searchButton" type="button">검색</button>
								</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</fieldset>
	
		<!-- 건수  -->
		<div class="topBehavior">
			<p class="totalCnt">총 <span>${count}</span>건</p>
		</div>
		<!-- 리스트 -->
		<div class="tableList">
			<table summary="Push 관리 목록">
				<caption>Push 관리</caption>
				<colgroup>
					<col style="width:5%" />
					<col style="width:10%" />
					<col />
				</colgroup>
				<thead>
				<tr>
					<th scope="col">NO</th>
					<th scope="col">분류</th>
					<th scope="col">제목</th>
				</tr>
				</thead>
				<tbody>
					<c:forEach items="${list}" var="item" varStatus="status">
						<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index}" />
						<tr>
							<td>${num}</td>
							<td>${item.menu_nm}</td>
							<td class="subject">
								<a href="javascript:selectLink('${item.gubun_key}','${item.title}')">
									<c:out value="${item.title}"/>
								</a>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</form>
	<div id="pagination">
	</div>

</body>
</html>