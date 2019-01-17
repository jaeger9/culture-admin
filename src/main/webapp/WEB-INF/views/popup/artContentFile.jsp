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
	,vvi_seq			=	frm.find('input[name=vvi_seq]')
	,vvm_seq			=	frm.find('input[name=vvm_seq]')
	,vmi_seq			=	frm.find('input[name=vmi_seq]')
	,vmi_title			=	frm.find('input[name=vmi_title]')
	,vmi_mime_type		=	frm.find('select[name=vmi_mime_type]')
	,vmi_prn_pos		=	frm.find('select[name=vmi_prn_pos]')
	,vmi_file			=	frm.find('input[name=vmi_file]')
	,vmi_file_sub		=	frm.find('input[name=vmi_file_sub]')
	,vmi_adult_chk		=	frm.find('input[name=vmi_adult_chk]')
	,vmi_new_chk		=	frm.find('input[name=vmi_new_chk]')

	,insert_btn			=	frm.find('.insert_btn')
	,close_btn			=	frm.find('.close_btn');

	frm.submit(function () {
		if (vmi_title.val() == '') {
			vmi_title.focus();
			alert('내용을 입력해 주세요.');
			return false;
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

<form name="frm" method="POST" action="/popup/artContent/file/form.do" enctype="multipart/form-data" style="padding:20px;">
<fieldset class="searchBox">
	<legend>등록</legend>

	<input type="hidden" name="vvi_seq" value="${paramMap.vvi_seq }" />
	<input type="hidden" name="vvm_seq" value="${paramMap.vvm_seq }" />
	<input type="hidden" name="vmi_seq" value="${view.vmi_seq }" />

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
				<select name="vmi_mime_type">
					<option value="TEXT">TEXT</option>
					<option value="MULTIPART"	${view.vmi_mime_type eq 'MULTIPART'		? 'selected="selected"' : '' }>MULTIPART</option>
					<option value="MESSAGE"		${view.vmi_mime_type eq 'MESSAGE'		? 'selected="selected"' : '' }>MESSAGE</option>
					<option value="APPLICATION"	${view.vmi_mime_type eq 'APPLICATION'	? 'selected="selected"' : '' }>APPLICATION</option>
					<option value="IMAGE"		${view.vmi_mime_type eq 'IMAGE'			? 'selected="selected"' : '' }>IMAGE</option>
					<option value="AUDIO"		${view.vmi_mime_type eq 'AUDIO'			? 'selected="selected"' : '' }>AUDIO</option>
					<option value="VIDEO"		${view.vmi_mime_type eq 'VIDEO'			? 'selected="selected"' : '' }>VIDEO</option>
					<option value="MODEL"		${view.vmi_mime_type eq 'MODEL'			? 'selected="selected"' : '' }>MODEL</option>
				</select>
			</td>
			<th scope="row">표현방식</th>
			<td>
				<select name="vmi_prn_pos">
					<option value="0"	${view.vmi_prn_pos eq '0' ? 'selected="selected"' : '' }>화면출력</option>
					<option value="4"	${view.vmi_prn_pos eq '4' ? 'selected="selected"' : '' }>링크만 출력</option>
				</select>
			</td>
		</tr>
		<tr>
			<th scope="row">19세 이상</th>
			<td>
				<input type="checkbox" name="vmi_adult_chk" value="Y"	${view.vmi_adult_chk eq 'Y' ? 'checked="checked"' : '' } />
			</td>
			<th scope="row">신규</th>
			<td>
				<input type="checkbox" name="vmi_new_chk" value="Y"		${view.vmi_new_chk eq 'Y' ? 'checked="checked"' : '' } />
			</td>
		</tr>
		<tr>
			<th scope="row">내용</th>
			<td colspan="3">
				<input type="text" name="vmi_title" value="${view.vmi_title }" style="width:400px;" />
			</td>
		</tr>
		<tr>
			<th scope="row">첨부파일 1</th>
			<td colspan="3">
				<input type="file" name="vmi_file" value="" class="inp_file" style="width:400px;" />
			</td>
		</tr>
		<tr>
			<th scope="row">첨부파일 2</th>
			<td colspan="3">
				<input type="file" name="vmi_file_sub" value="" class="inp_file" style="width:400px;" />
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