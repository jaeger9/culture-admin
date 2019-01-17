<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<style>
	.category-title {padding-left:10px;padding-bottom:10px;font-weight:bold;color:#444;font-size:1.2em;}

	.close-div {position:absolute;overflow:hidden;background:#444;top:610px;width:500px;height:20px;}
	.close-div span {float:right;}
	.close-div span a {color:#fff;font-weight:bold;font-size:14px;}
	.close-div span a:hover {text-decoration:none;}
</style>
<script type="text/javascript">
	$(function () {
		
		var frm = $('form[name=frm]');
		
		$('div.close-div span a').click(function () {
			window.close();
			return false;
		});
		
		frm.submit(function() {
			if ($('[name=category_nm]').val() == '') {
				alert('주제를 입력해 주세요');
				$('[name=category_nm]').focus();
				return false;
			}
			return true;
		});
		
		//수정 , 삭제 , 등록 
		$('div.btnBox > span > button').each(function() {
			$(this).click(function() {
				console.log($(this).html());
				if ($(this).html() == '수정') {
					if (!confirm('수정하시겠습니까?')) {
						return false;
					}
					frm.attr('action', 'categoryUpdate.do');
					frm.submit();
				} else if ($(this).html() == '삭제') {
					if (!confirm('삭제 하시겠습니까?')) {
						return false;
					}
					frm.attr('action', 'categoryDelete.do');
					frm.submit();
				} else if ($(this).html() == '등록') {
					if (!confirm('등록하시겠습니까?')) {
						return false;
					}
					frm.attr('action', 'categoryInsert.do');
					frm.submit();
				} else if ($(this).html() == '목록') {
					$(location).attr('href','categoryList.do');
				}
			});
		});
		
	});
</script>
</head>
<body>

<form name="frm" method="post" action="categoryInsert.do" style="padding:20px;">
<c:if test='${not empty view.seq}'>
	<input type="hidden" name="seq" value="${view.seq}"/>
</c:if>
	<div>
		<h3 class="category-title">문화 이슈 카테고리</h3>
	</div>

	<!-- table list -->
	<div class="tableWrite">
		<table summary="문화 이슈 카테고리 등록">
			<caption>문화 이슈 카테고리 등록</caption>
			<colgroup>
				<col width="25%"/>
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">주제</th>
					<td><input type="text" name="category_nm" style="width:300px;" value="${view.category_nm }"/></td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div class="btnBox textRight">
		<c:if test='${not empty view}'>
			<span class="btn white"><button type="button">수정</button></span>
			<span class="btn white"><button type="button">삭제</button></span>
		</c:if>
		<c:if test='${empty view }'>
			<span class="btn white"><button type="button">등록</button></span>
		</c:if>
		<span class="btn gray"><button type="button">목록</button></span>
	</div>
</form>

<div class="close-div"><span><a href="#">닫기</a></span></div>

</body>
</html>