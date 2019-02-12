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
	var reg_date_start = frm.find('input[name=reg_start]');
	var reg_date_end = frm.find('input[name=reg_end]');

	//layout
	if('${paramMap.sort_type}') {
		if('${paramMap.sort_type}' == 'hit'){
			$('ul.sortingList li').removeClass('on');
			$('ul.sortingList li:eq(1)').addClass('on');
		}
	}
	
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
	if ('${paramMap.tv_approval_state}') {
		$('input:radio[name="tv_approval_state"][value="${paramMap.tv_approval_state}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="tv_approval_state"][value=""]').prop('checked', 'checked');
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
	
	//최신순 , 조회순
	$('div.topBehavior ul li a').each(function() {
		$(this).click(function() { 
        	if($(this).html() == '최신순') {
              	$('input[name=sort_type]').val('latest');
              	search();
        	} else if($(this).html() == '조회순') {
              	$('input[name=sort_type]').val('hit');
              	search();
        	} 
    	});
	});

	//상세
	$('div.tableList table tbody tr td').each(function() {
		if(!$(this).find('input').attr('type') && !$(this).find('span').attr('class')){
    		$(this).click(function(){
        		view($(this).parent().first().find('input').attr('type' , 'checkbox').val());
    		});
  		}
	});
	
	view = function(tv_seq) { 
		url = '/magazine/culturemedia/view.do';
		if(tv_seq)
			url += '?tv_seq=' + tv_seq;
		
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
				alert('미승인할 코드를 선택하세요');
			if($('input[name=updateStatus]').val() == 'Y')
				alert('승인할 코드를 선택하세요');
			return false;
		}
		
		formSubmit('/magazine/culturemedia/statusUpdate.do');
	}
	
	//삭제
	deleteSites = function () {
		if(getCheckBoxCheckCnt() == 0) {
			alert('삭제할 코드를 선택하세요');
			return false;
		}

		//태그를 삭제할때 사용할 seq값을 담는다.
        $("input[name=tv_seq]:checked").each(function(i) {
        	$('<input>').attr('name','boardSeq').attr('type','hidden').val($(this).val()).appendTo('input[name=menuType]:last');
        });
		
		formSubmit('/magazine/culturemedia/delete.do');
	}
	
	//체크 박스 count 수 
	getCheckBoxCheckCnt = function() { 
		return $('input[name=tv_seq]:checked').length;
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
	<form name="frm" method="get" action="/magazine/culturemedia/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/> 
		<input type="hidden" name="sort_type" value="${paramMap.sort_type}"/>
		
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
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
							<th scope="row">승인 여부</th>
							<td>
								<div class="inputBox">
									<label><input type="radio" name="tv_approval_state" value=""/> 전체</label>
<!-- 									<label><input type="radio" name="tv_approval_state" value="W"/> 대기</label>
 -->									<label><input type="radio" name="tv_approval_state" value="Y"/> 승인</label>
									<label><input type="radio" name="tv_approval_state" value="N"/> 미승인</label>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">검색어</th>
							<td>
								<select name="searchGubun" style="width: 100px;">
									<option value="">전체</option>
									<option value="tv_title">행사명</option>
									<option value="tv_org">기관명</option>
									<option value="tv_request">요청사항</option>
								</select>
								<input type="text" name="keyword" title="검색어 입력" value="${paramMap.keyword}"/>
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
			<!-- <ul class="sortingList">
				<li class="on"><a href="#url">최신순</a></li>
				<li><a href="#url">조회순</a></li>
			</ul> -->
		</div>
		<!-- 리스트 -->
		<div class="tableList">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col style="width:3%" />
					<col style="width:5%" />
					<col style="width:%" />
					<col style="width:25%" />
					<col style="width:10%" />
					<col style="width:10%" />
					<col style="width:8%" />
				</colgroup>
				<thead>
				<tr>
					<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
					<th scope="col">번호</th>
					<th scope="col">행사명</th>
					<th scope="col">기관명</th>
					<th scope="col">등록자</th>
					<th scope="col">등록일</th>
					<th scope="col">승인<br/>여부</th>
				</tr>
				</thead>
				<tbody>
					<c:if test="${empty list }">
						<tr>
							<td colspan="7">검색된 결과가 없습니다.</td>
						</tr>
					</c:if>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index}" />
						<tr>
							<td><input type="checkbox" name="tv_seq" value="${item.tv_seq}"/></td>
							<td>${num}</td>
							<td class="subject">
								<a href="/magazine/culturemedia/view.do?tv_seq=${item.tv_seq}">
									<c:out value="${item.tv_title}"/>
								</a>
							</td>
							<td><c:out value="${item.tv_org}"/></td>
							<td>${item.insert_user_id}</td>
							<td>${item.insert_date }</td>
							<td>${item.tv_approval_state_name}</td>
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
