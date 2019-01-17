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
<script type="text/javascript" src="/crosseditor_3.5.0.11/js/namo_scripteditor.js"></script>

<script type="text/javascript">

var callback = {
	magazineagency : function (res) {
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
		
		$('input[name=company_seq]').val(res.orgId);
		$('input[name=company_name]').val(res.name);
	}
};

$(function () {

	var frm = $('form[name=frm]');
	var sw		= frm.find('input[name=sw]');
	var ucc_idx		= frm.find('input[name=ucc_idx]');
	var ucc_tbl		= frm.find('input[name=ucc_tbl]');
	var ucc_round		= frm.find('input[name=ucc_round]');
	var title		= frm.find('input[name=title]');
	var company_name		= frm.find('input[name=company_name]');
	var url		= frm.find('input[name=url]');

	//layout
	
	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
	// 20151006 : 이용환 : 에디터 변경을 위해 삭제
	// nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	
	//공연상 선택
	$('span.btn.whiteS a').each(function(){
	  	$(this).click(function(){
	    	if( $(this).html() == '선택'){
	      		window.open('/popup/magazineagency.do', 'placePopup', 'scrollbars=yes,width=400,height=300');
	    	} 
	  	});
	});
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		
		if(title.val() ==''){
			alert('제목 입력하세요');
			title.focus();
			return false;
		}

		if(company_name.val() ==''){
			alert('출처 입력하세요');
			company_name.focus();
			return false;
		}
		
		if(url.val() ==''){
			alert('URL 입력하세요');
			url.focus();
			return false;
		}
		
		return true;
	});
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/magazine/agency/insert.do');
           		// 20151006 : 이용환 : 에디터 변경을 위해 삭제
           		//oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
            	document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/magazine/agency/list.do';
        	}   		
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/magazine/agency/insert.do" enctype="multipart/form-data">
			<input type="hidden" value="" name="company_seq">
			<!-- <input type="hidden" value="" name="seq"> -->
			<input type="hidden" value="" name="sw">
			<input type="hidden" value="" name="ucc_idx">
			<input type="hidden" value="" name="ucc_tbl">
			<input type="hidden" value="" name="ucc_round">
			<table summary="공연/전시  작성">
				<caption>공연/전시 글쓰기</caption>
				<colgroup>
					<col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">제목</th>
						<td colspan="3">
							<input type="text" name="title" id="title" style="width:670px">
						</td>
					</tr>
					<tr>
						<th scope="row">출처</th>
						<td colspan="3">
							<input type="text" name="company_name" style="width:300px">
							<span class="btn whiteS"><a href="#url">선택</a></span>
						</td>
					</tr>
					<tr>
						<th scope="row">URL</th>
						<td>
							<input type="text" name="url" style="width:670px">
						</td>
					</tr>
					<tr>
						<th scope="row">썸네일 이미지</th>
						<td colspan="3">
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">내용</th>
						<td colspan="3">
							<!-- 20151005 이용환 에디터변경을 위해 삭제
							<textarea id="contents" name="content" style="width:100%;height:400px;"></textarea>
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
							<textarea id="contents" name="content" style="display:none;"></textarea>
						</td>	
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval" value="W"/> 대기</label>
								<label><input type="radio" name="approval" value="Y"/> 승인</label>
								<label><input type="radio" name="approval" value="N"/> 미승인</label>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div class="btnBox textRight">
		<span class="btn white"><button type="button">등록</button></span>
		<span class="btn gray"><button type="button">목록</button></span>
	</div>
</body>
</html>