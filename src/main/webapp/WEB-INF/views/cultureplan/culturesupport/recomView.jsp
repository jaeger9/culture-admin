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
var performIndex = 0 ;
var listIndex = 1;
var listMinSize = 1;

$(function () {

	var frm = $('form[name=frm]');

	if("${view.seq}") viewYN=true;
	//layout
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	
	$('input[name="uploadFile"]').change(function(){
		$(this).parent().parent().find('.inputText').val($(this).val().substr(12));
	});
	
	addInputForm = function(){
		
		addHtml = '<tr class="tr_#index#">'
		+ '<th scope="row">배너#index# 제목</th>'
		+ '<td colspan="3">'
		+ '<input type="text" name="s_title" style="width:590px">'
		+ '</td>'
		+ '</tr>'
		+ '<tr class="tr_#index#">'
		+ '<th scope="row">배너#index# URL</th>'
		+ '<td colspan="3">'
		+ '<input type="text" name="url" style="width:590px">'
		+ '</td>'
		+ '</tr>'
		+ '<tr class="tr_#index#">'
		+ '<th scope="row">배너#index# 이미지</th>'
		+ '<td colspan="3">'
		+ '<div class="fileInputs">'
		+ '<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />'
		+ '<div class="fakefile">'
		+ '<input type="text" title="" class="inputText" value=""/>'
		+ '<span class="btn whiteS"><button>찾아보기</button></span>'
		+ '</div>'
		+ '</div>'
		+ '</td>'
		+ '</tr>';
		
		while(addHtml.indexOf('#index#') > -1)
			addHtml = addHtml.replace('#index#', listIndex+1);
			
		$('.subList').append(addHtml);
		listIndex = listIndex + 1;
		
		$('input[name="uploadFile"]').change(function(){
			$(this).parent().parent().find('.inputText').val($(this).val().substr(12));
		});
	}
	
	deleteInputForm = function() {
		if(listIndex > listMinSize){
			removeTarketInputForm = $('.tr_' + listIndex);
		    removeTarketInputForm.remove();
		    listIndex = listIndex -1;
		} else {
			alert('배너는 최소 1개입니다.');
			return;
		}
	}
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		frm.attr('action' ,'/cultureplan/culturesupport/recomUpdate.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		frm.attr('action' ,'/cultureplan/culturesupport/recomDelete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		frm.attr('action' ,'/cultureplan/culturesupport/recomInsert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/cultureplan/culturesupport/recomList.do';
        	} else if($(this).html() == '배너 추가') {
        		addInputForm();
        	} else if($(this).html() == '배너 제거') {
        		deleteInputForm();
        	}
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/cultureplan/culturesupport/recomInsert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<input type="hidden" name="menuType" value="${paramMap.menuType}"/>
			<div class="sTitBar">
				<h4>테마 정보</h4>
			</div>
			<table summary="배너 등록/수정">
				<caption>배너 등록/수정</caption>
				<colgroup>
					<col style="width:17%" /><col style="width:33%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">테마제목</th>
						<td colspan="3">
							<input type="text" name="title" style="width:670px" value="${view.title}" />
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
			<div class="sTitBar">
				<h4>배너 정보</h4>
			</div>
			<table summary="배너 등록/수정">
				<caption>배너 등록/수정</caption>
				<colgroup>
					<col style="width:17%" /><col style="width:33%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody class="subList">
					<c:if test="${ empty subList}">
						<tr class="tr_1">
							<th scope="row">배너1 제목</th>
							<td colspan="3">
								<input type="text" id="s_title_<c:out value="${status.count}" />" name="s_title" style="width:590px">
							</td>
						</tr>
						<tr class="tr_1">
							<th scope="row">배너1 URL</th>
							<td colspan="3">
								<input type="text" id="url_<c:out value="${status.count}" />" name="url" style="width:590px">
							</td>
						</tr>
						<tr class="tr_1">
							<th scope="row">배너1 이미지</th>
							<td colspan="3">
								<div class="fileInputs">
									<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
									<div class="fakefile">
										<input type="text" title="" class="inputText" value=""/>
										<span class="btn whiteS"><button>찾아보기</button></span>
									</div>
								</div>
							</td>
						</tr>
					</c:if>
					<c:if test="${ not empty subList}">
						<c:forEach items="${subList}" var="subList" varStatus="status">
							<tr class="tr_${status.count}">
								<th scope="row">배너${status.count} 제목</th>
								<td colspan="3">
									<input type="hidden" name="tmp_seq" value="${subList.seq }">
									<input type="text" name="s_title" style="width:590px" value="${subList.s_title }">
								</td>
							</tr>
							<tr class="tr_${status.count}">
								<th scope="row">배너${status.count} URL</th>
								<td colspan="3">
									<input type="text" name="url" style="width:590px" value="${subList.url}">
								</td>
							</tr>
							<tr class="tr_${status.count}">
								<th scope="row">배너${status.count} 이미지</th>
								<td colspan="3">
									<div class="fileInputs">
										<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
										<div class="fakefile">
											<input type="text" title="" class="inputText" value="${subList.img_name1}"/>
											<span class="btn whiteS"><button>찾아보기</button></span>
										</div>
									</div>
								</td>
							</tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
		</form>
	</div>
	<div class="btnBox textRight">
		<span class="btn white"><button type="button">배너 추가</button></span>
		<span class="btn white"><button type="button">배너 제거</button></span>
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