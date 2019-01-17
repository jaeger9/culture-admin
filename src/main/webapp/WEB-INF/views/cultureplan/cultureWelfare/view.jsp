<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<c:if test="${paramMap.gubun eq 'W' }">
	<c:set var="list_url" value="/cultureplan/cultureWelfare/list.do"/>
	<c:set var="view_url" value="/cultureplan/cultureWelfare/view.do"/>
</c:if>
<c:if test="${paramMap.gubun eq 'E' }">
	<c:set var="list_url" value="/cultureplan/cultureWelfare/enterpriseList.do"/>
	<c:set var="view_url" value="/cultureplan/cultureWelfare/enterpriseView.do"/>
</c:if>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="/crosseditor/js/namo_scripteditor.js"></script>

<script type="text/javascript">
var target = null;
var targetView = null;

var callback = {
	fileUpload : function (res) {
		target.val(res.file_path);
		targetView.html('<img src="/upload/welfare/' + res.file_path + '" width="268" height="148" alt="" />');
	}
};

$(function() {
	var frm = $('form[name=frm]');
	var title = frm.find('input[name=title]');
	var file_name = frm.find('input[name=file_name]');
	var url = frm.find('input[name=url]');
	var start_date	=	frm.find('input[name=start_date]');
	var end_date	=	frm.find('input[name=end_date]');
	var content		=	frm.find('textarea[name=content]');
	
	new Datepicker(start_date, end_date);


	// 파일업로드
	$('.upload_pop_btn').click(function () {
		var p		=	$(this).parents('tr:eq(0)');
		target		=	p.find("input[name='file_name']");
		targetView	=	p.find('.upload_pop_img');

		Popup.fileUpload('knowledge_welfare');
		return false;
	});
	
	$("input:checkbox[name='file_delete']").change(function() {
		var file_name = $(this).parent().parent().parent().find('input[name=file_name]');
		if($(this).is(":checked")) {
			if(file_name.val() == $(this).val()){
				file_name.val("");	
			}
		}else{
			file_name.val($(this).val());
		}
	});
	
	// 유효성 검사
	$('.validate_pop_btn').click(function () {
		if($("input[name=url]").val() == ""){
			alert("URL을 입력해주세요.");
			return false;
		}
		window.open($("input[name=url]").val(), 'view');
		return false;
	});

	// radio check
	if ('${view.approval}') {
		$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="approval"][value="W"]').prop('checked', 'checked');
	}
	
	frm.submit(function() {
		
		document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
		
		if($('input[name=new_win_chk]').is(":checked")){
			$('input[name=new_win_yn]').val('Y');
		}else{
			$('input[name=new_win_yn]').val('N');
		}
		
		if (title.val() == '') {
			alert("제목을 입력해 주세요");
			title.focus();
			return false;
		}
		if (url.val() == '') {
			alert("URL을 입력해 주세요");
			url.focus();
			return false;
		}
		return true;
	});

	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
		$(this).click(function() {
			if ($(this).html() == '수정') {
				if (!confirm('수정하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/cultureplan/cultureWelfare/update.do');
				frm.submit();
			} else if ($(this).html() == '삭제') {
				if (!confirm('삭제 하시겠습니까?')) {
					return false;
				}s
				frm.attr('action', '/cultureplan/cultureWelfare/delete.do');
				frm.submit();
			} else if ($(this).html() == '등록') {
				if (!confirm('등록하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/cultureplan/cultureWelfare/insert.do');
				frm.submit();
			} else if ($(this).html() == '목록') {
				
				location.href = '${list_url}';
			}
		});
	});
});
</script>
</head>
<body>
<!-- 검색 필드 -->
<div class="tableWrite">
	<form name="frm" method="post" action="/cultureplan/cultureWelfare/insert.do" enctype="multipart/form-data">
		<input type="hidden" name="gubun" value="${paramMap.gubun}"/>
		<input type="hidden" name="new_win_yn" value=""/>
		<c:if test='${not empty view.seq}'>
			<input type="hidden" name="seq" value="${view.seq}"/>
		</c:if>
		<div class="tableWrite">	
			<table summary="문화복지혜택">
				<caption>문화복지혜택 글쓰기</caption>
				<colgroup>
					<col style="width:15%" />
					<col style="width:%" />
					<col style="width:15%" />
					<col style="width:%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">등록일</th>
						<td>
							${view.reg_date }
						</td>
						<th scope="row">조회수</th>
						<td>
							${view.view_cnt }
						</td>
					</tr>
					<tr>
						<th scope="row"><font style="color: red;">&#42;</font> 제목</th>
						<td colspan="3">
							<input type="text" name="title" id="title" maxlength="300" style="width:80%" value="<c:out value='${view.title }'/>"/>
						</td>
					</tr>
					<tr>
						<th scope="row"><font style="color: red;">&#42;</font> URL</th>
						<td colspan="3">
							<input type="text" name="url" id="url" maxlength="150" style="width:350px" value="<c:out value='${view.url }'/>"/>
							<input type="checkbox" ${view.new_win_yn eq 'Y' ? 'checked="checked"':''} title="새창열림여부" name="new_win_chk"/>&nbsp;새창&nbsp;
							<span class="btn whiteS"><a href="#" class="validate_pop_btn">유효성 검사</a></span>
						</td>
					</tr>
					<tr>
						<th scope="row">기간</th>
						<td colspan="3">
							<input type="text" name="start_date" value="${view.start_date}" readonly="readonly"/>
							<span>~</span>
							<input type="text" name="end_date" value="${view.end_date }" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th scope="row">이미지</th>
						
						<td colspan="3">
							<input type="hidden" name="file_name" value="${view.file_name }" />
							<span class="upload_pop_img">
								<c:if test="${not empty view.file_name }">
									<img src="/upload/welfare/${view.file_name }" width="268" height="148" alt="" />
								</c:if>
							</span>
							<span class="btn whiteS"><a href="#" class="upload_pop_btn">찾아보기</a></span>
							<c:if test="${not empty view.file_name }">
								<span class="inputBox">
									<label><input type="checkbox" name="file_delete" value="${view.file_name }" /> <strong>삭제</strong> ${view.file_name }</label>
								</span>
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">내용</th>
						<td colspan="3">
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
						<td>
							<div class="inputBox">
								<label><input type="radio" name="approval" value="W" <c:if test="${view.approval eq 'W'}">checked="checked"</c:if>/> 대기</label>
								<label><input type="radio" name="approval" value="Y" <c:if test="${view.approval eq 'Y'}">checked="checked"</c:if>/> 승인</label>
								<label><input type="radio" name="approval" value="N" <c:if test="${view.approval eq 'N'}">checked="checked"</c:if>/> 미승인</label>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
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