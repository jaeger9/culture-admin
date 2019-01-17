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
	var arc_idx_id		=	frm.find('select[name=arc_idx_id]');
	var idx_dtl_seq		=	frm.find('input[name=idx_dtl_seq]');
	var idx_dtl_title	=	frm.find('input[name=idx_dtl_title]');
	var idx_dtl_desc	=	frm.find('input[name=idx_dtl_desc]');
	
	frm.submit(function () {
		if (idx_dtl_seq.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		if (idx_dtl_title.val() == '') {
			idx_dtl_title.focus();
			alert('색인명을 입력해 주세요.');
			return false;
		}
		return true;
	});

	// 등록/수정
	$('.insert_btn').click(function () {
		frm.submit();
		return false;
	});
	
	// 삭제
	if ($('.delete_btn').size() > 0) {
		$('.delete_btn').click(function () {
			// 삭제
			if (!confirm('삭제하시겠습니까?')) {
				return false;
			}
			if (idx_dtl_seq.val() == '') {
				alert('idx_dtl_seq가 존재하지 않습니다.');
				return false;
			}

			var param = {
				idx_dtl_seqs : [ idx_dtl_seq.val() ]
			};

			$.ajax({
				url			:	'/addservice/archiveIndex/delete.do'
				,type		:	'post'
				,data		:	$.param(param, true)
				,dataType	:	'json'
				,success	:	function (res) {
					if (res.success) {
						alert("삭제가 완료 되었습니다.");
						location.href = $('.list_btn').attr('href');

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
	}

});
</script>
</head>
<body>

<form name="frm" method="POST" action="/addservice/archiveIndex/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="idx_dtl_seq" value="${view.idx_dtl_seq }" />

	<div class="tableWrite">
		<table summary="게시판 글 등록">
			<caption>게시판 글 등록</caption>
			<colgroup>
				<col style="width:15%" />
				<col style="width:35%" />
				<col style="width:15%" />
				<col style="width:35%" />
			</colgroup>
			<tbody>
<c:if test="${not empty view.idx_dtl_seq }">
				<tr>
					<th scope="row">고유번호</th>
					<td colspan="3">
						${view.idx_dtl_seq }
					</td>
				</tr>
				<tr>
					<th scope="row">분류</th>
					<td colspan="3">
<c:forEach items="${selectList }" var="item">
	<c:if test="${view.arc_idx_id eq item.arc_idx_id }">
						<input type="hidden" name="arc_idx_id" value="${item.arc_idx_id }" />
						${item.arc_idx_title }
	</c:if>
</c:forEach>
					</td>
				</tr>
</c:if>
<c:if test="${empty view.idx_dtl_seq }">
				<tr>
					<th scope="row">분류</th>
					<td colspan="3">
						<select name="arc_idx_id">
<c:forEach items="${selectList }" var="item">
							<option value="${item.arc_idx_id }" ${view.arc_idx_id eq item.arc_idx_id ? 'selected="selected"' : '' }>${item.arc_idx_title }</option>
</c:forEach>
						</select>
					</td>
				</tr>
</c:if>
				<tr>
					<th scope="row">색인명</th>
					<td colspan="3">
						<input type="text" name="idx_dtl_title" value="${view.idx_dtl_title }" maxlength="50" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">색인명</th>
					<td colspan="3">
						<input type="text" name="idx_dtl_desc" value="${view.idx_dtl_desc }" maxlength="50" style="width:670px" />
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.idx_dtl_seq ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view.idx_dtl_seq }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/addservice/archiveIndex/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>