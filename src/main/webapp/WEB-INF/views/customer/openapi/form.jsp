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
	uciOrg : function (res) {
		/*
			JSON.stringify(res) = {
				"cateType"	:	"F"
				,"orgCode"	:	"NLKF02"
				,"orgId"	:	86
				,"category"	:	"도서"
				,"name"		:	"국립중앙도서관"
			}
		*/
		if (res == null) {
			return false;
		}

		$('input[name=org_code]').val(res.orgCode);
		$('input[name=category]').val(res.category);
	}
};

$(function () {

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
	// nhn.husky.EZCreator.createInIFrame( oEditorsOption );

	var frm			=	$('form[name=frm]');
	var id			=	frm.find('input[name=id]');
	var category	=	frm.find('input[name=category]');
	var org_code	=	frm.find('input[name=org_code]');
	var name		=	frm.find('input[name=name]');

	frm.submit(function () {
		// frm.serialize()
		// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);

		if (id.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		if (category.val() == '' || org_code.val() == '') {
			category.focus();
			alert('분야를 선택해 주세요.');
			return false;
		}
		if (name.val() == '') {
			name.focus();
			alert('기관명을 입력해 주세요.');
			return false;
		}
		return true;
	});

	// 분야
	$('.category_btn').add(category).click(function () {
		Popup.uciOrg();
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
			if (id.val() == '') {
				alert('id가 존재하지 않습니다.');
				return false;
			}

			var param = {
				ids : [ id.val() ]
			};

			$.ajax({
				url			:	'/customer/openapi/delete.do'
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

<form name="frm" method="POST" action="/customer/openapi/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="id" value="${view.id }" />

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
<c:if test="${not empty view.id }">
				<tr>
					<th scope="row">고유번호</th>
					<td>
						${view.id }
					</td>
					<th scope="row">등록일</th>
					<td>
						<c:out value="${view.create_date }" default="-" />
					</td>
				</tr>
</c:if>
				<tr>
					<th scope="row">분야</th>
					<td colspan="3">
						<input type="hidden" name="org_code" value="${view.org_code }" />
						<input type="text" name="category" value="${view.category }" readonly="readonly" style="width:580px" />
						<span class="btn whiteS"><a href="#" class="category_btn">출처</a></span>
					</td>
				</tr>
				<tr>
					<th scope="row">기관명</th>
					<td colspan="3">
						<input type="text" name="name" value="${view.name }" style="width:670px" />
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.id ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view.id }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/customer/openapi/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>