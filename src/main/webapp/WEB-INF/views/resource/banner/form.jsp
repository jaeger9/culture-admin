<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="/crosseditor/js/namo_scripteditor.js"></script>

<script type="text/javascript">

var callback = {
	fileUpload : function (res) {
		// res.full_file_path
		// res.file_path
		$('input[name=image]').val(res.full_file_path);
		$('.upload_pop_img').html('<img src="' + res.full_file_path + '" width="174" height="114" alt="" />');
	}
};

$(function () {
	
	var frm				=	$('form[name=frm]')
	var seq				=	frm.find('input[name=seq]');
	var title			=	frm.find('input[name=title]');
	var image			=	frm.find('input[name=image]');
	var start_dt		=	frm.find('input[name=start_dt]');
	var end_dt			=	frm.find('input[name=end_dt]');
	var url				=	frm.find('input[name=url]');
	var contents		=	frm.find('textarea[name=contents]');
	var approval		=	frm.find('input[name=approval]');
	var pseq		=	frm.find('input[name=pseq]');

	new Datepicker(start_dt, end_dt);
	
	frm.submit(function () {
       	document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");

		if (seq.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		if (pseq.val() == ''){
			pseq.focus();
			alert('문화정보자원을 먼저 등록해주세요.');
			return false;
		}
		if (title.val() == '') {
			title.focus();
			alert('제목을 입력해 주세요.');
			return false;
		}
		if (title.val() == '') {
			title.focus();
			alert('제목을 입력해 주세요.');
			return false;
		}
		if (start_dt.val() == '') {
			start_dt.focus();
			alert('시작일을 입력해 주세요.');
			return false;
		}
		if (end_dt.val() == '') {
			end_dt.focus();
			alert('종료일을 입력해 주세요.');
			return false;
		}
/* 		if (url.val() == '') {
			url.focus();
			alert('URL을 입력해 주세요.');
			return false;
		} */
/* 		if (contents.val() == '' || contents.val().toLowerCase() == '<p><br /></p>') {
			alert('내용을 입력해 주세요.');
			return false;
		} */
		if (approval.filter(':checked').size() == 0) {
			approval.eq(0).focus();
			alert('승인 여부를 선택해 주세요.');
			return false;
		}
		return true;
	});

	// 파일업로드
	$('.upload_pop_btn').click(function () {
		Popup.fileUpload('resource_banner');
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
			if (seq.val() == '') {
				alert('seq가 존재하지 않습니다.');
				return false;
			}

			var param = {
				seqs : [ seq.val() ]
			};

			$.ajax({
				url			:	'/resource/banner/delete.do'
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
<style type="text/css">
 .tableWrite .reqStar {color:#D20B1E; margin-right:3px;}
</style>
</head>
<body>

<form name="frm" method="POST" action="/resource/banner/insert.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="seq" value="${view.seq }" />

	<div class="tableWrite">
		<table summary="게시판 글 등록">
			<caption>게시판 글 등록</caption>
			<colgroup>
				<col style="width:18%" />
				<col style="width:*" />
				<col style="width:10%" />
				<col style="width:10%" />
				<col style="width:10%" />
				<col style="width:10%" />
				<col style="width:10%" />
				<col style="width:12%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">문화정보자원</th>
					<td colspan="7">
						<c:choose>
							<c:when test="${empty siteList}">
								'페이지관리' 메뉴에서 '배너형태(수동입력)'인 경우만 등록 가능합니다.
								<input type="hidden" name="pseq" value=""/>
							</c:when>
							<c:otherwise>
								<select name="pseq" style="width:250px;">
									<c:forEach items="${siteList }" var="item">
										<option value="${item.seq }" ${item.seq eq view.pseq ? ' selected="selected" ' : '' } >${item.title }</option>
									</c:forEach>
								</select>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th scope="row"><span class="reqStar">*</span>제목</th>
					<td colspan="3">
						<input type="text" name="title" maxlength="100" value="${view.title }" style="width:100%" />
					</td>
					<th scope="row">작성자</th>
					<td>
						<c:out value="${view.reg_id }" default="-" />
					</td>
					<th scope="row">등록일</th>
					<td>
						<c:out value="${view.reg_date }" default="-" />
					</td>
				</tr>
				<tr>
					<th scope="row"><span class="reqStar">*</span>시작일</th>
					<td>
						<input type="text" name="start_dt" readonly="readonly" value="${view.start_dt}" />
					</td>
					<th scope="row"><span class="reqStar">*</span>종료일</th>
					<td colspan="5">
						<input type="text" name="end_dt" readonly="readonly" value="${view.end_dt}" />
					</td>
				</tr>
				<tr>
					<th scope="row">이미지</th>
					<td colspan="7">
						<input type="text" name="image" readonly="readonly" value="${view.image }" style="width:500px" />
						<span class="btn whiteS"><a href="#" class="upload_pop_btn">이미지 찾기</a></span>
						<div class="upload_pop_msg">* 125 * 155px에 맞추어 등록해 주세요.</div>
						<div class="upload_pop_img">
							<c:if test="${not empty view.image }">
								<img src="${view.image }" width="125" height="155" alt="" />
							</c:if>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">URL</th>
					<td>
						<input type="text" name="url" maxlength="500" value="${view.url}" style="width:500px;"/>
					</td>
				</tr>
				<tr>
					<th scope="row">내용</th>
					<td colspan="7">
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
						<textarea id="contents" name="contents" style="width:100%;height:400px;display:none;"><c:out value="${view.contents }" escapeXml="true" /></textarea>
							
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td colspan="7">
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

		<span class="btn gray"><a href="/resource/banner/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>