<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

$(function () {
	var frm			=	$('form[name=frm]');
	var seq			=	frm.find('input[name=seq]');

	var name			=	frm.find('input[name=name]');
	var email			=	frm.find('input[name=email]');
	var title			=	frm.find('input[name=title]');
	var content			=	frm.find('textarea[name=content]');


	// 등록/수정
	$('.insert_btn').click(function () {		
		if (seq.val() != '') {
			if (!confirm('저장하시겠습니까?')) {
				return false;
			}else{
				$('form[name=frm]').attr('action','/addservice/culturecok/eventHelpForm.do');
				frm.submit();
			}
		}
		return false;
	});
	
});

function sendMail(){
	
	if($('textarea[name=reply_content]').val().trim().length < 1){
		alert('답변 내용을 입력해주세요.');
		return false;
	}
	
	if(confirm('답변 내용을 저장하고 메일을 발송하시겠습니까?')){
		$('form[name=frm]').attr('action','/addservice/culturecok/eventHelpMail.do');
		$('form[name=frm]').submit();
	}
}

</script>
</head>
<body>

<form name="frm" method="POST" action="/addservice/culturecok/eventHelpForm.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>
	
	<input type="hidden" name="seq" value="${view.seq }" />

	<div class="tableWrite">
		<table summary="게시판 글 등록">
			<caption>게시판 글 등록</caption>
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">이름</th>
					<td>
						<input type="text" name="name" value="${view.name}" maxlength="10" style="width:500px;" readonly="readonly"/>
					</td>
				</tr>
				
				<tr>
					<th scope="row">이메일</th>
					<td>
						<input type="text" name="email" value="${view.email}" maxlength="30" style="width:500px;" readonly="readonly"/>
					</td>
				</tr>
				
				<tr>
					<th scope="row">제목</th>
					<td>
						<input type="text" name="title" maxlength="150" value="${view.title}" style="width:500px;" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<th scope="row">내용</th>
					<td>
						<textarea name="content" maxlength="150" style="width:100%; height:100px;" readonly="readonly">${view.content }</textarea>
					</td>
				</tr>
					
				<tr>
					<th scope="row">처리상태</th>
					<td>
						<select name="state">
							<option value="접수" ${empty view.state or view.state eq '접수' ? 'selected="selected"' : '' }>접수</option>
							<option value="답변중" ${view.state eq '답변중' ? 'selected="selected"' : '' }>답변중</option>
							<option value="답변완료" ${view.state eq '답변완료' ? 'selected="selected"' : '' }>답변완료</option>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row" rowspan="2">답변 내용</th>
					<td>
						<textarea name="reply_content" maxlength="200" style="width:100%; height:100px;">${view.reply_content }</textarea>	
					</td>
				</tr>
				<tr>
					<td style="border-top: none; text-align: right;">
						<c:if test="${not empty view.seq }"><span class="btn gray"><a href="#" onclick="sendMail();" class="list_btn">메일보내기</a></span></c:if>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn gray"><a href="#" class="insert_btn">등록</a></span>
		<span class="btn gray"><a href="/addservice/culturecok/eventHelpList.do" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>