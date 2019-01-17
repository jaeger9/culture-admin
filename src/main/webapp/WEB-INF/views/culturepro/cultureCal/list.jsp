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
	
	var strt_dt = frm.find('input[name=strt_dt]');
	var end_dt = frm.find('input[name=end_dt]');
	var reg_start = frm.find('input[name=reg_start]');
	var reg_end = frm.find('input[name=reg_end]');
	
	new Datepicker(strt_dt, end_dt);
	new Datepicker(reg_start, reg_end);
	
	//paging
	var p = new Pagination({
		view		:	'#pagination',
		page_count	:	'${count }',
		page_no		:	'${paramMap.page_no }',
		callback	:	function(pageIndex, e) {
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});
	if ('${paramMap.approval_yn}') {
		$('input:radio[name="approval_yn"][value="${paramMap.approval_yn}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="approval_yn"][value=""]').prop('checked', 'checked');
	}

	//검색 selectbox
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
		if(!$(this).find('input').attr('type') && !$(this).find('span').attr('class')){
    		$(this).click(function(){
        		view($(this).parent().first().find('input').attr('type' , 'checkbox').val());
    		});
  		}
	});
	
	view = function(seq) { 
		url = '/culturepro/cultureCal/view.do';
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
        		if (!confirm('승인 처리하시겠습니까?')) {
        			return false;
        		}
				$('input[name=updateStatus]').val('Y');
				updateStatus();
        	} else if($(this).html() == '미승인') {
        		if (!confirm('미승인 처리하시겠습니까?')) {
        			return false;
        		}
        		$('input[name=updateStatus]').val('N');
        		updateStatus();
			} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 처리하시겠습니까?')) {
        			return false;
        		}
        		deletes();
			}
    	});
	});
	
	//승인, 미승인  
	updateStatus = function () {
		
		if(getCheckBoxCheckCnt() == 0) {
			if($('input[name=updateStatus]').val() == 'N')
				alert('미승인할 팝업을 선택하세요');
			if($('input[name=updateStatus]').val() == 'Y')
				alert('승인할 팝업을 선택하세요');
			return false;
		}
		
		formSubmit('/culturepro/cultureCal/statusUpdate.do');
	}
	
	deletes = function () {
		
		if(getCheckBoxCheckCnt() == 0) {
			alert("삭제할건을 선택하세요.");
			return false;
		}
		
		formSubmit('/culturepro/cultureCal/delete.do');
	}
	
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
	<form name="frm" method="get" action="/culturepro/cultureCal/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/> 
		<input type="hidden" name="fromUrl" value="list"/>
		
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="문화캘린더 관리">
					<caption>문화캘린더 관리</caption>
					<colgroup>
						<col style="width:13%" />
						<col style="width:%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">등록일</th>
							<td>
								<input type="text" name="reg_start" class="datepicker" value="${paramMap.reg_start }" />
								<span>~</span>
								<input type="text" name="reg_end" class="datepicker" value="${paramMap.reg_end }" />
							</td>
						</tr>
						<tr>
							<th scope="row">기간</th>
							<td>
								<input type="text" name="strt_dt" class="datepicker" value="${paramMap.strt_dt }" />
								<span>~</span>
								<input type="text" name="end_dt" class="datepicker" value="${paramMap.end_dt }" />
							</td>
						</tr>
						<tr>
							<th scope="row">승인여부</th>
							<td>
								<div class="inputBox">
									<label><input type="radio" name="approval_yn" value=""/> 전체</label>
									<label><input type="radio" name="approval_yn" value="W"/> 대기</label>
									<label><input type="radio" name="approval_yn" value="Y"/> 승인</label>
									<label><input type="radio" name="approval_yn" value="N"/> 미승인</label>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">검색어</th>
							<td>
								<select name="searchGubun" style="width: 100px;">
									<option value="">전체</option>
									<option value="title">제목</option>
									<option value="contents">내용</option>
								</select>
								<input type="text" name="searchKeyword" title="검색어 입력" value="${paramMap.searchKeyword}"/>
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
			<table summary="문화캘린더 관리 목록">
				<caption>문화캘린더 관리</caption>
				<colgroup>
					<col style="width:3%" />
					<col style="width:5%" />
					<col style="width:25%" />
					<col style="width:*" />
					<col style="width:10%" />
					<col style="width:8%" />
					<col style="width:8%" />
				</colgroup>
				<thead>
				<tr>
					<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
					<th scope="col">NO</th>
					<th scope="col">기간</th>
					<th scope="col">제목</th>
					<th scope="col">등록일</th>
					<th scope="col">조회수</th>
					<th scope="col">승인여부</th>
				</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index}" />
						<tr>
							<td><input type="checkbox" name="seq" value="${item.seq}"/></td>
							<td>${num}</td>
							<td><c:out value="${item.strt_dt}"/> ~ <c:out value="${item.end_dt}"/></td>
							<td class="subject">
								<a href="/culturepro/cultureCal/view.do?seq=${item.seq}">
									<c:out value="${item.title}"/>
								</a>
							</td>
							<td>${item.reg_date }</td>
							<td>${item.view_cnt}</td>
							<td>
								<c:choose>
									<c:when test="${item.approval_yn eq 'Y'}">
										승인
									</c:when>
									<c:when test="${item.approval_yn eq 'W'}">
										대기
									</c:when>
									<c:otherwise>
										미승인
									</c:otherwise>
								</c:choose>
							</td>
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
