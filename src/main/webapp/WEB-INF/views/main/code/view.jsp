<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
var action = "";

$(function () {

	var frm = $('form[name=frm]');

	var name		= frm.find('input[name=name]');
	var type		= frm.find('input[name=type]');
	var value		= frm.find('input[name=value]');
	var sort		= frm.find('input[name=sort]');
	
	//layout
	
	//select key
	if('${view.pcode}') { 
		$("select").val('${view.pcode}').attr("selected", "selected");
	}
	

	frm.submit(function(){
		//DB NOT NULL 기준 체크
		if(action == 'list'){
			return true;
		}
		
		if(!$('select[name=pcode] > option:selected').val()) {
			alert('부모코드 선택하세요');
			$('select[name=pcode]').focus();
			return false;
		}
		
		if(name.val() ==''){
			alert('코드명 선택 입력하세요');
			name.focus();
			return false;
		}

		if(type.val() ==''){
			alert('코드타입 선택 입력하세요');
			type.focus();
			return false;
		}

		if(value.val() ==''){
			alert('코드값 선택 입력하세요');
			value.focus();
			return false;
		}

		/* 
		if(sort.val() ==''){
			alert('순번 선택 입력하세요');
			sort.focus();
			return false;
		}
		 */
		 
		return true;
	});

	//등록 , 수정 ,삭제
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 

        		if (!confirm('수정하시겠습니까?')) {
    				return false;
    			}
        		
        		frm.attr('action' ,'/main/code/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
    				return false;
    			}
        		
        		frm.attr('action' ,'/main/code/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
    				return false;
    			}
        		frm.attr('action' ,'/main/code/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		action = 'list';
        		frm.attr('action' ,'/main/code/list.do');
        		frm.submit();
        	}    		
    	});
	});
	
	//검색
	$('button[name=searchButton]').click(function(){
		$('input[name=page_no]').val('1');
		$('form[name=frm]').submit();
	});
	
	
	//상세
	$('div.tableList table tbody tr').each(function() {
		$(this).click(function() {	
			view($(this).attr('code'))
	  	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="get" action="/main/code/insert.do">
			<c:if test='${not empty view.code }'>
				<input type="hidden" name="code" value="${view.code }"/>
			</c:if>
			<table summary="공통 코드 작성">
				<caption>공통 코드  작성</caption>
				<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">부모코드 선택</th>
						<td colspan="3">
							<select name="pcode" title="검색어 선택">
								<option value="">선택</option>
								<c:forEach items="${parentCodeList}" var="list" varStatus="status">
									<option value="${list.code}">${list.name}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">코드명</th>
						<td colspan="3"><input type="text" name="name" style="width:670px" value="${view.name}"/></td>
					</tr>
					<tr>
						<th scope="row">코드타입</th>
						<td colspan="3"><input type="text" name="type" style="width:670px" value="${view.type}"/></td>
					</tr>
					<tr>
						<th scope="row">코드값</th>
						<td colspan="3"><input type="text" name="value" style="width:670px" value="${view.value}"/></td>
					</tr>
					<tr>
						<th scope="row">순번</th>
						<td colspan="3"><input type="text" name="sort" style="width:30px" value="${view.sort}"/></td>
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