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
	var dcollectionname		= frm.find('input[name=dcollectionname]');
	var dalternative		= frm.find('input[name=dalternative]');
	
	//layout
	
	//radio check
	if('${view.dhidden}')$('input:radio[name="dhidden"][value="${view.dhidden}"]').prop('checked', 'checked');
	
	//select selected
	if('${view.dparentcollectionid}')$("select[name=dparentcollectionid]").val('${view.dparentcollectionid}').attr("selected", "selected");
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		if(action != 'insert'){
			return true;
		}
		
		if(dcollectionname.val() ==''){
			alert('분류명 입력하세요');
			dcollectionname.focus();
			return false;
		}
		
		/* if(dalternative.val() ==''){
			alert('분류명 입력하세요');
			dalternative.focus();
			return false;
		} */
		
		if(!$('select[name=dparentcollectionid] > option:selected').val()) {
			alert('상의분류 선택하세요');
			$('select[name=dparentcollectionid]').focus();
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
        		frm.attr('action' ,'/pattern/db/category/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/pattern/db/category/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		action = "insert";
        		frm.attr('action' ,'/pattern/db/category/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/pattern/db/category/list.do';
        	}   		
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/pattern/db/category/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.dcollectionid}'>
				<input type="hidden" name="id" value="${view.dcollectionid}"/>
			</c:if>
			<table summary="분류체계  작성">
				<caption>분류체계 글쓰기</caption>
				<colgroup>
					<col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">분류명</th>
						<td colspan="3">
							<input type="text" name="dcollectionname" style="width:670px"  value="${view.dcollectionname}">
						</td>
					</tr>
					<tr>
						<th scope="row">분류명(한문)</th>
						<td colspan="3">
							<input type="text" name="dalternative" style="width:670px"  value="${view.dalternative}">
						</td>
					</tr>
					<tr>
						<th scope="row">사용여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="dhidden" value="거짓"/> 사용</label>
								<label><input type="radio" name="dhidden" value="참"/> 사용안함</label>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">상의분류</th>
						<td colspan="3">
							<select name="dparentcollectionid">
								<option value="">선택하세요</option>
			                    <c:forEach items="${categoryList }" var="categoryList" varStatus="status">
			                    	<option value="${categoryList.dcollectionid }">${categoryList.dcollectionname }</option>
			                    </c:forEach>
               				</select>
						</td>
					</tr>
					<tr>
						<th scope="row">내용</th>
						<td colspan="3">
							<textarea name="dabstract" style="width:100%;height:200px;"><c:out value="${view.dabstract}" escapeXml="true" /></textarea>
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