<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

var callback = {
	roleId : function (res) {
		if (res == null) {
			return false;
		}

		$('input[name=role_id]').val(res.role_id);
		$('input[name=role_id_check]').val(1);		
	}
};

$(function () {

	var frm					=	$('form[name=frm]');
	var role_id				=	frm.find('input[name=role_id]');
	var role_id_check		=	frm.find('input[name=role_id_check]');
	var role_id_btn			=	$('.role_id_btn');
	var name				=	frm.find('input[name=name]');
	var description			=	frm.find('input[name=description]');
	
	frm.submit(function () {
		if (role_id.val() == '') {
			role_id.focus();
			alert('아이디를 입력해 주세요.');
			return false;
		}
		if (role_id_check.val() != 1) {
			role_id.focus();
			alert('아이디 중복 검사를 해주세요.');
			return false;
		}
		if (name.val() == '') {
			name.focus();
			alert('이름을 입력해 주세요.');
			return false;
		}
		return true;
	});

	role_id.keypress(function (e) {
		role_id_check.val(0);
	});

	// 아이디 중복
	role_id_btn.click(function () {
		Popup.roleId( role_id.val() );
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
			if (!confirm('권한을 삭제할 경우\r\n해당 권한으로 설정된 모든 관리자 계정의 권한과\r\nURL에 설정된 권한 또한 삭제됩니다.\r\n이로인해 몇몇 관리자는 로그인을 사용할 수 없게 될 수 있으며 관리자 권한을 재설정해주셔야 될 수 있습니다.\r\n삭제하시겠습니까?')) {
				return false;
			}
			if (role_id.size() == 0) {
				alert('선택된 항목이 없습니다.');
				return false;
			}

			var param = {
				role_ids : [ role_ids.val() ]
			};

			$.ajax({
				url			:	'/admin/role/delete.do'
				,type		:	'post'
				,data		:	$.param(param, true)
				,dataType	:	'json'
				,success	:	function (res) {
					if (res.success) {
						alert("삭제가 완료 되었습니다.");
						location.reload();
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

<form name="frm" method="POST" action="/admin/role/form.do" enctype="multipart/form-data">
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
			<th scope="row">권한 아이디</th>
			<td>
				<input type="hidden" name="role_id_check" value="1" />
				<input type="hidden" name="role_id" value="${view.role_id }" />

				${view.role_id }
			</td>
			<th scope="row">최종 수정일</th>
			<td>
				<c:out value="${view.modify_date }" default="-" />
			</td>
		</tr>
</c:if>
<c:if test="${empty view }">
		<tr>
			<th scope="row">아이디</th>
			<td colspan="3">
				<input type="hidden" name="role_id_check" value="0" />
				<input type="text" name="role_id" value="${view.role_id }" style="width:150px;" />

				<span class="btn whiteS"><a href="#" class="role_id_btn">아이디 중복</a></span>
			</td>
		</tr>
</c:if>
		<tr>
			<th scope="row">이름</th>
			<td colspan="3">
				<input type="text" name="name" value="${view.name }" maxlength="10" style="width:150px;" />
			</td>
		</tr>
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
		<span class="btn white"><a href="#" class="insert_btn">${empty view.role_id ? '등록' : '수정' }</a></span>
		<span class="btn gray"><a href="/admin/role/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>