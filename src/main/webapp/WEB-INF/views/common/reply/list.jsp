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
	/* var creators = frm.find('input[name=creators]');
	var approval = frm.find('input[name=approval]');
	var reg_date_start = frm.find('inpput[name=reg_date_start]');
	var reg_date_end = frm.find('inpput[name=reg_date_end]');
	var insert_date_start = frm.find('inpput[name=insert_date_start]');
	var insert_date_end = frm.find('inpput[name=insert_date_end]');
	var search_type = frm.find('select[name=search_type]');
	var search_word = frm.find('inpput[name=search_word]'); */

	//layout
	
	//paging
	var p = new Pagination({
		view		:	'#pagination',
		page_count	:	'${count }',
		page_no		:	'${paramMap.page_no }',
		/* link		:	'/main/code/list.do?page_no=__id__', */
		callback	:	function(pageIndex, e) {
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});
	
	
	search = function() { 
		frm.submit();
	}
	
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" method="get" action="/common/reply/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no}"/>
		<input type="hidden" name="seq" value="${paramMap.seq}"/>
		<input type="hidden" name="rUrl" value="${paramMap.rUrl}"/>
		<input type="hidden" name="menu_cd" value="${paramMap.menu_cd}"/>
		
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="댓글 검색">
					<caption>댓글 검색</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">제목</th>
							<td colspan="3">
								${rdfView.title }
							</td>
						</tr> 
					</tbody>
				</table>
			</div>
		</fieldset>
	
		<!-- 건수  -->
		<div class="topBehavior">
			<p class="totalCnt">총 <span>${count}</span>건</p>
			<ul class="sortingList">
				<li class="on"><a href="#url">최신순</a></li>
				<li><a href="#url">조회순</a></li>
			</ul>
		</div>
		<!-- 리스트 -->
		<div class="tableList">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col style="width:10%" />
					<col style="width:10%" />
					<col style="width:%" />
					<col style="width:10%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">작성자</th>
						<th scope="col">내용</th>
						<th scope="col">등록일</th>
					</tr>
				</thead>
				<tbody>
				<c:if test="${empty list }">
					<tr>
						<td colspan="4">검색된 결과가 없습니다.</td>
					</tr>
				</c:if>
					<c:if test="${not empty list }">
							<c:forEach items="${list }" var="item" varStatus="status">
								<c:set var="num" value="${count-(paramMap.list_unit*(paramMap.page_no-1))-status.index}" />
								<tr>
									<td>${num}</td>
									<td>${item.user_id}</td>
									<td><c:out value="${item.content}" ></c:out> </td>
									<td>${item.reg_date}</td>
								</tr>
							</c:forEach>
					</c:if>
				</tbody>
			</table>
		</div>
	</form>
	<div id="pagination">
	</div>
	<div class="btnBox">
		<!-- 왜 있는 거냐?? -->
		<span class="btn dark fr"><a href="${paramMap.rUrl}">목록</a></span>
	</div>
</body>
</html>