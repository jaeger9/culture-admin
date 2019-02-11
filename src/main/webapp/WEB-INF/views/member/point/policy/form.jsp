<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
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
	var policy_name				=	frm.find('input[name=policy_name]');
	var mileage_point = frm.find("input[name=mileage_point]");

	
	frm.submit(function () {
		// frm.serialize()
		// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
		
		if (policy_name.val() == '') {
			policy_name.focus();
			alert('정책명을 입력하세요.');
			return false;
		}
		
		if(mileage_point.val() == ''){
			mileage_point.focus();
			alert('마일리지를 입력하세요.');
			return false;
		}

	
		return true;
	});

	/* user_id.keypress(function (e) {
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
	 */
	// 등록/수정
	$('.insert_btn').click(function () {
		frm.submit();
		return false;
	});
	 
	$('.delete_btn').click(function () {
		var policy_code=$("input[name=policy_code]:hidden");
		// 삭제
		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		if (isNaN(policy_code.val())) {
			alert('정책코드가 존재하지 않습니다.');
			return false;
		}

		var param = {
			policyCodes : [ policy_code.val() ]
		};

		$.ajax({
			url			:	'/member/point/policy/delete.do'
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

});
</script>
</head>
<body>

<form name="frm" method="POST" action="/member/point/policy/form.do" enctype="multipart/form-data">
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
		<c:choose>
	      <c:when test="${!empty view.policy_code }">
			<tr>
				<th scope="row">정책코드</th>
				<td>
							<input type="hidden" name="policy_code" value="${view.policy_code}" />
							${view.policy_code }
				</td>
			</tr>
		  </c:when>
		</c:choose>
		<tr>
			<th scope="row">정책명</th>
			<td colspan="3">
			<input type="text" name="policy_name" value="${view.policy_name }" style="width:500px"/>
			</td>
		</tr>
		<tr>
			<th scope="row">호출타입</th>
			<td colspan="3">
				<select name="policy_type">
					<option value="one" <c:if test="${view.policy_type eq 'one' }"> selected</c:if>>
					one
					</option>
					<option value="day" <c:if test="${view.policy_type eq 'day' }"> selected</c:if>>
					day
					</option>
					<option value="all" <c:if test="${view.policy_type eq 'all' }"> selected</c:if>>
					all
					</option>
				</select>
			</td>
		</tr>
		<tr>
			<th scope="row">마일리지</th>
			<td colspan="3">
				<input type="text" pattern="\d*" name="policy_point" value="${view.policy_point }" style="width:50px"/> P
			</td>
		</tr>
		<tr>
			<th scope="row">등록자</th>
			<td colspan="3">
				${view.update_id }
			</td>
		</tr>
		<tr>
			<th scope="row">등록일</th>
			<td colspan="3">
				${view.update_date }
			</td>
		</tr>
		
	
		
		</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.policy_code ? '등록' : '수정' }</a></span>
		<c:if test="${!empty view.policy_code }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>
		<span class="btn gray"><a href="/member/point/policy/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>