<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">


var viewYN = false;

$(function () {

	var frm = $('form[name=frm]');

	if("${view.seq}") viewYN=true;
	//layout
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') {
        		frm.attr('action' ,'/cultureplan/oneview/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		frm.attr('action' ,'/cultureplan/oneview/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		frm.attr('action' ,'/cultureplan/oneview/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/cultureplan/oneview/list.do';
        	}
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/cultureplan/oneview/insert.do">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<div class="sTitBar">
				<h4>한눈에보기 정보</h4>
			</div>
			<table summary="한눈에보기 등록/수정">
				<caption>한눈에보기 등록/수정</caption>
				<colgroup>
					<col style="width:17%" /><col style="width:33%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">제목</th>
						<td colspan="3">
							<input type="text" name="title" style="width:670px" value="${view.title}" />
						</td>
					</tr>
					<tr>
						<th scope="row">컨텐츠타입</th>
						<td colspan="3">
							<select name="cont_type">
								<c:forEach var="item" items="${contList}">
									<option value="${item.value}" ${item.value eq view.cont_type ? 'selected=selected' : ''}>${item.name}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">링크</th>
						<td colspan="3">
							<input type="text" name="url" style="width:670px" value="${view.url}" />
						</td>
					</tr>
					<tr>
						<th scope="row">출처</th>
						<td colspan="3">
							<input type="text" name="origin" style="width:670px" value="${view.origin}" />
						</td>
					</tr>
					<tr>
						<th scope="row">썸네일 이미지</th>
						<td colspan="3">
							<input type="text" name="thumb_url" style="width:670px" value="${view.thumb_url}" />
						</td>
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval" value="W"/> 대기</label>
								<label><input type="radio" name="approval" value="Y"/> 승인</label>
								<label><input type="radio" name="approval" value="N" checked="checked"/> 미승인</label>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
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