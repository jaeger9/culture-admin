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
	fileUpload : function (res) {
		// res.full_file_path
		// res.file_path
		$('input[name=img_url]').val(res.file_path);
		$('.upload_pop_img').html('<img src="/upload/recom/sns/' + res.file_path + '" width="40" height="40" alt="" />');
	}
};

$(function () {
	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
	// nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	
	var frm			=	$('form[name=frm]');
	var idx			=	frm.find('input[name=idx]');
	var creator		=	frm.find('input[name=creator]');
	var approval	=	frm.find('input[name=approval]');

	frm.submit(function () {
		// frm.serialize()
		// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
		
		var subject = document.getElementById("subject").value;
		if(subject=='A'){
			document.getElementById("sort").value ="7";
		}
		if(subject=='B'){
			document.getElementById("sort").value ="2";
		}
		if(subject=='C'){
			document.getElementById("sort").value ="1";
		}
		if(subject=='D'){
			document.getElementById("sort").value ="4";
		}
		if(subject=='E'){
			document.getElementById("sort").value ="6";
		}
		if(subject=='F'){
			document.getElementById("sort").value ="5";
		}
		if(subject=='G'){
			document.getElementById("sort").value ="3";
		}
		
		if (idx.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		if (creator.val() == '') {
			creator.focus();
			alert('기관명을 입력해 주세요.');
			return false;
		}
		if (approval.filter(':checked').size() == 0) {
			approval.eq(0).focus();
			alert('승인여부를 선택해 주세요.');
			return false;
		}
		return true;
	});

	// 파일업로드
	$('.upload_pop_btn').click(function () {
		Popup.fileUpload('customer_sns');
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
			if (idx.val() == '') {
				alert('idx가 존재하지 않습니다.');
				return false;
			}

			var param = {
				idxs : [ idx.val() ]
			};

			$.ajax({
				url			:	'/customer/sns/delete.do'
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

<form name="frm" method="POST" action="/customer/sns/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>
	<input type="hidden" name="sort" id="sort" value="" />
	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="idx" value="${view.idx }" />

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
<c:if test="${not empty view.idx }">
				<tr>
					<th scope="row">고유번호</th>
					<td colspan="3">
						${view.idx }
					</td>
				</tr>
				<tr>
					<th scope="row">등록자</th>
					<td>
						<c:out value="${view.reg_id }" default="-" />
					</td>
					<th scope="row">등록일</th>
					<td>
						<c:out value="${view.reg_date }" default="-" />
					</td>
				</tr>
</c:if>
				<tr>
					<th scope="row">구분</th>
					<td colspan="3">
						<select name="subject" id="subject">
<c:forEach items="${categoryList }" var="j">
							<option value="${j.value }" <c:if test="${item.subject eq j.value }">selected</c:if>>${j.name }</option>
</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">기관명</th>
					<td colspan="3">
						<input type="text" name="creator" value="${view.creator }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">기관	URL</th>
					<td colspan="3">
						<input type="text" name="organ_url" value="${view.organ_url }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">블로그 URL</th>
					<td colspan="3">
						<input type="text" name="blog_url" value="${view.blog_url }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">블로그 RSS URL</th>
					<td colspan="3">
						<input type="text" name="blog_url_rss" value="${view.blog_url_rss }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">트위터 URL</th>
					<td colspan="3">
						<input type="text" name="twitter_url" value="${view.twitter_url }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">인스타그램 URL</th>
					<td colspan="3">
						<input type="text" name="instagram_url" value="${view.instagram_url }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">페이스북 URL</th>
					<td colspan="3">
						<input type="text" name="face_url" value="${view.face_url }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">유투브 URL</th>
					<td colspan="3">
						<input type="text" name="youtube_url" value="${view.youtube_url }" style="width:670px" />
					</td>
				</tr>
			
				
				<tr>
					<th scope="row">썸네일 이미지</th>
					<td colspan="3">
						<input type="text" name="img_url" value="${view.img_url }" style="width:580px" />
						<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
						<div class="upload_pop_msg">(40px * 40px 크기의 이미지를 선택해 주세요.)</div>
						<div class="upload_pop_img">
							<c:if test="${not empty view.img_url }">
								<img src="/upload/recom/sns/${view.img_url }" width="40" height="40" alt="" />
							</c:if>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td colspan="3">
						<label><input type="radio" name="approval" value="W" ${view.approval eq 'W' or empty view.approval ? 'checked="checked"' : '' } /> 대기</label>
						<label><input type="radio" name="approval" value="Y" ${view.approval eq 'Y' ? 'checked="checked"' : '' } /> 승인</label>
						<label><input type="radio" name="approval" value="N" ${view.approval eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.idx ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view.idx }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/customer/sns/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>