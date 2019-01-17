<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {
	//checkbox
	new Checkbox('input[name=seqAll]', 'input[name=chkSeq]');
	//paging
	var p = new Pagination({
		view		:	'#pagination',
		page_count	:	'${count }',
		page_no		:	'${paramMap.page_no }',
		/* link		:	'/main/code/list.do?page_no=__id__', */
		callback	:	function(pageIndex, e) {
			console.log('pageIndex : ' + pageIndex);
			$('input[name=page_no]').val(pageIndex + 1);
			$('#frm').submit();
			return false;
		}
	});
});

//등록/수정 창 이동
function onInsert(){
	$('form[name=frm]').attr('action' , "/resource/page/form.do");
	$('form[name=frm]').submit();
}

//검색
function onSubmit(){
	$('form[name=frm]').attr('action' , "/resource/page/list.do");
	$('form[name=frm]').submit();
}

function onDelete(){
	if (!confirm('삭제 하시겠습니까?')) {
		return false;
	}
	
	if( $('input[name=chkSeq]:checked').length < 1 ){
		alert("삭제할 코드를 선택하세요 ");
		return;
	}
	$('form[name=frm]').attr('action' , "/resource/page/delete.do");
	$('form[name=frm]').submit();
	return;
}

function updateStatus(approval){
	var tmpStr = "승인";
	if( approval == "N" ){
		tmpStr = "미승인";
	}
	
	if (!confirm(tmpStr+' 처리 하시겠습니까?')) {
		return false;
	}

	if( $('input[name=chkSeq]:checked').length < 1 ){
			alert(tmpStr+'할 코드를 선택하세요');
		return;
	}
	
	$('#updateStatus').val(approval);

	$('form[name=frm]').attr('action' , "/resource/page/statusUpdate.do");
	$('form[name=frm]').submit();
	return;
}

function goMenu(seq, page_type){
	if( page_type == 'A' ){
		alert("해당 페이지 타입(A타입)은 메뉴구성이 존재하지 않는 페이지입니다.");
		return;
	}

	location.href = "/resource/menu/list.do?pseq="+seq;
}

function goView(seq){
	$('#seq').val(seq);
	$('form[name=frm]').attr('action' , "/resource/page/form.do");
	$('form[name=frm]').submit();
}

function goBoardList(url){
	location.href = url;
}
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" method="post" action="/resource/page/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" id="updateStatus"/>
		<input type="hidden" name="seq" id="seq"/>
		
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
					<colgroup>
						<col style="width:13%" />
						<col style="width:37%" />
						<col style="width:13%" />
						<col style="width:37%" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">승인여부</th>
							<td>
								<select title="승인여부 선택" name="srch_approval">
									<option value="" ${empty paramMap.srch_approval ? 'selected="selected"':'' }>전체</option>
									<option value="N" ${paramMap.srch_approval eq 'N' ? 'selected="selected"':'' }>미승인</option>
									<option value="Y" ${paramMap.srch_approval eq 'Y' ? 'selected="selected"':'' }>승인</option>
									<option value="W" ${paramMap.srch_approval eq 'W' ? 'selected="selected"':'' }>대기</option>
								</select>
							</td>
							<th scope="row">검색어</th>
							<td>
								<select title="검색어 선택" name="search_type">
									<option value="all" ${paramMap.search_type eq 'all' ? 'selected="selected"':'' }>전체</option>
									<option value="title" ${paramMap.search_type eq 'title' ? 'selected="selected"':'' }>제목</option>
									<option value="writer" ${paramMap.search_type eq 'writer' ? 'selected="selected"':'' }>작성자</option>
								</select>
								<input type="text" name="search_keyword" value="${paramMap.search_keyword}"/>
								<span class="btn darkS">
									<button name="searchButton" type="button" onclick="javascript:onSubmit();return;">검색</button>
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
					<col style="width:5%" />
					<col style="width:%" />
					<col style="width:8%" />
					<col style="width:8%" />
					<col style="width:8%" />
					
					<col style="width:12%" />
					<col style="width:12%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택"/></th>
						<th scope="col">번호</th>
						<th scope="col">문화정보자원명</th>
						<th scope="col">등록일</th>
						<th scope="col">등록자</th>
						<th scope="col">승인<br/>여부</th>
						
						<th scope="col">메뉴관리</th>
						<th scope="col">게시판</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${not empty list }">
						<c:forEach items="${list }" var="item" varStatus="status">
							<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index}" />
							<tr>
								<td><input type="checkbox" name="chkSeq" value="${item.seq}"/></td>
								<td>${num}</td>
								<td class="subject">
									<a href="#" onclick="javascript:goView('${item.seq }');return;">
										${item.title}
									</a>
								</td>
								<td>${item.reg_date}</td>
								<td>${item.name}</td>
								
								<td>${item.approval eq 'Y' ? '승인': item.approval eq 'W' ? '대기':'미승인' }</td>
								<td><span class="btn whiteS"><button type="button" onclick="javascript:goMenu('${item.seq}','${item.page_type}')">메뉴관리</button></span></td>
								<td><span class="btn whiteS"><button type="button" onclick="javascript:goBoardList('/resource/board/list.do?page_seq=${item.seq}');return;">게시판관리</button></span></td>
							</tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
		</div>
	</form>
	<div id="pagination">
	</div>
	<div class="btnBox">
		<span class="btn white"><button type="button" onclick="javascript:updateStatus('Y');return;">승인</button></span>
		<span class="btn white"><button type="button" onclick="javascript:updateStatus('N');return;">미승인</button></span>
		<span class="btn white"><button type="button" onclick="javascript:onDelete();return;">삭제</button></span>
		<span class="btn dark fr"><a href="#url" onclick="javascript:onInsert();return;">등록</a></span>
	</div>
</body>
</html>
