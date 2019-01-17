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
			targetView.html('<img src="' + res.file_path + '" width="480" height="360" alt="" />');
		}
	};
	
$(function() {
	// 상세 페이지
	if ('${view.outlink_kind}') {
		$('input:radio[name="outlink_kind"][value="${view.outlink_kind}"]').prop('checked', 'checked');
	}
	
	// 파일업로드
	$('.upload_pop_btn').click(function () {
		var p		=	$(this).parents('tr:eq(0)');
		target		=	p.find("input[name='file_name']");
		targetView	=	p.find('.upload_pop_img');

		Popup.fileUpload('cultureAppPop');
		return false;
	});
	

	var frm = $('form[name=frm]');
	var title = frm.find('input[name=title]');
	var strt_dt = frm.find('input[name=strt_dt]');
	var end_dt = frm.find('input[name=end_dt]');

	new Datepicker(strt_dt, end_dt);

	// 승인 여부  radio check
	if ('${view.approval_yn}') {
		$('input:radio[name="approval_yn"][value="${view.approval_yn}"]')
				.prop('checked', 'checked');
	} else {
		$('input:radio[name="approval_yn"][value="W"]').prop('checked',
				'checked');
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

		return true;
	});

	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
		$(this).click(function() {
			if ($(this).html() == '수정') {
				if (!confirm('수정하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/culturePop/update.do');
				frm.submit();
			} else if ($(this).html() == '삭제') {
				if (!confirm('삭제하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/culturePop/delete.do');
				frm.submit();
			} else if ($(this).html() == '등록') {
				if (!confirm('등록하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/culturePop/insert.do');
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = '/culturepro/culturePop/list.do';
			}
		});
	});
});
</script>
</head>
<body>
	<div class="tableWrite">
		<form name="frm" method="post" enctype="multipart/form-data">
			<c:if test='${not empty view}'>
				<input type="hidden" name="seq" value="${view.seq}" />
			</c:if>
			<div class="tableWrite">
				<table summary="관리자 팝업 등록 페이지입니다.">
					<caption>관리자 팝업 컨텐츠</caption>
					<colgroup>
						<col width="20%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">기간</th>
							<td><input type="text" name="strt_dt" class="datepicker"
								value="${view.strt_dt }" /> <span>~</span> <input type="text"
								name="end_dt" class="datepicker" value="${view.end_dt }" /></td>
						</tr>
						<tr>
							<th scope="row">제목</th>
							<td><span> <input type="text" id="title" name="title"
									value="<c:out value='${view.title }'/>"
									class="inputText width80" />
							</span></td>
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
							<th scope="row">이미지</th>
							<%-- <td>
								<span class="btn whiteS">									
									<input type="hidden" name="file_name" id="file_name"  value="${view.contents}" />
									<a href="#" class="upload_pop_btn">찾아보기</a>
								</span><br />
								<span class="upload_pop_img">  
									<c:if test="${not empty view.content}">
										<img src="http://m.culture.go.kr/upload/culturePop/${view.contents}" width="480" height="360" alt="" />
									</c:if>
								</span>  			 
								<input type="hidden" name="old_file_name" value="${view.contents}" />
							</td> --%>
							<td colspan="2">
								
								<textarea id="contents" name="contents" style="display: none"><c:out value="${view.contents }" escapeXml="true" /></textarea>								
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
								
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<br />

			<!-- 승인여부 -->
			<div class="tableWrite">
				<table summary="문화/제안 등록 여부">
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
	<div class="btnBox textRight">
		<c:if test='${not empty view}'>
			<span class="btn gray"><button id="register" type="button">수정</button></span>
		</c:if>
		<c:if test='${empty view}'>
			<span class="btn gray"><button id="register" type="button">등록</button></span>
		</c:if>
		<span class="btn gray"><button id="list" type="button">목록</button></span>
	</div>
</body>
</html>