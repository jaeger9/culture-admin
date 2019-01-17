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
		$('input[name=site_img]').val(res.full_file_path);
		$('.upload_pop_img').html('<img src="' + res.full_file_path + '" width="12" height="12" alt="" />');
	}
};

$(function () {

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
	// nhn.husky.EZCreator.createInIFrame( oEditorsOption );

	var frm				=	$('form[name=frm]');
	var site_id			=	frm.find('input[name=site_id]');
	var site_id_check	=	frm.find('input[name=site_id_check]');
	var site_name		=	frm.find('input[name=site_name]');
	var site_img		=	frm.find('input[name=site_img]');
	var url				=	frm.find('input[name=url]');
	var description		=	frm.find('textarea[name=description]');
	var approval		=	frm.find('input[name=approval]');

	site_id.keypress(function () {
		site_id_check.val(0);
	});
	
	frm.submit(function () {
		// frm.serialize()
		// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);

<c:if test="${not empty view.site_id }">
		if (!confirm('수정하시겠습니까?')) {
			return false;
		}
</c:if>
<c:if test="${empty view.site_id }">

		if (!confirm('등록하시겠습니까?')) {
			return false;
		}
		if (site_id.val() == '') {
			site_id.focus();
			alert('사이트 아이디를 입력해 주세요.');
			return false;
		}
		if (site_id_check.val() != 1) {
			site_id.focus();
			alert('사이트 아이디 중복 체크를 해주세요.');
			return false;
		}
		
</c:if>
		if (site_name.val() == '') {
			site_name.focus();
			alert('사이트명을 입력해 주세요.');
			return false;
		}
		if (approval.filter(':checked').size() == 0) {
			approval.eq(0).focus();
			alert('승인여부를 선택해 주세요.');
			return false;
		}
		return true;
	});

	// 파일업로드
	$('.upload_pop_btn').click(function () {
		Popup.fileUpload('microsite_site');
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
			if (site_id.val() == '') {
				alert('site_id가 존재하지 않습니다.');
				return false;
			}

			var param = {
				site_ids : [ site_id.val() ]
			};

			$.ajax({
				url			:	'/microsite/site/delete.do'
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

	// 아이디 중복 체크
	if ($('.exist_btn').size() > 0) {
		$('.exist_btn').click(function () {
			if (site_id.val() == '') {
				alert('사이트명을 입력해 주세요.');
				return false;
			}

			var param = {
				site_id : site_id.val()
			};
			
			$.ajax({
				url			:	'/microsite/site/siteIdCheck.do'
				,type		:	'post'
				,data		:	$.param(param, true)
				,dataType	:	'json'
				,success	:	function (res) {
					if (res.success) {
						site_id_check.val(1);
						alert('사용 가능한 아이디입니다.');

					} else {
						site_id_check.val(0);
						alert('이미 존재하는 아이디입니다.');
					}
				}
				,error : function(data, status, err) {
					site_id_check.val(0);
					alert("사이트 아이디 조회가 실패 되었습니다.");
				}
			});
		});
	}

});
</script>
</head>
<body>

<form name="frm" method="POST" action="/microsite/site/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />

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
<c:if test="${not empty view.site_id }">
				<tr>
					<th scope="row">사이트 아이디</th>
					<td colspan="3">
						<input type="hidden" name="site_id" value="${view.site_id }" />
						<input type="hidden" name="site_id_check" value="1" />
						${view.site_id }
					</td>
				</tr>
				<tr>
					<th scope="row">등록자</th>
					<td>
						<c:out value="${view.user_id }" default="-" />
					</td>
					<th scope="row">등록일</th>
					<td>
						<c:out value="${view.reg_date }" default="-" />
					</td>
				</tr>
</c:if>
<c:if test="${empty view.site_id }">
				<tr>
					<th scope="row">사이트 아이디</th>
					<td colspan="3">
						<input type="text" name="site_id" value="${view.site_id }" maxlength="20" style="width:580px" />
						<input type="hidden" name="site_id_check" value="0" />
						<span class="btn whiteS"><a href="#" class="exist_btn">중복 체크</a></span>
					</td>
				</tr>
</c:if>
				<tr>
					<th scope="row">사이트명</th>
					<td colspan="3">
						<input type="text" name="site_name" value="${view.site_name }" maxlength="100" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">사이트 파비콘</th>
					<td colspan="3">
						<input type="text" name="site_img" value="${view.site_img }" maxlength="100" style="width:580px" />
						<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
						<div class="upload_pop_msg">(외부 이미지 URL 또는 12px * 12px 크기의 이미지를 선택해 주세요.)</div>
						<div class="upload_pop_img">
							<c:if test="${not empty view.site_img }">
								<img src="${view.site_img }" width="12" height="12" alt="" />
							</c:if>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">URL</th>
					<td colspan="3">
						<input type="text" name="url" value="${view.url }" maxlength="1000" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">내용</th>
					<td colspan="3">
						<textarea id="contents" name="description" maxlength="2000" style="width:100%;height:400px;"><c:out value="${view.description }" escapeXml="true" /></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td colspan="3">
						<label><input type="radio" name="approval" value="Y" ${view.approval eq 'Y' or empty view.approval ? 'checked="checked"' : '' } /> 승인</label>
						<label><input type="radio" name="approval" value="N" ${view.approval eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.site_id ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view.site_id }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/microsite/site/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>