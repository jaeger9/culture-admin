<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- <script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script> -->
<script type="text/javascript">

var callback = {
	fileUpload : function (res) {
		// res.full_file_path
		// res.file_path
		$('input[name=image]').val(res.file_path);
		$('.upload_pop_img').html('<img src="/upload/contestMCST/' + res.file_path + '" style="width:100px;" alt="" />');
	}
};

$(function () {

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
	// nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	
	var frm			=	$('form[name=frm]');
	var seq			=	frm.find('input[name=seq]');
	var title		=	frm.find('input[name=title]');
	var start_dt	=	frm.find('input[name=start_dt]');
	var end_dt		=	frm.find('input[name=end_dt]');
	var url			=	frm.find('input[name=url]');
	var image		=	frm.find('input[name=image]');
	var approval	=	frm.find('input[name=approval]');
	
	new Datepicker(start_dt, end_dt);
	
	frm.submit(function () {
		// frm.serialize()
		// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
		
		if (seq.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		if (title.val() == '') {
			title.focus();
			alert('제목을 입력해 주세요.');
			return false;
		}
		if (start_dt.val() == '') {
			start_dt.focus();
			alert('시작일을 선택해 주세요.');
			return false;
		}
		if (end_dt.val() == '') {
			end_dt.focus();
			alert('종료일을 선택해 주세요.');
			return false;
		}
		if (url.val() == '') {
			url.focus();
			alert('URL을 입력해 주세요.');
			return false;
		}
		/*
		if (image.val() == '') {
			alert('이미지를 선택해 주세요.');
			return false;
		}
		*/
		if (approval.filter(':checked').size() == 0) {
			approval.eq(0).focus();
			alert('승인여부를 선택해 주세요.');
			return false;
		}
		return true;
	});
	
	// 파일업로드
	$('.upload_pop_btn').click(function () {
		Popup.fileUpload('addservice_contestMcst');
		return false;
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
			if (seq.val() == '') {
				alert('seq가 존재하지 않습니다.');
				return false;
			}

			var param = {
				seqs : [ seq.val() ]
			};

			$.ajax({
				url			:	'/addservice/contestMcst/delete.do'
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

<form name="frm" method="POST" action="/addservice/contestMcst/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="seq" value="${view.seq }" />

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
<c:if test="${not empty view.seq }">
				<tr>
					<th scope="row">seq</th>
					<td>
						${view.seq }
					</td>
					<th scope="row">등록일</th>
					<td>
						<c:out value="${view.reg_date }" default="-" />
					</td>
				</tr>
</c:if>
				<tr>
					<th scope="row">제목</th>
					<td colspan="3">
						<input type="text" name="title" value="${view.title }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">기간</th>
					<td colspan="3">
						<input type="text" name="start_dt" value="${view.start_dt }" />
						<span>~</span>
						<input type="text" name="end_dt" value="${view.end_dt }" />
					</td>
				</tr>
				<tr>
					<th scope="row">URL</th>
					<td colspan="3"><input type="text" name="url" value="${view.url }" style="width:670px" /></td>
				</tr>
				<tr>
					<th scope="row">썸네일 이미지</th>
					<td colspan="3">
						<input type="text" name="image" value="${view.image }" style="width:580px" />
						<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
						<div class="upload_pop_msg">(공모전 이미지를 선택해 주세요.)</div>
						<div class="upload_pop_img">
							<c:if test="${not empty view.image }">
								<img src="/upload/contestMCST/${view.image }" style="width:100px;" alt="" />
							</c:if>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td colspan="3">
						<label><input type="radio" name="approval" value="Y" ${view.approval ne 'N' ? 'checked="checked"' : '' } /> 승인</label>
						<label><input type="radio" name="approval" value="N" ${view.approval eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.seq ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view.seq }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/addservice/contestMcst/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>