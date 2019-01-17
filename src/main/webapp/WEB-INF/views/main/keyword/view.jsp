<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

	var frm = $('form[name=frm]');
	var keyword		= frm.find('input[name=keyword]');

	//layout
	var size = 1 ;
	
	if('${view[0].idx}') size = '${fn:length(view)}';
	
	//radio check
	if('${view[0].approval}')$('input:radio[name="approval"][value="${view[0].approval}"]').prop('checked', 'checked');
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		if($('input[name=keyword]').val() ==''){
			alert('키워드  입력하세요');
			$('input[name=keyword]').focus();
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
        		
        		keyword = '';
        		
        		for(index = 0 ; index < size ; index++)
        			keyword += $('input[name=keyword' + (index + 1) + ']').val() + ',';
        		
        		$('input[name=keyword]').val(keyword.substring(0, keyword.length - 1));
        		
        		frm.attr('action' ,'/main/keyword/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		
        		if (!confirm('삭제 하시겠습니까?')) {
    				return false;
    			}
        		
				keyword = '';
        		
        		for(index = 0 ; index < size ; index++)
        			keyword += $('input[name=keyword' + (index + 1) + ']').val() + ',';
        		
        		$('input[name=keyword]').val(keyword.substring(0, keyword.length - 1));
        		
        		frm.attr('action' ,'/main/keyword/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		
        		if (!confirm('등록하시겠습니까?')) {
    				return false;
    			}
        		
        		keyword = '';
        		
        		for(index = 0 ; index < size ; index++)
        			keyword += $('input[name=keyword' + (index + 1) + ']').val() + ',';
        		
        		$('input[name=keyword]').val(keyword.substring(0, keyword.length - 1));
        		
        		frm.attr('action' ,'/main/keyword/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/main/keyword/list.do';
        	}   		
    	});
	});
	
	$('div.sTitBar span a').each(function(){
		$(this).click(function() {
			if($(this).html() == '추가') {
				++size;
				console.log("size:" + size);
				html = '<input type="text" style="width:150px" name="keyword' + size + '">  '
				
				if (size % 3 == 0)html;
					
				$('table tbody tr:first td').append(html);
			} else if($(this).html() == '삭제') {
				if(size > 1 ){
					$('input[name=keyword' + size + ']').remove();
					--size;
					console.log("size:" + size);
				}
			}
		});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/main/keyword/insert.do">
			<input type="hidden" style="width:650px" name="keyword"/>
			<c:if test='${not empty view[0].idx}'>
        		<input type="hidden" name="idx" value="${view[0].idx }"/>
      		</c:if>
			
			<div class="sTitBar">
				<h4>인기키워드입력</h4>
				<span class="btn whiteS"><a href="#url">추가</a></span>
				<span class="btn whiteS"><a href="#url">삭제</a></span>
			</div>
			<table summary="공통 코드 작성">
				<caption>공통 코드  작성</caption>
				<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">키워드 ${status.count}</th>
						<td colspan="3">
							<c:forEach items="${view}" var="list" varStatus="status">
								<input type="text" name="keyword${status.count}" style="width:150px" value="${list.keyword}"/> <%-- <c:if test="${0 eq status.count%3}"></br></c:if> --%>
							</c:forEach>
							<c:if test="${empty view }">
								<input type="text" name="keyword1" style="width:150px"/>
							</c:if>
						</td>
					</tr>
					
					<tr>
						<th scope="row">노출구분</th>
						<td colspan="3">
							<c:forEach items="${view}" var="list" varStatus="status">
								<c:if test="${status.first}">
									<select type="text" name="mobile_yn" title="노출구분">
										<option value="N" ${empty list.mobile_yn or list.mobile_yn eq 'N' ? 'selected="selected"':''}>포털</option>
										<option value="Y" ${list.mobile_yn eq 'Y' ? 'selected="selected"':''}>모바일</option>
									</select>
								</c:if>
							</c:forEach>
							<c:if test="${empty view }">
								<select type="text" name="mobile_yn" title="노출구분">
									<option value="N" selected="selected"}>포털</option>
									<option value="Y">모바일</option>
								</select>
							</c:if>
						</td>
					</tr>
					
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval" value="Y"/> 승인</label>
								<label><input type="radio" name="approval" value="N" checked/> 미승인</label>
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