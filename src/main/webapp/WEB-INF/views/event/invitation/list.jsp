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
	var approval = frm.find('input[name=approval]');
	var display_dt_start = frm.find('input[name=display_dt_start]');
	var display_dt_end = frm.find('input[name=display_dt_end]');
	var win_dt_start = frm.find('input[name=win_dt_start]');
	var win_dt_end = frm.find('input[name=win_dt_end]');
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

	new Datepicker(display_dt_start, display_dt_end);
	new Datepicker(win_dt_start, win_dt_end);
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
			url			:	'/event/invitation/approval.do'
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
			url			:	'/event/invitation/delete.do'
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

	$('.applicant_btn').click(function () {
		window.open($(this).attr('href'), 'applicantPopup', 'scrollbars=yes,width=800,height=600');
		return false;
	});

	$('.stat_btn').click(function () {
		window.open($(this).attr('href'), 'statPopup', 'scrollbars=yes,width=800,height=600');
		return false;
	});
	
});
</script>
</head>
<body>

<form name="frm" method="get" action="/event/invitation/list.do">
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
					<th scope="row">승인여부</th>
					<td>
						<label><input type="radio" name="approval" value="" ${empty paramMap.approval ? 'checked="checked"' : '' } /> 전체</label>
						<label><input type="radio" name="approval" value="W" ${paramMap.approval eq 'W' ? 'checked="checked"' : '' } /> 대기</label>
						<label><input type="radio" name="approval" value="Y" ${paramMap.approval eq 'Y' ? 'checked="checked"' : '' } /> 승인</label>
						<label><input type="radio" name="approval" value="N" ${paramMap.approval eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
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
					<th scope="row">진행일</th>
					<td>
						<input type="text" name="display_dt_start" value="${paramMap.display_dt_start }" />
						<span>~</span>
						<input type="text" name="display_dt_end" value="${paramMap.display_dt_end }" />
					</td>
				</tr>
				<tr>
					<th scope="row">당첨자발표일</th>
					<td>
						<input type="text" name="win_dt_start" value="${paramMap.win_dt_start }" />
						<span>~</span>
						<input type="text" name="win_dt_end" value="${paramMap.win_dt_end }" />
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
			<col />
			<col style="width:8%" />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:9%" />
			<col style="width:6%" />
			<col style="width:6%" />
			<col style="width:6%" />
			<col style="width:6%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="seqsAll" /></th>
				<th scope="col">번호</th>
				<th scope="col">제목</th>
				<th scope="col">상태</th>
				<th scope="col">진행일</th>
				<th scope="col">당첨자<br />발표일</th>
				<th scope="col">등록일</th>
				<th scope="col">등록자</th>
				<th scope="col">조회수</th>
				<th scope="col">승인<br />여부</th>
				<th scope="col">응모자</th>
				<th scope="col">통계</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
			<tr>
				<td colspan="12">검색된 결과가 없습니다.</td>
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
				<td class="subject">
					<a href="/event/invitation/form.do?seq=${item.seq }&qs=${paramMap.qs }">
						<c:out value="${item.title }"/>
					</a>
				</td>
				<td>
					<c:choose>
						<c:when test="${item.status eq 0 }">대기</c:when>
						<c:when test="${item.status eq 1 }">진행중</c:when>
						<c:otherwise>종료</c:otherwise>
					</c:choose>
				</td>
				<td>
					${item.start_dt }<br />
					~<br />
					${item.end_dt }
				</td>
				<td>
					${item.win_dt }
				</td>
				<td>
					${item.reg_date }
				</td>
				<td>
					${item.user_id }
				</td>
				<td>
					<fmt:formatNumber value="${item.view_cnt }" pattern="###,###" />
				</td>
				<td>
					<c:choose>
						<c:when test="${item.approval eq 'W' }">대기</c:when>
						<c:when test="${item.approval eq 'N' }">미승인</c:when>
						<c:otherwise>승인</c:otherwise>
					</c:choose>
				</td>
				<td>
					<a href="/popup/invitationApplicant.do?event_seq=${item.seq }&event_title=${item.title }&perform_title=${item.perform_title }" class="applicant_btn">응모자<br />(<fmt:formatNumber value="${item.person_cnt }" pattern="###,###" />)</a>
				</td>
				<td>
					<a href="/popup/invitationStat.do?event_seq=${item.seq }&join_date_start=${item.start_dt }&join_date_end=${item.end_dt }" class="stat_btn">통계</a>
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
	<span class="btn dark fr"><a href="/event/invitation/form.do?qs=${paramMap.qs }">등록</a></span>
</div>
</form>

</body>
</html>