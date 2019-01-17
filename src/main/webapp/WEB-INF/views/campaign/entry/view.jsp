<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

$(function() {
	var frm = $('form[name=frm]');
	var del_yn = frm.find('select[name=del_yn]');
	var contents = frm.find('input[name=contents]');

	frm.submit(function() {
		if (contents.val() == '') {
			alert("내용을 입력해 주세요");
			contents.focus();
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
				frm.attr('action', 'update.do');
				frm.submit();
			} else if ($(this).html() == '삭제') {
				if (!confirm('삭제 하시겠습니까?')) {
					return false;
				}
				frm.attr('action', 'delete.do');
				frm.submit();
			} else if ($(this).html() == '등록') {
				if (!confirm('등록하시겠습니까?')) {
					return false;
				}
				frm.attr('action', 'insert.do');
				frm.submit();
			} else if($(this).html() == '답변하기') {
				if (!confirm('답변하시겠습니까?')) {
					return false;
				}
				frm.attr('action', 'reply.do');
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = 'list.do';
			}
		});
	});

});

</script>
</head>
<body>

<div class="tableWrite">
	<form name="frm" method="post" action="/campaign/news/insert.do" enctype="multipart/form-data">
		<c:if test='${not empty view.seq}'>
			<input type="hidden" name="seq" value="${view.seq}"/>
			<input type="hidden" name="event_seq" value="${view.event_seq}"/>
		</c:if>
		<div class="sTitBar">
			<h4>응모작 컨텐츠</h4>
		</div>
		<div class="tableWrite">	
			<table summary="응모작 컨텐츠 작성">
				<caption>응모작 글쓰기</caption>
				<colgroup>
					<col style="width:15%" />
					<col style="width:35%" />
					<col style="width:15%" />
					<col style="width:35%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">구분</th>
						<td>${view.event_nm }</td>
						<th scope="row">등록일</th>
						<td>${view.reg_date }</td>
					</tr>
					<tr>
						<th scope="row">작성자(이름)</th>
						<td>${view.user_nm }</td>						
						<th scope="row">이메일</th>
						<td>${view.user_email }</td>
					</tr>
					<tr>
						<th scope="row">이미지</th>
						<td colspan="3">
							<p><input type="file" name="file"/></p>
							<p style="margin-top:8px;"><img src="/${view.file_path }/${view.sys_file_nm }" style="height:200px;" alt="${view.ori_file_nm }"/></p>
						</td>
					</tr>
					<tr>
						<th scope="row">한 줄 메세지</th>
						<td colspan="3">
							<textarea name="contents" style="width:100%;height:100px;">${view.contents }</textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">노출여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="del_yn" value="N" <c:if test="${view.del_yn eq 'N' }">checked="checked"</c:if>/> 공개</label>
								<label><input type="radio" name="del_yn" value="Y" <c:if test="${view.del_yn eq 'Y' }">checked="checked"</c:if>/> 비공개</label>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>
</div>

<div class="btnBox">
<c:if test='${not empty view}'>
	<span class="btn white"><button type="button">수정</button></span>
	<span class="btn white"><button type="button">삭제</button></span>
</c:if>
	<span class="btn gray fr" style="margin-left:2px;"><button type="button">목록</button></span>
</div>

</body>
</html>