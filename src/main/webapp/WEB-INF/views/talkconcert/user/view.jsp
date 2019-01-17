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
	var event_seq = frm.find('select[name=event_seq]');
	var title = frm.find('input[name=title]');

	// radio check
	if ('${view.category}') {
		$('input:radio[name="category"][value="${view.category}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="category"][value="1"]').prop('checked', 'checked');
	}
	
	if ('${view.approval}') {
		$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="approval"][value="W"]').prop('checked', 'checked');
	}

	// select
	if('${view.event_seq}')$("select[name=event_seq]").val('${view.event_seq}').attr("selected", "selected");

	frm.submit(function() {
		if (event_seq.val() == '') {
			alert('구분을 선택해 주세요');
			event_seq.focus();
			return false;
		}
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
			} else if ($(this).html() == '목록') {
				location.href = 'list.do';
			}
		});
	});

});

</script>
</head>
<body>
<!-- 검색 필드 -->
<div class="tableWrite">
	<form name="frm" method="post" action="/campaign/news/insert.do">
		<c:if test='${not empty view.user_email}'>
			<input type="hidden" name="user_email" value="${view.user_email}"/>
		</c:if>
		<div class="sTitBar">
			<h4>캠페인 참여자 컨텐츠</h4>
		</div>
		<div class="tableWrite">	
			<table summary="캠페인 참여자 컨텐츠 작성">
				<caption>캠페인 참여자 컨텐츠 글쓰기</caption>
				<colgroup>
					<col style="width:15%" />
					<col style="width:35%" />
					<col style="width:15%" />
					<col style="width:35%" />
				</colgroup>
				<tbody>
					<tr>
						<th>이름</th>
						<td colspan="3">${view.user_nm }</td>						
					</tr>
					<tr>
						<th>이메일</th>
						<td>${view.user_email }</td>
						<th>전화번호</th>
						<td>${view.hp_no }</td>
					</tr>
					<tr>
						<th>동반1인 포함 여부</th>
						<td>${view.with_nm }</td>
						<th>응모일</th>
						<td>${view.entry_date }</td>
					</tr>
					<tr>
						<th scope="row">주소</th>
						<td colspan="3"><input type="text" name="user_addr" style="width:682px;" value="${view.user_addr }"/></td>
					</tr>
					<tr>
						<th scope="row">비고</th>
						<td colspan="3">
							<textarea name="admin_note" style="width:100%;height:200px;">${fn:replace(view.admin_note, br, crcn) }</textarea>
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
	</c:if>
	<span class="btn gray"><button type="button">목록</button></span>
</div>
</body>
</html>