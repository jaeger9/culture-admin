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
		var event_seq = frm.find('[name=event_seq]');
		
		// 추첨하기, 닫기 
		$('div.btnBox > span > button').each(function() {
			$(this).click(function() {
				if ($(this).html() == '추첨하기') {
					if(event_seq.val() == null || event_seq.val() == '') {
						alert('추첨할 이벤트를 선택해 주세요.');
						event_seq.focus();
						return false;
					}
					$('[name=frm]').attr('action', 'winnerRandomLot.do').submit();
				} else if ($(this).html() == '닫기') {
					self.close();
					return false;
				}
			});
		});
		
		$('[name=event_seq]').on({
			'change': function() {
				frm.submit();
			}
		})
		
	});
</script>
</head>
<body>

<form name="frm" method="get" action="winnerList.do" style="padding:20px;">
<fieldset class="searchBox">
	<legend>검색</legend>
	
	<input type="hidden" name="page_no" value="${paramMap.page_no }" />
	
	<div class="tableWrite">
		<table summary="게시판 글 검색">
			<caption>검색</caption>
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">검색</th>
					<td>
						<select name="event_seq" name="이벤트 선택">
							<option value="">이벤트 선택</option>
							<c:forEach var="item" items="${eventList }">
								<option value="${item.seq }" <c:if test="${item.seq eq paramMap.event_seq }">selected="selected"</c:if>>${item.title }</option>
							</c:forEach>
						</select>
					</td>
				</tr> 
			</tbody>
		</table>
	</div>
</fieldset>

<div class="topBehavior">
	<p class="totalCnt">총 <span><fmt:formatNumber value="${fn:length(winnerList) }" pattern="###,###" /></span>건</p>
</div>

<!-- table list -->
<div class="tableList">
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:10%" />
			<col style="width:20%" />
			<col style="width:16%" />
			<col style="width:%" />
			<col style="width:20%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">번호</th>
				<th scope="col">이벤트명</th>
				<th scope="col">이름</th>
				<th scope="col">이메일</th>
				<th scope="col">휴대폰번호</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty winnerList }">
				<tr>
					<td colspan="5">당첨자 정보가 없습니다. 추첨 버튼을 이용해 당첨자를 추첨해 주세요.</td>
				</tr>
			</c:if>
			<c:forEach var="data" items="${winnerList }" varStatus="status">
				<tr>
					<td>${status.count }</td>
					<td><c:out value="${data.event_nm }"/></td>
					<td><c:out value="${data.user_nm }"/></td>
					<td><c:out value="${data.user_email }"/></td>
					<td><c:out value="${data.hp_no }"/></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<%--<div id="pagination"></div> --%>

<div class="btnBox">
	<span class="btn white"><button type="button">추첨하기</button></span>
	<span class="btn dark fr"><button type="button">닫기</button></span>
</div>
</form>

</body>
</html>