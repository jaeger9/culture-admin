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
		$('input[name=cate_type]').val(res.cateType);
		$('input[name=creator]').val(res.name);
	},
	fileUpload : function (res) {
		// res.full_file_path
		// res.file_path
		$('input[name=reference_identifier]').val(res.full_file_path);
		$('.upload_pop_img').html('<img src="' + res.full_file_path + '" width="110" height="85" alt="" />');
	}
};

$(function () {

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
//	nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	
	var frm			=	$('form[name=frm]');
	var uci			=	frm.find('input[name=uci]');
	var datasource	=	frm.find('input[name=datasource]');

	var title		=	frm.find('input[name=title]');
	var publisher	=	frm.find('input[name=publisher]');
	var cate_type	=	frm.find('input[name=cate_type]');
	var creator		=	frm.find('input[name=creator]');
	var format		=	frm.find('input[name=format]');
	var url			=	frm.find('input[name=url]');
	var description	=	frm.find('textarea[name=description]');
	var approval	=	frm.find('input[name=approval]');
	
	
	frm.submit(function () {
		// frm.serialize()
//		oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
       	document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
		
		if (uci.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		if (title.val() == '') {
			title.focus();
			alert('제목을 입력해 주세요.');
			return false;
		}
		if (creator.val() == '') {
			creator.focus();
			alert('출처를 선택해 주세요.');
			return false;
		}
		if (format.filter(':checked').size() == 0) {
			format.eq(0).focus();
			alert('콘텐츠를 선택해 주세요.');
			return false;
		}
		if (url.val() == '') {
			url.focus();
			alert('URL을 입력해 주세요.');
			return false;
		}
		if (description.val() == '' || description.val().toLowerCase() == '<br>') {
			alert('내용을 입력해 주세요.');
			return false;
		}
		if (approval.filter(':checked').size() == 0) {
			approval.eq(0).focus();
			alert('승인여부를 선택해 주세요.');
			return false;
		}
		return true;
	});
	
	// 출처
	$('.uciOrg_btn').add(creator).click(function () {
		Popup.uciOrg();
		return false;
	});

	// 파일업로드
	$('.upload_pop_btn').click(function () {
		Popup.fileUpload('knowledge_ict');
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
			if (uci.val() == '') {
				alert('uci가 존재하지 않습니다.');
				return false;
			}

			var param = {
				ucis : [ uci.val() ]
			};

			$.ajax({
				url			:	'/knowledge/ict/delete.do'
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

<form name="frm" method="POST" action="/knowledge/ict/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="uci" value="${view.uci }" />
	<%-- <input type="hidden" name="type" value="${empty view.type ? 15 : view.type }" /> --%>

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
<c:if test="${not empty view.uci }">
				<tr>
					<th scope="row">UCI</th>
					<td>
						${fn:replace(view.uci, '%2b', '+') }
					</td>
					<th scope="row">조회수</th>
					<td>
						<fmt:formatNumber value="${view.view_cnt }" pattern="###,###"/>
						${empty view.view_cnt ? '0' : '' }
					</td>
				</tr>
				<tr>
					<th scope="row">등록일</th>
					<td>
						<c:out value="${view.reg_date }" default="-" />
					</td>
					<th scope="row">수집일</th>
					<td>
						<c:out value="${view.insert_date }" default="-" />
					</td>
				</tr>
</c:if>
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
						<input type="hidden" name="publisher" value="${view.publisher }" />
						<input type="hidden" name="cate_type" value="" /><!-- insert 시에만 필요 / popup에서 선택 시 값 입력 -->
						<input type="text" name="creator" value="${view.creator }" readonly="readonly" style="width:580px" />
						<span class="btn whiteS"><a href="#" class="uciOrg_btn">출처</a></span>
					</td>
				</tr>
				<tr>
					<th scope="row">콘텐츠</th>
					<td colspan="3">
						<c:choose>
							<c:when test="${view.format eq 'Image' }">
								<c:set var="tmp_format" value="2" />
							</c:when>
							<c:when test="${view.format eq 'Video' }">
								<c:set var="tmp_format" value="3" />
							</c:when>
							<c:otherwise>
								<c:set var="tmp_format" value="1" />
							</c:otherwise>
						</c:choose>

						<label><input type="radio" name="format" value="Text"  ${tmp_format eq 1 ? 'checked="checked"' : '' } /> 텍스트</label>
						<label><input type="radio" name="format" value="Image" ${tmp_format eq 2 ? 'checked="checked"' : '' } /> 이미지</label>
						<label><input type="radio" name="format" value="Video" ${tmp_format eq 3 ? 'checked="checked"' : '' } /> 비디오</label>
					</td>
				</tr>
				<tr>
					<th scope="row">URL</th>
					<td colspan="3"><input type="text" name="url" value="${view.url }" style="width:670px" /></td>
				</tr>
				<tr>
					<th scope="row">썸네일 이미지</th>
					<td colspan="3">
						<input type="text" name="reference_identifier" value="${view.reference_identifier }" style="width:580px" />
						<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
						<div class="upload_pop_msg">(외부 이미지 URL 또는 110px * 85px 크기의 이미지를 선택해 주세요.)</div>
						<div class="upload_pop_img">
							<c:if test="${not empty view.reference_identifier }">
								<img src="${view.reference_identifier }" width="110" height="85" alt="" />
							</c:if>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">내용</th>
					<td colspan="3">
	        			<!-- 20151006 : 이용환 : 에디터 변경을 위해 수정 
						<textarea id="contents" name="description" style="width:100%;height:400px;"><c:out value="${view.description }" escapeXml="true" /></textarea>
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
						<textarea id="contents" name="description" style="width:100%;height:400px;display:none;"><c:out value="${view.description }" escapeXml="true" /></textarea>
						
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td colspan="3">
						<label><input type="radio" name="approval" value="Y" ${view.approval ne 'N' ? 'checked="checked"' : '' } /> 승인</label>
						<label><input type="radio" name="approval" value="N" ${view.approval eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.uci ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view.uci }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/knowledge/ict/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>