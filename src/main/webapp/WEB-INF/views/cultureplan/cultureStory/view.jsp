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
			$('input[name=thumb_url]').val(res.full_file_path);
			$('.upload_pop_img').html('<img src="' + res.full_file_path + '" width="125" height="95" alt="" />');
		}
	};

$(function () {

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
	//nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	
	var frm			=	$('form[name=frm]');
	var seq			=	frm.find('input[name=seq]');
	var title		=	frm.find('input[name=title]');
	var sub_title	=	frm.find('input[name=sub_title]');
	var code		=	frm.find('select[name=code]');
	var content		=	frm.find('textarea[name=content]');
	var approval	=	frm.find('input[name=approval]');
	var creator		=	frm.find('input[name=creator]');

	frm.submit(function () {
		// frm.serialize()
		//oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
		document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");

		if (seq.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		if (title.val() == '') {
			title.focus();
			alert('제목을 입력해 주세요.');
			return false;
		}
		if (approval.filter(':checked').size() == 0) {
			approval.eq(0).focus();
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
	// 파일업로드
		$('.upload_pop_btn').click(function () {
			Popup.fileUpload('event_news');
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
				url			:	'/cultureplan/cultureStory/delete.do'
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
				,error : function(data, approval, err) {
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

<form name="frm" method="POST" action="/cultureplan/cultureStory/view.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="seq" value="${view.seq }" />

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
					<td colspan="3">
						${view.seq }
					</td>
				</tr>
				<tr>
					<th scope="row">등록자</th>
					<td>
						<c:out value="${view.reg_user }" default="-" />
					</td>
					<th scope="row">등록/수정일</th>
					<td>
						<c:out value="${view.reg_date }" default="-" />
						/
						<c:out value="${view.upd_date }" default="-" />
					</td>
				</tr>
</c:if>
				 <tr>
						<th scope="row">분류</th>
						<td colspan="3">
							<select name="code">
								<c:forEach var="item" items="${contList}">
									<option value="${item.code}" ${item.code eq view.code ? 'selected=selected' : ''}>${item.name}</option>
								</c:forEach>
							</select>
						</td>
				</tr>
				<tr>
					<th scope="row">제목</th>
					<td colspan="3">
						<input type="text" name="title" value="${view.title }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">부제목</th>
					<td colspan="3">
						<input type="text" name="sub_title" value="${view.sub_title }" style="width:670px" />
					</td>
				</tr>
				<tr>
						<th scope="row">출처</th>
						<td colspan="3">
							<input type="text" name="origin" style="width:670px" value="${view.origin}" />
						</td>
				</tr>
					<tr>
						<th scope="row">썸네일 이미지</th>
						<td colspan="3">
							<input type="text" name="thumb_url" value="${view.thumb_url }" style="width:580px" />
							<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
							<div class="upload_pop_msg"></div>
							<div class="upload_pop_img">
								<c:if test="${not empty view.thumb_url}">
									<img src="${view.thumb_url}" width="125" height="95" alt="" />
								</c:if>
							</div>
						</td>
					</tr>
				<tr>
					<th scope="row">내용</th>
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
		<span class="btn white"><a href="#" class="insert_btn">${empty view.seq ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view.seq }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/cultureplan/cultureStory/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>