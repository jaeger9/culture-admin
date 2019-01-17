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
			console.log('pageIndex : ' + pageIndex);
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});
	
	//checkbox
	new Checkbox('input[name=seqAll]', 'input[name=seq]');
	
	//selectbox
	if('${paramMap.approval}')$("select[name=approval]").val('${paramMap.approval}').attr("selected", "selected");
	if('${paramMap.search_type}')$("select[name=search_type]").val('${paramMap.search_type}').attr("selected", "selected");
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
		url = '/magazine/portalcolumn/view.do';
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
	
	//승인 , 미승인
	updateStatus = function () {
		
		if(getCheckBoxCheckCnt() == 0) {
			if($('input[name=updateStatus]').val() == 'N')
				alert('미승인할 코드를 선택하세요');
			if($('input[name=updateStatus]').val() == 'Y')
				alert('승인할 코드를 선택하세요');
			return false;
		}
		
		formSubmit('/magazine/portalcolumn/statusUpdate.do');
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
		
		
		formSubmit('/magazine/portalcolumn/delete.do');
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
	
	$('span.btn.whiteS button').each(function(){
		$(this).click(function(){
	
			if($(this).html() == '보기'){
				location.href = '/common/reply/list.do?rUrl=/magazine/portalcolumn/list.do&menu_cd=8&seq=' +  $(this).attr('seq');
				
				return false;
			} else if($(this).html() == '미리보기'){
				window.open('http://www.culture.kr/magazine/columnView.do?seq=' + $(this).attr('seq'));
				
				return false;
			}
		})
	})
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" method="get" action="/magazine/portalcolumn/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/>
		<input type="hidden" name="cont_type" value="C"/> 
		<input type="hidden" name="sort_type" value="${paramMap.sort_type}"/>
		<!-- 태그내 사용될 매뉴타입코드 -->
		<input type="hidden" name="menuType" id="menuType" value="${paramMap.menuType}"/>
		
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">등록일</th>
							<td colspan="3">
								<input type="text" name="reg_start" value="${paramMap.reg_start }" />
								<span>~</span>
								<input type="text" name="reg_end" value="${paramMap.reg_end }" />
							</td>
						</tr>
						<tr>
							<th scope="row">출처</th>
							<td colspan="3">
								<select title="출처 선택" name="search_type">
									<option value="">전체</option>
									<option value="1">문화포털 기자단</option>
									<option value="2">아시아문화중심도시 대학생 기자단</option>
									<option value="3">문화체육관광부 대학생 기자단</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">승인여부</th>
							<td>
								<select title="공연/전시일 선택하세요" name="approval">
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
									<option value="content">내용</option>
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

		
		<div style="margin-top:0px; margin-bottom: 20px;">
			<p style="font-weight: bold; color: red;">※승인, 미승인, 삭제시 운영 데이터에 반영됩니다.</p>
		</div>
			
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
					<col style="width:%" />
					<col style="width:15%" />
					<col style="width:8%" />
					
					<col style="width:8%" />
					<col style="width:5%" />
					<col style="width:12%" />
					<col style="width:10%" />
					<col style="width:12%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
						<th scope="col">번호</th>
						<th scope="col">제목</th>
						<th scope="col">출처</th>
						<th scope="col">작가</th>
						
						<th scope="col">등록일</th>
						<th scope="col">조회수</th>
						<th scope="col">댓글</th>
						<th scope="col">승인여부</th>
						<th scope="col">미리보기</th>
					</tr>
				</thead>
				<tbody>
				
				
					<%-- <c:forEach items="${topList }" var="topList" varStatus="status">
						<tr>
							<td>${item.code}</td>
							<td><input type="checkbox" name="seq" value="${topList.seq}"/></td>
							<td>베스트</td>
							<td>${topList.title}</td>
							<td>${topList.source_name}</td>
							<td>${topList.author_name}</td>
							
							<td>${topList.reg_date}</td>
							<td>${topList.view_cnt}</td>
							<td>
								<input type="hidden" name="menuTD"/><a href="/common/reply/list.do?rUrl=/magazine/portalcolumn/list.do&menu_cd=1&amp;seq=<c:out value="${item.seq }" />&amp;uci=<c:out value="${item.uci }" />" class="btnN"><span class="btn white"><button type="button">보기</button></span></a>(<c:out value="${item.reply_cnt}" />)
							</td>
							<td>${topList.approval}</td>
							<td><a href="http://www.culture.go.kr/culture/themeView.do?admin_ok=ok&seq=${item.seq}" ><span class="btn white"><button type="button">미리보기</button></span></a></td>
						</tr>
					</c:forEach> --%>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index}" />
						<tr>
							<td>
								<input type="checkbox" name="seq" value="${item.seq}"/>
							</td>
							<%-- <td>${item.code}</td> --%>
							<td>${num}</td>
							<td class="subject">
								<a href="/magazine/portalcolumn/view.do?seq=${item.seq}">
									${item.title}
								</a>
							</td>
							<td>${item.source_name}</td>
							<td>${item.author_name}</td>
							
							<td>${item.reg_date}</td>
							<td>${item.view_cnt}</td>
							<td>
								<%-- <input type="hidden" name="menuTD"/><a href="/common/reply/list.do?rUrl=/magazine/portalcolumn/list.do&menu_cd=8&amp;seq=<c:out value="${item.seq }" />&amp;uci=<c:out value="${item.uci }" />" class="btnN"><span class="btn white"><button type="button" onClick="javascript:show('8' , '${item.seq }')">보기</button></span></a>(<c:out value="${item.reply_cnt}" />) --%>
								<input type="hidden" name="menuTD"/><a href="#" class="btnN"><span class="btn whiteS"><button type="button" seq="${item.seq}" >보기</button></span></a>(<c:out value="${item.reply_cnt}" />)
							</td>
							<td>${item.approval}</td>
							<%-- <td><a target="_blank" href="http://www.culture.go.kr/culture/themeView.do?admin_ok=ok&seq=${item.seq}" ><span class="btn white"><button type="button" onClick="javascript:preshow('${item.seq}')">미리보기</button></span></a></td> --%>
							<td><a target="_blank" href="#" ><span class="btn whiteS"><button type="button" seq="${item.seq}" >미리보기</button></span></a></td>
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
