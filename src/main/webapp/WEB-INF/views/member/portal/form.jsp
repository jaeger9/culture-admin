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
	zipcode : function (res) {
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

		$('input[name=zip_code]').val(res.zipcode);
		$('input[name=addr]').val(res.addr);
	}
};

$(function () {

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
	// nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	
	var frm					=	$('form[name=frm]');
	
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

	var addr_category		=	frm.find('input[name=addr_category]');
	var zip_code			=	frm.find('input[name=zip_code]');
	var addr				=	frm.find('input[name=addr]');

	var favor_portal_tmp	=	frm.find('input[name=favor_portal_tmp]');
	var favor_portal		=	frm.find('input[name=favor_portal]');
	
	frm.submit(function () {
		// frm.serialize()
		// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);

		tel.val( tel1.val() + '-' + tel2.val() + '-' + tel3.val() );
		hp.val( hp1.val() + '-' + hp2.val() + '-' + hp3.val() );
		email.val( email1.val() + '@' + email2.val() );

		if (favor_portal_tmp.filter(':checked').size() > 0) {
			var value = '';
			favor_portal_tmp.filter(':checked').each(function () {
				if (value == '') {
					value = $(this).val();
				} else {
					value = value + ',' + $(this).val();
				}
			});
			favor_portal.val(value);
		}

		return true;
	});

	// 등록/수정
	$('.insert_btn').click(function () {
		frm.submit();
		return false;
	});
	
	// 우편번호
	$('.post_btn').add(zip_code).add(addr).click(function () {
		var value = '63';

		if (addr_category.filter(':checked').size() > 0) {
			value = addr_category.filter(':checked').val();
		}
		
		if (value != '63' && value != '64') {
			value = '63';
		}

		/* if (value == '63') {
			Popup.zipcode();
		} else {
			Popup.zipcodeRoad();
		} */
		window.open('/popup/jusoPopup.do','postalcodePopup' , 'width=570, height=420, scrollbars=yes, resizable=yes');

		return false;
	});
	
	if ($('input[name=private_agreement_yn]').filter(':checked') == 0) {
		$('input[name=private_agreement_yn]:eq(0)').click(); // checked bug 있음
	}
	
	if ($('input[name=sec_cer_flag]').filter(':checked') == 0) {
		$('input[name=sec_cer_flag]:eq(0)').click(); // checked bug 있음
	}
	// init
	if ($('input[name=newsletter_yn]').filter(':checked') == 0) {
		$('input[name=newsletter_yn]:eq(0)').click(); // checked bug 있음
	}
	if ($('input[name=addr_category]').filter(':checked') == 0) {
		$('input[name=addr_category]:eq(0)').click(); // checked bug 있음
	}
	if ($('input[name=join_path]').filter(':checked') == 0) {
		$('input[name=join_path]:eq(0)').click(); // checked bug 있음
	}
	
});

//도로명주소 Open Api
function jusoCallBack(sido, gugun, addr, addr2, zipNo){	
	$('input[name=zip_code]').val(zipNo);	//우편번호
	$('input[name=addr]').val(addr);		//기본주소
	$('input[name=addr_detail]').val(addr2);		//상세주소
}
</script>
</head>
<body>

<form name="frm" method="POST" action="/member/portal/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="user_id" value="${view.user_id }" />

	<input type="hidden" name="tel" value="${view.tel }" />
	<input type="hidden" name="hp" value="${view.hp }" />
	<input type="hidden" name="email" value="${view.email }" />
	<input type="hidden" name="favor_portal" value="${view.favor_portal }" />

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
		<tr>
			<th scope="row">아이디</th>
			<td>
				${view.user_id }
			</td>
			<th scope="row">가입일</th>
			<td>
				<c:out value="${view.join_date }" default="-" />
			</td>
		</tr>
		<tr>
			<th scope="row">회원구분</th>
			<td>
				<c:choose>
					<c:when test="${view.member_category eq '1' }">일반회원</c:when>
					<c:when test="${view.member_category eq '2' }">어린이회원</c:when>
					<c:when test="${view.member_category eq '3' }">외국인회원</c:when>
				</c:choose>
			</td>
			<th scope="row">가입구분</th>
			<td>
				<c:choose>
					<c:when test="${view.join_category eq '1' }">
						실명인증
						(인증번호 : <c:out value="${view.member_key }" default="-" />)
					</c:when>
					<c:otherwise>I-PIN</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr>
			<th scope="row">이름</th>
			<td>
				${view.name }
			</td>
			<th scope="row">성별</th>
			<td>
				${view.sex eq 'M' ? '남자' : '여자' }
			</td>
		</tr>
		<tr>
			<th scope="row">출생년도</th>
			<td colspan="3">
				${view.birth_year }
			</td>
		</tr>
		<tr>
			<th scope="row">권한</th>
			<td >
				<select name="userRole">
					<c:forEach items="${userRoleList }" var="item">
						<option value="${item.value }" <c:if test="${view.role eq item.value}">selected</c:if>>${item.name}</option>
					</c:forEach>
				</select>
			</td>
			<th scope="row">마일리지</th>
			<td>
				${view.point } P
			</td>
		</tr>
