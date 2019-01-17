<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

var callback = {
	adminId : function (res) {
		if (res == null) {
			return false;
		}

		$('input[name=user_id]').val(res.user_id);
		$('input[name=user_id_check]').val(1);		
	}
};

$(function () {

	var frm					=	$('form[name=frm]');
	var user_id				=	frm.find('input[name=user_id]');
	var user_id_check		=	frm.find('input[name=user_id_check]');
	var user_id_btn			=	$('.user_id_btn');
	var password			=	frm.find('input[name=password]');
	var name				=	frm.find('input[name=name]');
	var tel					=	frm.find('input[name=tel]');
	var email				=	frm.find('input[name=email]');
	var description			=	frm.find('input[name=description]');
	var active				=	frm.find('input[name=active]');
	var role_ids			=	frm.find('input[name=role_ids]');
	
	frm.submit(function () {
		if (user_id.val() == '') {
			user_id.focus();
			alert('아이디를 입력해 주세요.');
			return false;
		}
		if (user_id_check.val() != 1) {
			user_id.focus();
			alert('아이디 중복 검사를 해주세요.');
			return false;
		}
<c:if test="${empty view }">
		if (password.val() == '') {
			password.focus();
			alert('비밀번호를 입력해 주세요.');
			return false;
		}
</c:if>
		if (name.val() == '') {
			name.focus();
			alert('이름을 입력해 주세요.');
			return false;
		}
		if (active.filter(':checked').size() == 0) {
			active.eq(0).focus();
			alert('승인 여부를 선택해 주세요.');
			return false;
		}
		if (role_ids.filter(':checked').size() == 0) {
			if (!confirm('관리자 권한을 1개 이상 지정하지 않으실 경우 해당 계정으로 로그인 할 수 없게됩니다.\r\n동의하시겠습니까?')) {
				return false;
			}
		}
		return true;
	});

	user_id.keypress(function (e) {
		user_id_check.val(0);
	});

	// 아이디 중복
	user_id_btn.click(function () {
		Popup.adminId( user_id.val() );
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
			if (!confirm('삭제하시겠습니까?')) {
				return false;
			}
			if (user_id.size() == 0) {
				alert('선택된 항목이 없습니다.');
				return false;
			}

			var param = {
				user_ids : [ user_id.val() ]
			};

			$.ajax({
				url			:	'/admin/member/delete.do'
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

<form name="frm" method="POST" action="/admin/member/form.do" enctype="multipart/form-data">
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
			<th scope="row">아이디</th>
			<td>
				<input type="hidden" name="user_id_check" value="1" />
				<input type="hidden" name="user_id" value="${view.user_id }" />

				${view.user_id }
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
				<input type="hidden" name="user_id_check" value="0" />
				<input type="text" name="user_id" value="${view.user_id }" style="width:150px;" />

				<span class="btn whiteS"><a href="#" class="user_id_btn">아이디 중복</a></span>
			</td>
		</tr>
</c:if>
		<tr>
			<th scope="row">비밀번호</th>
			<td colspan="3">
				<input type="password" name="password" value="" style="width:150px;" />
<c:if test="${not empty view }">
				<span style="padding-left:5px;color:#999;font-size:11px;">(비밀번호 미입력 시 기존 비밀번호로 유지됩니다.)</span>
</c:if>
			</td>
		</tr>
		<tr>
			<th scope="row">이름</th>
			<td colspan="3">
				<input type="text" name="name" value="${view.name }" maxlength="10" style="width:150px;" />
			</td>
		</tr>
		<tr>
			<th scope="row">전화번호</th>
			<td colspan="3">
				<input type="text" name="tel" value="${view.tel }" maxlength="20" style="width:150px;" />
			</td>
		</tr>
		<tr>
			<th scope="row">E-MAIL</th>
			<td colspan="3">
				<input type="text" name="email" value="${view.email }" maxlength="200" style="width:300px;" />
			</td>
		</tr>
		<tr>
			<th scope="row">설명</th>
			<td colspan="3">
				<input type="text" name="description" value="${view.description }" maxlength="200" style="width:670px;" />
			</td>
		</tr>
		<tr>
			<th scope="row">승인여부</th>
			<td colspan="3">
				<label><input type="radio" name="active" value="Y" ${view.active eq 'Y' or empty view.active ? 'checked="checked"' : '' } /> 승인</label>
				<label><input type="radio" name="active" value="N" ${view.active eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
			</td>
		</tr>
		<tr>
			<th scope="row">권한</th>
			<td colspan="3">
				<c:forEach items="${adminRoleList }" var="item" varStatus="status">
					<label><input type="checkbox" name="role_ids" value="${item.role_id }" ${item.approval eq 'Y' ? 'checked="checked"' : '' } /> ${item.name }</label>
				</c:forEach>
			</td>
		</tr>
		</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.user_id ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/admin/member/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>