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
	var reg_date_start	=	frm.find('input[name=reg_date_start]');
	var reg_date_end	=	frm.find('input[name=reg_date_end]');
	
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
			url			:	'/addservice/englishSite/approval.do'
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
			url			:	'/addservice/englishSite/delete.do'
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

<form name="frm" method="get" action="/addservice/englishSite/list.do">
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
					<th scope="row">등록일</th>
					<td>
						<input type="text" name="reg_date_start" value="${paramMap.reg_date_start }" />
						<span>~</span>
						<input type="text" name="reg_date_end" value="${paramMap.reg_date_end }" />
					</td>
				</tr>
				<tr>
					<th scope="row">구분</th>
					<td>
						<select name="category">
							<option value="">선택</option>
							<option value="관광"		${paramMap.category eq '관광'	? 'selected="selected"' : '' }>관광</option>
							<option value="도서"		${paramMap.category eq '도서'	? 'selected="selected"' : '' }>도서</option>
							<option value="문화산업"	${paramMap.category eq '문화산업'	? 'selected="selected"' : '' }>문화산업</option>
							<option value="문화예술"	${paramMap.category eq '문화예술'	? 'selected="selected"' : '' }>문화예술</option>
							<option value="문화유산"	${paramMap.category eq '문화유산'	? 'selected="selected"' : '' }>문화유산</option>
							<option value="정책"		${paramMap.category eq '정책'	? 'selected="selected"' : '' }>정책</option>
							<option value="체육"		${paramMap.category eq '체육'	? 'selected="selected"' : '' }>체육</option>
							<option value="홍보"		${paramMap.category eq '홍보'	? 'selected="selected"' : '' }>홍보</option>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td>
						<select name="approval">
							<option value="">전체</option>
							<option value="S"	${paramMap.approval eq 'S'	? 'selected="selected"' : '' }>대기</option>
							<option value="Y"	${paramMap.approval eq 'Y'	? 'selected="selected"' : '' }>승인</option>
							<option value="N"	${paramMap.approval eq 'N'	? 'selected="selected"' : '' }>미승인</option>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">검색어</th>
					<td>
						<select name="search_type">
							<option value="all">전체</option>
							<option value="org_name"		${paramMap.search_type eq 'org_name'	? 'selected="selected"' : '' }>기관명</option>
							<option value="org_eng_name"	${paramMap.search_type eq 'org_eng_name'	? 'selected="selected"' : '' }>영문 풀네임</option>
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
</div>

<!-- table list -->
<div class="tableList">
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:4%" />
			<col style="width:6%" />
			<col style="width:12%" />
			<col style="width:20%" />
			<col style="width:20%" />
			<col style="width:20%"/>
			<col style="width:11%" />
			<col style="width:7%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="seqsAll" /></th>
				<th scope="col">번호</th>
				<th scope="col">구분</th>
				<th scope="col">기관명</th>
				<th scope="col">영문 풀네임</th>
				<th scope="col">연결 URL</th>
				<th scope="col">등록일</th>
				<th scope="col">승인</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
			<tr>
				<td colspan="8">검색된 결과가 없습니다.</td>
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
					${item.category }
				</td>
				<td class="subject">
					<a href="/addservice/englishSite/form.do?seq=${item.seq }">
						${item.org_name }
					</a>
				</td>
				<td>
					${item.org_eng_name }
				</td>
				<td style="text-overflow: ellipsis;  white-space: nowrap; overflow: hidden;">
					<a href="${item.url }" target="_blank">${item.url }</a>
				</td>
				<td>
					${item.reg_date }
				</td>
				<td>
					<c:choose>
						<c:when test="${item.approval eq 'N' }">미승인</c:when>
						<c:when test="${item.approval eq 'S' }">대기</c:when>
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
	<span class="btn dark fr"><a href="/addservice/englishSite/form.do">등록</a></span>
</div>
</form>

</body>
</html>