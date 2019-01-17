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
		
		//selectbox
		if('${paramMap.order}')$("select[name=order]").val('${paramMap.order}').attr("selected", "selected");
		if('${paramMap.contentsGroup}')$("select[name=contentsGroup]").val('${paramMap.contentsGroup}').attr("selected", "selected");
		
		//검색
		$('button[name=searchButton]').click(function(){
			$('input[name=page_no]').val('1');
			$('form[name=frm]').submit();
		});
		
		search = function() { 
			frm.submit();
		}
		
		//등록 & 상세
		/*$('span.btn.dark.fr').click(function(){
			view();
		});*/
		
	});

	function excelDown() {
		$('form[name=frm]').attr('action', 'excelDown.do').submit();
	}
		
</script>
</head>
<body>

	<!-- 검색 필드 -->
	<form name="frm" method="get" action="list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/>
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
							<th scope="row">콘텐츠 정렬</th>
							<td>
								<select name="order">
									<option value="DESC">내림차순</option>
									<option value="ASC">오름차순</option>
								</select>

							</td>
						</tr>
						<tr>
							<th scope="row">콘텐츠 구분</th>
							<td>
								<select name="contentsGroup">
									<option value="">전체</option>
									<option value="01">방콕형</option>
									<option value="02">먹방형</option>
									<option value="03">방방곡곡형</option>
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
					<col style="width:8%" />
					<col style="width:15%" />
					<col style="width:20%" />
					<col />
					<col style="width:13%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">콘텐츠구분</th>
						<th scope="col">콘텐츠제목</th>
						<th scope="col">콘텐츠URL</th>
						<th scope="col">좋아요횟수</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="item" items="${list }" varStatus="status">
					<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index }"/>
					<tr>
						<td>${num }</td>
						<td>${item.contents_group_nm }</a></td>
						<td>${item.contents_title }</td>
						<td><a href="${item.contents_url }" target="_blank">${item.contents_url }</a></td>
						<td><c:out value="${item.like_cnt }"/></td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
	</form>
	<div id="pagination">
	</div>
	<div class="btnBox">
		<span class="btn dark fr"><a href="#url" onclick="excelDown(); return false;">엑셀다운로드</a></span>
	</div>
	
</body>
</html>