<%-- 이쪽에 권한추가		<tr>
			<th scope="row">2단계 인증 사용 여부</th>
			<td colspan="3">
				<label><input type="radio" name="sec_cer_flag" value="Y" ${view.sec_cer_flag eq 'Y' ? 'checked="checked"' : '' } ${view.sec_cer_flag ne 'Y' ? 'disabled="disabled"' : '' }/> 사용</label>
				<label><input type="radio" name="sec_cer_flag" value="N" ${view.sec_cer_flag ne 'Y' ? 'checked="checked"' : '' } /> 미사용</label>
			</td>
		</tr> --%>
		<tr>
			<th scope="row">개인정보</br>재동의 여부</th>
			<td>
				<label><input type="radio" name="private_agreement_yn" value="Y" ${view.private_agreement_yn eq 'Y' ? 'checked="checked"' : '' } /> 동의</label>
				<label><input type="radio" name="private_agreement_yn" value="N" ${view.private_agreement_yn ne 'Y' ? 'checked="checked"' : '' } /> 미동의</label>
			</td>
			<th scope="row">재 동의일자</th>
			<td>
				${view.private_agreement_date }
			</td>
		</tr>
		<tr>
			<th scope="row">로그인 실패횟수</th>
			<td>
				${view.fail_cnt }
			</td>
			<th scope="row">비밀번호 변경일</th>
			<td>
				${view.pwd_chg_date }
			</td>
		</tr>
		<tr>
			<th scope="row">최종 로그인</th>
			<td>
				${view.login_date }
			</td>
			<th scope="row">최종 로그아웃</th>
			<td>
				${view.logout_date }
			</td>
		</tr>
		<%-- <tr>
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
		</tr> --%>
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
			<th scope="row">뉴스레터</th>
			<td colspan="3">
				<label><input type="radio" name="newsletter_yn" value="Y" ${view.newsletter_yn eq 'Y' ? 'checked="checked"' : '' } /> 수신</label>
				<label><input type="radio" name="newsletter_yn" value="N" ${view.newsletter_yn ne 'Y' ? 'checked="checked"' : '' } /> 미수신</label>
			</td>
		</tr>
		<tr>
			<th scope="row">거주지역</th>
			<td colspan="3">
				<select name="addr_sido">
					<option value="" <c:if test="${empty view.addr_sido}">selected="selected"</c:if>>- 선택 -</option>
					<option value="서울특별시" <c:if test="${view.addr_sido eq '서울특별시'}">selected="selected"</c:if>>서울특별시</option>
					<option value="부산광역시" <c:if test="${view.addr_sido eq '부산광역시'}">selected="selected"</c:if>>부산광역시</option>
					<option value="대구광역시" <c:if test="${view.addr_sido eq '대구광역시'}">selected="selected"</c:if>>대구광역시</option>
					<option value="인천광역시" <c:if test="${view.addr_sido eq '인천광역시'}">selected="selected"</c:if>>인천광역시</option>
					<option value="광주광역시" <c:if test="${view.addr_sido eq '광주광역시'}">selected="selected"</c:if>>광주광역시</option>
					<option value="대전광역시" <c:if test="${view.addr_sido eq '대전광역시'}">selected="selected"</c:if>>대전광역시</option>
					<option value="울산광역시" <c:if test="${view.addr_sido eq '울산광역시'}">selected="selected"</c:if>>울산광역시</option>
					<option value="세종특별자치시" <c:if test="${view.addr_sido eq '세종특별자치시'}">selected="selected"</c:if>>세종특별자치시</option>
					<option value="경기도" <c:if test="${view.addr_sido eq '경기도'}">selected="selected"</c:if>>경기도</option>
					<option value="강원도" <c:if test="${view.addr_sido eq '강원도'}">selected="selected"</c:if>>강원도</option>
					<option value="충청북도" <c:if test="${view.addr_sido eq '충청북도'}">selected="selected"</c:if>>충청북도</option>
					<option value="충청남도" <c:if test="${view.addr_sido eq '충청남도'}">selected="selected"</c:if>>충청남도</option>
					<option value="전라북도" <c:if test="${view.addr_sido eq '전라북도'}">selected="selected"</c:if>>전라북도</option>
					<option value="전라남도" <c:if test="${view.addr_sido eq '전라남도'}">selected="selected"</c:if>>전라남도</option>
					<option value="경상북도" <c:if test="${view.addr_sido eq '경상북도'}">selected="selected"</c:if>>경상북도</option>
					<option value="경상남도" <c:if test="${view.addr_sido eq '경상남도'}">selected="selected"</c:if>>경상남도</option>
					<option value="제주특별자치도" <c:if test="${view.addr_sido eq '제주특별자치도'}">selected="selected"</c:if>>제주특별자치도</option>
				</select>
			</td>
		</tr>
		</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">수정</a></span>
		<span class="btn gray"><a href="/member/portal/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>