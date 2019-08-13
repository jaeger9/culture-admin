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
	var search_date_start = frm.find('input[name=search_start]');
	var search_date_end = frm.find('input[name=search_end]');
	/* var creators = frm.find('input[name=creators]');
	var approval = frm.find('input[name=approval]');
	var reg_date_start = frm.find('inpput[name=reg_date_start]');
	var reg_date_end = frm.find('inpput[name=reg_date_end]');
	var insert_date_start = frm.find('inpput[name=insert_date_start]');
	var insert_date_end = frm.find('inpput[name=insert_date_end]');
	var search_type = frm.find('select[name=search_type]');
	var search_word = frm.find('inpput[name=search_word]'); */

	//layout
	if('${paramMap.sort_type}') {
		if('${paramMap.sort_type}' == 'hit'){
			$('ul.sortingList li').removeClass('on');
			$('ul.sortingList li:eq(1)').addClass('on');
		}
	}
	
	new Datepicker(search_date_start, search_date_end);
	
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

	//radio check
	if('${paramMap.state}')
		$('input:radio[name="state"][value="${paramMap.state}"]').prop('checked', 'checked');
	
	//checkbox
	new Checkbox('input[name=uciAll]', 'input[name=uci]');
	
	//selectbox
	if('${paramMap.approval}')$("select[name=approval]").val('${paramMap.approval}').attr("selected", "selected");
	if('${paramMap.period}')$("select[name=period]").val('${paramMap.period}').attr("selected", "selected");
	if('${paramMap.searchGubun}')$("select[name=searchGubun]").val('${paramMap.searchGubun}').attr("selected", "selected");

	// radio 변경
	// if('${paramMap.office}')$("select[name=office]").val('${paramMap.office}').attr("selected", "selected");
	
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
	
	show = function(menu_cd , seq) {
		location.href('/common/reply/list.do?rUrl=/perform/show/list.do&menu_cd=' + menu_cd + '&amp;seq=' + seq);
		
		return false;
	};

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
	
	// 등록, 상세
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
		
		formSubmit('/perform/show/statusUpdate.do');
	}
	
	//삭제
	deleteSites = function () { 
		
		if(getCheckBoxCheckCnt() == 0) {
			alert('삭제할 코드를 선택하세요');
			return false;
		}
		
		formSubmit('/perform/show/delete.do');
	}
	
	//체크 박스 count 수 
	getCheckBoxCheckCnt = function() { 
		return $('input[name=uci]:checked').length;
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
	<form name="frm" method="get" action="/perform/show/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/> 
		<input type="hidden" name="sort_type" value="${paramMap.sort_type}"/>
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<%--<tr>--%>
							<%--<th scope="row">출처</th>--%>
							<%--<td colspan="3">--%>
								<%--<select title="출처 선택" name="office">--%>
									<%--<option value="">전체</option>--%>
									<%--<c:forEach items="${officeList }" var="list" varStatus="status">--%>
										<%--<option value="${list.publisher}">${list.job_group_name}</option>	--%>
									<%--</c:forEach>--%>
								<%--</select>--%>
							<%--</td>--%>
						<%--</tr>--%>
						<tr>
							<th scope="row">출처</th>
							<td colspan="3">
								<div class="inputBox">
									<label><input type="radio" value="1" name="state" checked/> 전체</label>
									<label><input type="radio" value="2" name="state"/> 내부 등록</label>
									<label><input type="radio" value="3" name="state"/> 공연예술통합전산망</label>
									<label><input type="radio" value="4" name="state"/> nticket</label>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">공연/전시일</th>
							<td colspan="3">
								<select title="공연/전시일 선택하세요" name="period">
									<option value="">공연/전시일을 선택하세요.</option>
									<option value="event">공연/전시일</option>
									<option value="insert">등록일</option>
								</select>
								<input type="text" name="search_start" value="${paramMap.search_start }" />
								<span>~</span>
								<input type="text" name="search_end" value="${paramMap.search_end }" />
							</td>
						</tr>
						<tr>
							<th scope="row">승인여부</th>
							<td colspan="3">
								<select title="공연/전시일 선택하세요" name="approval">
									<option value="">전체</option>
									<option value="N">미승인</option>
									<option value="Y">승인</option>
									<option value="W">대기</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">검색어</th>
							<td colspan="3">
								<select name="searchGubun">
									<option value="all">전체</option>
									<option value="title">제목</option>
									<option value="description">내용</option>
									<option value="creator">작성자</option>
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
					<col style="width:6%" />
					<col style="width:6%" />
					<col style="width:10%" />
					<col style="width:25%" />
					
					<col style="width:10%" />
					<col style="width:10%" />
					<col style="width:10%" />
					<col style="width:6%" />
					<col style="width:8%" />
					<col style="width:10%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="uciAll" title="리스트 전체 선택" /></th>
						<th scope="col">번호</th>
						<th scope="col">지역</th>
						<th scope="col">장르</th>
						<th scope="col">제목</th>
						
						<th scope="col">출처/작성자</th>
						<th scope="col">공연기간</th>
						<th scope="col">등록일</th>
						<th scope="col">조회수</th>
						<th scope="col">승인여부</th>
						<th scope="col">댓글</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index}" />
						<tr>
							<td><input type="checkbox" name="uci" value="${item.uci}"/></td>
							<%-- <td>${item.code}</td> --%>
							<td>${num}</td>
							<td>${item.location}</td>
							<td>${item.genre}</td>
							<td><a href="/perform/show/view.do?uci=<c:out value="${item.uci}"/>&qs=${paramMap.qs }"><c:out value="${item.title}" /></a></td>
							<td>${item.creator}</td>
							<td>${item.reg_start} ~ ${item.reg_end}</td>
							<td>${item.reg_date}</td>
							<td>${item.view_cnt}</td>
							<td>${item.approval}</td>
							<td>
								<input type="hidden" name="menuTD"/><a href="/common/reply/list.do?rUrl=/perform/show/list.do&menu_cd=1&amp;seq=<c:out value="${item.seq }" />&amp;uci=<c:out value="${item.uci }" />" class="btnN"><span class="btn whiteS"><button type="button" onClick="javascript:show('1' , '${item.seq }')">보기</button></span></a>(<c:out value="${item.reply_cnt}" />)
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
		<span class="btn dark fr"><a href="/perform/show/view.do">등록</a></span>
	</div>
</body>
</html>