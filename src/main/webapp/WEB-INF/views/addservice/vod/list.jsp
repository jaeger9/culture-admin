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

	var vcm_up_code		=	frm.find('select[name=vcm_up_code]');
	var vcm_code		=	frm.find('select[name=vcm_code]');
	var org_code		=	frm.find('select[name=org_code]');
	
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

	new Checkbox('input[name=tvm_seqsAll]', 'input[name=tvm_seqs]');

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
		
		var tvm_seqs = $('input[name=tvm_seqs]:checked');

		if (!confirm(approvalText + ' 처리 하시겠습니까?')) {
			return false;
		}
		if (tvm_seqs.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}

		var param = {
			tvm_viewflag : approval
		};

		if (tvm_seqs.size() > 0) {
			param.tvm_seqs = [];
			
			$('input[name=tvm_seqs]:checked').each(function () {
				param.tvm_seqs.push( $(this).val() );
			});
		}

		$.ajax({
			url			:	'/addservice/vod/approval.do'
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

		var tvm_seqs = $('input[name=tvm_seqs]:checked');

		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		if (tvm_seqs.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}

		var param = {};

		if (tvm_seqs.size() > 0) {
			param.tvm_seqs = [];
			
			$('input[name=tvm_seqs]:checked').each(function () {
				param.tvm_seqs.push( $(this).val() );
			});
		}

		$.ajax({
			url			:	'/addservice/vod/delete.do'
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

	var oCategory = [];

	vcm_code.find('option').each(function () {
		var t = $(this);
		var d = $(this).data();

		oCategory.push({
			name : $.trim(t.html())
			,value : t.val()
			,pcode : d.pcode
			,select : $(this).is(':selected')
		});
	});

	vcm_up_code.change(function () {
		var pcode = $(this).val();
		var html = '<option value="">상세분류</option>';
		for (var i in oCategory) {
			if (pcode == oCategory[i].pcode) {
				html += '<option value="' + oCategory[i].value + '"' + (oCategory[i].select ? ' selected="selected"' : '') + '>' + oCategory[i].name + '</option>';
			}
		}
		vcm_code.html(html);
	}).change();

	
});
</script>
</head>
<body>

<form name="frm" method="get" action="/addservice/vod/list.do">
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
<!--
<select>
	<optgroup label="Swedish Cars">
		<option value="volvo">Volvo</option>
		<option value="saab">Saab</option>
	</optgroup>
	<optgroup label="German Cars">
		<option value="mercedes">Mercedes</option>
		<option value="audi">Audi</option>
	</optgroup>
</select>
-->
						<select name="vcm_up_code">
							<option value="">전체</option>
<c:forEach items="${listByVodCode }" var="item">
	<c:if test="${item.vcm_depth eq 1 }">
		<option value="${item.vcm_code }" ${paramMap.vcm_up_code eq item.vcm_code ? 'selected="selected"' : '' } >${item.vcm_title }</option>
	</c:if>
</c:forEach>
						</select>

						<select name="vcm_code">
							<option value="">상세분류</option>
<c:forEach items="${listByVodCode }" var="item">
	<c:if test="${item.vcm_depth eq 2 }">
		<option value="${item.vcm_code }" data-pcode="${item.vcm_up_code }" ${paramMap.vcm_code eq item.vcm_code ? 'selected="selected"' : '' } >${item.vcm_title }</option>
	</c:if>
</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">기관명</th>
					<td>
						<select name="org_code">
							<option value="">전체</option>
<c:forEach items="${listByVodOrg }" var="item">
	<option value="${item.org_code }" ${paramMap.org_code eq item.org_code ? 'selected="selected"' : '' } >${item.ooc_name }</option>
</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td>
						<label><input type="radio" name="tvm_viewflag" value="" ${empty paramMap.tvm_viewflag ? 'checked="checked"' : '' } /> 전체</label>
						<label><input type="radio" name="tvm_viewflag" value="0" ${paramMap.tvm_viewflag eq '0' ? 'checked="checked"' : '' } /> 승인</label>
						<label><input type="radio" name="tvm_viewflag" value="1" ${paramMap.tvm_viewflag eq '1' ? 'checked="checked"' : '' } /> 미승인</label>
					</td>
				</tr>
				<tr>
					<th scope="row">검색어</th>
					<td>
						<select name="search_type">
							<option value="all">전체</option>
							<option value="title"		${paramMap.search_type eq 'title'	? 'selected="selected"' : '' }>제목</option>
							<option value="contents"	${paramMap.search_type eq 'contents'? 'selected="selected"' : '' }>내용</option>
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
			<col style="width:20%" />
			<col style="width:12%" />
			<col style="width:6%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="tvm_seqsAll" /></th>
				<th scope="col">번호</th>
				<th scope="col">분류</th>
				<th scope="col">제목</th>
				<th scope="col">기관명</th>
				<th scope="col">등록일</th>
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
					<input type="checkbox" name="tvm_seqs" value="${item.tvm_seq }" />
				</td>
				<td>
					<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
				</td>
				<td>
					${item.vcm_name }
				</td>
				<td class="subject">
					<a href="/addservice/vod/form.do?tvm_seq=${item.tvm_seq }&qs=${paramMap.qs }">
						${item.tvm_title }
					</a>
				</td>
				<td>
					${item.org_name }
				</td>
				<td>
					${item.tvm_reg_date }
				</td>
				<td>
					<c:choose>
						<c:when test="${item.tvm_viewflag eq '1' }">미승인</c:when>
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
	<span class="btn dark fr"><a href="/addservice/vod/form.do?qs=${paramMap.qs }">등록</a></span>
</div>
</form>

</body>
</html>