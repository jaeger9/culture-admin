<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

var fileTarget = null;
var fileView = null;

var callback = {
	fileUpload : function (res) {
		// res.full_file_path
		// res.file_path
		if (fileTarget != null) {
			fileTarget.val(res.file_path);
			fileView.html('<a href="/upload/customer/openapi/' + res.file_path + '" target="_blank">' + res.file_path + '</a>');
		}
	}
};

$(function () {

	var template		=	$('#template');
	var operation		=	$('#operation');
	var empty			=	$('#empty');
	var frm				=	$('form[name=frm]');
	var delete_ids		=	frm.find('input[name=delete_ids]');
	var add_btn			=	$('.add_btn');
	var insert_btn		=	$('.insert_btn');

	frm.submit(function () {
		var valid = true;

		operation.find('> div').each(function () {
			var name	=	$(this).find('input[name=name]');
			var format	=	$(this).find('input[name=format]');
			var url		=	$(this).find('input[name=url]');

			if (name.val() == '') {
				name.focus();
				valid = false;
				alert('오러레이션명을 입력해 주세요.');
				return false;
			}
			if (format.val() == '') {
				format.focus();
				valid = false;
				alert('전송 방식을 입력해 주세요.');
				return false;
			}
			if (url.val() == '') {
				url.focus();
				valid = false;
				alert('URL을 입력해 주세요.');
				return false;
			}
		});
		return valid;
	});
	
	// 파일업로드
	$(document).on('click', '.upload_pop_btn', function () {
		fileTarget = $(this).parent().parent().find('input[name=filename]');
		fileView = $(this).parent().parent().find('.fileView');
		
		Popup.fileUpload('customer_openapi');
		return false;
	});
	
	// 삭제
	$(document).on('click', '.item_delete', function () {
		var p = $(this).parents('div.ids:eq(0)');
		var id = p.find('input[name=id]').val();

		if (id != '') {
			if (delete_ids.val() == '') {
				delete_ids.val( id );				
			} else {
				delete_ids.val( delete_ids.val() + ',' + id );
			}
		}

		p.remove();

		if (operation.find('div.ids').size() == 0) {
			empty.show();
		} else {
			empty.hide();
		}

		return false;
	});

	// 추가
	add_btn.click(function () {
		operation.append( template.html() );
		operation.find('> div:last-child').find('span.index').text( operation.find('> div').size() );

		if (operation.find('div.ids').size() == 0) {
			empty.show();
		} else {
			empty.hide();
		}

		return false;
	});

	insert_btn.click(function () {
		frm.submit();
		return false;
	});

	// 초기 미등록 시
	if (operation.find('div.ids').size() == 0) {
		empty.show();
	} else {
		empty.hide();
	}
});
</script>
</head>
<body>

<div id="template" style="display:none;">
	<div class="ids">
		<input type="hidden" name="openapi_id" value="${paramMap.openapi_id }" />
		<input type="hidden" name="id" value="" />

		<p>
			<span class="name">번호</span>
			<span class="index">0</span>
		</p>
		<p>
			<span class="name">오퍼레이션</span>
			<input type="text" name="name" value="" />
		</p>
		<p>
			<span class="name">서비스</span>
			<input type="text" name="description" value="" />
		</p>
		<p>		
			<span class="name">전송방식</span>
			<input type="text" name="format" value="" />
		</p>
		<p>
			<span class="name">URL</span>
			<input type="text" name="url" value="" />
		</p>
		<p>
			<span class="name">가이드</span>
			<input type="text" name="filename" value="" style="width:610px;" />
			<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
			<span class="fileView">
				(파일을 선택해 주세요.)
			</span>
		</p>

		<div class="btns">
			<a href="#" class="item_delete">삭제</a>
		</div>
	</div>
</div>

<form name="frm" method="POST" action="/customer/openapi/operation.do" enctype="multipart/form-data">
<input type="hidden" name="openapi_id_temp" value="${paramMap.openapi_id }" />
<input type="hidden" name="delete_ids" value="" />

<div id="empty" style="display:none;">
	등록된 오퍼레이션이 없습니다.
</div>

<div id="operation">

	<c:forEach items="${list }" var="item" varStatus="status">
	<div class="ids">
		<input type="hidden" name="openapi_id" value="${item.openapi_id }" />
		<input type="hidden" name="id" value="${item.id }" />

		<p>
			<span class="name">번호</span>
			<span class="index">${status.count } (${item.id })</span>
		</p>
		<p>
			<span class="name">오퍼레이션</span>
			<input type="text" name="name" value="${item.name }" />
		</p>
		<p>
			<span class="name">서비스</span>
			<input type="text" name="description" value="${item.description }" />
		</p>
		<p>		
			<span class="name">전송방식</span>
			<input type="text" name="format" value="${item.format }" />
		</p>
		<p>
			<span class="name">URL</span>
			<input type="text" name="url" value="${item.url }" />
		</p>
		<p>
			<span class="name">가이드</span>
			<input type="text" name="filename" value="${item.filename }" style="width:610px;" />
			<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
			<span class="fileView">
				<c:if test="${not empty item.filename }">
					<a href="/upload/customer/openapi/${item.filename }" target="_blank">${item.filename }</a>
				</c:if>
				<c:if test="${empty item.filename }">
					(파일을 선택해 주세요.)
				</c:if>
			</span>
		</p>

		<div class="btns">
			<a href="#" class="item_delete">삭제</a>
		</div>
	</div>
	</c:forEach>	

</div>
</form>

<div class="btnBox textRight">
	<span class="btn white"><a href="#" class="add_btn">추가</a></span>
	<span class="btn white"><a href="#" class="insert_btn">등록</a></span>
	<span class="btn gray"><a href="/customer/openapi/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
</div>

</body>
</html>