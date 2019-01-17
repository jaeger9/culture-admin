<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	// 치환변수
	pageContext.setAttribute("cr", "\r"); //Space
	pageContext.setAttribute("cn", "\n"); //Enter
	pageContext.setAttribute("crcn", "\r\n"); //Space, Enter
	pageContext.setAttribute("br", "<br/>"); //br 태그
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

$(function() {
	var frm = $('form[name=frm]');
	var open_yn = frm.find('select[name=open_yn]');
	var title = frm.find('input[name=title]');

	// radio check
	if ('${view.open_yn}') {
		$('input:radio[name="open_yn"][value="${view.open_yn}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="open_yn"][value="1"]').prop('checked', 'checked');
	}

	frm.submit(function() {
		if (title.val() == '') {
			alert("제목을 입력해 주세요");
			title.focus();
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
	<form name="frm" method="post" action="/campaign/news/insert.do">
		<c:if test='${not empty view.seq}'>
			<input type="hidden" name="seq" value="${view.seq}"/>
		</c:if>
		<div class="sTitBar">
			<h4>캠페인 문의하기 컨텐츠</h4>
		</div>
		<div class="tableWrite">	
			<table summary="캠페인 소식 컨텐츠 작성">
				<caption>캠페인 문의하기 컨텐츠 글쓰기</caption>
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
						<th scope="row">작성자(이름)</th>
						<td>${view.user_nm }</td>
					</tr>
					<tr>
						<th scope="row">등록일</th>
						<td>${view.reg_date }</td>
						<th scope="row">조회수</th>
						<td>${view.view_cnt }</td>
					</tr>
					<tr>
						<th scope="row">이메일(비밀번호)</th>
						<td colspan="3">${view.user_email }</td>
					</tr>
					<tr>
						<th scope="row">공개여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="open_yn" value="Y" <c:if test="${view.open_yn eq 'Y' }">checked="checked"</c:if>/> 공개</label>
								<label><input type="radio" name="open_yn" value="N" <c:if test="${view.open_yn eq 'N' }">checked="checked"</c:if>/> 비공개</label>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">제목</th>
						<td colspan="3">
							<input type="text" name="title" style="width:100%;" value="<c:out value='${view.title }'/>"/>
						</td>
					</tr>
					<tr>
						<th scope="row">내용</th>
						<td colspan="3">
							<textarea name="contents" style="width:100%;height:200px;">${fn:replace(view.contents, br, crcn) }</textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">첨부파일</th>
						<td colspan="3">
							<c:if test="${not empty view.sys_file_nm }">
								<a href="${view.file_path }/${view.sys_file_nm }" target="blank">${view.ori_file_nm }</a>
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">답변</th>
						<td colspan="3">
							<c:if test="${view.reply_yn eq 'Y' }">
								답변 ${view.rep_date }
							</c:if>
							<textarea name="rep_contents" style="width:100%;height:200px;" <c:if test="${view.reply_yn eq 'Y' }">disabled="disabled"</c:if>>${fn:replace(view.rep_contents, br, crcn) }</textarea>
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

<c:if test="${view.reply_yn eq 'N' }">	
	<span class="btn gray fr"><button type="button">답변하기</button></span>
</c:if>
</div>

</body>
</html>