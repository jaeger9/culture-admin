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
	var reg_date_start = frm.find('input[name=start_date]');
	var reg_date_end = frm.find('input[name=end_date]');
	/* var creators = frm.find('input[name=creators]');
	var approval = frm.find('input[name=approval]');
	var reg_date_start = frm.find('inpput[name=reg_date_start]');
	var reg_date_end = frm.find('inpput[name=reg_date_end]');
	var insert_date_start = frm.find('inpput[name=insert_date_start]');
	var insert_date_end = frm.find('inpput[name=insert_date_end]');
	var search_type = frm.find('select[name=search_type]');
	var search_word = frm.find('inpput[name=search_word]'); */

	//layout
	
	
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
	
	//selectbox
	if('${paramMap.status}')$("select[name=status]").val('${paramMap.status}').attr("selected", "selected");
	if('${paramMap.start_date}')$("select[name=start_date]").val('${paramMap.start_date}').attr("selected", "selected");
	if('${paramMap.end_date}')$("select[name=end_date]").val('${paramMap.end_date}').attr("selected", "selected");
	if('${paramMap.searchGubun}')$("select[name=searchGubun]").val('${paramMap.searchGubun}').attr("selected", "selected");
	
	//검색
	$('button[name=searchButton]').click(function(){
		$('input[name=page_no]').val('1');
		formSubmit('/pattern/ask/list.do');
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
		url = '/pattern/ask/view.do';
		if(seq)
			url += '?seq=' + seq.replace(/\+/g,"%2B");
		
		location.href = url;
	}
	
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
				alert('미승인할 코드를 선택하세요');
			if($('input[name=updateStatus]').val() == 'Y')
				alert('승인할 코드를 선택하세요');
			return false;
		}
		
		formSubmit('/pattern/ask/statusUpdate.do');
	}
	
	//삭제
	deleteSites = function () { 
		
		if(getCheckBoxCheckCnt() == 0) {
			alert('삭제할 코드를 선택하세요');
			return false;
		}
		
		formSubmit('/pattern/ask/delete.do');
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
	
	excelDown = function() {
		formSubmit('/pattern/ask/excelDownload.do');
	};
	
	excelDown2 = function() {
		formSubmit('/pattern/ask/excelDownload2.do');
	};
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" method="get" action="/pattern/ask/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/> 
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">기간</th>
							<td colspan="3">
								<select name="searchDateType">
									<option value="regDate">신청일</option>
									<option value="confirmDate">승인일</option>
								</select>
								<input type="text" name="start_date" value="${paramMap.start_date }" />
								<span>~</span>
								<input type="text" name="end_date" value="${paramMap.end_date }" />
							</td>
						</tr>
						<tr>
							<th scope="row">승인여부</th>
							<td>
								<select title="공연/전시일 선택하세요" name="status">
									<option value="">전체</option>
									<option value="W" ${paramMap.status eq 'W' ? 'selected="selected"' : ''}>대기</option>
									<option value="N"  ${paramMap.status eq 'N' ? 'selected="selected"' : ''}>미승인</option>
									<option value="Y"  ${paramMap.status eq 'Y' ? 'selected="selected"' : ''}>승인</option>
									<option value="C"  ${paramMap.status eq 'C' ? 'selected="selected"' : ''}>신청취소</option>
									<option value="D"  ${paramMap.status eq 'D' ? 'selected="selected"' : ''}>다운로드</option>
								</select>
							</td>
							<th scope="row">사용용도 구분</th>
							<td>
								<select title="공연/전시일 선택하세요" name="searchContestsType">
									<option value="">전체</option>
									<option value="1" ${paramMap.searchContestsType eq '1' ? 'selected="selected"' : ''}>개인</option>
									<option value="2" ${paramMap.searchContestsType eq '2' ? 'selected="selected"' : ''}>민간</option>
									<option value="3" ${paramMap.searchContestsType eq '3' ? 'selected="selected"' : ''}>공공</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">검색어</th>
							<td colspan="3">
								<select name="searchGubun">
									<option value="title">제목</option>
									<option value="name">신청자</option>
 									<!-- <option value="">전체</option> -->
								</select>
								<input type="text" name="keyword" title="검색어 입력" value="${paramMap.keyword}" style="width:520px;" />
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
					<col style="width:8%" />
					<col style="width:%" />
					<col style="width:15%" />
					<col style="width:10%" />
					
					<col style="width:10%" />
					<col style="width:10%" />
					<col style="width:10%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
						<th scope="col">번호</th>
						<th scope="col">신청문양</th>
						<th scope="col">사용용도</th>
						<th scope="col">신청자</th>
						
						<th scope="col">신청일</th>
						<th scope="col">승인일</th>
						<th scope="col">승인여부</th>
						
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index}" />
						<tr>
							<td><input type="checkbox" name="seq" value="${item.seq}"/></td>
							<%-- <td>${item.code}</td> --%>
							<td>${num}</td>
							<td>	
								<a href="/pattern/ask/view.do?seq=<c:out value="${item.seq}"/>&qs=${paramMap.qs }">
									<c:if test="${item.title eq '(1111111)' }" >
										전통문양사용신청 요청
									</c:if>
									
									<c:if test="${item.title ne '(1111111)' }" >
										<c:out value="${item.title} " />
									</c:if>
									<c:if test='${(item.pattern_cnt)-1 > 0 }' >외 <c:out value='${item.pattern_cnt-1 }건' /></c:if>
								</a>
							</td>
							<td>
								<c:if test="${item.contents1 eq 1}">개인<c:if test="${not empty item.contents2 or not empty item.contents2}">, </c:if></c:if>
								<c:if test="${item.contents2 eq 2}">민간<c:if test="${not empty item.contents3}">, </c:if></c:if>
								<c:if test="${item.contents3 eq 3}">공공</c:if>
							</td>
							<td>
								<a href="/pattern/ask/view.do?seq=<c:out value="${item.seq}"/>&qs=${paramMap.qs }">
									<c:out value="${item.name}" />
								</a>
							</td>
							<td>
								<c:out value="${item.reg_date}" default="-" />
							</td>
							<td>
								<c:out value="${item.confirm_date}" default="-" />
							</td>
							<td>${item.status}</td>							
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
		<span class="btn dark fr"><a href="#url" onclick="view(); return false;">등록</a></span>
		<span class="btn dark fr" style="margin-right:4px;"><a href="#url" onclick="excelDown(); return false;">엑셀다운로드</a></span>
		<span class="btn dark fr" style="margin-right:4px;"><a href="#url" onclick="excelDown2(); return false;">사용자별통계</a></span> 
	</div>
</body>
</html>
