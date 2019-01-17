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
	
	//layout
	
	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
//	nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
    				return false;
    			}
        		frm.attr('action' ,'/perform/review/answer/insert.do');
//        		oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
               	document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/perform/review/list.do';
        	}   		
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/perform/review/answer/insert.do">
			<input type="hidden" name="parent_seq"   value="<c:out value="${paramMap.seq}" />" />
			<input type="hidden" name="review_level" value="<c:out value="${view.review_level }" />" />
			<input type="hidden" name="review_order" value="<c:out value="${view.review_order }" />" />
			<input type="hidden" name="uci"          value="<c:out value="${view.uci }" />" />
			<table summary="공연장 등록/수정">
				<caption>공연장 등록/수정</caption>
				<colgroup>
					<col style="width:17%" /><col style="width:33%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">제목</th>
						<td colspan="3">
							<input type="text" name="title" style="width:670px"/>
						</td>
					</tr>
					<tr>
						<th scope="row">내용</th>
						<td colspan="3">
		        			<!-- 20151006 : 이용환 : 에디터 변경을 위해 수정 
							<textarea id="contents" name="content" style="width:100%;height:400px;">
								<br />
								<br />
								<br />
								--------------------원문내용--------------------<br />
								<c:out value="${view.content }" />
							</textarea>
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
							<textarea id="contents" name="content" style="width:100%;height:400px;display:none;">
								<br />
								<br />
								<br />
								--------------------원문내용--------------------<br />
								<c:out value="${view.content }" />
							</textarea>
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