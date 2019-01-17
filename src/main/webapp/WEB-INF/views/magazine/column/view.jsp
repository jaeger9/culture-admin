<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">

$(function () {

	var frm = $('form[name=frm]');
	//layout
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');

	//check box
	if('${view.top_yn}')$('input[name=top_yn][value="${view.top_yn}"]').prop('checked' , 'checked');
	
	//select selected
	if('${view.type}')$("select[name=type]").val('${view.type}').attr("selected", "selected");
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		if (!confirm('수정하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/magazine/column/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/magazine/column/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/magazine/column/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		console.log('목록');
        		location.href='/magazine/column/list.do';
        	}   		
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/magazine/column/insert.do">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<table summary="블로그 등록/수정">
				<caption>블로그 등록/수정</caption>
				<colgroup>
					<col style="width:17%" /><col style="width:33%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">제목</th>
						<td colspan="3">
							${view.title}
						</td>
					</tr>
					<tr>
						<th scope="row">작성자</th>
						<td colspan="3">
							${view.creator}
						</td>
					</tr>
					<tr>
						<th scope="row">등록일</th>
						<td colspan="3">
							${view.reg_date}
						</td>
					</tr>
					<tr>
						<th scope="row">URL</th>
						<td colspan="3">
							${view.url}
						</td>
					</tr>
					<tr>
						<th scope="row">내용</th>
						<td colspan="3">
							<%-- <textarea id="contents" name="content" style="width:100%;height:400px;" readonly="readonly"><c:out value="${view.description }" escapeXml="true" /></textarea> --%>
							<div>
								<%-- ${view.description } --%>
								<tags:out text="${view.description }" byteLength="450" ellipsis="..." removeXml="true" escapeXml="false" removeXml3="true"/>
							</div>
						</td>	
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							${view.approval eq 'N' ? '미승인' : '승인'}
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div class="btnBox textRight">
		<%-- <c:if test='${not empty view}'>
			<span class="btn white"><button type="button">수정</button></span>
			<span class="btn white"><button type="button">삭제</button></span>
		</c:if>
		<c:if test='${empty view }'>
			<span class="btn white"><button type="button">등록</button></span>
		</c:if> --%>
		<span class="btn gray"><button type="button">목록</button></span>
	</div>
</body>
</html>