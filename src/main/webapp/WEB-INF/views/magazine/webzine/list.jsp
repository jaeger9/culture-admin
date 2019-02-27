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
	new Checkbox('input[name=seqAll]', 'input[name=seq]');
	
	//selectbox
	if('${paramMap.grp}')$("select[name=grp]").val('${paramMap.grp}').attr("selected", "selected");
	if('${paramMap.approval}')$("select[name=approval]").val('${paramMap.approval}').attr("selected", "selected");
	
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
  		if($(this).find('input').length == 0 && $(this).find('span').length == 0){
    		$(this).click(function(){
        		view($(this).parent().first().find('input').attr('type' , 'checkbox').val());
    		});
  		}
	}); 
	
	view = function(seq) { 
		url = '/magazine/webzine/view.do';
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
        	if($(this).html() == '보기') {
        	} if($(this).html() == 'HTML') {
        	};
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
		
		formSubmit('/magazine/webzine/statusUpdate.do');
	}
	
	//삭제
	deleteSites = function () { 
		
		if(getCheckBoxCheckCnt() == 0) {
			alert('삭제할 코드를 선택하세요');
			return false;
		}
		
		//태그를 삭제할때 사용할 seq값을 담는다.
        $("input[name=seq]:checked").each(function(i) {
        	$('<input>').attr('name','boardSeq').attr('type','hidden').val($(this).val()).appendTo('input[name=menuType]:last');
        });
		
		formSubmit('/magazine/webzine/delete.do');
	};
	
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
	<form name="frm" method="get" action="/magazine/webzine/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/> 
		<input type="hidden" name="sort_type" value="${paramMap.sort_type}"/>
		<!-- 태그내 사용될 매뉴타입코드/시퀀스 -->
		<input type="hidden" name="menuType" id="menuType" value="${paramMap.menuType}"/>
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
					<col style="width:%" />
					<col style="width:8%" />
					<col style="width:8%" />
					<col style="width:8%" />
					
					<col style="width:10%" />
					<col style="width:8%" />
					<col style="width:8%" />
					<col style="width:8%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
						<th scope="col">웹진 명</th>
						<th scope="col">조회수</th>
						<th scope="col">유형</th>
						<th scope="col">승인여부</th>
						
						<th scope="col">등록일</th>
						<th scope="col">미리보기</th>
						<th scope="col">다운로드</th>
						<th scope="col">메일발송</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(paramMap.list_unit*(paramMap.page_no-1))-status.index}" />
						<tr>
							<td><input type="checkbox" name="seq" value="${item.seq}"/></td>
							<td><a href="/magazine/webzine/view.do?seq=<c:out value="${item.seq}"/>"><c:out value="${item.title}" /></a></td>
							<td>${item.hit}</td>
							<td>
								<c:if test="${empty item.template_type or item.template_type eq 'D'}">
									기본형
								</c:if>
								<c:if test="${item.template_type eq 'P' }">
									포스트형
								</c:if>
							</td>
							<td>${item.approval_yn}</td>
							
							<td>${item.reg_date}</td>
							<td><span class="btn whiteS"><a href="http://www.culture.go.kr/magazine/webzinePreview.do?seq=${item.seq}" target="_blank" title="새창열림">보기</a></span></td>
							<td><span class="btn whiteS"><a href="/magazine/webzine/html.do?seq=${item.seq}">HTML</a></span></td>
							<td><span class="btn whiteS"><a href="/magazine/webzine/mail.do?seq=${item.seq}">MAIL</a></span></td>
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
