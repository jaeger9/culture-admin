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
	var vvm_status		=	frm.find('input[name=vvm_status]');
	var search_type		=	frm.find('select[name=search_type]');
	var search_word		=	frm.find('input[name=search_word]');
	var search_btn		=	frm.find('button[name=search_btn]');

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

	new Checkbox('input[name=vvm_seqsAll]', 'input[name=vvm_seqs]');
	
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
	var ajaxApproval = function (vvm_status) {
		vvm_status = vvm_status == '0' ? '0' : '1';
		var vvm_statusText = vvm_status == '0' ? '승인' : '미승인';
		
		var vvm_seqs = $('input[name=vvm_seqs]:checked');

		if (!confirm(vvm_statusText + ' 처리 하시겠습니까?')) {
			return false;
		}
		if (vvm_seqs.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}

		var param = {
			vvm_status : vvm_status
		};

		if (vvm_seqs.size() > 0) {
			param.vvm_seqs = [];
			
			$('input[name=vvm_seqs]:checked').each(function () {
				param.vvm_seqs.push( $(this).val() );
			});
		}

		$.ajax({
			url			:	'/addservice/artContent/approval.do'
			,type		:	'post'
			,data		:	$.param(param, true)
			,dataType	:	'json'
			,success : function( res ) {

				if (res.success) {
					alert(vvm_statusText + " 처리가 완료 되었습니다.");
					location.reload();
				} else {
					alert(vvm_statusText + " 처리가 실패 되었습니다.");
				}
			}
			,error : function(data, status, err) {
				alert(vvm_statusText + " 처리가 실패 되었습니다.");
			}
		});

	};

	$('.approval_y_btn').click(function () {
		ajaxApproval('0');
		return false;
	});

	$('.approval_n_btn').click(function () {
		ajaxApproval('1');
		return false;
	});
	
	// 삭제
	$('.delete_btn').click(function () {

		var vvm_seqs = $('input[name=vvm_seqs]:checked');

		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		if (vvm_seqs.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}

		var param = {};

		if (vvm_seqs.size() > 0) {
			param.vvm_seqs = [];
			
			$('input[name=vvm_seqs]:checked').each(function () {
				param.vvm_seqs.push( $(this).val() );
			});
		}

		$.ajax({
			url			:	'/addservice/artContent/delete.do'
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

<form name="frm" method="get" action="/addservice/artContent/list.do">
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
					<th scope="row">분류</th>
					<td>
						<select name="ccm_code">
							<option value="">전체</option>
							<c:forEach items="${codeList }" var="item">
								<option value="${item.ccm_code }"${paramMap.ccm_code eq item.ccm_code ? ' selected="selected" ' : '' }>${item.ccm_titles }</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td>
						<label><input type="radio" name="vvm_status" value="" ${empty paramMap.vvm_status ? 'checked="checked"' : '' } /> 전체</label>
						<label><input type="radio" name="vvm_status" value="0" ${paramMap.vvm_status eq '0' ? 'checked="checked"' : '' } /> 승인</label>
						<label><input type="radio" name="vvm_status" value="1" ${paramMap.vvm_status eq '1' ? 'checked="checked"' : '' } /> 미승인</label>
					</td>
				</tr>
				<tr>
					<th scope="row">검색어</th>
					<td>
						<select name="search_type">
							<option value="all">전체</option>
							<option value="title"		${paramMap.search_type eq 'title'	? 'selected="selected"' : '' }>제목</option>
							<option value="content"		${paramMap.search_type eq 'content'	? 'selected="selected"' : '' }>내용</option>
							<option value="keyword"		${paramMap.search_type eq 'keyword'	? 'selected="selected"' : '' }>키워드</option>
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
			<col style="width:15%" />
			<col />
			<col style="width:12%" />
			<col style="width:12%" />
			<col style="width:6%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="vvm_seqsAll" /></th>
				<th scope="col">번호</th>
				<th scope="col">구분</th>
				<th scope="col">작품/자료명</th>
				<th scope="col">등록일</th>
				<th scope="col">조회수</th>
				<th scope="col">승인<br />여부</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
			<tr>
				<td colspan="7">검색된 결과가 없습니다.</td>
			</tr>
			</c:if>

			<c:forEach items="${list }" var="item" varStatus="status">
			<tr>
				<td>
					<input type="checkbox" name="vvm_seqs" value="${item.vvm_seq }" />
				</td>
				<td>
					<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
				</td>
				<td>
					${item.ccm_name }
				</td>
				<td class="subject">
					<a href="/addservice/artContent/form.do?vvm_seq=${item.vvm_seq }&qs=${paramMap.qs }">
						${item.vvm_title }
					</a>
				</td>
				<td>
					${item.vvm_cre_date }
				</td>
				<td>
					${item.view_cnt }
				</td>
				<td>
					${item.vvm_status eq '0' ? '승인' : '미승인' }
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
	<span class="btn dark fr"><a href="/addservice/artContent/form.do?qs=${paramMap.qs }">등록</a></span>
</div>

</form>

</body>
</html>