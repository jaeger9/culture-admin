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
var cultureAgreeIndex = 0;
var callback = {
		cultureagree : function (res) {
			/*
				JSON.stringify(res) = {
					"cateType"	:	"F"
					,"orgCode"	:	"NLKF02"
					,"orgId"	:	86
					,"category"	:	"도서"
					,"name"		:	"국립중앙도서관"
				}
			*/
			console.log(JSON.stringify(res));
			if (res == null) {
				alert('CallBack Res Null');
				return false;
			}
			
			if(res.title)$('#s_title_' + cultureAgreeIndex).val(res.title);
			if(res.seq)$('#s_seq_' + cultureAgreeIndex).val(res.seq);
			if(res.thumbUrl)$('#s_thumb_url_' + cultureAgreeIndex).val(res.thumbUrl);
			
		}
}

$(function () {

	var frm = $('form[name=frm]');
	var menuType = frm.find('input[name=menuType]');
	//layout
	
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');

	//공연상 선택
	$('span.btn.whiteS a').each(function(){
	  	$(this).click(function(){
	  		if( $(this).html() == '문화공감선택'){
	  			cultureAgreeIndex = $(this).attr("index");
	      		window.open('/popup/cultureagree.do', 'placePopup', 'scrollbars=yes,width=400,height=300');
	    	} 
	  	});
	});
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		if (!confirm('수정하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/magazine/recom/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/magazine/recom/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/magazine/recom/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/magazine/recom/list.do';
        	}   		
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/magazine/recom/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<c:if test='${not empty view.menu_cd}'>
				<input type="hidden" name="menu_cd" value="${view.menu_cd}"/>
			</c:if>
			<table summary="공연장 등록/수정">
				<caption>공연장 등록/수정</caption>
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
						<th scope="row">소개</th>
						<td colspan="3">
							<textarea id="description" name="description" style="width:100%;height:100px;"><c:out value="${view.description }" escapeXml="true" /></textarea>
						</td>
					</tr>
					
					<c:if test="${empty subList }">
						<c:forEach begin="0" end="4" varStatus="status">
							<tr>
								<th scope="row">문화공감${status.count}</th>
								<td colspan="3">
									<input type="text"  id="s_title_${status.count}" name="s_title" style="width:565px" value="${list.title}" />
									<span class="btn whiteS"><a href="#url" index="${status.count}" >문화공감선택</a></span>
									<input type="text" name="s_seq" id="s_seq_${status.count}">
									<input type="text" name="s_thumb_url" id="s_thumb_url_${status.count}">
								</td>
							</tr>
						</c:forEach>
					</c:if>
					<c:if test="${not empty subList }">
						<c:forEach items="${subList }" var="subList" varStatus="status">
							<tr>
								<th scope="row">문화공감${status.count}</th>
								<td colspan="3">
									<input type="text" id="s_title_${status.count}" name="s_title" style="width:565px" value="${subList.s_title}" />
									<span class="btn whiteS"><a href="#url" index="${status.count}">문화공감선택</a></span>
									<input type="text" value="${subList.s_seq}" name="s_seq" id="s_seq_${status.count}">
									<input type="text" value="${subList.s_thumb_url}" name="s_thumb_url" id="s_thumb_url_${status.count}">
									<input type="text" value="${subList.seq }" name="tmp_seq">
								</td>
							</tr>
						</c:forEach>
					</c:if>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval" value="W"/> 대기</label>
								<label><input type="radio" name="approval" value="Y"/> 승인</label>
								<label><input type="radio" name="approval" value="N"/> 미승인</label>
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