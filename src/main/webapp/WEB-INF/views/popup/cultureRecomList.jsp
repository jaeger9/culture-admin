<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@	taglib prefix="tags" tagdir="/WEB-INF/tags"%>
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
	
	var close_btn = frm.find('.close_btn');
	close_btn.click(function () {
		window.close();
		return false;
	});
	
	//select key
	if('${paramMap.approval}')$("select[name=approval]").val('${paramMap.approval}').attr("selected", "selected");
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
	$('span.btn.dark.fr').click(function(){
		showForm();
	});
	
	showForm = function() { 
		url = '/magazine/recomCulture/update.do?menu_type=' + $('input[name=menu_type]').val();
		location.href = url;
	}
	
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
	
	
	$('.tableList a').click(function () {
		
		var data = $(this).parent().parent().data();
		
		var data = $(this).parent().parent().data();

		if (window.opener && window.opener.callback && window.opener.callback.culturerecom) {
			window.opener.callback.culturerecom( data );
		} else 
			alert('callback function undefined')
		
		window.close();
		return false;
		
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" method="post" action="/popup/list.do" style="padding:20px;">
		<input type="hidden" name="page_no" value="${paramMap.page_no}"/>
		<input type="hidden" name="updateStatus" value=""/>
		<input type="hidden" name="menu_type" value="${paramMap.menu_type}"/>
		<c:if test="${exception eq 'Y'}">
			<ul class="tab">
				<c:forEach items="${VodCateList }" var="VodCateList" varStatus="status">
					<c:if test="${VodCateList.value eq '2' or VodCateList.value eq '3'}">
						<li>
							<a href="/popup/list.do?menu_type=${VodCateList.value}&exception=Y&sub_menu_type=${VodCateList.value}" <c:if test="${ paramMap.sub_menu_type eq VodCateList.value }"> class="focus"</c:if>>
								${VodCateList.name}
							</a>
						</li>
					</c:if>
				</c:forEach>
			</ul>
		</c:if>
		
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
					<colgroup>
						<col style="width:17%" />
						<col />
					</colgroup>
					<tbody>
						<tr>
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
					<!--
					<col style="width:10%" />
					-->
					<col style="width:10%" />
					<col style="width:70%" />
					<col style="width:10%" />
					<!-- 
					<col style="width:10%" />
					 -->
				</colgroup>
				<thead>
				
					<tr>
						<!--
						<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
						-->
						<th scope="col">번호</th>
						<th scope="col">제목</th>
						<th scope="col">작성자</th>
						<!-- 
						<th scope="col">승인여부</th>
						 -->
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(paramMap.list_unit*(paramMap.page_no-1))-status.index}" />
						<tr data-idx="${item.idx }" data-title="${item.title}">
							<td>${num}</td>
							<td>
								<a href="#">${item.title}</a>
							</td>
							<td>${item.user_name}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		<div id="pagination"></div>
		<div class="btnBox">
		<span class="btn dark fr"><a href="#" class="close_btn">닫기</a></span>
		</div>
	</form>
</body>
</html>