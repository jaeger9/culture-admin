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
	var title		= frm.find('input[name=title]');
	var top_yn		= frm.find('input[name=top_yn]');
	var blog_url		= frm.find('input[name=blog_url]');
	
	//layout
	
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');

	//check box
	if('${view.top_yn}')$('input[name=top_yn][value="${view.top_yn}"]').prop('checked' , 'checked');
	
	//select selected
	if('${view.type}')$("select[name=type]").val('${view.type}').attr("selected", "selected");
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		
		if(title.val() == '') {
		    alert("제목 입력하세요");
		    title.focus();
		    return false;
		}
		
		if(!$('select[name=type] > option:selected').val()) {
			alert('분류 입력하세요');
			$('select[name=type] > option:selected').focus();
			return false;
		}
		
		if(blog_url.val() ==''){
			alert('블로그 UR 입력하세요');
			blog_url.focus();
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
        		frm.attr('action' ,'/magazine/blog/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/magazine/blog/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/magazine/blog/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/magazine/blog/list.do';
        	}   		
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/magazine/blog/insert.do">
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
							<input type="text" name="title" style="width:400px" value="${view.title}" />
							<input type="checkbox" name="top_yn" value="Y"/>문화포털블로그 베스트
						</td>
					</tr>
					<tr>
						<th scope="row">분류</th>
						<td colspan="3">
							<select title="분류선택하세요" name="type">
								<option value="">전체</option>
								<c:forEach items="${sortList }" var="sortList" varStatus="status">
									<option value="${sortList.value }">${sortList.name}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">작성자</th>
						<td>
							${view.user_id}
						</td>
						<th scope="row">등록일</th>
						<td>
							${view.reg_date}
						</td>
					</tr>
					<tr>
						<th scope="row">블로그 URL</th>
						<td colspan="3">
							<input type="text" name="blog_url" style="width:670px" value="${view.blog_url}" />
						</td>
					</tr>
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