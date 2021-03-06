<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

	$(function() {
		
		var frm = $('form[name=frm]');
		var page_no = frm.find('input[name=page_no]');
			
		//paging
		var p = new Pagination({
			view		:	'#pagination',
			page_count	:	'${count }',
			page_no		:	'${paramMap.page_no }',
			/* link		:	'/main/code/list.do?page_no=__id__', */
			callback	:	function(pageIndex, e) {
				//console.log('pageIndex : ' + pageIndex);
				page_no.val(pageIndex + 1);
				search();
				return false;
			}
		});
		
		//검색
		$('button[name=searchButton]').click(function(){
			$('form[name=frm]').attr('action', 'commentEntry.do');
			$('input[name=page_no]').val('1');
			$('form[name=frm]').submit();
		});
		
		search = function() {
			$('form[name=frm]').attr('action', 'commentEntry.do').submit();
			frm.submit();
		}
		
		var reg_start	=	frm.find('input[name=reg_start]');
		var reg_end		=	frm.find('input[name=reg_end]');
		new Datepicker(reg_start, reg_end);
		
	});

	function excelDown() {
		$('form[name=frm]').attr('action', 'commentExcelDown.do').submit();
	}
	
	function winnerPopup() {
		window.open('commentWinnerPopup.do', 'winnerPopup', 'scrollbars=yes,width=600,height=630');
	}
</script>
</head>
<body>

	<!-- 검색 필드 -->
	<form name="frm" method="get" action="commentEntry.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
					<colgroup>
						<col style="width:20%" />
						<col />
					<tbody>
						<tr>
							<th scope="row">등록일</th>
							<td>
								<input type="text" name="reg_start" value="${paramMap.reg_start }" />
								<span>~</span>
								<input type="text" name="reg_end" value="${paramMap.reg_end }" />
							</td>
						</tr>
						<tr>
							<th scope="row">검색어</th>
							<td>
								<select name="search_field">
									<option value="" <c:if test="${empty paramMap.search_field}">selected</c:if>>전체</option>
									<option value="name" <c:if test="${paramMap.search_field eq 'name'}">selected</c:if>>성명</option>
									<option value="hp" <c:if test="${paramMap.search_field eq 'hp'}">selected</c:if>>휴대폰 번호</option>
								</select>
								<input type="text" name="search_keyword" title="검색어 입력" value="${paramMap.search_keyword}"/>
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
					<col style="width:8%" />
					<col style="width:10%" />
					<col />
					<col />
					<col style="width:15%" />
					<col style="width:10%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">성명</th>
						<th scope="col">공유 URL</th>
						<th scope="col">응원글</th>
						<th scope="col">휴대폰 번호</th>
						<th scope="col">등록일</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="item" items="${list }" varStatus="status">
					<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index }"/>
					
					<tr>
						<td>${num }</td>
						<td>${item.user_nm}</a></td>
						<td style="text-overflow: ellipsis;  white-space: nowrap; overflow: hidden;"><a href="${item.url }" target="_blank">${item.url }</a></td>
						<td style="text-overflow: ellipsis;  white-space: nowrap; overflow: hidden;">${item.summary }</td>
						<td>${item.hp_no }</td>
						<td><c:out value="${item.reg_date }"/></td>
						
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
	</form>
	<div id="pagination">
	</div>
	<div class="btnBox">
		<span class="btn dark fr" style="margin-right:4px;"><a href="#url" onclick="winnerPopup();return false;">당첨자 추첨</a></span>
		<span class="btn dark fr" style="margin-right:4px;"><a href="#url" onclick="excelDown(); return false;">엑셀다운로드</a></span>
	</div>
	
</body>
</html>
