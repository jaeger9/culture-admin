<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

	var frm			=	$('form[name=frm]')
	,vvm_seq		=	$('input[name=vvm_seq]')
	,vvi_seq		=	$('input[name=vvi_seq]')
	,vru_seq		=	$('input[name=vru_seq]')	
	,vru_url_efct	=	$('input[name=vru_url_efct]')
	,vru_type		=	$('select[name=vru_type]')
	,vru_title		=	$('input[name=vru_title]')
	,vru_url		=	$('input[name=vru_url]')

	,insert_btn			=	frm.find('.insert_btn')
	,close_btn			=	frm.find('.close_btn');

	frm.submit(function () {
		if (vru_title.val() == '') {
			vru_title.focus();
			alert('사이트명을 입력해 주세요.');
			return false;
		}
		if (vru_url.val() == '') {
			vru_url.focus();
			alert('사이트 URL을 입력해 주세요.');
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

<form name="frm" method="POST" action="/popup/artContent/site/form.do" enctype="multipart/form-data" style="padding:20px;">
<fieldset class="searchBox">
	<legend>등록</legend>

	<input type="hidden" name="vvi_seq" value="${paramMap.vvi_seq }" />
	<input type="hidden" name="vvm_seq" value="${paramMap.vvm_seq }" />
	<input type="hidden" name="vru_seq" value="${view.vru_seq }" />
	<input type="hidden" name="vru_url_efct" value="${empty view.vru_url_efct ? '0' : view.vru_url_efct }" />

	<div class="tableWrite">
		<table summary="게시판 글 검색">
		<caption>게시판 글 검색</caption>
		<colgroup>
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
		<tr>
			<th scope="row">파일형식</th>
			<td>
				<select name="vru_type">
					<option value="1">제목 링크</option>
					<option value="0" ${view.vru_type eq '0' ? 'selected="selected"' : '' }>주소 출력</option>
				</select>
			</td>
		</tr>
		<tr>
			<th scope="row">사이트명</th>
			<td>
				<input type="text" name="vru_title" value="${view.vru_title }" style="width:400px;" />
			</td>
		</tr>
		<tr>
			<th scope="row">사이트 URL</th>
			<td>
				<input type="text" name="vru_url" value="${view.vru_url }" style="width:400px;" />
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