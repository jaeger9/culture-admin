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
	
	new Datepicker(reg_date_start, reg_date_end);
	
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
	
	//selectbox
	if('${paramMap.xtype}')$("select[name=xtype]").val('${paramMap.xtype}').attr("selected", "selected");
	if('${paramMap.xdimension}')$("select[name=xdimension]").val('${paramMap.xdimension}').attr("selected", "selected");
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
	
	view = function(ecim_ecid) { 
		url = '/pattern/db/manage/view.do';
		if(ecim_ecid)
			url += '?ecim_ecid=' + ecim_ecid;
		
		location.href = url;
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
	
	//등록 & 상세
	$('span.btn.dark.fr').click(function(){
		view();
	});
	
	//승인 , 미승인 , 삭제 이벤트 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '삭제') {
        		deleteSites();
        	} 
    	});
	});
	
	
	//삭제
	deleteSites = function () { 
		
		if(getCheckBoxCheckCnt() == 0) {
			alert('삭제할 코드를 선택하세요');
			return false;
		}
		
		formSubmit('/pattern/db/manage/delete.do');
	}
	
	//체크 박스 count 수 
	getCheckBoxCheckCnt = function() { 
		return $('input[name=ecim_ecid]:checked').length;
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
	<form name="frm" method="get" action="/pattern/db/manage/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/>
		<input type="hidden" name="sort_type" value="${paramMap.sort_type}"/>
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="공연장 검색">
					<caption>공연장 검색</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>	
						<tr>
							<th scope="row">문양구분</th>
							<td>
								<select name="xdimension">
								    <option value="">전체</option>
								    <option value="2D">2D</option>
								    <option value="3D">3D</option>
								</select>
							</td>
							<th scope="row">콘텐츠 구분</th>
							<td>
								<select name="xtype" style="width=50px;">
								    <option value="">전체</option>
								    <option value="원시문양">원시문양</option>
								    <option value="개별문양">개별문양</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">등록일</th>
							<td colspan="3">
								<input type="text" name="reg_start" value="${paramMap.reg_start }" />
								<span>~</span>
								<input type="text" name="reg_end" value="${paramMap.reg_end }" />
							</td>
						</tr>
						<tr>
							<th scope="row">검색어</th>
							<td colspan="3">
								<select name="searchGubun">
								    <option value="">선택하세요</option>
								    <option value="did">문양코드</option>
								    <option value="title">문양명</option>
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
					<col style="width:10%" />
					<col style="width:%" />
					<col style="width:15%" />
					<col style="width:17%" />
					
					<col style="width:10%" />
					<col style="width:10%" />
					<col style="width:8%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">이미지</th>
						<th scope="col">문양명</th>
						<th scope="col">문양구분</th>
						<th scope="col">분류체계</th>

						<th scope="col">국적/시대</th>
						<th scope="col">등록일자</th>
						<th scope="col">조회수</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list}" var="item" varStatus="status">
						<tr>
							<td>
							<a href="/pattern/db/manage/view.do?did=<c:out value="${item.did}" />">
								<img src="http://www.culture.go.kr/pattern/service_design/images/thumb/80/<c:out value='${item.xthumbseq}' />.GIF" width=80 height=60>
							</a>
							</td>
							<td class="colTit"><a href="/pattern/db/manage/view.do?did=<c:out value='${item.did}'/>"><c:out value='${item.xtitle}' /><br>(&nbsp;<c:out value='${item.did}' />&nbsp;)</a></td>
							<td><c:out value='${item.xdimension}' /></td>
							<td><c:out value='${item.xtaxonomy}' /></td>
							
							<td><c:out value='${item.xage}' /></td>
							<td><c:out value='${item.xcreated}' /></td>
							<td><c:out value="${item.view_cnt }" /><c:if test='${empty item.view_cnt }' >0</c:if></td>
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
