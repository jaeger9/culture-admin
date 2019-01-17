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

$().ready(function() {
			
			$("input[name='job_group_id']").click(function(){
				
			 if (this.value == "내가권하는한권의책") {
				   $("#title").show();
				    $("#alt").show();
					$("#new").hide();
					$("#sub").hide();
					$("#sec").hide();
					$("#date").hide();
					$("#mon").hide();
			   } else if (this.value == "기관별추천도서") {
					$("#title").hide();
					$("#alt").hide();
					$("#new").show();
					$("#sec").show();
					$("#sub").hide();
					$("#date").hide();
					$("#mon").hide();
				
				} else if (this.value == "어린이추천도서") {
					$("#title").hide();
					$("#alt").hide();
					$("#new").show();
					$("#sec").hide();
					$("#sub").show();
					$("#date").show();
					$("#mon").hide();
				
				} else if (this.value == "사서추천도서") {
					$("#title").hide();
					$("#alt").hide();
					$("#new").show();
					$("#sec").hide();
					$("#sub").show();
					$("#date").show();
					$("#mon").hide();
					
				} else if (this.value == "발간도서"){
					$("#title").hide();
					$("#alt").hide();
					$("#rights").hide();
					$("#new").show();
					$("#sec").hide();
					$("#sub").show();
					$("#date").hide();
					$("#mon").show();
				}
			});
		});

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
	var job_group_id	=	frm.find('input[name=job_group_id]');
	
	
	frm.submit(function () {
		// frm.serialize()
//      oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
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
				url			:	'/knowledge/book/delete.do'
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

<form name="frm" method="POST" action="/knowledge/book/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="uci" value="${form.uci }" />

	<div class="tableWrite">
		<table summary="도서 게시판 글 등록">
			<caption>도서 게시판 글 등록</caption>
			<colgroup>
				<col style="width:15%" />
				<col style="width:35%" />
				<col style="width:15%" />
				<col style="width:35%" />
			</colgroup>
			<tbody>
<c:if test="${not empty form.uci }">
				<tr>
					<th scope="row">UCI</th>
					<td>
						${fn:replace(form.uci, '%2b', '+') }
					</td>
				</tr>
				<tr>
					<th scope="row">등록일</th>
					<td>
						<c:out value="${form.reg_date }" default="-" />
					</td>
					<th scope="row">수집일</th>
					<td>
						<c:out value="${form.insert_date }" default="-" />
					</td>
				</tr>
</c:if>
					<tr>
						<th scope="row" class="onPage"><label for="idTitle">구분</label></th>
							<td class="onPage" colspan="3">  
								<input type="radio" name="job_group_id" value="내가권하는한권의책" <c:if test="${form.job_group_id eq '내가권하는한권의책' or empty form }">checked</c:if>/>내가 권하는 한권의 책							
								<input type="radio" name="job_group_id" value="기관별추천도서" <c:if test="${form.job_group_id eq '기관별추천도서' }">checked="checked"</c:if>/>기관별추천도서
								<input type="radio" name="job_group_id" value="어린이추천도서" <c:if test="${form.job_group_id eq '어린이추천도서' }">checked="checked"</c:if>/>어린이추천도서
								<input type="radio" name="job_group_id" value="사서추천도서" <c:if test="${form.job_group_id eq '사서추천도서' }">checked="checked"</c:if>/>사서추천도서
								<input type="radio" name="job_group_id" value="발간도서" <c:if test="${form.job_group_id eq '발간도서' }">checked="checked"</c:if>/>발간도서
						</td>
					</tr>
				
				    <tr <c:if test="${form.job_group_id eq '내가권하는한권의책' }">style="display: none;"</c:if> id="title">
							<th scope="row">글제목</th>
							<td colspan="3">
								<input type="text" name="title" style="width:670px" value="${form.title}" />
							</td>
					</tr>
						
					<tr <c:if test="${form.job_group_id eq '내가권하는한권의책' }">style="display: none;"</c:if> id="alt">
						<th scope="row">책제목</th>
						<td colspan="3">
							<input type="text" name="alternative_title" style="width:670px" value="${form.alternative_title}" />
						</td>
					</tr>
					<tr <c:if test="${form.job_group_id ne '기관별추천도서' }">style="display: none;"</c:if> id="new">
						<th scope="row">책제목</th>
						<td colspan="3">
							<input type="text" name="title" style="width:670px" value="${form.title}" />
						</td>
					</tr>
					
					<tr <c:if test="${form.job_group_id ne '어린이추천도서' }">style="display: none;"</c:if> id="sub">
						<th scope="row">주제</th>
						<td colspan="3">
							<input type="text" name="subject_category" style="width:670px" value="${form.subject_category}" />
						</td>
					</tr>
							
					<tr>
							<th scope="row">저자/출판사</th>
							<td colspan="3">
								<input type="text" name="rights" style="width:335px" value="${form.rights}" />
							</td>
					</tr>
					
					<tr>
						<th scope="row">출처</th>
						<td colspan="3">
							<input type="hidden" name="publisher" value="${form.publisher }" />
							<input type="hidden" name="cate_type" value="" /><!-- insert 시에만 필요 / popup에서 선택 시 값 입력 -->
							<input type="text" name="creator" value="${form.creator }" readonly="readonly" style="width:580px" />
							<span class="btn whiteS"><a href="#" class="uciOrg_btn">출처</a></span>
						</td>
					</tr>
					
					<tr >
						<th scope="row">썸네일 이미지</th>
						<td colspan="3">
							<input type="text" name="reference_identifier" value="${form.reference_identifier }" style="width:580px" />
							<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
							<div class="upload_pop_msg">(외부 이미지 URL 또는 110px * 85px 크기의 이미지를 선택해 주세요.)</div>
							<div class="upload_pop_img">
								<c:if test="${not empty form.reference_identifier }">
									<img src="${form.reference_identifier }" width="110" height="85" alt="" />
								</c:if>
							</div>
						</td>
					</tr>
					
					<tr>
							<th scope="row">URL</th>
							<td colspan="3">
								<input type="text" name="url" style="width:670px" value="${form.url}" />
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
					<tr <c:if test="${form.job_group_id ne '기관별추천도서'}">style="display: none;"</c:if> id="sec">
						<th scope="row">출판일시</th>
						<td colspan="3">
							<input type="text" name="reg_date" style="width:335px" value="${form.reg_date}" />
						</td>
					</tr>
					<tr <c:if test="${form.job_group_id ne '어린이추천도서'}">style="display: none;"</c:if> id="date">
						<th scope="row">출판년도</th>
						<td colspan="3">
							<input type="text" name="reg_date" style="width:335px" value="${form.reg_date}" />
						</td>
					</tr>
					<tr <c:if test="${form.job_group_id ne '발간도서'}">style="display: none;"</c:if> id="mon">
						<th scope="row">출판년월</th>
						<td colspan="3">
							<input type="text" name="reg_date" style="width:335px" value="${form.reg_date}" />
						</td>
					</tr>
			</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty form.uci ? '등록' : '수정' }</a></span>

		<c:if test="${not empty form.uci }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/knowledge/book/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>