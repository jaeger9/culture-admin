<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {
	
	var frm				=	$('form[name=frm]');
	var page_no			=	frm.find('input[name=page_no]');
	var search_word		=	frm.find('input[name=search_word]');
	var search_btn		=	frm.find('button[name=search_btn]');
	
	var search = function () {
		$('form[name=frm]').attr('action', 'eventEntry.do');
		frm.submit();
	};
	
	new Pagination({
		view		:	'#pagination',
		page_count	:	'${count }',
		page_no		:	'${paramMap.page_no }',
		callback	:	function(pageIndex, e) {
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});

	search_word.keypress(function(event) {
		if (event.which == 13) {
			event.preventDefault();
			page_no.val(1);
			search();
		}
	});

	search_btn.click(function () {
		page_no.val(1);
		search();
		return false;
	});
	
});

function showImage(img){
	var imgTmp = new Image(); 
	imgTmp.src = "/upload/culturecok/" + img;
	
    window.open("/addservice/culturecok/imgPopup.do?img="+img,"gImgWin","width=500,height=500,status=no,toolbar=no,scrollbars=yes,resizable=no"); 
}

function excelDownload(){
	$('form[name=frm]').attr('action', 'eventEntryExcelDownload.do');
	$('form[name=frm]').submit();
}

function winnerPopup() {
	window.open('/addservice/culturecok/winnerPopup.do?gubun=${paramMap.gubun}', 'winnerPopup', 'scrollbars=yes,width=800,height=950');
}
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" method="post" action="/addservice/culturecok/eventEntry.do">
		<input type="hidden" name="gubun" value="${paramMap.gubun}"/>
		<input type="hidden" name="page_no" value="${paramMap.page_no }" />
		
		<ul class="tab">
			<li>
				<a href="/addservice/culturecok/eventEntry.do?gubun=A" <c:if test="${ paramMap.gubun eq 'A' }"> class="focus"</c:if>>
					앱 인증 이벤트 응모현황
				</a>
			</li>
			<li>
				<a href="/addservice/culturecok/eventEntry.do?gubun=S" <c:if test="${ paramMap.gubun eq 'S' }"> class="focus"</c:if>>
					홍보 인증 이벤트 응모현황
				</a>
			</li>
			<li>
				<a href="/addservice/culturecok/eventEntry.do?gubun=T" <c:if test="${ paramMap.gubun eq 'T' }"> class="focus"</c:if>>
					스탬프 적립 이벤트
				</a>
			</li>
		</ul>
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
					<colgroup>
						<col style="width:10%" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">검색</th>
							<td>
								<select name="search_type">
									<option value="all">전체</option>
									<option value="name"		${paramMap.search_type eq 'name'	? 'selected="selected"' : '' }>이름</option>
									<option value="hp_no"		${paramMap.search_type eq 'hp_no'	? 'selected="selected"' : '' }>전화번호</option>
								</select>
		
								<input type="text" name="search_word" value="${paramMap.search_word }" style="width:470px;" />
		
								<span class="btn darkS">
									<button type="button" name="search_btn">검색</button>
								</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</fieldset>
	
		<!-- 건수  -->
		<div class="topBehavior">
			<p class="totalCnt">총 <span><fmt:formatNumber value="${count }" pattern="###,###" /></span>건</p>
		</div>
		<!-- 리스트 -->
		<div class="tableList">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col style="width:5%" />
					<col style="width:12%" />
					<col />
					<col style="width:12%"/>
					<col style="width:15%" />
					<col style="width:20%" />
					<c:if test="${ paramMap.gubun ne 'T' }">
					<col style="width:10%" />
					</c:if>
				</colgroup>
				<thead>	
					<tr>
						<th scope="col">번호</th>
						<th scope="col">응모일</th>
						
						<c:if test="${ paramMap.gubun ne 'T'}">
						<th scope="col">한줄내용</th>
						</c:if>
						<c:if test="${ paramMap.gubun eq 'T'}">
						<th scope="col">아이디</th>
						</c:if>
						
						<th scope="col">이름</th>
						<th scope="col">연락처</th>
						<th scope="col">이메일</th>
						<c:if test="${ paramMap.gubun eq 'A' }">
						<th scope="col">이미지보기</th>
						</c:if>		
						<c:if test="${ paramMap.gubun eq 'S' }">
						<th scope="col">공유 URL</th>
						</c:if>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty list }">
						<tr>
							<td colspan="7">검색된 결과가 없습니다.</td>
						</tr>
					</c:if>
					<c:forEach items="${list }" var="item" varStatus="status">
						<tr>
							<td><fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" /></td>
							<td>${item.reg_date }</td>
							
							<c:if test="${ paramMap.gubun ne 'T'}">
							<td style="text-overflow: ellipsis;  white-space: nowrap; overflow: hidden;">${item.memo}</td>
							</c:if>
							<c:if test="${ paramMap.gubun eq 'T'}">
							<td style="text-overflow: ellipsis;  white-space: nowrap; overflow: hidden;">${item.file_name}</td>
							</c:if>
							
							
							<td>${item.name}</td>
							<td>${item.hp_no}</td>
							<td>${item.email}</td>
							
							<c:if test="${ paramMap.gubun eq 'A' }">
							<td><button type="button" onclick="showImage('${item.file_sysname}');">첨부이미지</button></td>
							</c:if>		
							<c:if test="${ paramMap.gubun eq 'S' }">
							<td><a href="${item.url }" target="_blank">${item.url }</a></td>
							</c:if>						
						</tr>
					</c:forEach>			
				</tbody>
			</table>
		</div>
		
		<div id="pagination"></div>

		<div class="btnBox">
			<span class="btn dark fr" style="margin-right:4px;"><a href="#url" onclick="winnerPopup();return false;">당첨자 추첨</a></span>
			<span class="btn dark fr" style="margin-right:4px;"><a href="#" onclick="excelDownload();">전체다운로드(리스트)</a></span>
		</div>
		
	</form>
</body>
</html>