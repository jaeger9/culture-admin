<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

	//상단배너용 테이블을 별도구현
	if( '${paramMap.menu_type}' == '701'){
		$('#topBannerDiv').show();
		$('#otherBannerDiv').hide();
	}else{
		$('#topBannerDiv').hide();
		$('#otherBannerDiv').show();
	}
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
		url = '/main/banner/view.do?menu_type=' + $('input[name=menu_type]').val();
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
        		deleteBanner();
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
	deleteBanner = function() { 
		if(getCheckBoxCheckCnt() == 0) {
			alert('삭제할 배너를 선택하세요');
			return false;
		}
		
		formSubmit('/main/banner/delete.do');
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
		
		formSubmit('/main/banner/statusUpdate.do');
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
	<form name="frm" method="post" action="/main/banner/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no}"/>
		<input type="hidden" name="updateStatus" value=""/>
		<input type="hidden" name="menu_type" value="${paramMap.menu_type}"/>
		
		<ul class="tab">
			<c:forEach items="${bannerList }" var="bannerList" varStatus="status">
				<c:if test="${bannerList.code ne 205 and bannerList.code ne 571 and bannerList.code ne 572 }">
				<li>
					<a href="/main/banner/list.do?menu_type=${bannerList.code}" <c:if test="${ paramMap.menu_type eq bannerList.code }"> class="focus"</c:if>>
						${bannerList.name}
					</a>
				</li>
				</c:if>
			</c:forEach>
		</ul>
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">승인여부</th>
							<td>
								<select title="승인여부 선택" name="status">
									<option value="">전체</option>
									<option value="N">미승인</option>
									<option value="Y">승인</option>
									<option value="W">대기</option>
								</select>
							</td>
							<th scope="row">검색어</th>
							<td>
								<input type="text" name=keyword title="검색어 입력" value="${paramMap.keyword}"/>
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
		<div class="tableList" id="otherBannerDiv">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col style="width:6%" />
					<col style="width:8%" />
					<col style="width:10%" />
					<c:if test="${571 eq paramMap.menu_type}">
						<col style="width:15%" />
					</c:if>
					<col style="width:%" />
					<c:if test="${207 ne paramMap.menu_type}">
						<col style="width:10%" />
						<col style="width:10%" />
					</c:if>
					<c:if test="${573 eq paramMap.menu_type}">
						<col style="width:10%" />
					</c:if>
					<col style="width:10%" />
				</colgroup>
				<thead>
				
					<tr>
						<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
						<th scope="col">번호</th>
						<th scope="col">이미지</th>
						<c:if test="${571 eq paramMap.menu_type}">
							<th scope="col">핫존영역제목 </th>
						</c:if>
						<th scope="col">제목</th>
						<c:if test="${207 ne paramMap.menu_type}">
							<th scope="col">시작일</th>
							<th scope="col">종료일</th>
						</c:if>
						<c:if test="${573 eq paramMap.menu_type}">
						<th scope="col">작성자</th>
						</c:if>			
						<th scope="col">승인여부</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(paramMap.list_unit*(paramMap.page_no-1))-status.index}" />
						<tr code="${item.code}">
							<td><input type="checkbox" name="seq" value="${item.seq}"/></td>
							<td>${num}</td>
							<td><img src="${item.image_url}"  alt="${item.title}" /></td>
							<c:if test="${571 eq paramMap.menu_type}">
								<td>${item.banner_title}</td>
							</c:if>
							<td><a href="/main/banner/view.do?seq=<c:out value="${item.seq}"/>&amp;menu_type=<c:out value="${paramMap.menu_type}" />"><c:out value="${item.title}" /></a></td>
							<c:if test="${207 ne paramMap.menu_type}">
								<td>${item.start_date}</td>
								<td>${item.end_date}</td>
							</c:if>
							
							<c:if test="${573 eq paramMap.menu_type}">
							<td><a href="/member/portal/form.do?user_id=<c:out value="${item.user_id}"/>" </a> ${item.user_id}</td>
							</c:if>
							
							<td>${item.status}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		
		<!-- 리스트 상단배녀용으로 별로구현 -->
		<div class="tableList" id="topBannerDiv" style="display:none;">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col style="width:5%" />
					<col style="width:5%" />
					<col style="width:5%" />
					<col style="width:%" />
					<col style="width:20%" />
					<col style="width:10%" />
					<col style="width:10%" />
					<col style="width:10%" />
				</colgroup>
				<thead>
				
					<tr>
						<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
						<th scope="col">번호</th>
						<th scope="col">타입</th>
						<th scope="col">이미지</th>
						<th scope="col">제목</th>
						<th scope="col">시작일</th>
						<th scope="col">종료일</th>
						<th scope="col">승인여부</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(paramMap.list_unit*(paramMap.page_no-1))-status.index}" />
						<tr code="${item.code}">
							<td><input type="checkbox" name="seq" value="${item.seq}"/></td>
							<td>${num}</td>
							<td>${item.top_banner_type}</td>
							<td>
								<img src="${item.image_url}"  alt="${item.summary}" style="width:auto; height:100%;"/>
								<c:if test="${not empty item.image_name2 }">
									<img src="${item.image_url2}"  alt="${item.summary2}" style="width:auto; height:100%;"/>
								</c:if>
								<c:if test="${not empty item.image_name3 }">
									<img src="${item.image_url3}"  alt="${item.summary3}" style="width:auto; height:100%;"/>
								</c:if>
								<c:if test="${not empty item.image_name4 }">
									<img src="${item.image_url4}"  alt="${item.summary4}" style="width:auto; height:100%;"/>
								</c:if>
							</td>
							<td><a href="/main/banner/view.do?seq=<c:out value="${item.seq}"/>&amp;menu_type=<c:out value="${paramMap.menu_type}" />"><c:out value="${item.title}" /></a></td>
							<td>${item.start_date}</td>
							<td>${item.end_date}</td>
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
		<span class="btn dark fr"><a href="#url">등록</a></span>
	</div>
</body>
</html>