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

	var frm = $('form[name=frm]');

	var title				= frm.find('input[name=title]');
	var use					= frm.find('input[name=use]');
	var pattern_name		= frm.find('input[name=pattern_name]');
	var url					= frm.find('input[name=url]');

	//layout
	
	//radio check
	if('${view.status}')$('input:radio[name="status"][value="${view.status}"]').prop('checked', 'checked');

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
//	nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		
		if(title.val() ==''){
			alert('제품명 입력하세요');
			title.focus();
			return false;
		}
		
		if($('textarea[name=concept]').val() ==''){
			alert('디자인 컨셉 입력하세요');
			$('textarea[name=concept]').focus();
			return false;
		}
		
		if(use.val() ==''){
			alert('용도 입력하세요');
			use.focus();
			return false;
		}
		
		if(pattern_name.val() ==''){
			alert('활용문양 입력하세요');
			pattern_name.focus();
			return false;
		}

		/*if(url.val() ==''){
			alert('관련 디자인정보 더보기(URL) 입력하세요');
			url.focus();
			return false;
		}*/
		
		return true;
	});
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		if (!confirm('수정하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/pattern/apply/gallery/update.do');
//        		oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
               	document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/pattern/apply/gallery/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/pattern/apply/gallery/insert.do');
//        		oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
               	document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		console.log('목록');
        		location.href='/pattern/apply/gallery/list.do';
        	}   		
    	});
	});
	
	//중복체크
	$('span.btn a').click(function(){
		if($(this).html() == '중복체크') {
		    code = $('input[name=org_code]').val();
	
		    var request = $.ajax({
		      url: "/main/agencycode/codeOverlapCheck.do",
		      type: "POST",
		      data: { org_code : code}
		    });
	
		    request.done(function( msg ) {
		    	if(msg.codeCnt < 1) {
		        	alert('사용 가능합니다.');
		          	$('input[name=orgIdCheckYN]').val('Y');
		      	} else { 
		          	alert('이미 등록된 코드 입니다.');
		          	$('input[name=orgIdCheckYN]').val('N');
		        	$('input[name=orgIdCheckYN]').focus();
		      	}
		    });
		    
		    request.fail(function( jqXHR, textStatus ) {
		      	alert( "Request failed: " + textStatus );
			});
	  	}
	});


	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/pattern/apply/gallery/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<table summary="활용갤러리 작성">
				<caption>활용갤러리   작성</caption>
				<colgroup><col style="width:18%" /><col style="width:34%" /><col style="width:14%" /><col style="width:34%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">제품명</th>
						<td colspan="3">
							<input type="text" name="title" style="width:670px" value="${view.title}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">작성자</th>
						<td>
							${view.user_id}
						</td>
						<th scope="row">등록일</th>
						<td>
							${view.reg_date}
							<c:if test="${not empty view.upd_date }">
								(최종수정일 ${view.upd_date}) 
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">디자인 컨셉</th>
						<td colspan="3">
							<textarea name="concept" style="width:100%;height:100px;"><c:out value="${view.concept }" escapeXml="true" /></textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">용도</th>
						<td colspan="3">
							<input type="text" name="use" style="width:670px" value="${view.use}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">활용문양</th>
						<td colspan="3">
							<input type="text" name="pattern_name" style="width:670px" value="${view.pattern_name}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">관련 디자인정보 </br>더보기(URL)</th>
						<td colspan="3">
							<input type="text" name="url" style="width:670px" value="${view.url}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">활용디자인 이미지</th>
						<td colspan="3">
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
							<c:if test='${not empty view.image_name}'>
								<div class="inputBox">
									${view.image_name}
								</div>
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">내용</th>
						<td colspan="3">
		        			<!-- 20151006 : 이용환 : 에디터 변경을 위해 수정 
							<textarea id="contents" name="description" style="width:100%;height:400px;display:none;"><c:out value="${view.concept }" escapeXml="true" /></textarea>
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
							<div class="inputBox">
								<label><input type="radio" name="status" value="W"/>대기</label>
								<label><input type="radio" name="status" value="Y"/>승인</label>
								<label><input type="radio" name="status" value="N" checked/>미승인</label>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div class="btnBox textRight">
		<c:if test='${not empty view}'>
			<span class="btn white"><button type="button">수정</button></span>
			<span class="btn white"><button type="button">삭제</button></span>
		</c:if>
		<c:if test='${empty view }'>
			<span class="btn white"><button type="button">등록</button></span>
		</c:if>
		<span class="btn gray"><button type="button">목록</button></span>
	</div>
</body>
</html>