<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

	var frm					=	$('form[name=frm]');
	var page_no				=	frm.find('input[name=page_no]');
	var active				=	frm.find('input[name=active]');
	var create_date_start	=	frm.find('input[name=create_date_start]');
	var create_date_end		=	frm.find('input[name=create_date_end]');
	var modify_date_start	=	frm.find('input[name=modify_date_start]');
	var modify_date_end		=	frm.find('input[name=modify_date_end]');
	var search_type			=	frm.find('select[name=search_type]');
	var search_word			=	frm.find('input[name=search_word]');
	var search_btn			=	frm.find('button[name=search_btn]');

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

	new Datepicker(create_date_start, create_date_end);
	new Datepicker(modify_date_start, modify_date_end);
	new Checkbox('input[name=user_idsAll]', 'input[name=user_ids]');

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
	var ajaxApproval = function (active) {
		active = active == 'Y' ? 'Y' : 'N';
		var activeText = active == 'Y' ? '승인' : '미승인';

		var user_ids = $('input[name=user_ids]:checked');

		if (!confirm(activeText + ' 처리 하시겠습니까?')) {
			return false;
		}
		if (user_ids.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}

		var param = {
			active : active
		};

		if (user_ids.size() > 0) {
			param.user_ids = [];
			
			$('input[name=user_ids]:checked').each(function () {
				param.user_ids.push( $(this).val() );
			});
		}

		$.ajax({
			url			:	'/admin/member/approval.do'
			,type		:	'post'
			,data		:	$.param(param, true)
			,dataType	:	'json'
			,success : function( res ) {

				if (res.success) {
					alert(activeText + " 처리가 완료 되었습니다.");
					location.reload();
				} else {
					alert(activeText + " 처리가 실패 되었습니다.");
				}
			}
			,error : function(data, status, err) {
				alert(activeText + " 처리가 실패 되었습니다.");
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

		var user_ids = $('input[name=user_ids]:checked');

		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		if (user_ids.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}

		var param = {};

		if (user_ids.size() > 0) {
			param.user_ids = [];
			
			$('input[name=user_ids]:checked').each(function () {
				param.user_ids.push( $(this).val() );
			});
		}

		$.ajax({
			url			:	'/admin/member/delete.do'
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

<form name="frm" method="get" action="/admin/member/list.do">
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
						<label><input type="radio" name="active" value="" ${empty paramMap.active ? 'checked="checked"' : '' } /> 전체</label>
						<label><input type="radio" name="active" value="Y" ${paramMap.active eq 'Y' ? 'checked="checked"' : '' } /> 승인</label>
						<label><input type="radio" name="active" value="N" ${paramMap.active eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
					</td>
				</tr>
				<tr>
					<th scope="row">등록일</th>
					<td>
						<input type="text" name="create_date_start" value="${paramMap.create_date_start }" />
						<span>~</span>
						<input type="text" name="create_date_end" value="${paramMap.create_date_end }" />
					</td>
				</tr>
				<tr>
					<th scope="row">수정일</th>
					<td>
						<input type="text" name="modify_date_start" value="${paramMap.modify_date_start }" />
						<span>~</span>
						<input type="text" name="modify_date_end" value="${paramMap.modify_date_end }" />
					</td>
				</tr>
				<tr>
					<th scope="row">검색어</th>
					<td>
						<select name="search_type">
							<option value="all">전체</option>
							<option value="user_id"		${paramMap.search_type eq 'user_id'	? 'selected="selected"' : '' }>아이디</option>
							<option value="name"		${paramMap.search_type eq 'name'	? 'selected="selected"' : '' }>이름</option>
							<option value="email"		${paramMap.search_type eq 'email'	? 'selected="selected"' : '' }>이메일</option>
							<option value="tel"			${paramMap.search_type eq 'tel'		? 'selected="selected"' : '' }>연락처</option>
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
			<col style="width:30%" />
			<col style="width:12%" />
			<col style="width:6%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="user_idsAll" /></th>
				<th scope="col">번호</th>
				<th scope="col">아이디</th>
				<th scope="col">이름</th>
				<th scope="col">수정일</th>
				<th scope="col">승인<br />여부</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
			<tr>
				<td colspan="6">검색된 결과가 없습니다.</td>
			</tr>
			</c:if>
			<c:forEach items="${list }" var="item" varStatus="status">
			<tr>
				<td>
					<input type="checkbox" name="user_ids" value="${item.user_id }" />
				</td>
				<td>
					<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
				</td>
				<td class="subject" style="text-align:center;">
					<a href="/admin/member/form.do?user_id=${item.user_id }&qs=${paramMap.qs }">
						${item.user_id }
					</a>
				</td>
				<td>
					${item.name }
				</td>
				<td>
					${item.modify_date }
				</td>
				<td>
					${item.active eq 'Y' ? '승인' : '' }
					${item.active eq 'N' ? '미승인' : '' }
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
	<span class="btn dark fr"><a href="/admin/member/form.do?qs=${paramMap.qs }">등록</a></span>
</div>
</form>

</body>
</html>