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
	
	var search = function () {
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
	
	close_btn.click(function () {
		window.close();
		return false;
	});

	$('.tableList a').click(function () {
		var data = $(this).parent().parent().data();

		if (window.opener && window.opener.callback && window.opener.callback.education) {
			window.opener.callback.education( data );
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

<form name="frm" method="get" action="/popup/education.do" style="padding:20px;">
<fieldset class="searchBox">
	<legend>검색</legend>
	
	<input type="hidden" name="page_no" value="${paramMap.page_no }" />
	
	<div class="tableWrite">
		<table summary="게시판 글 검색">
			<caption>공연장 검색</caption>
			<colgroup>
				<col style="width:17%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">검색어</th>
					<td colspan="3">
						<select name="searchGubun">
							<option value="all">전체</option>
							<option value="title">제목</option>
							<option value="description">내용</option>
							<option value="creator">작성자</option>
						</select>
						<input <input type="text" name="keyword" title="검색어 입력" value="${paramMap.keyword}"/>
						<span class="btn darkS">
							<button name="search_btn" type="button">검색</button>
						</span>
					</td>
				</tr> 
			</tbody>
		</table>
	</div>
</fieldset>

<div class="topBehavior">
	<p class="totalCnt">총 <span><fmt:formatNumber value="${count }" pattern="###,###" /></span>건</p>
</div>

<!-- table list -->
<div class="tableList">
	<table summary="교육 목록">
		<caption>교육 목록</caption>
		<colgroup>
			<col style="width:12%" />
			<col style="width:%" />
			<col style="width:16%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">번호</th>
                <th scope="col">교육명</th>
				<th scope="col">등록일</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
				<tr>
					<td colspan="3">검색된 게시물이 없습니다.</td>
				</tr>
			</c:if>
			<c:forEach items="${list }" var="item" varStatus="status">
				<tr
					data-seq="${item.seq}"
					data-title="${item.title}"
					data-url="/edu/educationView.do?seq=${item.seq}"
					data-uci="${item.uci}"
					data-reg-date="${item.reg-date}"
					data-rights="${item.rights}"
					data-period="${item.period}"
				>
					<td>
					<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
					</td>
                	<td class="subject">
						<a href="#" name="${item.title}" location="${item.title}">
							<c:out value="${item.title}" default="-" />
						</a>
					</td>
                    <td>
					${item.reg_date}
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<div id="pagination"></div>

<div class="btnBox">
	<span class="btn dark fr"><a href="#" class="close_btn">닫기</a></span>
</div>
</form>

</body>
</html>