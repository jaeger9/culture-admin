<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<!-- <script type="text/javascript" src="/crosseditor/js/namo_scripteditor.js"></script> -->
<script type="text/javascript">
$(function() {
	var frm = $('form[name=frm]');
	var subject = frm.find('input[name=subject]');

	// 승인 여부  radio check
	if ('${view.approval_yn}') {
		$('input:radio[name="approval_yn"][value="${view.approval_yn}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="approval_yn"][value="W"]').prop('checked', 'checked');
	}
	
	frm.submit(function() {
		
		if (subject.val() == '') {
			alert("제목 입력해 주세요");
			title.focus();
			return false;
		}
		
		if ($('textarea[name=content]').val() == '') {
			alert("내용을 입력해 주세요");
			$('textarea[name=content]').focus();
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
				frm.attr('action', '/culturepro/cultureQna/update.do');
				frm.submit();
			} else if ($(this).html() == '삭제') {
				if (!confirm('삭제 하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/cultureQna/delete.do');
				frm.submit();
			} else if ($(this).html() == '답변') {
				if (!confirm('답변 하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/cultureQna/comments.do');
				frm.submit();
			} else if ($(this).html() == '등록') {
				if (!confirm('등록하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/cultureQna/insert.do');
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = '/culturepro/cultureQna/list.do';
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
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<div class="tableWrite">
				<table summary="관리자 문의/제안관리 등록 페이지입니다.">
					<caption>관리자 문의/제안관리 컨텐츠</caption>
					<tbody>
						<tr>
							<th scope="row">등록일</th>
							<td colspan="3">
								<span><c:out value='${view.reg_dt }'/></span>
							</td>
						</tr>
						<tr>
							<th scope="row">답변일</th>
							<td colspan=>
								<span><c:out value='${view.rep_dt }'/></span>
							</td>
							<th scope="row">답변자</th>
							<td colspan=>
								<span><c:out value='${view.rep_id }'/></span>
							</td>
						</tr>
						<tr>
							<th scope="row">제목</th>
							<td colspan="3">
								<span>
									<input type="text" id="subject" name="subject" value="<c:out value='${view.subject }'/>" class="inputText width80" />
								</span>
							</td>
						</tr>
						<tr>
							<th scope="row">질문</th>
							<td colspan="3">
								<textarea id="content2" name="content2" style="width:100%;height:100px;" maxlength="2000"><c:out value="${view.content}" escapeXml="true" /></textarea>
							</td>
						</tr>
						<tr>
							<th scope="row">답변</th>
							<td colspan="3">
								<textarea id="comments" name="comments" style="width:100%;height:100px;" maxlength="2000"><c:out value="${view.comments}" escapeXml="true" /></textarea>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<br />
			
			<%-- <!-- 승인여부 -->
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
							<td><label><input type="radio" name="status"
									value="W"
									${view.status eq 'W' ? 'checked="checked"' : '' } /> 대기</label> <label><input
									type="radio" name="status" value="Y"
									${view.status eq 'Y' ? 'checked="checked"' : '' } /> 승인</label> <label><input
									type="radio" name="status" value="N"
									${view.status eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
							</td>
						</tr>
					</tbody>
				</table>
			</div> --%>

		</form>
	</div>
	<div class="btnBox textRight">
	<c:if test='${not empty view}'>
		<span class="btn gray"><button type="button">답변</button></span>
		<span class="btn gray"><button type="button">수정</button></span>
		<span class="btn gray"><button type="button">삭제</button></span>
	</c:if>
	<c:if test='${empty view}'>
		<span class="btn gray"><button id="register" type="button">등록</button></span>
	</c:if>
		<span class="btn gray"><button id="list" type="button">목록</button></span>
	</div>
</body>
</html>