<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

$(function() {

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
				location.href = 'list.do?${paramMap.qs }';
			}
		});
	});

});

</script>
</head>
<body>
<!-- 검색 필드 -->
<div class="tableWrite">
	<div class="sTitBar">
		<h4>복주머니참여자</h4>
	</div>
	<div class="tableWrite">	
		<table summary="복주머니 참여자">
			<caption>복주머니 참여자</caption>
			<colgroup>
				<col style="width:15%" />
				<col style="width:35%" />
				<col style="width:15%" />
				<col style="width:35%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">이름</th>
					<td colspan="3">${view.name }</td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td>${view.hp }</td>
					<th>이메일</th>
					<td>${view.email }</td>
				</tr>
				<tr>
					<th scope="row">주소</th>
					<td colspan="3">(${view.zip_code }) ${view.addr } ${view.addr_detail }</td>
				</tr>
				<tr>
					<th>참여횟수</th>
					<td>${view.entry_cnt }회</td>
					<th>참여날짜</th>
					<td>
					<c:forEach var="item" items="${entryDateList }">
						${item.entry_date }<br />
					</c:forEach>
					</td>
			</tbody>
		</table>
	</div>
</div>
<div class="btnBox textRight">
	<span class="btn gray"><button type="button">목록</button></span>
</div>
</body>
</html>