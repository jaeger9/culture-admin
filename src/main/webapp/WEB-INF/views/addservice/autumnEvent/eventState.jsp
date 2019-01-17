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

	var reg_start	=	frm.find('input[name=reg_start]');
	var reg_end		=	frm.find('input[name=reg_end]');
	new Datepicker(reg_start, reg_end);
	
	//검색
	$('button[name=searchButton]').click(function(){
		$('form[name=frm]').submit();
	});
	
	search = function() {
		$('form[name=frm]').attr('action', 'eventState.do');
		frm.submit();
	}
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" method="post" action="/addservice/autumnEvent/eventState.do">
		<input type="hidden" name="gubun" value="${paramMap.gubun}"/>
		
<!-- 		<ul class="tab"> -->
<!-- 			<li> -->
<%-- 				<a href="/addservice/autumnEvent/eventState.do?event=autumnEvent" <c:if test="${ paramMap.event eq 'autumnEvent' }"> class="focus"</c:if>> --%>
<!-- 					EVENT1 참여현황 -->
<!-- 				</a> -->
<!-- 			</li> -->
<!-- 			<li> -->
<%-- 				<a href="/addservice/autumnEvent/eventState.do?event=autumnEventSNS" <c:if test="${ paramMap.event eq 'autumnEventSNS' }"> class="focus"</c:if>> --%>
<!-- 					EVENT2 참여현황 -->
<!-- 				</a> -->
<!-- 			</li> -->
<!-- 		</ul> -->
	
		<!-- 건수  -->
		<div class="topBehavior">
			<ul class="sortingList">
				<jsp:useBean id="toDay" class="java.util.Date" />
				<c:set var="todayCnt" value="0"/>
				<c:set var="today">
				<fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" />
				</c:set>
				<c:forEach items="${stateList }" var="data" varStatus="status">
					<c:if test ="${data.reg_date eq today}">
						<c:set var="todayCnt">${data.cnt}</c:set>
					</c:if>
				</c:forEach>
				
				<li style="margin-right: 10px;">=> 오늘 참여자 : ${todayCnt}건</li>
				<li>/ 전체 누적 수 : ${total.all_cnt}</li>
			</ul>
		</div>
		
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
					<colgroup>
						<col style="width:20%" />
						<col />
					<tbody>
						<tr>
							<th scope="row">이벤트명</th>
							<td>
								<select name="event_name" items="${list }" onChange="frm.submit();">
									<option value="cultureCockEvent2018"		<c:if test="${paramMap.event_name eq 'cultureCockEvent2018' }"		>selected</c:if>	>[2018]문화콕이벤트</option>
									<option value="autumnEvent"					<c:if test="${paramMap.event_name eq 'autumnEvent' }"					>selected</c:if>	>[2018]가을이벤트1</option>
									<option value="autumnEventSNS" 				<c:if test="${paramMap.event_name eq 'autumnEventSNS' }"				>selected</c:if>	>[2018]가을이벤트2</option>
									<option value="chuseokEvent"					<c:if test="${paramMap.event_name eq 'chuseokEvent' }"					>selected</c:if>	>[2018]추석이벤트1</option>
									<option value="chuseokEventSNS"				<c:if test="${paramMap.event_name eq 'chuseokEventSNS' }"				>selected</c:if>	>[2018]추석이벤트2</option>
									<option value="incomeDeductionEvent" 		<c:if test="${paramMap.event_name eq 'incomeDeductionEvent' }"		>selected</c:if>	>[2018]소득공제이벤트1</option>
									<option value="incomeDeductionEventSNS"	<c:if test="${paramMap.event_name eq 'incomeDeductionEventSNS' }"	>selected</c:if>	>[2018]소득공제이벤트2</option>
									<option value=""										<c:if test="${paramMap.event_name eq '' }"										>selected</c:if>	>전체</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">등록일</th>
							<td>
								<input type="text" name="reg_start" value="${paramMap.reg_start }" />
								<span>~</span>
								<input type="text" name="reg_end" value="${paramMap.reg_end }" />
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
					<col />
					<col />
					<col />
				</colgroup>
				<thead>	
					<tr>
						<th scope="col">번호</th>
						<th scope="col">일자</th>
						<th scope="col">건수</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty stateList }">
						<tr>
							<td colspan="3">검색된 결과가 없습니다.</td>
						</tr>
					</c:if>
					<c:forEach items="${stateList }" var="item" varStatus="status">
						<tr>
							<td><fmt:formatNumber value="${fn:length(stateList) - status.index}" pattern="###,###" /></td>
							<td>${item.reg_date }</td>
							<td>${item.cnt}</td>
						</tr>
					</c:forEach>
					
						<tr style="background-color:#F0F0F0;">
							<td>총계</td>
							<td>${total.day_cnt }</td>
							<td>${total.all_cnt}</td>
						</tr>					
				</tbody>
			</table>
		</div>
	</form>
</body>
</html>