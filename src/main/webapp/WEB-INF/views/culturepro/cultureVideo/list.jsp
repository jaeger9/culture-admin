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
	var frm2 = $('form[name=tvFrm]');
	var page_no = frm.find('input[name=page_no]');
	var reg_date_start = frm.find('input[name=reg_start]');
	var reg_date_end = frm.find('input[name=reg_end]');
	var display_start_date = frm2.find('input[name=display_start_date]');
	var display_end_date = frm2.find('input[name=display_end_date]');
	

	//layout
	if('${paramMap.sort_type}') {
		if('${paramMap.sort_type}' == 'hit'){
			$('ul.sortingList li').removeClass('on');
			$('ul.sortingList li:eq(1)').addClass('on');
		}
	}
	
	new Datepicker(reg_date_start
			, reg_date_end);
	new Datepicker(display_start_date
			, display_end_date);
	
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
	
	//checkbox
	new Checkbox('input[name=seqAll]', 'input[name=seq]');

	// 승인여부 radio check
	if ('${paramMap.approval_yn}') {
		$('input:radio[name="approval_yn"][value="${paramMap.approval_yn}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="approval_yn"][value=""]').prop('checked', 'checked');
	}
	
	//분류
	if('${paramMap.category}')$("select[name=category]").val('${paramMap.category}').attr("selected", "selected");
	
	
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
	
	view = function(seq) { 
		url = '/culturepro/cultureVideo/view.do';
		if(seq)
			url += '?seq=' + seq;
		
		location.href = url;
	}
	
	
	//등록 & 상세
// 	$('span.btn.dark.fr').click(function(){
// 		view();
// 	});
	
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
			}
    	});
	});
	
	//승인, 미승인  
	updateStatus = function () {
		
		if(getCheckBoxCheckCnt() == 0) {
			if($('input[name=updateStatus]').val() == 'N')
				alert('미승인할 영상을 선택하세요');
			if($('input[name=updateStatus]').val() == 'Y')
				alert('승인할 영상을 선택하세요');
			return false;
		}
		
		formSubmit('/culturepro/cultureVideo/statusUpdate.do');
	}
	
	//삭제
	deleteSites = function () {
		if(getCheckBoxCheckCnt() == 0) {
			alert('삭제할 소식을 선택하세요');
			return false;
		}

		//태그를 삭제할때 사용할 seq값을 담는다.
        $("input[name=seq]:checked").each(function(i) {
        	$('<input>').attr('name','boardSeq').attr('type','hidden').val($(this).val()).appendTo('input[name=menuType]:last');
        });
		
		formSubmit('/culturepro/cultureVideo/delete.do');
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

function submitTvLive(){
	var frm = $('form[name=tvFrm]');
	frm.submit();
	
}
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" method="get" action="/culturepro/cultureVideo/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/> 
		<input type="hidden" name="sort_type" value="${paramMap.sort_type}"/>
		
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="문화영상관리 글 검색">
					<caption>문화영상관리</caption>
					<colgroup>
						<col style="width:13%" />
						<col style="width:%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">분류</th>
							<td>
								<select id="category" name="category" style="width: 100px;" onChange="frm.submit();">
									<option value="">전체</option>
									<option value="culturetv">문화TV</option>
									<option value="cultureroad">길 위의 인문학</option>
									<option value="culture100">한국문화100</option>
									<option value="job30">문화직업30</option>
									<option value="cultureCast">문화예보</option>
									<option value="culturepd">문화PD</option>
								</select>
							</td>
						</tr>
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
			<ul class="sortingList">
				<li class="on"><a href="#url">최신순</a></li>
				<li><a href="#url">조회순</a></li>
			</ul>
		</div>
		<!-- 리스트 -->
		<div class="tableList">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col style="width:3%" />
					<col style="width:5%" />
					<col style="width:10%" />
					<col style="width:25%" />
					<col style="width:8%" />
					<col style="width:6%" />
					<col style="width:8%" />
				</colgroup>
				<thead>
				<tr>
					<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
					<th scope="col">NO</th>
					<th scope="col">분류</th>
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
							<td>
							<c:choose>
								<c:when test="${item.category == 'culturetv' }">문화TV</c:when>
								<c:when test="${item.category == 'cultureroad' }">길 위의 인문학</c:when>
								<c:when test="${item.category == 'culture100' }">한국문화100</c:when>
								<c:when test="${item.category == 'job30' }">문화직업30</c:when>
								<c:when test="${item.category == 'cultureCast' }">문화예보</c:when>
								<c:when test="${item.category == 'culturepd' }">문화PD</c:when>
							</c:choose></td>
							<td class="subject">
								<a href="/culturepro/cultureVideo/view.do?seq=${item.seq}">
									<c:out value="${item.title}"/>
								</a>
							</td>
							<td><c:out value="${item.reg_date}"/></td>
							<td>${item.view_cnt}</td>
							<td>${item.approval_nm }</td>
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
		<span class="btn dark fr"><a href="#url" onclick="view()">등록</a></span>
	</div>
	<br/> 
<% /* 	
	<br/>
	<h3 class="title01">문화 TV Live OnAir</h3>
	<form name="tvFrm" method="post" enctype="multipart/form-data" action="/culturepro/cultureVideo/liveTvUpdate.do">
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="문화 TV Live OnAir 등록">
					<caption>문화 TV Live OnAir</caption>
					<colgroup>
						<col style="width:13%" />
						<col style="width:%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">표시기간</th>
							<td>
								<input type="text" name="display_start_date" value="${tvInfo.display_start_date }" />
								<span>~</span>
								<input type="text" name="display_end_date" value="${tvInfo.display_end_date }" />
							</td>
						</tr>
						
						<tr>
							<th scope="row">승인여부</th>
							<td>
								<div class="inputBox">
									<c:if test="${tvInfo.approval_yn == 'Y' }">
										<label><input type="radio" name="approval_yn" value="Y" checked="checked"/> 승인</label>
										<label><input type="radio" name="approval_yn" value="N"/> 미승인</label>
									</c:if>
									<c:if test="${tvInfo.approval_yn == 'N' }">
										<label><input type="radio" name="approval_yn" value="Y" /> 승인</label>
										<label><input type="radio" name="approval_yn" value="N" checked="checked"/> 미승인</label>
									</c:if>
									
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">링크</th>
							<td>
								<input type="text" name="link_url" title="검색어 입력" value="${tvInfo.link_url}"/>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</fieldset>
		<div class="btnBox">
			<span class="btn dark fr"><a href="#url" onclick="submitTvLive()">등록</a></span>
		</div>
	</form>
*/ %>
</body>
</html>
