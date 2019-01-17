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
		
		//checkbox
		new Checkbox('input[name=seqAll]', 'input[name=seq]');
		
		//selectbox
		if('${paramMap.search_event}')$("select[name=search_event]").val('${paramMap.search_event}').attr("selected", "selected");
		if('${paramMap.search_reply}')$("select[name=search_reply]").val('${paramMap.search_reply}').attr("selected", "selected");
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
		$('span.btn.dark.fr').click(function(){
			view();
		});
		
		view = function(seq) { 
			url = 'view.do';
			if(seq) {
				url += '?seq=' + seq;
			}			
			location.href = url;
		}
		
		//승인 , 미승인 , 삭제 이벤트 
		$('span > button').each(function() {
			$(this).click(function() { 
				if($(this).html() == '삭제') {
					if (!confirm('삭제 하시겠습니까?')) {
						return false;
					}
					deleteSites();
				} else if($(this).html() == '승인') {
					if (!confirm('승인 처리 하시겠습니까?')) {
						return false;
					}
					$('input[name=updateStatus]').val('Y');
					updateStatus();
				} else if($(this).html() == '미승인') {
					if (!confirm('미승인 처리 하시겠습니까?')) {
						return false;
					}
					$('input[name=updateStatus]').val('N');
					updateStatus();
				}
			});
		});		
		
		//승인 , 미승인
		updateStatus = function () {
			
			if(getCheckBoxCheckCnt() == 0) {
				if($('input[name=updateStatus]').val() == 'N')
					alert('미승인할 코드를 선택하세요');
				if($('input[name=updateStatus]').val() == 'Y')
					alert('승인할 코드를 선택하세요');
				return false;
			}
			
			formSubmit('statusUpdate.do');
		}
		
		//삭제
		deleteSites = function () {
			if(getCheckBoxCheckCnt() == 0) {
				alert('삭제할 소식를 선택하세요');
				return false;
			}		
			formSubmit('delete.do');
		}
		
		//체크 박스 count 수 
		getCheckBoxCheckCnt = function() { 
			return $('input[name=seq]:checked').length;
		};
		
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
							<th scope="row">구분</th>
							<td>
								<select title="구분 선택" name="search_event">
									<option value="">전체</option>
									<c:forEach var="item" items="${eventList }">
										<option value="${item.seq }">${item.title }</option>
									</c:forEach>
								</select>
								<select title="카테고리 선택" name="search_reply">
									<option value="">전체</option>
									<option value="N">답변대기</option>
									<option value="Y">답변완료</option>
								</select>
							</td>
						</tr>
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
									<option value="title">제목</option>
									<option value="all">제목+내용</option>
									<option value="nm">작성자</option>
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
					<col style="width:5%" />
					<col style="width:8%" />
					<col style="width:12%" />
					<col />
					<col style="width:10%" />
					<col style="width:12%" />
					<col style="width:8%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
						<th scope="col">번호</th>
						<th scope="col">구분</th>
						<th scope="col">제목</th>
						<th scope="col">작성자</th>
						<th scope="col">등록일</th>
						<th scope="col">답변여부</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="item" items="${list }" varStatus="status">
					<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index }"/>
					<c:choose>
						<c:when test="${item.reply_yn eq 'Y' }"><c:set var="reply_nm" value="답변완료"/></c:when>
						<c:otherwise><c:set var="reply_nm" value="답변대기"/></c:otherwise>
					</c:choose>
					<tr>
						<td><input type="checkbox" name="seq" value="${item.seq }"/></td>
						<td>${num }</td>
						<td>${item.event_nm }</td>
						<td class="subject">
							<a href="view.do?seq=${item.seq }"><c:out value="${item.title }"/></a>
							<c:if test="${item.new_yn eq 'Y' }"><img src="/images/icon/icon_new.png" style="width:9px;height:10px;" alt="새글" /></c:if>
							<c:if test="${item.open_yn eq 'N' }"><img src="/images/icon/icon_locked.png" style="width:10px;height:13px;" alt="비밀글" /></c:if>
						</td>
						<td><c:out value="${item.user_nm }"/></td>
						<td><c:out value="${item.reg_date }"/></td>
						<td><c:out value="${reply_nm }"/></td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
	</form>
	<div id="pagination">
	</div>
	<div class="btnBox">
		<span class="btn white"><button type="button">삭제</button></span>
	</div>
	
</body>
</html>