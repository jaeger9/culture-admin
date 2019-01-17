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

		$('input[name=publisher]').val(res.orgCode);
		$('input[name=creator]').val(res.name);
	},
	userId : function (res) {
		if (res == null) {
			return false;
		}

		$('input[name=user_id]').val(res.user_id);
		$('input[name=user_id_check]').val(1);
	}
};

$(function () {

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
	// nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	
	var frm					=	$('form[name=frm]');
	var user_id				=	frm.find('input[name=user_id]');
	var user_id_check		=	frm.find('input[name=user_id_check]');
	var user_id_btn			=	$('.user_id_btn');

	var pwd					=	frm.find('input[name=pwd]');
	var name				=	frm.find('input[name=name]');
	
	var tel1				=	frm.find('select[name=tel1]');
	var tel2				=	frm.find('input[name=tel2]');
	var tel3				=	frm.find('input[name=tel3]');
	var tel					=	frm.find('input[name=tel]');
	
	var hp1					=	frm.find('select[name=hp1]');
	var hp2					=	frm.find('input[name=hp2]');
	var hp3					=	frm.find('input[name=hp3]');
	var hp					=	frm.find('input[name=hp]');
	
	var email1				=	frm.find('input[name=email1]');
	var email2				=	frm.find('input[name=email2]');
	var email				=	frm.find('input[name=email]');

	var publisher			=	frm.find('input[name=publisher]');
	var creator				=	frm.find('input[name=creator]');
	var publisher_btn		=	$('.publisher_btn');
	
	frm.submit(function () {
		// frm.serialize()
		// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);

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
		if (pwd.val() == '') {
			pwd.focus();
			alert('비밀번호를 입력해 주세요.');
			return false;
		}
</c:if>
		if (name.val() == '') {
			name.focus();
			alert('이름을 입력해 주세요.');
			return false;
		}

		if (tel2.val() == '' || tel3.val() == '') {
			tel2.focus();
			alert('전화번호를 입력해 주세요.');
			return false;
		}

		if (hp2.val() == '' || hp3.val() == '') {
			hp2.focus();
			alert('휴대폰번호를 입력해 주세요.');
			return false;
		}

		if (email1.val() == '' || email2.val() == '') {
			email1.focus();
			alert('이메일을 입력해 주세요.');
			return false;
		}

		tel.val( tel1.val() + '-' + tel2.val() + '-' + tel3.val() );
		hp.val( hp1.val() + '-' + hp2.val() + '-' + hp3.val() );
		email.val( email1.val() + '@' + email2.val() );

		return true;
	});

	user_id.keypress(function (e) {
		user_id_check.val(0);
	});

	// 아이디 중복
	user_id_btn.click(function () {
		Popup.userId( user_id.val() );
		return false;
	});
	
	// 출처
	publisher_btn.add(creator).click(function () {
		Popup.uciOrg();
		return false;
	});
	
	// 등록/수정
	$('.insert_btn').click(function () {
		frm.submit();
		return false;
	});

});
</script>
</head>
<body>

<form name="frm" method="POST" action="/member/agent/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />

	<input type="hidden" name="tel" value="${view.tel }" />
	<input type="hidden" name="hp" value="${view.hp }" />
	<input type="hidden" name="email" value="${view.email }" />

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
			<th scope="row">가입일</th>
			<td>
				<c:out value="${view.join_date }" default="-" />
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
				<input type="password" name="pwd" value="" style="width:150px;" />
<c:if test="${not empty view }">
				<span style="padding-left:5px;color:#999;font-size:11px;">(비밀번호 미입력 시 기존 비밀번호로 유지됩니다.)</span>
</c:if>
			</td>
		</tr>
		<tr>
			<th scope="row">이름</th>
			<td colspan="3">
				<input type="text" name="name" value="${view.name }" style="width:150px;" />
			</td>
		</tr>
		<tr>
			<th scope="row">성별</th>
			<td colspan="3">
				<label><input type="radio" name="sex" value="M"  ${view.sex ne 'F' ? 'checked="checked"' : '' } /> 남성</label>
				<label><input type="radio" name="sex" value="F" ${view.sex eq 'F' ? 'checked="checked"' : '' } /> 여성</label>
			</td>
		</tr>
		<tr>
			<th scope="row">전화번호</th>
			<td colspan="3">
				<select name="tel1">
					<c:forEach items="${telList }" var="item">
						<option value="${item.value }" ${view.tel1 eq item.value ? 'selected="selected"' : '' }>${item.name }</option>
					</c:forEach>
				</select>
				-
				<input type="text" name="tel2" value="${view.tel2 }" maxlength="4" style="width:50px;" />
				-
				<input type="text" name="tel3" value="${view.tel3 }" maxlength="4" style="width:50px;" />
			</td>
		</tr>
		<tr>
			<th scope="row">휴대폰번호</th>
			<td colspan="3">
				<select name="hp1">
					<c:forEach items="${phoneList }" var="item">
						<option value="${item.value }" ${view.hp1 eq item.value ? 'selected="selected"' : '' }>${item.name }</option>
					</c:forEach>
				</select>
				-
				<input type="text" name="hp2" value="${view.hp2 }" maxlength="4" style="width:50px;" />
				-
				<input type="text" name="hp3" value="${view.hp3 }" maxlength="4" style="width:50px;" />
			</td>
		</tr>
		<tr>
			<th scope="row">E-MAIL</th>
			<td colspan="3">
				<input type="text" name="email1" value="${view.email1 }" style="width:150px;" />
				@
				<input type="text" name="email2" value="${view.email2 }" style="width:150px;" />

				<select name="email3">
					<option value="">직접입력</option>
					<c:forEach items="${mailList }" var="item">
						<option value="${item.value }" ${view.email2 eq item.value ? 'selected="selected"' : '' }>${item.name }</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th scope="row">권한</th>
			<td colspan="3">
				<label><input type="radio" name="auth" value="1" ${view.auth eq 1 ? 'checked="checked"' : '' } /> 기관회원</label>
				<label><input type="radio" name="auth" value="2" ${view.auth eq 2 ? 'checked="checked"' : '' } /> 교육관리자</label>
				<label><input type="radio" name="auth" value="3" ${view.auth eq 3 ? 'checked="checked"' : '' } /> 시설관리자</label>
			</td>
		</tr>
		<tr>
			<th scope="row">기관</th>
			<td colspan="3">
				<input type="hidden" name="publisher" value="${view.publisher }" />
				<input type="text" name="creator" value="${view.creator }" readonly="readonly" style="width:580px" />
				<span class="btn whiteS"><a href="#" class="publisher_btn">기관</a></span>
			</td>
		</tr>
		<tr>
			<th scope="row">기관명 직접입력</th>
			<td colspan="3">
				<input type="text" name="org_nm" value="${view.org_nm }" style="width:150px;" />
			</td>
		</tr>
		</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.user_id ? '등록' : '수정' }</a></span>
		<span class="btn gray"><a href="/member/agent/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>