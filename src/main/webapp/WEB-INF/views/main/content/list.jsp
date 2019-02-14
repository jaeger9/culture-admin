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
	if('${paramMap.approval}')$("select[name=approval]").val('${paramMap.approval}').attr("selected", "selected");
	if('${paramMap.source}')$("select[name=source]").val('${paramMap.source}').attr("selected", "selected");
	
	
	//checkbox
	new Checkbox('input[name=seqAll]', 'input[name=seq]');
	
	
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
		url = '/main/content/view.do?menu_type=' + $('input[name=menu_type]').val();
		if(seq)
			url += '&seq=' + seq;
		
		location.href = url;
	}
	
	//등록
	$('span.btn.dark.fr').click(function(){
		view();
	});
	
	//승인 , 미승인 , 삭제 이벤트 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
    				return false;
    			}
        		deleteContents();
        	} else if($(this).html() == '승인') {
        		if (!confirm('승인 처리 하시겠습니까?')) {
    				return false;
    			}
				$('input[name=updateStatus]').val('Y');
				updateStatus();
        	} else if($(this).html() == '미승인') {
        		if (!confirm('미승인 처리 하시겠습니까?')) {
    				return false;
    			}
        		$('input[name=updateStatus]').val('N');
        		updateStatus();
			}
    	});
	});
	
	//삭제
	deleteContents = function () { 
		if(getCheckBoxCheckCnt() == 0) {
			alert('삭제할 코드를 선택하세요');
			return false;
		}
		formSubmit('/main/content/delete.do');
	}
	
	
	//승인 , 미승인
	updateStatus = function () {
		if(getCheckBoxCheckCnt() == 0) {
			if($('input[name=updateStatus]').val() == 'N')
				alert('미승인할 코드를 선택하세요');
			if($('input[name=updateStatus]').val() == 'Y')
				alert('승인할 코드를 선택하세요');
			return false;
		}
		
		formSubmit('/main/content/statusUpdate.do');
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

function onSearch(){
	//검색하면 페이지 초기화
	$('input[name=page_no]').val(1);
	frm.submit();
}
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" method="post" action="/main/content/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no}"/>
		<input type="hidden" name="updateStatus" value=""/>
		<input type="hidden" name="menu_type" value="${paramMap.menu_type}"/>
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
					<colgroup>
						<col style="width:15%" />
						<col style="width:*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">승인여부</th>
							<td>
								<select title="승인여부 선택" name="searchApproval" onchange="javascript:onSearch();return;">
									<option value="" ${paramMap.searchApproval eq '' ? 'selected="selected"':'' }>전체</option>
									<option value="N" ${paramMap.searchApproval eq 'N' ? 'selected="selected"':'' }>미승인</option>
									<option value="Y" ${paramMap.searchApproval eq 'Y' ? 'selected="selected"':'' }>승인</option>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</fieldset>
		
		<ul class="tab">
			<c:forEach items="${tabList }" var="tabList" varStatus="status">
			   <c:if test="${tabList.code ne 750 and  tabList.code ne 751 and tabList.code ne 752
			     and tabList.code ne 753  and tabList.code ne 707  and tabList.code ne 703}">
				<li>
					<a href="/main/content/list.do?menu_type=${tabList.code}" <c:if test="${ paramMap.menu_type eq tabList.code }"> class="focus"</c:if>>
						${tabList.name}
					</a>
				</li>
				</c:if>
			</c:forEach>
		</ul>
		<!-- 리스트 -->
		<div class="tableList">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col style="width:6%" />
					<col style="width:8%" />
					<c:choose>
						<c:when test="${paramMap.menu_type eq '707'}">
							<col style="width:25%" />
							<col style="width:%" />
						</c:when>
						<c:otherwise>
							<col style="width:%" />
						</c:otherwise>
					</c:choose>
					<col style="width:14%" />
					<col style="width:14%" />
					<col style="width:12%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
						<th scope="col">번호</th>
						<c:choose>
							<c:when test="${paramMap.menu_type eq '707'}">
								<th scope="col">제목</th>
								<th scope="col">URL</th>
							</c:when>
							<c:otherwise>
								<th scope="col">제목</th>
							</c:otherwise>
						</c:choose>
						<th scope="col">등록자</th>
						<th scope="col">등록일</th>
						<th scope="col">승인여부</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(paramMap.list_unit*(paramMap.page_no-1))-status.index}" />
						<tr code="${item.code}">
							<td><input type="checkbox" name="seq" value="${item.seq}"/></td>
							<td>${num}</td>
							<c:choose>
								<c:when test="${paramMap.menu_type eq '707'}">
									<td><a href="/main/content/view.do?seq=<c:out value="${item.seq}"/>&amp;menu_type=<c:out value="${paramMap.menu_type}" />"><c:out value="${item.title}" /></a></td>
									<td>${item.url}</td>
								</c:when>
								<c:otherwise>
									<td><a href="/main/content/view.do?seq=<c:out value="${item.seq}"/>&amp;menu_type=<c:out value="${paramMap.menu_type}" />"><c:out value="${item.title}" /></a></td>
								</c:otherwise>
							</c:choose>
							<td>${item.writer}</td>
							<td>${item.reg_date}</td>
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