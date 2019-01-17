<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />

<script type="text/javascript">
var target = null;
var targetView = null;

var callback = {
	fileUpload : function (res) {
		target.val(res.file_path);
		targetView.html('<img src="/upload/cardinst/' + res.file_path + '" width="268" height="148" alt="" />');
	}
};

$(function() {
	var frm = $('form[name=frm]');
	var title = frm.find('input[name=title]');
	var file_name = frm.find('input[name=file_name]');
	var url = frm.find('input[name=url]');

	// 파일업로드
	$('.upload_pop_btn').click(function () {
		var p		=	$(this).parents('tr:eq(0)');
		target		=	p.find("input[name='file_name']");
		targetView	=	p.find('.upload_pop_img');

		Popup.fileUpload('knowledge_cardinst');
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
	if ('${view.approval_yn}') {
		$('input:radio[name="approval_yn"][value="${view.approval_yn}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="approval_yn"][value="W"]').prop('checked', 'checked');
	}
	
	frm.submit(function() {
		if (title.val() == '') {
			alert("기관명을 입력해 주세요");
			title.focus();
			return false;
		}
		if (file_name.val() == '') {
			alert("기관 이미지를 입력해 주세요");
			return false;
		}
		if (url.val() == '') {
			alert("홈페이지URL을 입력해 주세요");
			url.focus();
			return false;
		}
		if ($('textarea[name=contents]').val() == '') {
			alert("혜택 내용을 입력해 주세요");
			$('textarea[name=contents]').focus();
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
				frm.attr('action', '/cultureplan/cardInstitute/update.do');
				frm.submit();
			} else if ($(this).html() == '삭제') {
				if (!confirm('삭제 하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/cultureplan/cardInstitute/delete.do');
				frm.submit();
			} else if ($(this).html() == '등록') {
				if (!confirm('등록하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/cultureplan/cardInstitute/insert.do');
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = '/cultureplan/cardInstitute/list.do';
			}
		});
	});
});
</script>
</head>
<body>
<!-- 검색 필드 -->
<div class="tableWrite">
	<form name="frm" method="post" action="/cultureplan/cardInstitute/insert.do" enctype="multipart/form-data">
		<c:if test='${not empty view.seq}'>
			<input type="hidden" name="seq" value="${view.seq}"/>
		</c:if>
		<div class="tableWrite">	
			<table summary="카드대표참여기관 작성">
				<caption>카드대표참여기관 글쓰기</caption>
				<colgroup>
					<col style="width:15%" />
					<col style="width:%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">기관명</th>
						<td>
							<input type="text" name="title" id="title" style="width:100%"  value="<c:out value='${view.title }'/>"/>
						</td>
					</tr>
					<tr>
						<th scope="row">기관 이미지</th>
						<td>
							<input type="hidden" name="file_name" value="${view.file_name }" />
							<span class="upload_pop_img">
								<c:if test="${not empty view.file_name }">
									<img src="/upload/cardinst/${view.file_name }" width="268" height="148" alt="" />
								</c:if>
							</span>
							<span class="btn whiteS"><a href="#" class="upload_pop_btn">찾아보기</a></span>
							<c:if test="${not empty view.file_name }">
								<span class="inputBox">
									<label><input type="checkbox" name="file_delete" value="${view.file_name }" /> <strong>삭제</strong> ${view.file_name }</label>
								</span>
							</c:if>
							<span class="inputBox" style="vertical-align: bottom;">
							268 * 148 px에 맞추어 등록해주시기 바랍니다.
							</span>
						</td>
					</tr>
					<tr>
						<th scope="row">홈페이지 URL</th>
						<td>
							<input type="text" name="url" id="url" style="width:500px"  value="<c:out value='${view.url }'/>"/>
							<span class="btn whiteS"><a href="#" class="validate_pop_btn">유효성 검사</a></span>
						</td>
					</tr>
					<tr>
						<th scope="row">혜택 내용</th>
						<td>
							<textarea name="contents" style="width:100%;height:100px;" maxlength="2000"><c:out value="${view.contents}" escapeXml="true" /></textarea>
						</td>	
					</tr>
					<tr>
						<th scope="row">참고사항</th>
						<td>
							<textarea name="note" style="width:100%;height:100px;" maxlength="2000"><c:out value="${view.note}" escapeXml="true" /></textarea>
						</td>	
					</tr>
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