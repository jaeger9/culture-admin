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
	if('${paramMap.approval_yn}')$("select[name=approval_yn]").val('${paramMap.approval_yn}').attr("selected", "selected");
	if('${paramMap.source}')$("select[name=source]").val('${paramMap.source}').attr("selected", "selected");
	if('${paramMap.searchGubun}')$("select[name=searchGubun]").val('${paramMap.searchGubun}').attr("selected", "selected");
	
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
	/**
	$('div.tableList table tbody tr td').each(function() {
  		if(!$(this).find('input').attr('type')){
    		$(this).click(function(){
    			view($(this).parent().first().find('input').attr('type' , 'checkbox').val());
    		});
  		}
	});
	**/
	view = function(seq) { 
		url = '/main/banner/view.do?menu_type=' + $('input[name=menu_type]').val();
		if(seq)
			url += '&seq=' + seq;
		
		location.href = url;
	}
	
	//등록
	/**
	$('span.btn.dark.fr').click(function(){
		showForm();
	});
	
	showForm = function() { 
		url = '/magazine/recomCulture/update.do?menu_type=' + $('input[name=menu_type]').val();
		location.href = url;
	}
	**/
	
	
	
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
        	else if($(this).html() == '추천 영상등록') { 
    			
        		if (!confirm('추천 영상등록 하시겠습니까?')) {
        			return false;
        		}
        		url = '/magazine/recomCulture/update.do?menu_type=' + $('input[name=menu_type]').val();
        		location.href = url;
        		
        		
        	}else if($(this).html() == 'Live 영상등록') {
        		
        		if (!confirm('Live 영상등록 하시겠습니까?')) {
        			return false;
        		}
        		url = '/magazine/recomCulture/update.do?menu_type=' + $('input[name=menu_type]').val()+'&live_type=Y';
        		location.href = url;
        		
        	}
    	});
	});
	
	//삭제
	deleteBanner = function() { 
		if(getCheckBoxCheckCnt() == 0) {
			alert('삭제할 대상을 선택하세요');
			return false;
		}
		
		formSubmit('/magazine/recomCulture/delete.do');
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
		
		formSubmit('/magazine/recomCulture/approval.do');
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
	<form name="frm" method="post" action="/magazine/recomCulture/recomList.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no}"/>
		<input type="hidden" name="updateStatus" value=""/>
		<input type="hidden" name="menu_type" value="${paramMap.menu_type}"/>
		
		<ul class="tab">
			<c:forEach items="${VodCateList }" var="VodCateList" varStatus="status">
				<li>
					<a href="/magazine/recomCulture/recomList.do?menu_type=${VodCateList.value}" <c:if test="${ paramMap.menu_type eq VodCateList.value }"> class="focus"</c:if>>
						${VodCateList.name}
					</a>
				</li>
			</c:forEach>
		</ul>
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div style ="width:100%;/*margin-bottom:40px;*/border-top:2px solid #222">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
					<colgroup><col style="width:15%" /><col style="width:20%" /><col style="width:15%" /><col style="width:50%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">승인여부</th>
							<td>
								<select title="승인여부 선택" name="approval_yn">
									<option value="">전체</option>
									<option value="N">미승인</option>
									<option value="Y">승인</option>
									<option value="W">대기</option>
								</select>
							</td>
							<th scope="row">검색어</th>
							<td>
								<select name="searchGubun">
									<option value="">전체</option>
									<option value="title">제목</option>
									<option value="name">작성자</option>
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
		</div>
		<!-- 리스트 -->
		<div class="tableList">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<c:choose>
						<c:when test="${paramMap.menu_type ne 1}">
							<col style="width:5%" />
							<col style="width:5%" />
							<col style="width:25%" />
							<col style="width:40%" />
							<col style="width:10%" />
							<col style="width:10%" />
							<col style="width:5%" />
						</c:when>
						<c:otherwise>
							<col style="width:5%" />
							<col style="width:5%" />
							<col style="width:60%" />
							<col style="width:15%" />
							<col style="width:10%" />
							<col style="width:5%" />
						</c:otherwise>
					</c:choose>
				</colgroup>
				<thead>
				
					<tr>
						<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
						<th scope="col">번호</th>
						<c:if test="${paramMap.menu_type ne 1}">
						<th scope="col">영상제목</th>
						</c:if>
						<th scope="col">추천제목</th>
						<th scope="col">등록일</th>
						<th scope="col">작성자</th>
						<th scope="col">승인여부</th>
						
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(paramMap.list_unit*(paramMap.page_no-1))-status.index}" />
						<tr code="${item.code}">
							
							<td><input type="checkbox" name="seq" value="${item.idx}"/></td>
							<td>${num}</td>
							<c:if test="${paramMap.menu_type ne 1}">
							<td style ="text-align:left">${item.title}</td>
							</c:if>
							<td style ="text-align:left">
							<c:if test="${item.recom_live_yn eq 'Y'}">
								<a href="/magazine/recomCulture/update.do?idx=${item.idx}&menu_type=${item.menu_type}&live_type=Y">${item.theme_title}&nbsp;[Live]</a>
							</c:if>
							<c:if test="${item.recom_live_yn ne 'Y'}">
								<a href="/magazine/recomCulture/update.do?idx=${item.idx}&menu_type=${item.menu_type}">${item.theme_title}</a>
							</c:if>
							</td>
							<td>${item.write_dat}</td>
							<td>${item.user_name}</td>
							<td>
							<c:if test="${item.approval_yn eq 'W'}">
							대기
							</c:if>
							<c:if test="${item.approval_yn eq 'Y'}">
							승인
							</c:if>
							<c:if test="${item.approval_yn eq 'N'}">
							미승인
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
		
		<c:if test="${paramMap.menu_type eq '4'}">
			<span class="btn dark fr"><button type="button">Live 영상등록</button></span>
			<span class="btn dark fr"><button type="button">추천 영상등록</button></span>
		</c:if>
		<c:if test="${paramMap.menu_type ne '4'}">
			<span class="btn dark fr"><button type="button">추천 영상등록</button></a></span>
		</c:if>
		
	</div>
</body>
</html>