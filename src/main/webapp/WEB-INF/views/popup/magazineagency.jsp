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
	var search_btn = frm.find('button[name=search_btn]');
	var search_word = frm.find('input[name=name]');
	
	var close_btn = frm.find('.close_btn');
	
	var search = function () {
		frm.submit();
	};
	
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

		if (window.opener && window.opener.callback && window.opener.callback.magazineagency) {
			window.opener.callback.magazineagency( data );
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

<form name="frm" method="get" action="/popup/magazineagency.do" style="padding:20px;">
<div class="topBehavior">
	<p class="totalCnt">총 <span><fmt:formatNumber value="${count }" pattern="###,###" /></span>건</p>
</div>

<!-- table list -->
<div class="tableList">
	<table summary="기관/단체명 목록">
		<caption>기관/단체명 목록</caption>
		<colgroup>
			<col style="width:%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">제목</th>
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
					data-org-id="${item.org-id}"
					data-name="${item.name}"
				>
					<td>
						<a href="#">
							<c:out value="${item.name}"/>
						</a>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>
<div class="btnBox">
	<span class="btn dark fr"><a href="#" class="close_btn">닫기</a></span>
</div>
</form>

</body>
</html>