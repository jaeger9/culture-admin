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
	
	//checkbox
	new Checkbox('input[name=cul_seqAll]', 'input[name=cul_seq]');
	
	//selectbox
	if('${paramMap.grp}')$("select[name=grp]").val('${paramMap.grp}').attr("selected", "selected");
	if('${paramMap.post_flag}')$("select[name=post_flag]").val('${paramMap.post_flag}').attr("selected", "selected");
	if('${paramMap.approval}')$("select[name=approval]").val('${paramMap.approval}').attr("selected", "selected");
	if('${paramMap.apply_yn}')$("select[name=apply_yn]").val('${paramMap.apply_yn}').attr("selected", "selected");
	
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
  		if($(this).find('input').length == 0 && $(this).find('span').length == 0){
    		$(this).click(function(){
        		view($(this).parent().first().find('input').attr('type' , 'checkbox').val());
    		});
  		}
	});
	
	view = function(cul_seq) { 
		url = '/facility/place/view.do';
		if(cul_seq)
			url += '?cul_seq=' + cul_seq;
		
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
	
	//예약가능
	$('span > a').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '예약가능') {
        		
        	};
    	});
	});
	


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


	//승인 , 미승인
	updateStatus = function () {
		
		if(getCheckBoxCheckCnt() == 0) {
			if($('input[name=updateStatus]').val() == 'N')
				alert('미승인할 코드를 선택하세요');
			if($('input[name=updateStatus]').val() == 'Y')
				alert('승인할 코드를 선택하세요');
			return false;
		}
		
		formSubmit('/facility/place/statusUpdate.do');
	}
	
	//삭제
	deleteSites = function () { 
		
		if(getCheckBoxCheckCnt() == 0) {
			alert('삭제할 코드를 선택하세요');
			return false;
		}
		
		formSubmit('/facility/place/delete.do');
	}
	
	//체크 박스 count 수 
	getCheckBoxCheckCnt = function() { 
		return $('input[name=cul_seq]:checked').length;
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
	<form name="frm" method="get" action="/facility/place/list.do">
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
							<th scope="row">분류</th>
							<td>
								<!-- java 에 박혀 있으나 jsp 박혀 있으나.. -->
								<select name="grp">
				                    <option value="">전체</option>
				                   	<c:forEach items="${grpCodeList}" var="list" varStatus="status">
					                    <option value="${list.value}">${list.name}</option>
						            </c:forEach>
                				</select>
							</td>
							<th scope="row">시설승인여부</th>
							<td>
								<select name="post_flag">
				                    <option value="">전체</option>
				                    <option value="Y">승인</option>
				                    <option value="N">미승인</option>
				                    <option value="W">대기</option>
                				</select>
							</td>
						</tr>
						<tr>
							<th scope="row">대관여부</th>
							<td>
								<select name="apply_yn">
				                    <option value="">전체</option>
				                    <option value="Y">대관 가능</option>
				                    <option value="N">대관 불가</option>
                				</select>
							</td>
							<th scope="row">대관승인여부</th>
							<td>
								<select name="approval">
				                    <option value="">전체</option>
				                    <option value="Y">승인</option>
				                    <option value="N">미승인</option>
				                    <option value="W">대기</option>
                				</select>
							</td>
						</tr>
						<tr>
							<th scope="row">등록일</th>
							<td>
								<input type="text" name="reg_start" style="width:100px;" value="${paramMap.reg_start }" />
								<span>~</span>
								<input type="text" name="reg_end" style="width:100px;" value="${paramMap.reg_end }" />
							</td>
							<th scope="row">제목</th>
							<td>
								<input type="text" name="name" title="검색어 입력" value="${paramMap.name}"/>
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
					<col style="width:8%" />
					<col style="width:7%" />
					<col style="width:20%" />
					<col style="width:10%" />
					
					<col style="width:10%" />
					<col style="width:9%" />
					<col style="width:9%" />
					<col style="width:10%" />
					<col style="width:12%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="cul_seqAll" title="리스트 전체 선택" /></th>
						<th scope="col">번호</th>
						<th scope="col">분류</th>
						<th scope="col">문화시설명</th>
						<th scope="col">지역</th>
						
						<th scope="col">작성자</th>
						<th scope="col">등록일</th>
						<th scope="col">조회수</th>
						<th scope="col">시설승인여부</th>
						<th scope="col">대관승인여부</th> 
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(paramMap.list_unit*(paramMap.page_no-1))-status.index}" />
						<tr>
							<td><input type="checkbox" name="cul_seq" value="${item.cul_seq}"/></td>
							<td>${num}</td>
							<td>
								<c:forEach items="${grpCodeList}" var="list" varStatus="status">
					            	<c:if test="${list.value eq item.cul_grp1}">
					            		${list.name}
					            	</c:if>
						        </c:forEach>
							</td>
							<td><a href="/facility/place/view.do?cul_seq=<c:out value="${item.cul_seq}"/>" /><c:out value="${item.cul_name}" /></a></td>
							<td>${item.cul_place}</td>
							
							<td>${item.cul_user}</td>
							<td>${item.cul_regdate}</td>
							<td>${item.view_cnt}</td>
							<td>${item.post_flag}</td>
							<td>
								<c:if test="${item.apply_yn eq 'Y' }">
									<c:if test="${empty item.apply_url }">
									승인<span class="btn whiteS"><a href="rentalapplylist.do?cul_seq=${item.cul_seq}">예약현황(${item.apply_cnt})</a></span>
									</c:if>
									<c:if test="${not empty item.apply_url }">
									시설자체대관
									</c:if>
								</c:if>
								<c:if test="${item.apply_yn eq 'N' }">
									<c:if test="${item.rental_approval eq 'N' }">
									미승인
									</c:if>
									<c:if test="${item.rental_approval ne 'N' }">
									대관 불가
									</c:if>
								</c:if>
								<c:if test="${item.apply_yn eq 'W' }">
									대기
								</c:if>
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
