<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

	var frm					=	$('form[name=frm]');
	var url_id				=	frm.find('input[name=url_id]');
	var url_string			=	frm.find('input[name=url_string]');
	var description			=	frm.find('input[name=description]');

	// frm.submit(function () {return true;});

	// 신규 등록
	$('.new_btn').click(function () {
		location.href = '/admin/url/form.do';
		return false;
	});
	
	// 등록/수정
	$('.insert_btn').click(function () {
		if (url_string.size() == 0) {
			if (url_string.val() == '') {
				url_string.focus();
				alert('URL을 입력해 주세요.');
				return false;
			}

			if (description.val() == '') {
				description.focus();
				alert('URL 설명을 입력해 주세요.');
				return false;
			}

			$.post('/admin/url/existUrl.do', {
				url_string : url_string.val()
			}, function (data) {
				if (data.success) {
					alert('이미 존재하는 URL입니다.');
					return false;
				} else {
					frm.submit();
				}
			}).fail(function() {
				alert('URL 중복 체크가 실패했습니다.');
			});

		} else {
			if (description.val() == '') {
				description.focus();
				alert('URL 설명을 입력해 주세요.');
				return false;
			}

			frm.submit();
		}
		return false;
	});

	// 삭제
	if ($('.delete_btn').size() > 0) {
		$('.delete_btn').click(function () {
			if (!confirm('삭제하시겠습니까?')) {
				return false;
			}
			if (url_id.size() == 0) {
				alert('선택된 항목이 없습니다.');
				return false;
			}

			var param = {
				url_ids : [ url_id.val() ]
			};

			$.ajax({
				url			:	'/admin/url/delete.do'
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

<form name="frm" method="POST" action="/admin/url/form.do" enctype="multipart/form-data">
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
<c:if test="${not empty view }">
		<tr>
			<th scope="row">URL 아이디</th>
			<td>
				${view.url_id }
			</td>
			<th scope="row">최종 수정일</th>
			<td>
				<c:out value="${view.modify_date }" default="-" />
			</td>
		</tr>
		<tr>
			<th scope="row">URL</th>
			<td colspan="3">
				<input type="hidden" name="url_id" value="${view.url_id }" />
				${view.url_string }
			</td>
		</tr>
</c:if>
<c:if test="${empty view }">
		<tr>
			<th scope="row">URL</th>
			<td colspan="3">
				<input type="hidden" name="url_id" value="" />
				<input type="text" name="url_string" value="" maxlength="200" style="width:670px;" />
			</td>
		</tr>
</c:if>
		<tr>
			<th scope="row">설명</th>
			<td colspan="3">
				<input type="text" name="description" value="${view.description }" maxlength="200" style="width:670px;" />
			</td>
		</tr>
		</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<c:if test="${not empty view.url_id }">
			<span class="btn white"><a href="#" class="new_btn">신규등록</a></span>
		</c:if>
		<span class="btn white"><a href="#" class="insert_btn">${empty view.url_id ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/admin/url/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>