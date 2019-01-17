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

	//layout
	
	//paging
	var p = new Pagination({
		view		:	'#pagination',
		page_count	:	'${count }',
		page_no		:	'${paramMap.page_no }',
		/* link		:	'/main/code/list.do?page_no=__id__', */
		callback	:	function(pageIndex, e) {
			console.log('pageIndex : ' + pageIndex);
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});
	
	//selectbox
	if('${paramMap.parentId}')$("select[name=parentId]").val('${paramMap.parentId}').attr("selected", "selected");
	
	//검색
	$('button[name=searchButton]').click(function(){
		$('input[name=page_no]').val('1');
		$('form[name=frm]').submit();
	});
	
	search = function() { 
		frm.submit();
	}
	
	//상세
	$('div.tableList table tbody tr').each(function() {
		$(this).click(function(){
    		view($(this).attr("id"));
		});
	});
	
	view = function(id) { 
		url = '/pattern/db/category/view.do';
		if(id)
			url += '?id=' + id;
		
		location.href = url;
	}
	
	//등록 
	$('span.btn.dark.fr').click(function(){
		view();
	});
	
	//submit
	formSubmit = function (url) { 
		frm.attr('action' , url);
		frm.submit();		
	};
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" method="get" action="/pattern/db/category/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="분류체계 검색">
					<caption>분류체계 검색</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">분류선택</th>
							<td colspan="3">
								
								<select name="parentId">
				                    <option value="2">카테고리</option>
				                    <c:forEach items="${categoryList }" var="categoryList" varStatus="status">
				                    	<option value="${categoryList.dcollectionid }">${categoryList.dcollectionname }</option>
				                    </c:forEach>
                				</select>
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
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col style="width:10%" />
					<col style="width:%" />
					<col style="width:10%" />
					<col style="width:15%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">분류명</th>
						<th scope="col">사용여부</th>
						<th scope="col">등록일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index}" />
						<tr id="${item.dcollectionid}">
							<td>${num}</td>
							<td><a href="/pattern/db/category/view.do?id=<c:out value="${item.dcollectionid}"/>" /><c:out value="${item.dcollectionname}" /></a></td>
							<td>${fn:replace(fn:replace(item.dhidden, '참', 'N'), '거짓', 'Y')}</td>
							<td>${item.dcreatedate}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</form>
	<div id="pagination">
	</div>
	<div class="btnBox">
		<span class="btn dark fr"><a href="#url">등록</a></span>
	</div>
</body>
</html>