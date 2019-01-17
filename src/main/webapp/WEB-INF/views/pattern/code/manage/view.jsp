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
	var cded_code		= frm.find('input[name=cded_code]');
	var cded_desc		= frm.find('input[name=cded_desc]');
	//layout
	
	//radio check
	if('${view.cded_usyn}')$('input:radio[name="cded_usyn"][value="${view.cded_usyn}"]').prop('checked', 'checked');
	
	//selectbox
	if('${view.cded_pcde}')$("select[name=cded_pcde]").val('${view.cded_pcde}').attr("selected", "selected");
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		if($('input[name=cded_code]').val() ==''){
			alert('코드  선택하세요');
			$('input[name=cded_code]').focus();
			return false;
		}

		if(cded_desc.val() ==''){
			alert('코드설명 입력하세요');
			cded_desc.focus();
			return false;
		}
		
		
		if($('input[name=orgIdCheckYN]').val() != 'Y'){
			alert('중복 확인 하세요');
			cded_desc.focus();
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
        		frm.attr('action' ,'/pattern/code/manage/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/pattern/code/manage/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/pattern/code/manage/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/pattern/code/manage/list.do';
        	}   		
    	});
	});
	
	//중복체크
	$('span.btn a').click(function(){
		if($(this).html() == '중복확인') {
			cded_pcde = $('select[name=cded_pcde] option:selected').val();
			cded_code = $('input[name=cded_code]').val();
			
		    var request = $.ajax({
		      url: "/pattern/code/manage/codeOverlapCheck.do",
		      type: "POST",
		      data: { 
		    	  	"cded_pcde" : cded_pcde ,
		    	  	"cded_code" : cded_code
		    	  }
		    });
	
		    request.done(function( msg ) {
		    	if(msg.codeCnt < 1) {
		        	alert('사용 가능합니다.');
		          	$('input[name=orgIdCheckYN]').val('Y');
		      	} else { 
		          	alert('이미 등록된 코드 입니다.');
		          	$('input[name=orgIdCheckYN]').val('N');
		      	}
		    });
		    
		    request.fail(function( jqXHR, textStatus ) {
		      	alert( "Request failed: " + textStatus );
			});
	  	}
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<input type="hidden" name="orgIdCheckYN" value="N"/>
		<form name="frm" method="post" action="/pattern/code/manage/insert.do" enctype="multipart/form-data">
			<table summary="분류체계  작성">
				<caption>분류체계 글쓰기</caption>
				<colgroup>
					<col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">코드분류 선택</th>
						<td colspan="3">
							<c:if test="${ empty view.cded_pcde}">
								<select title="코드분류선택" id="cded_pcde" name="cded_pcde">
									<option value="">==선택==</option>
									<c:forEach items="${codeList }" var="codeList" varStatus="status">
										<option selected="" value="${codeList.cdem_code}">${codeList.cdem_name}</option>
									</c:forEach>
								</select>
							</c:if>
							<c:if test="${ not empty view.cded_pcde}">
								${view.cded_pcde}
								<input type="hidden" name="cded_pcde" value="${view.cded_pcde}">
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">코드</th>
						<td colspan="3">
							<c:if test="${ empty view.cded_code}">
								<input type="text" name="cded_code" style="width:580px"  value="${view.cded_code}">
								<span class="btn whiteS"><a href="#url">중복확인</a></span>
							</c:if>
							<c:if test="${ not empty view.cded_code}">
								
								${view.cded_code}
								<input type="hidden" name="cded_code" value="${view.cded_code}">
							</c:if>
						</td>
					</tr>
										<tr>
						<th scope="row">코드설명</th>
						<td colspan="3">
							<input type="text" name="cded_desc" style="width:670px"  value="${view.cded_desc}">
						</td>
					</tr>
					<tr>
						<th scope="row">사용여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="cded_usyn" value="Y"/> 사용</label>
								<label><input type="radio" name="cded_usyn" value="N" checked/> 사용안함</label>
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