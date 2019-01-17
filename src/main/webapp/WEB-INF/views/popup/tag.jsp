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
	var select_btn = frm.find('.select_btn');
	
	
	//checkbox
	new Checkbox('input[name=nameAll]', 'input[name=name]');
	
	close_btn.click(function () {
		window.close();
		return false;
	});

	select_btn.click(function() {
		var data = {};
		var names = [];

		$('input[name=name]:checked').each(function(){
		   names.push($(this).val());
		});

		data.names = names.join();
		
		if (window.opener && window.opener.callback && window.opener.callback.tag) {
			window.opener.callback.tag( data );
		} else 
			alert('callback function undefined')
		
		window.close();
		return false;
	});
	
	$('.tableList a').click(function () {
		var data = {};
		var names = [];

		$('input[name=name]:checked').each(function(){
		   names.push($(this).val());
		});

		data.names = names.join();
		
		if (window.opener && window.opener.callback && window.opener.callback.tag) {
			window.opener.callback.tag( data );
		} else 
			alert('callback function undefined')
		
		window.close();
		return false;
	});
	
	
	trim = function(data) {
	    return data.replace(/(^\s*)|(\s*$)/gi, "");
	}
});
</script>
</head>
<body>

<form name="frm" method="get">
<div class="topBehavior">
	<p class="totalCnt">총 <span><fmt:formatNumber value="${count }" pattern="###,###" /></span>건</p>
</div>

<!-- table list -->
<div class="tableList">
	<table summary="기관/단체명 목록">
		<caption>기관/단체명 목록</caption>
		<colgroup>
			<col style="width:50%" />
			<col style="width:50%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="nameAll" title="리스트 전체 선택" /></th>
				<th scope="col">태그명</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
				<tr>
					<td>검색된 게시물이 없습니다.</td>
				</tr>
			</c:if>
			<c:forEach items="${list }" var="item" varStatus="status">
				<tr>
					<td><input type="checkbox" name="name" value="${item.name}"/></td>
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

<!-- <div id="pagination"></div> -->

<div class="btnBox">
	<span class="btn white"><a href="#" class="select_btn">선택</a></span>
	<span class="btn dark fr"><a href="#" class="close_btn">닫기</a></span>
</div>
</form>

</body>
</html>