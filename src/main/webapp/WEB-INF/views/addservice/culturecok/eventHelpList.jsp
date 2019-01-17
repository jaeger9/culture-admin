<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {
	
	var frm				=	$('form[name=frm]');
	var page_no			=	frm.find('input[name=page_no]');
	var search_word		=	frm.find('input[name=search_word]');
	var search_btn		=	frm.find('button[name=search_btn]');
	
	var search = function () {
		$('form[name=frm]').attr('action', 'eventHelpList.do');
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
	
});


function excelDownload(){
	$('form[name=frm]').attr('action', 'eventHelpExcelDownload.do');
	$('form[name=frm]').submit();
}
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" method="post" action="/addservice/culturecok/eventHelpList.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }" />
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
					<colgroup>
						<col style="width:10%" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">검색</th>
							<td>
								<select name="search_type">
									<option value="all">전체</option>
									<option value="name"		${paramMap.search_type eq 'name'	? 'selected="selected"' : '' }>이름</option>
									<option value="email"		${paramMap.search_type eq 'email'	? 'selected="selected"' : '' }>이메일</option>
								</select>
		
								<input type="text" name="search_word" value="${paramMap.search_word }" style="width:470px;" />
		
								<span class="btn darkS">
									<button type="button" name="search_btn">검색</button>
								</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</fieldset>
	
		<!-- 건수  -->
		<div class="topBehavior">
			<p class="totalCnt">총 <span><fmt:formatNumber value="${count }" pattern="###,###" /></span>건</p>
		</div>
		<!-- 리스트 -->
		<div class="tableList">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col style="width:7%" />
					<col style="width:12%" />
					<col />
					<col style="width:12%"/>
					<col style="width:15%" />
				</colgroup>
				<thead>	
					<tr>
						<th scope="col">번호</th>
						<th scope="col">접수일</th>
						<th scope="col">제목</th>
						<th scope="col">이름</th>
						<th scope="col">상태</th>	
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty list }">
						<tr>
							<td colspan="5">검색된 결과가 없습니다.</td>
						</tr>
					</c:if>
					<c:forEach items="${list }" var="item" varStatus="status">
						<tr>
							<td><fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" /></td>
							<td>${item.reg_date }</td>
							<td style="text-overflow: ellipsis;  white-space: nowrap; overflow: hidden;"><a href="/addservice/culturecok/eventHelpForm.do?seq=${item.seq}">${item.title}</a></td>
							<td>${item.name}</td>
							<td>${item.state}</td>
						</tr>
					</c:forEach>			
				</tbody>
			</table>
		</div>
		
		<div id="pagination"></div>

		<div class="btnBox">
			<span class="btn dark fr" style="margin-right:4px;"><a href="#" onclick="excelDownload();">전체다운로드(리스트)</a></span>
			<span class="btn dark fr" style="margin-right:4px;"><a href="/addservice/culturecok/eventHelpForm.do">등록</a></span>
		</div>
		
	</form>
</body>
</html>