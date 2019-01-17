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
	
	//checkbox
	new Checkbox('input[name=seqAll]', 'input[name=seq]');

	// radio check
	if ('${paramMap.approval_yn}') {
		$('input:radio[name="approval_yn"][value="${paramMap.approval_yn}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="approval_yn"][value=""]').prop('checked', 'checked');
	}
	
	if ('${paramMap.mapping_yn}') {
		$('input:radio[name="mapping_yn"][value="${paramMap.mapping_yn}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="mapping_yn"][value=""]').prop('checked', 'checked');
	}
	
	//selectbox
	if('${paramMap.searchGubun}')$("select[name=searchGubun]").val('${paramMap.searchGubun}').attr("selected", "selected");
	
	//검색
	$('button[name=searchButton]').click(function(){
		$('input[name=page_no]').val('1');
		$('form[name=frm]').submit();
	});

	//연결설정
	$('button[name=setupButton]').click(function(){
		var p =	$(this).parents('tr:eq(0)');
		var ele = p.find("input[name='seq']");		
		var url = "/culturepro/manage/form.do?g_seq=" + ele.val();
		
		location.href = url;
	});
	
	search = function() { 
		frm.submit();
	}

	//상세
	$('div.tableList table tbody tr td').each(function() {
		if(!$(this).find('input').attr('type') && !$(this).find('span').attr('class')){
    		$(this).click(function(){
        		view($(this).parent().first().find('input').attr('type' , 'checkbox').val());
    		});
  		}
	});
	
	view = function(seq) { 
		url = '/culturepro/manage/view.do';
		if(seq)
			url += '?seq=' + seq;
		
		location.href = url;
	}
	
	//승인 , 미승인 , 삭제 이벤트 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '승인') {
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
        	} else if($(this).html() == '정보 업데이트') {
        		if (!confirm('정보를 업데이트하시겠습니까?')) {
        			return false;
        		}
        		formSubmit('/culturepro/manage/syncMapping2.do');
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
		
		formSubmit('/culturepro/manage/statusUpdate.do');
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
	<form name="frm" method="get" action="/culturepro/manage/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/> 
		<input type="hidden" name="targetView" value="N"/>
		
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
					<colgroup>
						<col style="width:13%" />
						<col style="width:%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">승인여부</th>
							<td>
								<div class="inputBox">
									<label><input type="radio" name="approval_yn" value=""/> 전체</label>
									<label><input type="radio" name="approval_yn" value="W"/> 대기</label>
									<label><input type="radio" name="approval_yn" value="Y"/> 승인</label>
									<label><input type="radio" name="approval_yn" value="N"/> 미승인</label>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">매핑여부</th>
							<td>
								<div class="inputBox">
									<label><input type="radio" name="mapping_yn" value=""/> 전체</label>
									<label><input type="radio" name="mapping_yn" value="Y"/> 매핑</label>
									<label><input type="radio" name="mapping_yn" value="N"/> 미매핑</label>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">검색어</th>
							<td>
								<select name="searchGubun">
									<option value="">전체</option>
									<option value="title">대표시설명</option>
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
					<col style="width:3%" />
					<col style="width:10%" />
					<col style="width:%" />
					<col style="width:13%" />
					<col style="width:10%" />
				</colgroup>
				<thead>
				<tr>
					<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
					<th scope="col">고유번호</th>
					<th scope="col">대표시설명</th>
					
					<th scope="col">연결설정</th>
					<th scope="col">승인여부</th>
				</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<tr>
							<td><input type="checkbox" name="seq" value="${item.seq}"/></td>
							<td>${item.seq}</td>
							<td class="subject">
								<a href="/culturepro/manage/view.do?g_seq=${item.seq}">
									<c:out value="${item.facility_name}"/>
								</a>
							</td>
							<td><span class="btn white"><button name="setupButton" type="button">연결설정</button></span></td>
							<td>${item.approval_nm}</td>
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
		<span class="btn dark fr"><button type="button">정보 업데이트</button></span>
	</div>
</body>
</html>
