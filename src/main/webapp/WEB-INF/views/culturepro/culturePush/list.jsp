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
		callback	:	function(pageIndex, e) {
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});

	//검색 selectbox
	if('${paramMap.searchGubun}')$("select[name=searchGubun]").val('${paramMap.searchGubun}').attr("selected", "selected");
	
	//검색
	$('button[name=searchButton]').click(function(){
		$('input[name=page_no]').val('1');
		$('form[name=frm]').submit();
	});
	
	
	search = function() { 
		frm.submit();
	}

	//상세
// 	$('div.tableList table tbody tr td').each(function() {
// 		if(!$(this).find('input').attr('type') && !$(this).find('span').attr('class')){
//     		$(this).click(function(){
//         		view($(this).parent().first().find('input').attr('type' , 'checkbox').val());
//     		});
//   		}
// 	});
	
	view = function(seq) { 
		url = '/culturepro/culturePush/view.do';
		if(seq)
			url += '?seq=' + seq;
		
		location.href = url;
	}
	
	//등록 & 상세
	$('#addBtn').click(function(){
		view();
	});
});
//발송하기
function send_push(seq){
	if(!confirm("지금 발송하시겠습니까?")){
		return;
	}
	
	//바로발송처리 
	$('input[name=seq]').val(seq);
	var frm = $('form[name=frm]');
	frm.attr('action' , '/culturepro/culturePush/send.do');
	frm.submit();	
}
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" method="get" action="/culturepro/culturePush/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="seq" value="0"/>
		<input type="hidden" name="fromUrl" value="list"/>
		
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="PUSH 검색">
					<caption>PUSH 검색</caption>
					<colgroup>
						<col style="width:13%" />
						<col style="width:%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">검색어</th>
							<td>
								<select name="searchGubun" style="width: 100px;">
									<option value="">전체</option>
									<option value="title">제목</option>
									<option value="contents">내용</option>
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
			<table summary="Push 관리 목록">
				<caption>Push 관리</caption>
				<colgroup>
					<col style="width:10%" />
					<col style="width:30%" />
					<col style="width:10%" />
					<col style="width:25%" />
					<col style="width:10%" />
				</colgroup>
				<thead>
				<tr>
					<th scope="col">NO</th>
					<th scope="col">제목</th>
					<th scope="col">등록일</th>
					<th scope="col">발송시각 및 예약시각 </th>
					<th scope="col">발송여부</th>
				</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index}" />
						<tr>
							<td>${num}</td>
							<td class="subject">
								<a href="/culturepro/culturePush/view.do?seq=${item.seq}">
									<c:out value="${item.title}"/>
								</a>
							</td>
							<td>${item.reg_date }</td>
							<td>${item.send_date} <c:if test="${null ne item.send_hour}">${item.send_hour}:${item.send_minute}</c:if></td>
							<td>
							<c:if test="${item.send_yn == 'N'}">
							<span class="btn white"><button type="button" onclick="send_push('${item.seq}')">바로발송</button></span>
							</c:if>
							<c:if test="${item.send_yn != 'N'}">발송완료</c:if></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</form>
	<div id="pagination">
	</div>
	<div class="btnBox">
		<span class="btn dark fr"><a id="addBtn" href="#url">등록</a></span>
	</div>
</body>
</html>
