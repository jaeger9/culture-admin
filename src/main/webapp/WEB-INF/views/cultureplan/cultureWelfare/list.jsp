<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<c:if test="${paramMap.gubun eq 'W' }">
	<c:set var="list_url" value="/cultureplan/cultureWelfare/list.do"/>
	<c:set var="view_url" value="/cultureplan/cultureWelfare/view.do"/>
</c:if>
<c:if test="${paramMap.gubun eq 'E' }">
	<c:set var="list_url" value="/cultureplan/cultureWelfare/enterpriseList.do"/>
	<c:set var="view_url" value="/cultureplan/cultureWelfare/enterpriseView.do"/>
</c:if>
<script type="text/javascript">
$(function () {

	var frm = $('form[name=frm]');
	var page_no = frm.find('input[name=page_no]');
	var reg_date_start = frm.find('input[name=reg_start]');
	var reg_date_end = frm.find('input[name=reg_end]');
	
	new Datepicker(reg_date_start, reg_date_end);
	
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
	
	//checkbox
	new Checkbox('input[name=seqAll]', 'input[name=seq]');

	// radio check
	if ('${paramMap.searchAproval}') {
		$('input:radio[name="searchAproval"][value="${paramMap.searchAproval}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="searchAproval"][value=""]').prop('checked', 'checked');
	}
	
	//selectbox
	if('${paramMap.searchGubun}')$("select[name=searchGubun]").val('${paramMap.searchGubun}').attr("selected", "selected");
	
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
		url = '${view_url}';
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
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		deleteSites();
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
	
	//승인 , 미승인
	updateStatus = function () {		
		if(getCheckBoxCheckCnt() == 0) {
			if($('input[name=updateStatus]').val() == 'N')
				alert('미승인할 대상을 선택해주세요');
			if($('input[name=updateStatus]').val() == 'Y')
				alert('승인할 대상을 선택해주세요');
			return false;
		}
		
		formSubmit('/cultureplan/cultureWelfare/statusUpdate.do');
	}
	
	//삭제
	deleteSites = function () {
		if(getCheckBoxCheckCnt() == 0) {
			alert('삭제할 대상을 선택하세요');
			return false;
		}
		
		formSubmit('/cultureplan/cultureWelfare/delete.do');
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
	<form name="frm" method="get" action="${list_url }">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/>
		<input type="hidden" name="gubun" value="${paramMap.gubun }"/>
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="문화복지혜택 검색">
					<caption>문화복지혜택 검색</caption>
					<colgroup>
						<col style="width:13%" />
						<col style="width:%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">등록일</th>
							<td>
								<input type="text" name="reg_start" value="${paramMap.reg_start }" />
								<span>~</span>
								<input type="text" name="reg_end" value="${paramMap.reg_end }" />
							</td>
						</tr>
						<tr>
							<th scope="row">승인여부</th>
							<td>
								<div class="inputBox">
									<label><input type="radio" name="searchAproval" value="" <c:if test="${empty paramMap.searchAproval }">checked="checked"</c:if>/> 전체</label>
									<label><input type="radio" name="searchAproval" value="W" <c:if test="${paramMap.searchAproval eq 'W'}">checked="checked"</c:if>/> 대기</label>
									<label><input type="radio" name="searchAproval" value="Y" <c:if test="${paramMap.searchAproval eq 'Y' }">checked="checked"</c:if>/> 승인</label>
									<label><input type="radio" name="searchAproval" value="N" <c:if test="${paramMap.searchAproval eq 'N'}">checked="checked"</c:if>/> 미승인</label>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">검색어</th>
							<td>
								<select name="searchGubun" style="width: 100px;">
									<option value="all">전체</option>
									<option value="title">제목</option>
									<option value="contents">내용</option>
									<option value="all">제목+내용</option>
								</select>
								<input type="text" name="search_word" title="검색어 입력" value="${paramMap.search_word}"/>
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
					<col style="width:15%" />
					<col style="width:15%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
						<th scope="col">번호</th>
						<th scope="col">제목</th>
						<th scope="col">등록일</th>
						<th scope="col">조회수</th>
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
								<a href="${view_url}?seq=<c:out value="${item.seq}"/>">
									<c:out value="${item.title}" />
								</a>
							</td>
							<td>${item.reg_date}</td>
							<td>${item.view_cnt}</td>
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
