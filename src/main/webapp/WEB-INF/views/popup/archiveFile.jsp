<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

	var frm				=	$('form[name=frm]')
	,file_type			=	frm.find('input[name-file_type]')
	,amd_mime_type		=	frm.find('select[name=amd_mime_type]')
	,amd_title			=	frm.find('input[name=amd_title]')

	,insert_btn			=	frm.find('.insert_btn')
	,close_btn			=	frm.find('.close_btn');

	frm.submit(function () {
		if (amd_title.val() == '') {
			amd_title.focus();
			alert('내용을 입력해 주세요.');
			return false;
		}

		if ("APPLICATION" == amd_mime_type.val()) {
		    file_type.val("p");
		} else if ("IMAGE" == amd_mime_type.val()) {
			file_type.val("i");
		} else if ("AUDIO" == amd_mime_type.val()) {
		    file_type.val("a");
		} else if ("VIDEO" == amd_mime_type.val()) {
			file_type.val("v");
		}
		
		return true;
	});

	insert_btn.click(function () {
		frm.submit();
	});

	close_btn.click(function () {
		window.close();
		return false;
	});

});
</script>
</head>
<body>

<form name="frm" method="POST" action="/popup/archive/file/form.do" enctype="multipart/form-data" style="padding:20px;">
<fieldset class="searchBox">
	<legend>등록</legend>

	<input type="hidden" name="acm_cls_cd" value="${paramMap.acm_cls_cd }" />
	<input type="hidden" name="file_type" value="p" />

	<div class="tableWrite">
		<table summary="게시판 글 검색">
		<caption>게시판 글 검색</caption>
		<colgroup>
			<col style="width:15%" />
			<col style="width:35%" />
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
		<tr>
			<th scope="row">파일형식</th>
			<td>
				<select name="amd_mime_type">
					<option value="APPLICATION">APPLICATION</option>
					<option value="IMAGE">IMAGE</option>
					<option value="AUDIO">AUDIO</option>
					<option value="VIDEO">VIDEO</option>
				</select>
			</td>
			<th scope="row">19세 이상</th>
			<td>
				<input type="checkbox" name="amd_adult_chk" value="Y" />
			</td>
		</tr>
		<tr>
			<th scope="row">내용</th>
			<td colspan="3">
				<input type="text" name="amd_title" style="width:400px;" />
			</td>
		</tr>
		<tr>
			<th scope="row">첨부파일 1</th>
			<td colspan="3">
				<input type="file" name="amd_file" value="" class="inp_file" style="width:400px;" />
			</td>
		</tr>
		<tr>
			<th scope="row">첨부파일 2</th>
			<td colspan="3">
				<input type="file" name="amd_file_sub" value="" class="inp_file" style="width:400px;" />
			</td>
		</tr>
		</tbody>
		</table>
	</div>
</fieldset>

<div class="btnBox textRight">
	<span class="btn gray"><a href="#" class="insert_btn">등록</a></span>
	<span class="btn dark"><a href="#" class="close_btn">닫기</a></span>
</div>
</form>

</body>
</html>