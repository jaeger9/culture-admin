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
var target = null;
var targetView = null;

var callback = {
	fileUpload : function (res) {
		target.val(res.file_path);
	    targetView.html('<img src="/upload/culturemedia/' + res.file_path + '" width="150" height="150" alt="" />');
	}
};

$(function() {
	var frm = $('form[name=frm]');
	var tv_org= frm.find('input[name=tv_org]');
	var tv_hp2 = frm.find('input[name=tv_hp2]');
	var tv_hp3 = frm.find('input[name=tv_hp3]');
	var tv_title = frm.find('input[name=tv_title]');
	var tv_date = frm.find('input[name=tv_date]');

	
	new Datepicker(tv_date);

	// 파일업로드
	$('.upload_pop_btn').click(function () {
		var p		=	$(this).parents('tr:eq(0)');
		target		=	p.find("input[name='file_name']");
		targetView	=	p.find('.upload_pop_img');

		Popup.fileUpload('culturemedia');
		return false;
	});

	// radio check
	if ('${view.tv_approval_state}') {
		$('input:radio[name="tv_approval_state"][value="${view.tv_approval_state}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="tv_approval_state"][value="W"]').prop('checked', 'checked');
	}
	
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
	
	frm.submit(function() {
		document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
		
		if (tv_org.val() == '') {
			alert('기관명을 입력해주세요.');
			source.focus();
			return false;
		}
		
		if (tv_hp2.val() == '' || tv_hp3.val() == '') {
			alert('담당자 연락처를 입력해 주세요');
			tv_hp3.focus();
			return false;
		}
		
		if (tv_date.val() == '') {
			alert('날짜를 입력해주세요.');
			tv_date.focus();
			return false;
		}
		if (tv_title.val() == '') {
			alert('행사명을 입력해주세요.');
			tv_date.focus();
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
				frm.attr('action', '/magazine/culturemedia/update.do');
				frm.submit();
			} else if ($(this).html() == '삭제') {
				if (!confirm('삭제 하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/magazine/culturemedia/delete.do');
				frm.submit();
			} else if ($(this).html() == '등록') {
				if (!confirm('등록하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/magazine/culturemedia/insert.do');
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = '/magazine/culturemedia/list.do';
			}
		});
	});
});
</script>
</head>
<body>
<!-- 검색 필드 -->
<div class="tableWrite">
	<form name="frm" method="post" action="/magazine/culturemedia/insert.do" enctype="multipart/form-data">
		<c:if test='${not empty view.tv_seq}'>
			<input type="hidden" name="tv_seq" value="${view.tv_seq}"/>
		</c:if>
		<input type="hidden" name="cont_type" value="S"/>
		<input type="hidden" name="open_date" />
		<div class="tableWrite">	
			<table summary="카드 뉴스 컨텐츠 작성">
				<caption>카드 뉴스 컨텐츠 글쓰기</caption>
				<colgroup>
					<col style="width:15%" />
					<col style="width:%" />
				</colgroup>
				<tbody>
					<%-- <c:if test='${not empty view}'>
						<tr>
							<th scope="row">조회수</th>
							<td>${view.view_cnt}</td>
						</tr>
					</c:if> --%>
					<tr>
						<th scope="row"><span style="color:red">*</span> 기관명</th>
						<td>
							<input type="text" name="tv_org" style="width:500px" value="${view.tv_org }"/>
						</td>
					</tr>
					<tr>
						<th scope="row"><span style="color:red">*</span> 담당자연락처</th>
						<td>
							<select name="tv_hp1">
								<c:forEach items="${phoneList }" var="item">
									<option value="${item.value }">${item.value }</option>
								</c:forEach>
							</select>-
							<input type="text" name="tv_hp2" value="${view.tv_hp2 }" maxlength="4" /> -
							<input type="text" name="tv_hp3" value="${view.tv_hp3 }" maxlength="4" />
						</td>
					</tr>
					<tr>
						<th scope="row"><span style="color:red">*</span> 행사명</th>
						<td>
							<input type="text" name="tv_title" value="${view.tv_title }"/>							
						</td>
					</tr>
					<tr>
						<th scope="row"><span style="color:red">*</span> 행사날짜</th>
						<td>
							<input type="text" name="tv_date" value="${view.tv_date }" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th scope="row"><span style="color:red">*</span> 요청사항</th>
						<td>
							<%-- <textarea name="contents" style="width:100%;height:100px;" maxlength="2000"><c:out value="${view.contents}" escapeXml="true" /></textarea> --%>
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
						<textarea id="contents" name="tv_request" style="width:100%;height:400px;display:none;"><c:out value="${view.tv_request }" escapeXml="true" /></textarea>
						</td>	
					</tr>
				</tbody>
			</table>	
		</div>
		
		<br/>
		<div class="tableWrite">
			<table summary="카드 뉴스 컨텐츠 작성">
				<caption>카드 뉴스 컨텐츠 글쓰기</caption>
				<colgroup>
					<col style="width:15%" />
					<col style="width:%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">승인여부</th>
						<td>
							<div class="inputBox">
								<label><input type="radio" name="tv_approval_state" value="Y"/> 승인</label>
								<label><input type="radio" name="tv_approval_state" value="N"/> 미승인</label>
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