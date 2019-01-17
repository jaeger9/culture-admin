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
	var apply_start_dt = frm.find('input[name=apply_start_dt]');
	var apply_end_dt = frm.find('input[name=apply_end_dt]');
	var post_start_dt = frm.find('input[name=post_start_dt]');

	if("${view.seq}") viewYN=true;
	//layout
	
	new Datepicker(apply_start_dt, apply_end_dt);
	setDatepicker(post_start_dt);
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') {
        		apply_start_dt.val(apply_start_dt.val().replace(/-/g, ''));
        		apply_end_dt.val(apply_end_dt.val().replace(/-/g, ''));
        		post_start_dt.val(post_start_dt.val().replace(/-/g, ''));
        		frm.attr('action' ,'/cultureplan/culturesupport/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		frm.attr('action' ,'/cultureplan/culturesupport/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		apply_start_dt.val(apply_start_dt.val().replace(/-/g, ''));
        		apply_end_dt.val(apply_end_dt.val().replace(/-/g, ''));
        		post_start_dt.val(post_start_dt.val().replace(/-/g, ''));
        		frm.attr('action' ,'/cultureplan/culturesupport/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/cultureplan/culturesupport/list.do';
        	}
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/cultureplan/culturesupport/insert.do">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<div class="sTitBar">
				<h4>문화지원사업 정보</h4>
			</div>
			<table summary="배너 등록/수정">
				<caption>문화지원사업 등록/수정</caption>
				<colgroup>
					<col style="width:17%" /><col style="width:33%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">사업</th>
						<td colspan="3">
							<input type="text" name="title" style="width:670px" value="${view.title}" />
						</td>
					</tr>
					<tr>
						<th scope="row">공고명</th>
						<td colspan="3">
							<textarea id="contents" name="notice" style="width:100%;height:100px;"><c:out value="${view.notice }" escapeXml="true" /></textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">단위사업명</th>
						<td colspan="3">
							<input type="text" name="category" style="width:670px" value="${view.category}" />
						</td>
					</tr>
					<tr>
						<th scope="row">기관명</th>
						<td colspan="3">
							<input type="text" name="origin" style="width:670px" value="${view.origin}" />
						</td>
					</tr>
					<tr>
						<th scope="row">사업년도</th>
						<td colspan="3">
							<input type="text" name="biz_year" style="width:40px" maxlength="4" value="${view.biz_year}" />
						</td>
					</tr>
					<tr>
						<th scope="row">사업담당자</th>
						<td colspan="3">
							<input type="text" name="charge" style="width:670px" value="${view.charge}" />
						</td>
					</tr>
					<tr>
						<th scope="row">URL</th>
						<td colspan="3">
							<input type="text" name="url" style="width:670px" value="${view.url}" />
						</td>
					</tr>
					<tr>
						<th scope="row">신청시작일</th>
						<td colspan="3">
							<input type="text" name="apply_start_dt" value="${view.apply_start_dt}" />
						</td>
					</tr>
					<tr>
						<th scope="row">신청종료일</th>
						<td colspan="3">
							<input type="text" name="apply_end_dt" value="${view.apply_end_dt}" />
						</td>
					</tr>
					<tr>
						<th scope="row">게시시작일</th>
						<td colspan="3">
							<input type="text" name="post_start_dt" value="${view.post_start_dt}" />
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