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
	,acm_cls_cd			=	frm.find('input[name=acm_cls_cd]')
	,act_title			=	frm.find('input[name=act_title]')
	,acs_contents		=	frm.find('textarea[name=acs_contents]')

	,insert_btn			=	frm.find('.insert_btn')
	,close_btn			=	frm.find('.close_btn')
	;

	frm.submit(function () {
		if (act_title.val() == '') {
			act_title.focus();
			alert('제목을 입력해 주세요.');
			return false;
		}
		if (acs_contents.val() == '') {
			acs_contents.focus();
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

<form name="frm" method="POST" action="/popup/archive/content/form.do" enctype="multipart/form-data" style="padding:20px;">
<fieldset class="searchBox">
	<legend>등록</legend>

	<input type="hidden" name="acm_cls_cd" value="${paramMap.acm_cls_cd }" />

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
			<th scope="row">제목</th>
			<td colspan="3">
				<input type="text" name="act_title" value="" style="width:400px;" />
			</td>
		</tr>
		<tr>
			<th scope="row">내용</th>
			<td colspan="3">
				<textarea name="acs_contents" style="width:400px; height:150px"></textarea>
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