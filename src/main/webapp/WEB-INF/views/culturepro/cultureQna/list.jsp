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
		page_count	:	'${count}',
		page_no		:	'${paramMap.page_no }',
		callback	:	function(pageIndex, e) {
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});
	
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
		url = '/culturepro/cultureQna/view.do';
		if(seq)
			url += '?seq=' + seq;
		
		location.href = url;
	}
	
	//등록 & 상세
	$('span.btn.dark.fr').click(function(){
		view();
	});
	
	
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
	<form name="frm" method="get" action="/culturepro/cultureQna/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="sort_type" value="${paramMap.sort_type}"/>
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="문화영상관리 글 검색">
					<caption>문의</caption>
					<colgroup>
						<col style="width:13%" />
						<col style="width:%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">등록일</th>
							<td>
								<input type="text" name="reg_start" class="datepicker" value="${paramMap.reg_start }" />
								<span>~</span>
								<input type="text" name="reg_end" class="datepicker" value="${paramMap.reg_end }" />
							</td>
						</tr>
						<tr>
							<th scope="row">답변여부</th>
							<td>
								<div class="inputBox">
									<label><input type="radio" name="status" id="status" value="" /> 전체</label>
									<label><input type="radio" name="status" id="status" value="Y"<c:if test="${paramMap.status eq 'Y' }"> checked</c:if>/> 답변</label>
									<label><input type="radio" name="status" id="status" value="N"<c:if test="${paramMap.status eq 'N' }"> checked</c:if>/> 미답변</label>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">검색어</th>
							<td>
								<select name="searchGubun" style="width: 100px;">
									<option value="">전체</option>
									<option value="subject">제목</option>
									<option value="content">내용</option>
								</select>
								<input type="text" name="searchKeyword" title="검색어 입력" value="${paramMap.searchKeyword}"/>
								<span class="btn darkS">
									<button name="searchButton" type="button">검색</button>
								</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</fieldset>
	
		<!-- 리스트 -->
		<div class="tableList">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col style="width:3%" />
					<col style="width:5%" />
					<col style="width:*" />
					<col style="width:10%" />
					<col style="width:8%" />
				</colgroup>
				<thead>
				<tr>
					<th scope="col"><input type="checkbox" name="seqAll" id="seqAll" title="리스트 전체 선택" /></th>
					<th scope="col">NO</th>
					<th scope="col">제목</th>
					<th scope="col">등록일</th>
					<th scope="col">답변여부</th>
				</tr>
				</thead>
				<tbody>
					<c:forEach items="${list}" var="item" varStatus="status">
						<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index}" />
						<tr>
							<td><input type="checkbox" class="seq" name="seq" value="${item.seq}"/></td>
							<td>${num}</td>
							<td class="subject">
								<a onclick="fn_detail('${item.seq}')" style="cursor: pointer;"> 
									<c:out value="${item.subject}" escapeXml="false"/>
								</a>
							</td>
							<td><c:out value="${item.reg_dt}"/></td>
							<td>${item.status_nm}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</form>
	<div id="pagination"></div>
	<div class="btnBox">
		<span class="btn dark fr"><a href="#url">등록</a></span>
	</div>
</body>
</html>
