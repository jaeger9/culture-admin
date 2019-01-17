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
	var category = frm.find('select[name=category]');
	var status = frm.find('input[name=status]');
	var reg_date_start = frm.find('input[name=reg_date_start]');
	var reg_date_end = frm.find('input[name=reg_date_end]');
	var search_type = frm.find('select[name=search_type]');
	var search_word = frm.find('input[name=search_word]');
	var search_btn = frm.find('button[name=search_btn]');
	
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

	new Datepicker(reg_date_start, reg_date_end);
	new Checkbox('input[name=seqsAll]', 'input[name=seqs]');

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

	// 승인 여부
	var ajaxApproval = function (approval) {
		approval = approval == 'Y' ? 'Y' : 'N';
		var approvalText = approval == 'Y' ? '승인' : '미승인';
		
		var seqs = $('input[name=seqs]:checked');

		if (!confirm(approvalText + ' 처리 하시겠습니까?')) {
			return false;
		}
		if (seqs.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}

		var param = {
			approval : approval
		};

		if (seqs.size() > 0) {
			param.seqs = [];
			
			$('input[name=seqs]:checked').each(function () {
				param.seqs.push( $(this).val() );
			});
		}

		$.ajax({
			url			:	'/customer/qna/approval.do'
			,type		:	'post'
			,data		:	$.param(param, true)
			,dataType	:	'json'
			,success : function( res ) {

				if (res.success) {
					alert(approvalText + " 처리가 완료 되었습니다.");
					location.reload();
				} else {
					alert(approvalText + " 처리가 실패 되었습니다.");
				}
			}
			,error : function(data, status, err) {
				alert(approvalText + " 처리가 실패 되었습니다.");
			}
		});

	};

	$('.approval_y_btn').click(function () {
		ajaxApproval('Y');
		return false;
	});

	$('.approval_n_btn').click(function () {
		ajaxApproval('N');
		return false;
	});

	$('.delete_btn').click(function () {

		var seqs = $('input[name=seqs]:checked');

		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		if (seqs.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}

		var param = {};

		if (seqs.size() > 0) {
			param.seqs = [];
			
			$('input[name=seqs]:checked').each(function () {
				param.seqs.push( $(this).val() );
			});
		}

		$.ajax({
			url			:	'/customer/qna/delete.do'
			,type		:	'post'
			,data		:	$.param(param, true)
			,dataType	:	'json'
			,success	:	function (res) {
				if (res.success) {
					alert("삭제가 완료 되었습니다.");
					location.reload();
				} else {
					alert("삭제 실패 되었습니다.");
				}
			}
			,error : function(data, status, err) {
				alert("삭제 실패 되었습니다.");
			}
		});

		return false;
	});

});
</script>
</head>
<body>

