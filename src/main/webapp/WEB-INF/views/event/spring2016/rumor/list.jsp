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
		var reg_date_start = frm.find('input[name=reg_start]');
		var reg_date_end = frm.find('input[name=reg_end]');
		
		new Datepicker(reg_date_start, reg_date_end);
		
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
		if('${paramMap.search_event}')$("select[name=search_event]").val('${paramMap.search_event}').attr("selected", "selected");
		if('${paramMap.search_category}')$("select[name=search_category]").val('${paramMap.search_category}').attr("selected", "selected");
		if('${paramMap.search_field}')$("select[name=search_field]").val('${paramMap.search_field}').attr("selected", "selected");
		
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
		
		view = function(seq) { 
			url = 'view.do';
			if(seq) {
				url += '?seq=' + seq;
			}			
			location.href = url;
		}		
		
	});

	function excelDown() {
		$('form[name=frm]').attr('action', 'excelDown.do').submit();
	}

	function winnerPopup() {
		window.open('winnerLotPopup.do', 'winnerLotPopup', 'scrollbars=yes,width=600,height=630');
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
									<option value="">전체</option>
									<option value="name">작성자</option>
									<option value="hp">전화번호</option>
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
					<col style="width:12%" />
					<col />
					<%-- <col style="width:20%" /> --%>
					<col style="width:13%" />
					<col style="width:12%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">이름</th>
						<%-- <th scope="col">내용</th> --%>
						<th scope="col">공유 URL</th>
						<th scope="col">휴대폰</th>
						<th scope="col">등록일</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="item" items="${list }" varStatus="status">
					<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index }"/>
					<tr>
						<td>${num }</td>
						<td>${item.user_nm }</td>
						<%-- <td class="subject">${item.comment_contents }</td> --%>
						<td class="subject" style="word-break:break-all;"><a href="${item.url }" title="${item.url }" target="_blank">${item.url }</a></td>
						<td><c:out value="${item.hp_no }"/></td>
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
		<span class="btn dark fr"><a href="#url" onclick="excelDown(); return false;">엑셀다운로드</a></span>
		<span class="btn dark fr" style="margin-right:4px;"><a href="#url" onclick="winnerPopup();return false;">당첨자 추첨</a></span>
	</div>
	
</body>
</html>
