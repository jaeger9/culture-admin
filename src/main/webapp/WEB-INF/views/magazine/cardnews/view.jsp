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
	    targetView.html('<img src="/upload/cardnews/' + res.file_path + '" width="150" height="150" alt="" />');
	}
};

$(function() {
	var frm = $('form[name=frm]');
	var source = frm.find('input[name=source]');
	var title = frm.find('input[name=title]');

	// 파일업로드
	$('.upload_pop_btn').click(function () {
		var p		=	$(this).parents('tr:eq(0)');
		target		=	p.find("input[name='file_name']");
		targetView	=	p.find('.upload_pop_img');

		Popup.fileUpload('cardnews');
		return false;
	});

	// radio check
	if ('${view.approval_yn}') {
		$('input:radio[name="approval_yn"][value="${view.approval_yn}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="approval_yn"][value="W"]').prop('checked', 'checked');
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
		
		if (source.val() == '') {
			alert('출처를 입력해 주세요');
			source.focus();
			return false;
		}
		if (title.val() == '') {
			alert("제목 입력해 주세요");
			title.focus();
			return false;
		}
		if ($('textarea[name=contents]').val() == '') {
			alert("내용을 입력해 주세요");
			$('textarea[name=contents]').focus();
			return false;
		}
		
		var file_chk = false;
		$("input[name='file_name']").each(function(){
		    if($(this).val()){
		    	file_chk = true;
		    }
		});
		if(!file_chk){
			alert("이미지를 선택해 주세요");
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
				frm.attr('action', '/magazine/cardnews/update.do');
				frm.submit();
			} else if ($(this).html() == '삭제') {
				if (!confirm('삭제 하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/magazine/cardnews/delete.do');
				frm.submit();
			} else if ($(this).html() == '등록') {
				if (!confirm('등록하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/magazine/cardnews/insert.do');
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = '/magazine/cardnews/list.do';
			}
		});
	});
});
</script>
</head>
<body>
<!-- 검색 필드 -->
<div class="tableWrite">
	<form name="frm" method="post" action="/magazine/cardnews/insert.do" enctype="multipart/form-data">
		<c:if test='${not empty view.seq}'>
			<input type="hidden" name="seq" value="${view.seq}"/>
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
					<c:if test='${not empty view}'>
						<tr>
							<th scope="row">조회수</th>
							<td>${view.view_cnt}</td>
						</tr>
					</c:if>
					<tr>
						<th scope="row"><span style="color:red">*</span> 출처</th>
						<td>
							<input type="text" name="source" style="width:500px" value="${view.source }"/>
						</td>
					</tr>
					<tr>
						<th scope="row"><span style="color:red">*</span> 제목</th>
						<td>
							<input type="text" name="title" id="title" style="width:500px"  value="<c:out value='${view.title }'/>"/>
						</td>
					</tr>
					<tr>
						<th scope="row"><span style="color:red">*</span> 내용</th>
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
						<textarea id="contents" name="contents" style="width:100%;height:400px;display:none;"><c:out value="${view.contents }" escapeXml="true" /></textarea>
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
					<col style="width:7%" />
					<col style="width:50%" />
					<col style="width:%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">순번</th>
						<th scope="row"><span style="color:red">*</span> 이미지<br/>
							<span style="color: rgba(126, 137, 155, 1);">540 * 540 px에 맞추어 등록해주시기 바랍니다.</span>
						</th>
						<th scope="row">이미지 설명<br/>
							<span style="color: rgba(126, 137, 155, 1);">※ 웹 접근성 준수사항으로 반드시 작성해야 합니다.<br/>
							(작성 방법: 이미지에 있는 텍스트 동일하게 기입. / 한 줄로 작성. / 내용은 ‘| ‘로 구분 )</span>
						</th>
					</tr>
					<c:forEach var="i" begin="1" end="30">
						<tr>
							<td style="text-align:center">${i}</th>
							<td>
								<table>
									<tr>
										<td>
											<span class="upload_pop_img">
												<c:if test="${not empty listFile[i-1].file_name }">
													<img src="/upload/cardnews/${listFile[i-1].file_name }" width="150" height="150" alt="" />
												</c:if>
											</span>
										</td>
										<td>
											<input type="hidden" name="file_name" value="${listFile[i-1].file_name }" />
											<span class="btn whiteS"><a href="#" class="upload_pop_btn">찾아보기</a></span>
											<c:if test="${not empty listFile[i-1].file_name }">
												<span class="inputBox">
													<label><input type="checkbox" name="file_delete" value="${listFile[i-1].file_name }" /> <strong>삭제</strong> ${listFile[i-1].file_name }</label>
												</span>
											</c:if>
										</td>
									</tr>
								</table>
							</td>
							<td>
								<textarea name="description" style="width:100%;height:150px;" maxlength="2000"><c:out value="${listFile[i-1].description }" escapeXml="true" /></textarea>
							</td>
							</tr>	
						</tr>
					</c:forEach>
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
								<label><input type="radio" name="approval_yn" value="W"/> 대기</label>
								<label><input type="radio" name="approval_yn" value="Y"/> 승인</label>
								<label><input type="radio" name="approval_yn" value="N"/> 미승인</label>
							</div>
						</td>
					</tr>
					<c:if test='${not empty view.seq}'>
						<tr>
						<th scope="row">모바일사용여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="mobile_yn" value="Y"  ${not empty view.mdescription ? 'checked="checked"' : '' }/>사용</label>
								<label><input type="radio" name="mobile_yn" value="N" ${empty view.mdescription ? 'checked="checked"' : '' }/>사용안함</label>
							</div>
						</td>
					</tr>
					</c:if>
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