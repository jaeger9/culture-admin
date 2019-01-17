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
	var menuType = frm.find('input[name=menuType]');
	
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
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});
	
	//checkbox
	new Checkbox('input[name=ecim_ecidAll]', 'input[name=ecim_ecid]');
	
	//selectbox
	if('${paramMap.ecgb}')$("select[name=ecgb]").val('${paramMap.ecgb}').attr("selected", "selected");
	
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
		url = '/pattern/db/content/view.do';
		if(ecim_ecid)
			url += '?ecim_ecid=' + ecim_ecid;
		
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
        	} 
    	});
	});
	
	
	//삭제
	deleteSites = function () { 
		
		if(getCheckBoxCheckCnt() == 0) {
			alert('삭제할 코드를 선택하세요');
			return false;
		}
		
		formSubmit('/pattern/db/content/delete.do');
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
	<form name="frm" method="get" action="/pattern/db/content/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/>
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="공연장 검색">
					<caption>공연장 검색</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">검색어</th>
							<td colspan="3">
								<select name="ecgb">
				                    <option value="">전체</option>
									
									<c:forEach items="${codeList }" var="codeList" varStatus="status">
										<option value="${codeList.cded_code}">${codeList.cded_desc}</option>				                    
				                    </c:forEach>
                				</select>
							
								<input type="text" name="ecgbname" title="검색어 입력" value="${paramMap.ecgbname}"/>
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
					<col style="width:5%" />
					<col style="width:10%" />
					<col style="width:%" />
					<col style="width:15%" />
					<col style="width:13%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="ecim_ecidAll" title="리스트 전체 선택" /></th>
						<th scope="col">이미지</th>
						<th scope="col">제목</th>
						<th scope="col">응용컨텐츠구분</th>
						<th scope="col">등록일자</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<tr>
							<td><input type="checkbox" name="ecim_ecid" value="${item.ecim_ecid}"/></td>
							<td><img src="<c:out value="http://www.culture.go.kr/pattern/service_design/images/ex/${item.ecim_file }" />" alt="${item.title}"></td>
							<td><a href="/pattern/db/content/view.do?ecim_ecid=<c:out value="${item.ecim_ecid}"/>" /><c:out value="${item.ecim_name}" /></a></td>
							<td>${item.cded_desc}</td>
							<td>${item.dt}</td>
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
