<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- 
	20151006 : 이용환 : 에디터 변경을 위해 수정 
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
 -->
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="/crosseditor/js/namo_scripteditor.js"></script>

<script type="text/javascript">

var callback = {
	fileUpload : function (res) {
		// res.full_file_path
		// res.file_path
		$('input[name=file_nm]').val(res.file_path);
		$('input[name=file_org]').val(res.file_path);
		$('.upload_pop_img').html('<img src="/upload/event/' + res.file_path + '" width="180" height="117" alt="" />');
	}
};

$(function () {

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
//	nhn.husky.EZCreator.createInIFrame( oEditorsOption );

	var frm			=	$('form[name=frm]');
	var event_id	=	frm.find('input[name=event_id]');
	var uci			=	frm.find('input[name=uci]');
	var del_yn		=	frm.find('input[name=del_yn]');
	var gubun		=	frm.find('input[name=gubun]');
	var title		=	frm.find('input[name=title]');
	var top_yn		=	frm.find('input[name=top_yn]');
	var rights		=	frm.find('input[name=rights]');
	var file_nm		=	frm.find('input[name=file_nm]');
	var file_org	=	frm.find('input[name=file_org]');
	var start_dt	=	frm.find('input[name=start_dt]');
	var end_dt		=	frm.find('input[name=end_dt]');
	var win_date	=	frm.find('input[name=win_date]');
	var win_url		=	frm.find('input[name=win_url]');
	var content		=	frm.find('textarea[name=content]');
	var link_url	=	frm.find('input[name=link_url]');
	var request		=	frm.find('input[name=request]');
	var approval	=	frm.find('input[name=approval]');

	var displayGubun = function (value) {
		if (value == 'Y') {
			$('#contentArea, #win_urlArea').show();
			$('#link_urlArea').hide();
		} else if (value == 'N') {
			$('#contentArea, #win_urlArea').hide();
			$('#link_urlArea').show();
		} else {
			$('#contentArea').hide();
			$('#win_urlArea, #link_urlArea').show();
		}
	};
	
	new Datepicker(start_dt, end_dt);
	setDatepicker(win_date);

	frm.submit(function () {
		// frm.serialize()
//		oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
		document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");

		if (event_id.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		if (gubun.filter(':checked').size() == 0) {
			gubun.eq(0).focus();
			alert('구분을 선택해 주세요.');
			return false;
		}
		if (title.val() == '') {
			title.focus();
			alert('이벤트명을 입력해 주세요.');
			return false;
		}
		if (rights.val() == '') {
			rights.focus();
			alert('주최/주관을 입력해 주세요.');
			return false;
		}
		if (start_dt.val() == '') {
			start_dt.focus();
			alert('이벤트 시작일을 선택해 주세요.');
			return false;
		}
		if (end_dt.val() == '') {
			end_dt.focus();
			alert('이벤트 종료일을 선택해 주세요.');
			return false;
		}
		if (approval.filter(':checked').size() == 0) {
			approval.eq(0).focus();
			alert('승인여부를 선택해 주세요.');
			return false;
		}
		return true;
	});
	
	// 구분
	gubun.click(function () {
		displayGubun( $(this).val() );
	});

	// 파일업로드
	$('.upload_pop_btn').click(function () {
		Popup.fileUpload('event_event');
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
			if (event_id.val() == '') {
				alert('event_id가 존재하지 않습니다.');
				return false;
			}

			var param = {
				event_ids : [ event_id.val() ]
			};

			$.ajax({
				url			:	'/event/event/delete.do'
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

	// 구분
	displayGubun( gubun.filter(':checked').val() );

});
</script>
</head>
<body>

<form name="frm" method="POST" action="/event/event/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="event_id" value="${view.event_id }" />
	<input type="hidden" name="uci" value="${view.uci }" />
	<input type="hidden" name="del_yn" value="${view.del_yn }" />

<!--
	미사용
	
	creator
	win_approval
	link_type
-->

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
<c:if test="${not empty view.event_id }">
				<tr>
					<th scope="row">고유번호/UCI</th>
					<td>
						${view.event_id } / ${view.uci }
					</td>
					<th scope="row">조회수</th>
					<td>
						<fmt:formatNumber value="${view.view_cnt }" pattern="###,###"/>
						${empty view.view_cnt ? '0' : '' }
					</td>
				</tr>
				<tr>
					<th scope="row">등록자</th>
					<td>
						<c:out value="${view.user_id }" default="-" />
					</td>
					<th scope="row">등록/수정일</th>
					<td>
						<c:out value="${view.reg_date }" default="-" />
						/
						<c:out value="${view.update_date }" default="-" />
					</td>
				</tr>
</c:if>
				<tr>
					<th scope="row">구분</th>
					<td colspan="3">
						<label><input type="radio" name="gubun" value="Y" ${view.gubun eq 'Y' or empty view.gubun ? 'checked="checked"' : '' } /> 내부이벤트</label>
						<label><input type="radio" name="gubun" value="N" ${view.gubun eq 'N' ? 'checked="checked"' : '' } /> 외부이벤트</label>
						<label><input type="radio" name="gubun" value="A" ${view.gubun eq 'A' ? 'checked="checked"' : '' } /> 연계이벤트</label>
					</td>
				</tr>
				<tr>
					<th scope="row">이벤트명</th>
					<td colspan="3">
						<input type="text" name="title" value="${view.title }" style="width:580px" />
						<label><input type="checkbox" name="top_yn" value="Y" ${view.top_yn eq 'Y' ? 'checked="checked"' : '' } /> 상단노출</label>
					</td>
				</tr>
				<tr>
					<th scope="row">주최/주관</th>
					<td colspan="3">
						<input type="text" name="rights" value="${view.rights }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">썸네일 이미지</th>
					<td colspan="3">
						<input type="hidden" name="file_nm" value="${view.file_nm }" style="width:580px" />
						<input type="text" name="file_org" value="${view.file_org }" style="width:580px" />
						<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
						<div class="upload_pop_msg">(180px * 117px 크기의 이미지를 선택해 주세요.)</div>
						<div class="upload_pop_img">
							<c:if test="${not empty view.file_org }">
								<img src="/upload/event/${view.file_org }" width="180" height="117" alt="" />
							</c:if>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">이벤트기간</th>
					<td colspan="3">
						<input type="text" name="start_dt" value="${view.start_dt }" readonly="readonly" />
						~
						<input type="text" name="end_dt" value="${view.end_dt }" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<th scope="row">당첨자발표</th>
					<td colspan="3">
						<input type="text" name="win_date" value="${view.win_date }" readonly="readonly" />
					</td>
				</tr>
				<tr id="win_urlArea">
					<th scope="row">당첨자URL</th>
					<td colspan="3">
						<input type="text" name="win_url" value="${view.win_url }" style="width:670px" />
					</td>
				</tr>

				<tr id="contentArea">
					<th scope="row">이벤트안내</th>
					<td colspan="3">
	        			<!-- 20151006 : 이용환 : 에디터 변경을 위해 수정 
						<textarea id="contents" name="content" style="width:100%;height:400px;"><c:out value="${view.content }" escapeXml="true" /></textarea>
						-->
						<script type="text/javascript" language="javascript">
							var CrossEditor = new NamoSE('contents');
							CrossEditor.params.Width = "100%";
							CrossEditor.params.Height = "400px";
							CrossEditor.params.UserLang = "auto";
							CrossEditor.params.UploadFileSizeLimit = "image:10485760";
							CrossEditor.params.Font = {"NanumGothic":"나눔고딕","Dotum":"돋움", "Gulim":"굴림", "Batang":"바탕", "Gungsuh":"궁서", "맑은 고딕":"맑은 고딕"  ,"David":"David", "MS Pgothic":"MS Pgothic","Simplified Arabic":"Simplified Arabic","SimSun":"SimSun","Arial":"Arial","Courier New":"Courier New", "Tahoma":"Tahoma", "Times New Roman":"Times New Roman", "verdana":"Verdana"};
							CrossEditor.EditorStart();
							function OnInitCompleted(e){
								e.editorTarget.SetBodyValue(document.getElementById("contents").value);
							}
						</script>
						<textarea id="contents" name="content" style="width:100%;height:400px;display:none;"><c:out value="${view.content }" escapeXml="true" /></textarea>
					
					</td>
				</tr>
				<tr id="link_urlArea">
					<th scope="row">이벤트안내 URL</th>
					<td colspan="3">
						<input type="text" name="link_url" value="${view.link_url }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">요청사항</th>
					<td colspan="3">
						<textarea name="request" style="width:100%; height:200px;">${view.request }</textarea>
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
		<span class="btn white"><a href="#" class="insert_btn">${empty view.event_id ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view.event_id }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/event/event/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

<!-- 웹필터 수정 -->
<%@ include file="/webfilter/inc/initCheckWebfilter.jsp"%>
<!-- 웹필터 수정 -->

</body>
</html>