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
	var job_name = frm.find('select[name=job_name]');
	var job_group_id = frm.find('select[name=job_group_id]');
	var approval = frm.find('select[name=approval]');
	var reg_date_start = frm.find('input[name=reg_date_start]');
	var reg_date_end = frm.find('input[name=reg_date_end]');
	var search_type = frm.find('select[name=search_type]');
	var search_word = frm.find('input[name=search_word]');
	var search_btn = frm.find('button[name=search_btn]');
	
	var search = function () {
		frm.submit();
	};
	
	new Pagination({
		form		:	'#pagination',
		page_count	:	'${count }',
		page_no		:	'${paramMap.page_no }',
		callback	:	function(pageIndex, e) {
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});

	new Datepicker(reg_date_start, reg_date_end);
	new Checkbox('input[name=ucisAll]', 'input[name=ucis]');

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
		
		var ucis = $('input[name=ucis]:checked');

		if (!confirm(approvalText + ' 처리 하시겠습니까?')) {
			return false;
		}
		if (ucis.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}

		var param = {
			approval : approval
		};

		if (ucis.size() > 0) {
			param.ucis = [];
			
			$('input[name=ucis]:checked').each(function () {
				param.ucis.push( $(this).val() );
			});
		}

		$.ajax({
			url			:	'/knowledge/book/approval.do'
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

		var ucis = $('input[name=ucis]:checked');

		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		if (ucis.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}

		var param = {};

		if (ucis.size() > 0) {
			param.ucis = [];
			
			$('input[name=ucis]:checked').each(function () {
				param.ucis.push( $(this).val() );
			});
		}

		$.ajax({
			url			:	'/knowledge/book/delete.do'
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


<form name="frm" method="get" action="/knowledge/book/list.do">
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
						<select title="분류여부 선택" name="job_id">
							<option value="" ${empty paramMap.job_id ? 'selected="selected"' : '' } >전체</option>
							<option value="JOB1203" ${ paramMap.job_id eq 'JOB1203' ? 'selected="selected"' : '' } >이달의 읽을 만한 책</option>
							<option value="JOB1204" ${ paramMap.job_id eq 'JOB1204' ? 'selected="selected"' : '' } >청소년 권장도서</option>
							<option value="JOB293" ${ paramMap.job_id eq 'JOB293' ? 'selected="selected"' : '' } >어린이 추천도서</option>
							<option value="JOB1212" ${ paramMap.job_id eq 'JOB1212' ? 'selected="selected"' : '' } >사서 추천도서</option>
							<!-- <option value="발간도서">서점마스터 추천도서</option> -->
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">출처</th>
					<td>
						<select title="출처여부 선택" name="job_group_id">
							<option value="">전체</option>
							<option value="GRP28" ${ paramMap.job_group_id eq 'GRP28' ? 'selected="selected"' : '' } >국립중앙도서관</option>
							<option value="GRP51" ${ paramMap.job_group_id eq 'GRP51' ? 'selected="selected"' : '' } >국립청소년도서관</option>
							<option value="GRP59" ${ paramMap.job_group_id eq 'GRP59' ? 'selected="selected"' : '' } >출판문화산업진흥원</option>
							<!-- <option value="">서점온</option> -->
						</select>
					</td>
				</tr>
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
			<col style="width:3%" />
			<col style="width:10%" />
			<col style="width:15%" />
			<col style="width:%" />
					
			<col style="width:10%" />
			<col style="width:10%" />
			<%-- <col style="width:10%" /> --%>
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="ucisAll" /></th>
				<th scope="col">번호</th>
				<th scope="col">분류</th>
				<th scope="col">제목</th>
				<th scope="col">등록일</th>
				<th scope="col">승인여부</th>
				<!-- <th scope="col">조회수</th> -->
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
					<input type="checkbox" name="ucis" value="${item.uci }" />
				</td>
				<td>
					<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
				</td>
				<td>${item.job_name}</td>	
				<td class="subject">
					<a href="/knowledge/book/form.do?uci=${item.uci }&qs=${paramMap.qs }">
						${item.title }
					</a>
				</td>
				<td>${item.reg_date}</td>
				<td>${item.approval}</td>
				<%-- <td>${item.form_cnt}</td> --%>
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
	<span class="btn dark fr"><a href="/knowledge/book/form.do?qs=${paramMap.qs }">등록</a></span>
</div>
</form>

</body>
</html>