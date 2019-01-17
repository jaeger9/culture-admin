<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- <script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script> -->
<script type="text/javascript">

$(function () {

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
	// nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	
	var frm				=	$('form[name=frm]');
	var tvm_seq			=	frm.find('input[name=tvm_seq]');

	var tvm_title		=	frm.find('input[name=tvm_title]');
	var vcm_code		=	frm.find('select[name=vcm_code]');
	var org_code		=	frm.find('select[name=org_code]');
	var tvm_low_url		=	frm.find('input[name=tvm_low_url]');
	var tvm_high_url	=	frm.find('input[name=tvm_high_url]');
	var tvm_url			=	frm.find('input[name=tvm_url]');
	var tvm_contents	=	frm.find('textarea[name=tvm_contents]');
	var tvm_etc_info	=	frm.find('input[name=tvm_etc_info]');
	var tvm_viewflag	=	frm.find('input[name=tvm_viewflag]');
	
	frm.submit(function () {
		// frm.serialize()
		// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);

		if (tvm_seq.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}

		if (tvm_title.val() == '') {
			tvm_title.focus();
			alert('제목을 입력해 주세요.');
			return false;
		}
		if (tvm_viewflag.filter(':checked').size() == 0) {
			tvm_viewflag.eq(0).focus();
			alert('승인여부를 선택해 주세요.');
			return false;
		}
		return true;
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
			if (tvm_seq.val() == '') {
				alert('tvm_seq가 존재하지 않습니다.');
				return false;
			}

			var param = {
				tvm_seqs : [ tvm_seq.val() ]
			};

			$.ajax({
				url			:	'/addservice/vod/delete.do'
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

	$('.view56').click(function () {
		var v = tvm_low_url.val();
		if (v == '') {
			alert('56k URL이 입력되지 않았습니다.');
			return false;
		}
		window.open(v, 'view56');
	});
	$('.view300').click(function () {
		var v = tvm_high_url.val();
		if (v == '') {
			alert('300k URL이 입력되지 않았습니다.');
			return false;
		}
		window.open(v, 'view300');
	});
	
});
</script>
</head>
<body>

<form name="frm" method="POST" action="/addservice/vod/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="tvm_seq" value="${view.tvm_seq }" />

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
<c:if test="${not empty view.tvm_seq }">
				<tr>
					<th scope="row">고유번호</th>
					<td>
						${view.tvm_seq }
					</td>
					<th scope="row">등록일</th>
					<td>
						<c:out value="${view.tvm_reg_date }" default="-" />
					</td>
				</tr>
</c:if>
				<tr>
					<th scope="row">제목</th>
					<td colspan="3">
						<input type="text" name="tvm_title" value="${view.tvm_title }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">분류</th>
					<td colspan="3">
						<select name="vcm_code">
<c:forEach items="${listByVodCode }" var="item">
	<c:if test="${item.vcm_depth eq 2 }">
		<option value="${item.vcm_code }" ${view.vcm_code eq item.vcm_code ? 'selected="selected"' : '' } >
			<c:forEach items="${listByVodCode }" var="j">
				<c:if test="${j.vcm_depth eq 1 and item.vcm_up_code eq j.vcm_code }">
					[${j.vcm_title }]
				</c:if>
			</c:forEach>
			-
			${item.vcm_title }
		</option>
	</c:if>
</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">기관명</th>
					<td colspan="3">
						<select name="org_code">
<c:forEach items="${listByVodOrg }" var="item">
	<option value="${item.org_code }" ${view.org_code eq item.org_code ? 'selected="selected"' : '' }>${item.ooc_name }</option>
</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">56k</th>
					<td colspan="3">
						<input type="text" name="tvm_low_url" value="${view.tvm_low_url }" style="width:580px" />
						<span class="btn whiteS"><a href="#" class="view56">미리보기</a></span>
					</td>
				</tr>
				<tr>
					<th scope="row">300k</th>
					<td colspan="3">
						<input type="text" name="tvm_high_url" value="${view.tvm_high_url }" style="width:580px" />
						<span class="btn whiteS"><a href="#" class="view300">미리보기</a></span>
					</td>
				</tr>
				<tr>
					<th scope="row">URL</th>
					<td colspan="3">
						<input type="text" name="tvm_url" value="${view.tvm_url }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">서비스 소개</th>
					<td colspan="3">
						<textarea name="tvm_contents" style="width:100%;height:400px;"><c:out value="${view.tvm_contents }" escapeXml="false" /></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">기타</th>
					<td colspan="3">
						<input type="text" name="tvm_etc_info" value="${view.tvm_etc_info }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td colspan="3">
						<label><input type="radio" name="tvm_viewflag" value="0" ${view.tvm_viewflag eq '0' or empty view.tvm_viewflag ? 'checked="checked"' : '' } /> 승인</label>
						<label><input type="radio" name="tvm_viewflag" value="1" ${view.tvm_viewflag eq '1' ? 'checked="checked"' : '' } /> 미승인</label>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.tvm_seq ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view.tvm_seq }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/addservice/vod/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>