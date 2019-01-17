<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
var action = "";

$(function () {

	var frm = $('form[name=frm]');
	
	var ecim_ecid		= frm.find('input[name=ecim_ecid]');
	var ecim_name		= frm.find('input[name=ecim_name]');
	var uploadFile		= frm.find('input[name=uploadFile]');
	//layout
	
	
	//select selected
	if('${view.ecim_ecgb}')$("select[name=ecim_ecgb]").val('${view.ecim_ecgb}').attr("selected", "selected");
		
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		if(action != 'insert'){
			return true;
		}
		
		if(!$('select[name=ecim_ecgb] > option:selected').val()) {
			alert('응용컨텐츠구분 선택하세요');
			$('select[name=ecim_ecgb]').focus();
			return false;
		}
		
		if(ecim_ecid.val() ==''){
			alert('응용컨텐츠 ID 입력하세요');
			ecim_ecid.focus();
			return false;
		}

		if(ecim_name.val() ==''){
			alert('제목 입력하세요');
			ecim_name.focus();
			return false;
		}

		if(uploadFile.val() ==''){
			alert('응용컨텐츠 파일 선택하세요');
			uploadFile.focus();
			return false;
		}
		
		return true;
	});
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		if (!confirm('수정하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/pattern/db/content/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/pattern/db/content/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		action = "insert";
        		frm.attr('action' ,'/pattern/db/content/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/pattern/db/content/list.do';
        	}   		
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/pattern/db/content/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.ecim_ecid}'>
				<input type="hidden" name="ecim_ecid" value="${view.ecim_ecid}"/>
			</c:if>
			<table summary="분류체계  작성">
				<caption>분류체계 글쓰기</caption>
				<colgroup>
					<col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">응용컨텐츠구분</th>
						<td colspan="3">
							<select name="ecim_ecgb">
			                    <option value="">전체</option>
								
								<c:forEach items="${codeList }" var="codeList" varStatus="status">
									<option value="${codeList.cded_code}">${codeList.cded_desc}</option>				                    
			                    </c:forEach>
               				</select>
						</td>
					</tr>
					<tr>
						<th scope="row">응용컨텐츠 ID</th>
						<td colspan="3">
							<c:if test='${not empty view.ecim_ecid}'>
								${view.ecim_ecid}
							</c:if>
							<c:if test='${empty view.ecim_ecid}'>
								<input type="text" name="ecim_ecid" style="width:670px"  value="${view.ecim_ecid}"/>
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">제목</th>
						<td colspan="3">
							<input type="text" name="ecim_name" style="width:670px"  value="${view.ecim_name}">
						</td>
					</tr>
					<tr>
						<th scope="row">응용컨텐츠</th>
						<td colspan="3">
							
							<div class="inputBox">
								이전파일: ${view.ecim_file}
							</div>
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
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