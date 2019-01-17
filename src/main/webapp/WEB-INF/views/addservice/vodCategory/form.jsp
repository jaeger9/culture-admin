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
	var vcm_code		=	frm.find('input[name=vcm_code]');

	var vcm_title		=	frm.find('input[name=vcm_title]');
	var vcm_status		=	frm.find('input[name=vcm_status]');

	frm.submit(function () {
		// frm.serialize()
		// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);

		if (vcm_code.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}

		if (vcm_title.val() == '') {
			vcm_title.focus();
			alert('제목을 입력해 주세요.');
			return false;
		}
		if (vcm_status.filter(':checked').size() == 0) {
			vcm_status.eq(0).focus();
			alert('승인여부를 선택해 주세요.');
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
			if (vcm_code.val() == '') {
				alert('vcm_code가 존재하지 않습니다.');
				return false;
			}

			var param = {
				vcm_codes : [ vcm_code.val() ]
			};

			$.ajax({
				url			:	'/addservice/vodCategory/delete.do'
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

<form name="frm" method="POST" action="/addservice/vodCategory/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="vcm_code" value="${view.vcm_code }" />
	<input type="hidden" name="vcm_up_code" value="${view.vcm_up_code }" />
	<input type="hidden" name="vcm_gr_no" value="${view.vcm_gr_no }" />
	<input type="hidden" name="vcm_ar_no" value="${view.vcm_ar_no }" />
	<input type="hidden" name="vcm_depth" value="${view.vcm_depth }" />

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
<c:if test="${not empty view.vcm_code }">
				<tr>
					<th scope="row">고유번호</th>
					<td>
						${view.vcm_code }
					</td>
					<th scope="row">상위 고유번호</th>
					<td>
						${view.vcm_up_code }
						/
						${view.vcm_up_title }
					</td>
				</tr>
				<tr>
					<th scope="row">등록/수정자</th>
					<td>
						<c:out value="${view.vcm_reg_name }" default="-" />
						/
						<c:out value="${view.vcm_upd_name }" default="-" />
					</td>
					<th scope="row">등록/수정일</th>
					<td>
						<c:out value="${view.vcm_reg_date }" default="-" />
						/
						<c:out value="${view.vcm_upd_date }" default="-" />
					</td>
				</tr>
</c:if>
				<tr>
					<th scope="row">제목</th>
					<td colspan="3">
						<input type="text" name="vcm_title" value="${view.vcm_title }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td colspan="3">
						<label><input type="radio" name="vcm_status" value="0" ${view.vcm_status eq '0' or empty view.vcm_status ? 'checked="checked"' : '' } /> 승인</label>
						<label><input type="radio" name="vcm_status" value="1" ${view.vcm_status eq '1' ? 'checked="checked"' : '' } /> 미승인</label>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.vcm_code ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view.vcm_code }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/addservice/vodCategory/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>