<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- <script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script> -->
<script type="text/javascript">

$(function () {

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
	// nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	
	var frm				=	$('form[name=frm]');
	var vvm_seq			=	frm.find('input[name=vvm_seq]');
	var vvm_file_seq	=	frm.find('input[name=vvm_file_seq]');
	var vvm_comment		=	frm.find('input[name=vvm_comment]');
	
	frm.submit(function () {
		// frm.serialize()
		// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);

		if (vvm_seq.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
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
			if (!confirm('이미지를 삭제하시겠습니까?')) {
				return false;
			}
			if (vvm_file_seq.val() == '') {
				alert('vvm_file_seq가 존재하지 않습니다.');
				return false;
			}

			var param = {
				vvm_file_seqs : [ vvm_file_seq.val() ]
			};

			$.ajax({
				url			:	'/addservice/artCopyright/delete.do'
				,type		:	'post'
				,data		:	$.param(param, true)
				,dataType	:	'json'
				,success	:	function (res) {
					if (res.success) {
						alert("삭제가 완료 되었습니다.");
						// location.href = $('.list_btn').attr('href');
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
	}
	
});
</script>
</head>
<body>

<form name="frm" method="POST" action="/addservice/artCopyright/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="vvm_seq" value="${view.vvm_seq }" />
	<input type="hidden" name="vvm_gubun" value="${view.vvm_gubun }" />
	<input type="hidden" name="vvm_file_seq" value="${view.vvm_file_seq }" />
	<input type="hidden" name="vvm_file_name" value="${view.vvm_file_name }" />

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
<c:if test="${not empty view.vvm_seq }">
				<tr>
					<th scope="row">고유번호</th>
					<td>
						${view.vvm_seq }
					</td>
					<th scope="row">등록일</th>
					<td>
						<c:out value="${view.vvm_reg_date }" default="-" />
					</td>
				</tr>
</c:if>
				<tr>
					<th scope="row">제목</th>
					<td colspan="3">
						${view.vvm_title }
					</td>
				</tr>
				<tr>
					<th scope="row">분류</th>
					<td colspan="3">
						${view.ccm_name }
					</td>
				</tr>
				<tr>
					<th scope="row">저작권자</th>
					<td colspan="3">
						<c:if test="${not empty view.vvm_file_name }">
							<input type="text" name="vvm_comment" value="${view.vvm_comment }" style="width:670px" />
						</c:if>
						<c:if test="${empty view.vvm_file_name }">
							저작권 이미지 등록 후 수정 가능합니다.
						</c:if>
					</td>
				</tr>
				<tr>
					<th scope="row">저작권 이미지</th>
					<td colspan="3">
						<c:if test="${not empty view.vvm_file_name }">
							<img src="/dat/vim/<c:out value="${view.vvm_file_name }" />" />
						</c:if>
						<c:if test="${empty view.vvm_file_name }">
							저작권 이미지 등록 후 수정 가능합니다.
						</c:if>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<c:if test="${not empty view.vvm_file_name }">
			<span class="btn white"><a href="#" class="insert_btn">${empty view.vvm_seq ? '등록' : '수정' }</a></span>
		</c:if>

		<c:if test="${not empty view.vvm_file_name }">
			<span class="btn white"><a href="#" class="delete_btn">이미지 삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/addservice/artCopyright/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>