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

$(function () {

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
//	nhn.husky.EZCreator.createInIFrame( oEditorsOption );

	var frm				=	$('form[name=frm]')
	var seq				=	frm.find('input[name=seq]');
	var category		=	frm.find('input[name=category]');
	var is_delete		=	frm.find('input[name=is_delete]');
	var content_type	=	frm.find('input[name=content_type]');
	var title			=	frm.find('input[name=title]');
	var top_yn			=	frm.find('input[name=top_yn]');
	var company			=	frm.find('input[name=company]');
	var url				=	frm.find('input[name=url]');
	var content			=	frm.find('textarea[name=content]');
	var confirm_yn		=	frm.find('input[name=confirm_yn]');
	
	frm.submit(function () {
		// frm.serialize()
//		oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
		document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");

		if (seq.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		if (content_type.filter(':checked').size() == 0) {
			content_type.eq(0).focus();
			alert('구분을 선택해 주세요.');
			return false;
		}
		if (title.val() == '') {
			title.focus();
			alert('제목을 입력해 주세요.');
			return false;
		}
		if (confirm_yn.filter(':checked').size() == 0) {
			confirm_yn.eq(0).focus();
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
			if (seq.val() == '') {
				alert('seq가 존재하지 않습니다.');
				return false;
			}

			var param = {
				seqs : [ seq.val() ]
			};

			$.ajax({
				url			:	'/event/notice/delete.do'
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

<form name="frm" method="POST" action="/event/notice/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="seq" value="${view.seq }" />
	<input type="hidden" name="category" value="5" />
	<input type="hidden" name="is_delete" value="${view.is_delete }" />

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
<c:if test="${not empty view.seq }">
				<tr>
					<th scope="row">고유번호</th>
					<td>
						${view.seq }
					</td>
					<th scope="row">조회수</th>
					<td>
						<fmt:formatNumber value="${view.hit }" pattern="###,###"/>
						${empty view.hit ? '0' : '' }
					</td>
				</tr>
				<tr>
					<th scope="row">등록자</th>
					<td>
						<c:out value="${view.user_id }" default="-" />
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
						<label><input type="radio" name="content_type" value="1" ${view.content_type eq '1' or empty view.content_type ? 'checked="checked"' : '' } /> 일반공지</label>
						<label><input type="radio" name="content_type" value="2" ${view.content_type eq '2' ? 'checked="checked"' : '' } /> 당첨자발표</label>
					</td>
				</tr>
				<tr>
					<th scope="row">제목</th>
					<td colspan="3">
						<input type="text" name="title" value="${view.title }" style="width:580px" />
						<label><input type="checkbox" name="top_yn" value="Y" ${view.top_yn eq 'Y' ? 'checked="checked"' : '' } /> 상단노출</label>
					</td>
				</tr>
				<tr>
					<th scope="row">출처</th>
					<td colspan="3">
						<input type="text" name="company" value="${view.company }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">URL</th>
					<td colspan="3">
						<input type="text" name="url" value="${view.url }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td colspan="3">
						<label><input type="radio" name="confirm_yn" value="W" ${view.confirm_yn eq 'W' or empty view.confirm_yn ? 'checked="checked"' : '' } /> 대기</label>
						<label><input type="radio" name="confirm_yn" value="Y" ${view.confirm_yn eq 'Y' ? 'checked="checked"' : '' } /> 승인</label>
						<label><input type="radio" name="confirm_yn" value="N" ${view.confirm_yn eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	
	<div class="sTitBar">
		<h4>
			<label>내용</label>
		</h4>
	</div>
	
	<div class="tableWrite">	
		<table summary="공지/당첨자발표 컨텐츠 작성">
		<caption>공지/당첨자발표 컨텐츠 글쓰기</caption>
		<colgroup>
			<col style="width:15%" />
			<col style="width:35%" />
			<col style="width:15%" />
			<col style="width:35%" />
		</colgroup>
		<tbody>
			<tr>
				<td colspan="4">
        			<!-- 20151006 : 이용환 : 에디터 변경을 위해 수정 
					<textarea id="contents" name="content" style="width:100%;height:400px;"><c:out value="${view.content }" escapeXml="true" /></textarea>
					-->
					<script type="text/javascript" language="javascript">
						var CrossEditor = new NamoSE('contents');
						CrossEditor.params.Width = "100%";
						CrossEditor.params.Height = "900px";
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
		</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.seq ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view.seq }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/event/notice/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

<!-- 웹필터 수정 -->
<%@ include file="/webfilter/inc/initCheckWebfilter.jsp"%>
<!-- 웹필터 수정 -->

</body>
</html>