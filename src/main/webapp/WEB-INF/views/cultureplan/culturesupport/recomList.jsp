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
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});
	
	//checkbox
	new Checkbox('input[name=seqAll]', 'input[name=seq]');
	
	//selectbox
	if('${paramMap.approval}')$("select[name=approval]").val('${paramMap.approval}').attr("selected", "selected");
	
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
        		view($(this).parent().first().find('input').attr('type' , 'checkbox').val());
    		});
  		}
	});
	
	view = function(seq) { 
		url = '/cultureplan/culturesupport/recomView.do';
		if(seq)
			url += '?seq=' + seq;
		
		location.href = url;
	}
	
	//등록 & 상세
	$('span.btn.dark.fr').click(function(){
		view();
	});
	
	//승인 , 미승인 , 삭제 이벤트 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '삭제') {
        		deleteSites();
        	} else if($(this).html() == '승인') {
				$('input[name=updateStatus]').val('Y');
				updateStatus();
        	} else if($(this).html() == '미승인') {
        		$('input[name=updateStatus]').val('N');
        		updateStatus();
			}
    	});
	});
	
	//승인 , 미승인
	updateStatus = function () {
		
		if(getCheckBoxCheckCnt() == 0) {
			if($('input[name=updateStatus]').val() == 'N')
				alert('미승인할 코드를 선택하세요');
			if($('input[name=updateStatus]').val() == 'Y')
				alert('승인할 코드를 선택하세요');
			return false;
		}
		
		formSubmit('/cultureplan/culturesupport/recomStatusUpdate.do');
	}
	
	//삭제
	deleteSites = function () { 
		
		if(getCheckBoxCheckCnt() == 0) {
			alert('삭제할 코드를 선택하세요');
			return false;
		}
		
		formSubmit('/cultureplan/culturesupport/recomDelete.do');
	}
	
	//체크 박스 count 수 
	getCheckBoxCheckCnt = function() { 
		return $('input[name=seq]:checked').length;
	};
	
	//submit
	formSubmit = function (url) { 
		frm.attr('action' , url);
		frm.submit();		
	};
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" method="get" action="/cultureplan/culturesupport/recomList.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/>
		<input type="hidden" name="menuType" value="${paramMap.menuType}"/>  
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="공연장 검색">
					<caption>공연장 검색</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">승인여부</th>
							<td colspan="3">
								<select name="approval">
				                    <option value="">전체</option>
				                    <option value="Y">승인</option>
				                    <option value="N">미승인</option>
				                    <option value="W">대기</option>
                				</select>
							</td>
						</tr>
						<tr>
							<th scope="row">테마 제목</th>
							<td colspan="3">
								<input type="text" name="title" title="검색어 입력" value="${paramMap.title}"/>
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
					<col style="width:3%" />
					<col style="width:10%" />
					<col style="width:%" />
					<col style="width:15%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
						<th scope="col">번호</th>
						<th scope="col">테마제목</th>
						<th scope="col">승인여부</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(paramMap.list_unit*(paramMap.page_no-1))-status.index}" />
						<tr>
							<td><input type="checkbox" name="seq" value="${item.seq}"/></td>
							<td>${num}</td>
							<td>
								<a href="/cultureplan/culturesupport/recomView.do?seq=<c:out value="${item.seq}"/>">
									<c:out value="${item.title}" />
								</a>
							</td>
							<td>${item.approval}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</form>
	<div id="pagination">
	</div>
	<div class="btnBox">
		<span class="btn white"><button type="button">승인</button></span>
		<span class="btn white"><button type="button">미승인</button></span>
		<span class="btn white"><button type="button">삭제</button></span>
		<span class="btn dark fr"><a href="#url">등록</a></span>
	</div>
</body>
</html>
