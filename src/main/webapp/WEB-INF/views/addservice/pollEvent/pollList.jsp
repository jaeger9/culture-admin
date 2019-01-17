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
	var approval		=	frm.find('input[name=approval]');

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

	new Checkbox('input[name=seqsAll]', 'input[name=seqs]');

	//검색
	$('button[name=searchButton]').click(function(){
		$('input[name=page_no]').val('1');
		$('form[name=frm]').submit();
	});
	var search = function () {
		frm.submit();
	};
	

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
			url			:	'/addservice/pollEvent/approval.do'
			,type		:	'post'
			,data		:	$.param(param, true)
			,dataType	:	'json'
			,success : function( res ) {

				if (res.success) {
					// $('input[name=cul_seqs]:checked, input[name=rdf_seqs]:checked').each(function () {
					// $(this).parent().parent().find('td:eq(6)').text( approval == 'Y' ? '승인' : '미승인' );
					// });

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

/* 	$('.delete_btn').click(function () {

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
			url			:	'/addservice/pollEvent/pollDelete.do'
			,type		:	'post'
			,data		:	$.param(param, true)
			,dataType	:	'json'
			,success	:	function (res) {
				if (res.success) {
					alert("삭제가 완료 되었습니다.");
					location.reload();
				} else {
					alert("이벤트에 투표자가 있습니다.");
				}
			}
			,error : function(data, status, err) {
				alert("삭제 실패 되었습니다.");
			}
		});

		return false;
	}); */

});
</script>
</head>
<body>

	<!-- 검색 필드 -->
	<form name="frm" method="get" action="pollList.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
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
							<th scope="row">승인여부</th>
							<td>
								<input type="radio" name="search_field1" value="" <c:if test="${empty paramMap.search_field1}">checked="checked"</c:if>/> 전체
								<input type="radio" name="search_field1" value="S" <c:if test="${paramMap.search_field1 eq 'S' }">checked="checked"</c:if>/> 대기
								<input type="radio" name="search_field1" value="Y" <c:if test="${paramMap.search_field1 eq 'Y' }">checked="checked"</c:if>/> 승인
								<input type="radio" name="search_field1" value="N" <c:if test="${paramMap.search_field1 eq 'N' }">checked="checked"</c:if>/> 미승인
							</td>
						</tr>
						<tr>
							<th scope="row">검색어</th>
							<td>
								<select name="search_field2">
									<option value="" <c:if test="${empty paramMap.search_field2}">selected</c:if>>전체</option>
									<option value="title" <c:if test="${paramMap.search_field2 eq 'title' }">selected</c:if>>투표타이틀</option>
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
					<col style="width:10%" />
					<col style="width:20%" />
					<col />
					<col />
					<col style="width:8%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="seqsAll"/></th>
						<th scope="col">회차</th>
						<th scope="col">투표 기간</th>
						<th scope="col">투표 타이틀1</th>
						<th scope="col">투표 타이틀2</th>
						<th scope="col">승인</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="item" items="${list }" varStatus="status">
					<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index }"/>
					<tr>
						<td><input type="checkbox" name="seqs" value="${item.event_seq }"/></td>
						<td>${item.event_number}</td>
						<td><a href="/addservice/pollEvent/pollForm.do?event_seq=${item.event_seq}">${item.poll_start_date } ~ ${item.poll_end_date}</a></td>
						<td>${item.poll1_title }</td>
						<td>${item.poll2_title }</td>
						<td>
							<c:choose>
								<c:when test="${item.approval eq 'S' }">대기</c:when>
								<c:when test="${item.approval eq 'N' }">미승인</c:when>
								<c:when test="${item.approval eq 'Y' }">승인</c:when>
							</c:choose>
						</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
	
	<div id="pagination">
	</div>
	<div class="btnBox">
		<span class="btn white"><a href="#" class="approval_y_btn">승인</a></span>
		<span class="btn white"><a href="#" class="approval_n_btn">미승인</a></span>
		<!-- <span class="btn white"><a href="#" class="delete_btn">삭제</a></span> -->
		<span class="btn dark fr"><a href="/addservice/pollEvent/pollForm.do">등록</a></span>
	</div>
	
	</form>
</body>
</html>
