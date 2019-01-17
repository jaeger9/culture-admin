<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<%-- 
<c:url var="urlExcel" value="/event/invitationApplicant/excel.do">
	<c:param name="event_seq" value="${paramMap.event_seq }">
		<c:out value="${paramMap.event_seq }" />
	</c:param>
	<c:param name="event_title">
		<c:out value="${paramMap.event_title }" />
	</c:param>
	<c:param name="perform_title">
		<c:out value="${paramMap.perform_title }" />
	</c:param>
</c:url>
 --%>
<script type="text/javascript">
$(function () {

	var frm = $('form[name=frm]');
	var page_no = frm.find('input[name=page_no]');
	var close_btn = frm.find('.close_btn');
	var search_btn = frm.find('[name=search_btn]');
	
	search_btn.on({
		'click': function() {
			frm.attr('action', 'invitationApplicant.do').submit();
		}
	});
	
	var search = function () {
		frm.attr('action', 'invitationApplicant.do').submit();
	};
	
	new Pagination({
		view		:	'#pagination',
		page_count	:	'${count }',
		page_no		:	'${paramMap.page_no }',
		callback	:	function(pageIndex, e) {
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});
	
	close_btn.click(function () {
		window.close();
		return false;
	});
	
	//checkbox
	new Checkbox('input[name=seqAll]', 'input[name=seq]');
	
	//승인 , 미승인 , 삭제 이벤트 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '당첨자 승인') {
        		if (!confirm('당첨자 승인 하시겠습니까?')) {
    				return false;
    			}
        		$('input[name=updateStatus]').val('Y');
        		updateStatus();
        	}else if($(this).html() == '당첨자 취소') {
        		if (!confirm('당첨자 취소 하시겠습니까?')) {
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
				alert('취소 대상을 선택하세요');
			if($('input[name=updateStatus]').val() == 'Y')
				alert('당첨 대상을 선택하세요');
			return false;
		}
		
		formSubmit('/popup/statusUpdate.do');
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
function excelDown(val) {
	if(val == 'Y'){
		$('input[name="win_yn"]').val('Y');
	}else{
		$('input[name="win_yn"]').val('N');
	}
	$('form[name=frm]').attr('action', '/event/invitationApplicant/excel.do').submit();
}
</script>
</head>
<body>

<form name="frm" method="get" action="/popup/invitationApplicant.do" style="padding:20px;">
<fieldset class="searchBox">
	<legend>검색</legend>
	<input type="hidden" name="updateStatus" value=""/>
	<input type="hidden" name="page_no" value="${paramMap.page_no }" />
	<input type="hidden" name="event_seq" value="${paramMap.event_seq }" />
	<input type="hidden" name="event_title" value="${paramMap.event_title }" />
	<input type="hidden" name="perform_title" value="${paramMap.perform_title }" />
	<input type="hidden" name="win_yn" value="" />

	<div class="tableWrite">
		<table summary="게시판 글 검색">
			<caption>게시판 글 검색</caption>
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">이벤트명</th>
					<td>
						${paramMap.event_title }
					</td>
				</tr>
				<tr>
					<th scope="row">공연명</th>
					<td>
						${paramMap.perform_title }
					</td>
				</tr>
				<tr>
				  	<th scope="row">아이디 검색</th>
					<td>
						<input type="text" name="user_id" value="${paramMap.user_id }" />
						<span class="btn darkS">
							<button type="button" name="search_btn">검색</button>
						</span>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</fieldset>

<div class="topBehavior">
	<p class="totalCnt">총 <span><fmt:formatNumber value="${count }" pattern="###,###" /></span>건</p>
</div>

<div>
	<%-- <a href="/event/invitationApplicant/excel.do?event_seq=${paramMap.event_seq }&amp;event_title=${paramMap.event_title }&amp;perform_title=${paramMap.perform_title }" target="_blank">[응모자 엑셀 다운로드]</a>
	&nbsp;&nbsp;
	<a href="/event/invitationApplicant/excel.do?event_seq=${paramMap.event_seq }&amp;event_title=${paramMap.event_title }&amp;perform_title=${paramMap.perform_title }&amp;win_yn=Y" target="_blank">[당첨자 엑셀 다운로드]</a> --%>
	<a href="#url" onclick="excelDown('N'); return false;">[응모자 엑셀 다운로드]</a>
	&nbsp;&nbsp;
	<a href="#url" onclick="excelDown('Y'); return false;">[당첨자 엑셀 다운로드]</a>
</div>

<!-- table list -->
<div class="tableList">
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:5%" />
			<col style="width:5%" />
			<col />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:10%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
				<th scope="col">번호</th>
				<th scope="col">내용</th>
				<th scope="col">응모자</th>
				<th scope="col">응모일</th>
				<th scope="col">당첨여부</th>
				<th scope="col">당첨횟수<br>(3개월이내)</th>
				<th scope="col">최종당첨일</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
			<tr>
				<td colspan="8">검색된 결과가 없습니다.</td>
			</tr>
			</c:if>
			<c:forEach items="${list }" var="item" varStatus="status">
			<tr data-seq="${item.seq }">
				<td><input type="checkbox" name="seq" value="${item.seq}"/></td>
				<td>
					<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
				</td>
				<td class="subject">
					<c:out value="${item.content }" default="-" />
				</td>
				<td>
					${item.user_id }
				</td>
				<td>
					${item.reg_date }
				</td>
				<td>
					<c:if test="${item.win_yn eq 'Y' }">
					당첨
					</c:if>
				</td>
				<td>
					${item.win_cnt }
				</td>
				<td>
					${item.last_win_dat }
				</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<div id="pagination"></div>

<div class="btnBox">
	<span class="btn white"><button type="button">당첨자 승인</button></span>
	<span class="btn white"><button type="button">당첨자 취소</button></span>
	
	
	<span class="btn dark fr"><a href="#" class="close_btn">닫기</a></span>
</div>
</form>

</body>
</html>