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
	var page_no = frm.find('input[name=page_no]');
	/* var creators = frm.find('input[name=creators]');
	var approval = frm.find('input[name=approval]');
	var reg_date_start = frm.find('inpput[name=reg_date_start]');
	var reg_date_end = frm.find('inpput[name=reg_date_end]');
	var insert_date_start = frm.find('inpput[name=insert_date_start]');
	var insert_date_end = frm.find('inpput[name=insert_date_end]');
	var search_type = frm.find('select[name=search_type]');
	var search_word = frm.find('inpput[name=search_word]'); */

	//layout
	
	//paging
	var p = new Pagination({
		view		:	'#pagination',
		page_count	:	'${count }',
		page_no		:	'${paramMap.page_no }',
		/* link		:	'/main/code/list.do?page_no=__id__', */
		callback	:	function(pageIndex, e) {
			console.log('pageIndex : ' + pageIndex);
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});
	
	//select key
	if('${paramMap.searchKey}')
		$("select").val('${paramMap.searchKey}').attr("selected", "selected");
	
	
	//checkbox
	new Checkbox('input[name=codeAll]', 'input[name=code]');
	
	
	//검색
	$('button[name=searchButton]').click(function(){
		$('input[name=page_no]').val('1');
		$('form[name=frm]').submit();
	});
	
	search = function() { 
		frm.submit();
	}
	
	//상세
	$('div.tableList table tbody tr td').each(function() {
  		if(!$(this).find('input').attr('type')){
    		$(this).click(function(){
        		view($(this).parent().attr('code'))
    		});
  		}
	});
	
	view = function(code) { 
		url = '/main/code/view.do';
		if(code)
			url += '?code=' + code;
		
		location.href = url;
	}
	
	//등록
	$('span.btn.dark.fr').click(function(){
		view();
	});
	
	//삭제
	
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '삭제') {
        		
        		if (!confirm('삭제 하시겠습니까?')) {
    				return false;
    			}
        		
        		deleteCodes();
        	}
    	});
	});
	
	deleteCodes = function () { 
		checkCnt = $('input[name=code]:checked').length;
		
		if(checkCnt == 0) {
			alert('삭제할 코드를 선택하세요');
			return false;
		}
		
		frm.attr('action' ,'/main/code/delete.do');
		frm.submit();
	}
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" method="get" action="/main/code/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<td colspan="3">
								<select name="searchKey" title="검색어 선택">
									<option value="title">코드명</option>
									<option value="type">코드타입</option>
								</select>
								<input <input type="text" name="searchKeyword" title="검색어 입력" value="${paramMap.searchKeyword}"/>
								<span class="btn darkS">
									<button name="searchButton" type="button">검색</button>
								</span>
							</td>
						</tr> 
					</tbody>
				</table>
			</div>
		</fieldset>
	
		<!-- 건수  -->
		<div class="topBehavior">
			<p class="totalCnt">총 <span>${count}</span>건</p>
		</div>
		<!-- 리스트 -->
		<div class="tableList">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col style="width:6%" />
					<col style="width:12%" />
					<col style="width:12%" />
					<col style="width:%" />
					<col style="width:20%" />
					<col style="width:10%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="codeAll" title="리스트 전체 선택" /></th>
						<th scope="col">코드</th>
						<th scope="col">부모코드</th>
						<th scope="col">코드명</th>
						<th scope="col">코드타입</th>
						<th scope="col">순번</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<tr code="${item.code}">
							<td><input type="checkbox" name="code" value="${item.code}"/></td>
							<td>${item.code}</td>
							<td>${item.pcode}</td>
							<td><a href="/main/code/view.do?code=<c:out value="${item.code}"/>" /><c:out value="${item.name}" /></a></td>
							<td>${item.type}</td>
							<td>${item.sort}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</form>
	<div id="pagination">
	</div>
	<div class="btnBox">
		<span class="btn white"><button type="button">삭제</button></span>
		<span class="btn dark fr"><a href="#url">등록</a></span>
	</div>
</body>
</html>