<form name="frm" method="get" action="/customer/qna/list.do">
<fieldset class="searchBox">
	<legend>검색</legend>
	
	<input type="hidden" name="page_no" value="${paramMap.page_no }" />
	
	<div class="tableWrite">
		<table summary="게시판 글 검색">
			<caption>게시판 글 검색</caption>
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">구분</th>
					<td>
						<select name="category">
							<option value="">전체</option>
							<option value="0" <c:if test="${paramMap.category eq '0'}">selected</c:if>>소식</option>
							<option value="1" <c:if test="${paramMap.category eq '1'}">selected</c:if>>행사/교육</option>
							<option value="2" <c:if test="${paramMap.category eq '2'}">selected</c:if>>공연/전시</option>
							<option value="3" <c:if test="${paramMap.category eq '3'}">selected</c:if>>문화동영상</option>
							<option value="4" <c:if test="${paramMap.category eq '4'}">selected</c:if>>문화추천</option>
							<option value="5" <c:if test="${paramMap.category eq '5'}">selected</c:if>>전통디자인</option>
							<option value="6" <c:if test="${paramMap.category eq '6'}">selected</c:if>>이벤트</option>
							<option value="7" <c:if test="${paramMap.category eq '7'}">selected</c:if>>오픈 API</option>
							<option value="8" <c:if test="${paramMap.category eq '8'}">selected</c:if>>기타</option>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td>
						<label><input type="radio" name="status" value="" ${empty paramMap.status ? 'checked="checked"' : '' } /> 전체</label>
						<label><input type="radio" name="status" value="W" ${paramMap.status eq 'W' ? 'checked="checked"' : '' } /> 대기</label>
						<label><input type="radio" name="status" value="Y" ${paramMap.status eq 'Y' ? 'checked="checked"' : '' } /> 승인</label>
						<label><input type="radio" name="status" value="N" ${paramMap.status eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
					</td>
				</tr>
				<tr>
					<th scope="row">답변여부</th>
					<td>
						<label><input type="radio" name="public_yn" value="" ${empty paramMap.public_yn ? 'checked="checked"' : '' } /> 전체</label>
						<label><input type="radio" name="public_yn" value="N" ${paramMap.public_yn eq 'N' ? 'checked="checked"' : '' } /> 답변대기</label>
						<label><input type="radio" name="public_yn" value="Y" ${paramMap.public_yn eq 'Y' ? 'checked="checked"' : '' } /> 답변완료</label>
					</td>
				</tr>
				<tr>
					<th scope="row">등록일</th>
					<td>
						<input type="text" name="reg_date_start" value="${paramMap.reg_date_start }" />
						<span>~</span>
						<input type="text" name="reg_date_end" value="${paramMap.reg_date_end }" />
					</td>
				</tr>
				<tr>
					<th scope="row">검색어</th>
					<td>
						<select name="search_type">
							<option value="all">전체</option>
							<option value="title" ${paramMap.search_type eq 'title' ? 'selected="selected"' : '' }>제목</option>
							<option value="description" ${paramMap.search_type eq 'description' ? 'selected="selected"' : '' }>내용</option>
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

<div class="topBehavior">
	<p class="totalCnt">총 <span><fmt:formatNumber value="${count }" pattern="###,###" /></span>건</p>
<!--
	<ul class="sortingList">
		<li class="on"><a href="#url">최신순</a></li>
		<li><a href="#url">조회순</a></li>
	</ul>
-->
</div>

<!-- table list -->
<div class="tableList">
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:4%" />
			<col style="width:8%" />
			<col style="width:18%" />
			<col />
			<col style="width:12%" />
			<col style="width:12%" />
			<col style="width:6%" />
			<col style="width:6%" />
			<col style="width:6%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="seqsAll" /></th>
				<th scope="col">번호</th>
				<th scope="col">구분</th>
				<th scope="col">제목</th>
				<th scope="col">등록자</th>
				<th scope="col">등록일</th>
				<th scope="col">조회수</th>
				<th scope="col">답변<br />여부</th>
				<th scope="col">승인<br />여부</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
			<tr>
				<td colspan="9">검색된 결과가 없습니다.</td>
			</tr>
			</c:if>

			<c:forEach items="${list }" var="item" varStatus="status">
			<tr>
				<td>
					<input type="checkbox" name="seqs" value="${item.seq }" />
				</td>
				<td>
					<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
				</td>
				<td>
					<c:if test="${item.category eq '0'}">소식</c:if>
					<c:if test="${item.category eq '1'}">행사/교육</c:if>
					<c:if test="${item.category eq '2'}">공연/전시</c:if>
					<c:if test="${item.category eq '3'}">문화동영상</c:if>
					<c:if test="${item.category eq '4'}">문화추천</c:if>
					<c:if test="${item.category eq '5'}">전통디자인</c:if>
					<c:if test="${item.category eq '6'}">이벤트</c:if>
					<c:if test="${item.category eq '7'}">오픈 API</c:if>
					<c:if test="${item.category eq '8'}">기타</c:if>
				</td>
				<td class="subject">
					<a href="/customer/qna/form.do?seq=${item.seq }&qs=${paramMap.qs }">
						${item.title }
					</a>
				</td>
				<td>
					${item.user_id }
				</td>
				<td>
					${item.reg_date }
				</td>
				<td>
					<fmt:formatNumber value="${item.cnt }" pattern="###,###" />
				</td>
				<td>
					<c:choose>
						<c:when test="${item.public_yn eq 'N' }">대기</c:when>
						<c:otherwise>완료</c:otherwise>
					</c:choose>
				</td>
				<td>
					<c:choose>
						<c:when test="${item.status eq 'W' }">대기</c:when>
						<c:when test="${item.status eq 'N' }">미승인</c:when>
						<c:otherwise>승인</c:otherwise>
					</c:choose>
				</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<div id="pagination"></div>

<div class="btnBox">
	<span class="btn white"><a href="#" class="approval_y_btn">승인</a></span>
	<span class="btn white"><a href="#" class="approval_n_btn">미승인</a></span>
	<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
	<%-- <span class="btn dark fr"><a href="/customer/qna/form.do?qs=${paramMap.qs }">등록</a></span> --%>
</div>
</form>

</body>
</html>