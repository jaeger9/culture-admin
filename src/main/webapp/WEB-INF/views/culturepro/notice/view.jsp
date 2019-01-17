<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="/crosseditor/js/namo_scripteditor.js"></script>
<script type="text/javascript" src="/js/smartEdit/js/HuskyEZCreator.js"></script>
<script type="text/javascript">
var target = null;
var targetView = null;

var callback = {
	fileUpload : function (res) {
		target.val(res.file_path);
		targetView.html('<img src="/upload/cardvideo/' + res.file_path + '" width="480" height="360" alt="" />');
	}
};

$(function() {
	var frm = $('form[name=frm]');
	var title = frm.find('input[name=title]');
	
	
	
	// 승인 여부  radio check
	if ('${view.approval_yn}') {
		$('input:radio[name="approval_yn"][value="${view.approval_yn}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="approval_yn"][value="W"]').prop('checked', 'checked');
	}
	
	// 상세 페이지
	if ('${view.outlink_kind}') {
		$('input:radio[name="outlink_kind"][value="${view.outlink_kind}"]').prop('checked', 'checked');
	}

	
	frm.submit(function() {
		
		if (title.val() == '') {
			alert("제목 입력해 주세요");
			title.focus();
			return false;
		}
		oEditors.getById["contents"].exec("UPDATE_CONTENTS_FIELD", []);
		if ($('textarea[name=contents]').val() == '') {
			alert("내용을 입력해 주세요");
			$('textarea[name=contents]').focus();
			return false;
		}
// 		if(!CrossEditor.IsDirty()){ // 크로스에디터 안의 컨텐츠 입력 확인 
// 		      alert(" 에디터에 내용을 입력해 주세요 !!"); 
// 		      CrossEditor.SetFocusEditor();// 크로스에디터 Focus 이동 
// 		      return false; 
// 		 }
		
		//크로스 에디터에서 작성한 컨텐츠의 내용을 가져오기
// 		document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
		
		return true;
	});

	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
		$(this).click(function() {
			if ($(this).html() == '수정') {
				if (!confirm('수정하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/cultureNotice/update.do');
				frm.submit();
			} else if ($(this).html() == '삭제') {
				if (!confirm('삭제 하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/cultureNotice/delete.do');
				frm.submit();
			} else if ($(this).html() == '등록') {
				if (!confirm('등록하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/cultureNotice/insert.do');
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = '/culturepro/cultureNotice/list.do';
			} else if ($(this).html() == '미리보기') {
				
			}
		});
	});
});
</script>
</head>
<body>

	<div class="tableWrite">
		<form name="frm" method="post" 
			enctype="multipart/form-data">
			<c:if test='${not empty view}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<div class="tableWrite">
				<table summary="관리자 공지사항관리 페이지입니다.">
					<caption>공지사항관리 </caption>
					<tbody>
					 <c:if test='${not empty view}'>
						<tr>
							<th scope="row">등록일</th>
							<td><span><c:out value='${view.reg_date }'/></span></td>
						</tr>
						<tr>
							<th scope="row">조회수</th>
							<td><span><c:out value='${view.view_cnt }'/></span></td>
						</tr>
					</c:if>
						<tr>
							<th scope="row"><span style="color: red">*</span> 제목</th>
							<td><span><input type="text" id="title" name="title" value="<c:out value='${view.title }'/>"
									class="inputText width80" /></span></td>
						</tr>
						<tr>
							<th scope="row"> 상세페이지(url)</th>
							<td>
								<span>
									<label><input type="radio" name="outlink_kind" value="in"/> 내부링크</label>
									<label><input type="radio" name="outlink_kind" value="ex"/> 외부링크</label>
								</span>
								<input type="text" id="outlink" name="outlink" value="${view.outlink }" style="width:100%;" />
							</td>
						</tr>
						<tr>
							
							<td colspan="2">
								<textarea id="contents" name="contents" style="width:100%;height:100px;">${view.contents}</textarea>
								<!-- 스크립트 -->
								<script type="text/javascript">
									var oEditors = [];
									nhn.husky.EZCreator.createInIFrame({
										oAppRef: oEditors,
										elPlaceHolder: "contents",
										sSkinURI: "/js/smartEdit/SmartEditor2Skin.html",
										fCreator: "createSEditor2",
										htParams: {
											fOnBeforeUnload:function(){
												return;
											}
										}
									});
								</script>
								<script type="text/javascript" language="javascript">
// 									var CrossEditor = new NamoSE('contents');
// 									CrossEditor.params.Width = "725px";
// 									CrossEditor.params.Height = "650px";
// 									CrossEditor.params.UserLang = "auto";
// 									CrossEditor.params.UploadFileSizeLimit = "image:10485760";
// 									CrossEditor.params.Font = {"NanumGothic":"나눔고딕","Dotum":"돋움", "Gulim":"굴림", "Batang":"바탕", "Gungsuh":"궁서", "맑은 고딕":"맑은 고딕"  ,"David":"David", "MS Pgothic":"MS Pgothic","Simplified Arabic":"Simplified Arabic","SimSun":"SimSun","Arial":"Arial","Courier New":"Courier New", "Tahoma":"Tahoma", "Times New Roman":"Times New Roman", "verdana":"Verdana"};
// 									CrossEditor.EditorStart();
// 									function OnInitCompleted(e){
// 										e.editorTarget.SetBodyValue(document.getElementById("contents").value);
// 									}
								</script>
								<textarea id="contents" name="contents_1" style="display: none"><c:out value="${view.contents }" escapeXml="true" /></textarea>
								
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<br />
			
			<!-- 승인여부 -->
			<div class="tableWrite">
				<table summary="문화융성앱 컨텐츠 등록 승인 여부">
					<caption>승인여부</caption>
					<colgroup>
						<col style="width: 15%" />
						<col style="width: %" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">승인여부</th>
							<td><label><input type="radio" name="approval_yn"
									value="W"
									${view.approval_yn eq 'W' ? 'checked="checked"' : '' } /> 대기</label> <label><input
									type="radio" name="approval_yn" value="Y"
									${view.approval_yn eq 'Y' ? 'checked="checked"' : '' } /> 승인</label> <label><input
									type="radio" name="approval_yn" value="N"
									${view.approval_yn eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

		</form>
	</div>
	<div class="btnBox">
		<!-- <span class="btn white"><button type="button">미리보기</button></span> -->
	<c:if test='${not empty view}'>
		<span class="fr">
		<span class="btn dark"><button type="button">수정</button></span> 
		<span class="btn dark"><button type="button">삭제</button></span>
		<span class="btn dark"><button id="list" type="button">목록</button></span> 
		</span>
	</c:if>
	<c:if test='${empty view}'>
		<span class="fr">
		<span class="btn dark"><button id="register" type="button">등록</button></span>
		<span class="btn dark"><button id="list" type="button">목록</button></span> 
		</span>
	</c:if>
	
	</div>
</body>
</html>