<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">

$(function () {

	var frm = $('form[name=frm]');
	
	//layout
	var uploadFile		= frm.find('input[name=uploadFile]');
	var usec_type		= frm.find('input[name=usec_type]');
	var usec_ctid		= frm.find('input[name=usec_ctid]');
	
	//select selected
	if('${view.ecim_ecgb}')$("select[name=ecim_ecgb]").val('${view.ecim_ecgb}').attr("selected", "selected");
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		
		if(usec_type.val() ==''){
			alert('구분 입력하세요');
			usec_type.focus();
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
        		frm.attr('action' ,'/pattern/db/design/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/pattern/db/design/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/pattern/db/design/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/pattern/db/design/list.do';
        	}   		
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/pattern/db/design/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.usec_upid}'>
				<input type="hidden" name="usec_upid" value="${view.usec_upid}"/>
			</c:if>
			<table summary="활용문양 작성">
				<caption>활용문양  글쓰기</caption>
				<colgroup>
					<col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr rowspan="@">
						<th>이미지</th>
						<td colspan="3">
							<c:if test="${not empty view.usec_thum}">
								<div class="inputBox">
									이전파일: ${view.usec_thum}
								</div>
							</c:if>
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
									</br>* 80 X 80 사이즈 이미지를 선택해주세요
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th></th>
						<td colspan="3">
							<c:if test="${not empty view.usec_file}">
								<div class="inputBox">
									이전파일: ${view.usec_file}
								</div>
							</c:if>
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
									</br>* 2D일 경우 500 X 500 이미지, 3D일 경우 icf 파일을 선택하세요.
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">내용</th>
						<td colspan="3">
							<textarea name="usec_cont" style="width:100%;height:100px;"><c:out value="${view.usec_cont }" escapeXml="true" /></textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">구분</th>
						<td colspan="3">
							<input type="text" name="usec_type" style="width:20px"  value="${view.usec_type}">
						</td>
					</tr>
					<tr>
						<th scope="row">사용문양 파일명</th>
						<td colspan="3">
							<input type="text" name="usec_ctid" style="width:670px"  value="${usec_ctid}">
							</br></br> 	※ 파일명은 콤마(,)로 구분하여 입력하세요.
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