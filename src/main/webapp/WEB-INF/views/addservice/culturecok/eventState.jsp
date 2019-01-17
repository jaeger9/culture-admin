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
		frm.submit();
	}
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" method="post" action="/addservice/culturecok/eventState.do">
		<input type="hidden" name="gubun" value="${paramMap.gubun}"/>
		
		<ul class="tab">
			<li>
				<a href="/addservice/culturecok/eventState.do?gubun=A" <c:if test="${ paramMap.gubun eq 'A' }"> class="focus"</c:if>>
					앱 인증 이벤트 응모현황
				</a>
			</li>
			<li>
				<a href="/addservice/culturecok/eventState.do?gubun=S" <c:if test="${ paramMap.gubun eq 'S' }"> class="focus"</c:if>>
					홍보 인증 이벤트 응모현황
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
							<th scope="row">조회</th>
							<td>
								<input type="text" name="reg_start" value="${paramMap.reg_start }" />
								<span>~</span>
								<input type="text" name="reg_end" value="${paramMap.reg_end }" />
								
								<span class="btn darkS" style="margin-left: 10px;">
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
			<ul class="sortingList">
				<li style="margin-right: 10px;">/ 오늘 참여자 : ${ eventCnt.today_cnt }건</li>
				<li>/ 전체 누적 수 : ${eventCnt.all_cnt }</li>
			</ul>
		</div>
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