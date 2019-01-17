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
	var search_btn = frm.find('button[name=search_btn]');
	var search_word = frm.find('input[name=name]');
	
	var close_btn = frm.find('.close_btn');
	
	var search = function () {
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
	
	close_btn.click(function () {
		window.close();
		return false;
	});

	$('.tableList a').click(function () {
		var data = $(this).parent().parent().data();

		if (window.opener && window.opener.callback && window.opener.callback.postalcode) {
			window.opener.callback.postalcode( data );
		} else {
			alert('callback function undefined');
		}

		window.close();
		return false;
	});
});
</script>
</head>
<body>

<form name="frm" method="get" action="/popup/postalcode.do" style="padding:20px;">
<input type="hidden" name="zip_yn" value="${paramMap.zip_yn}"/>
<fieldset class="searchBox">
	<legend>검색</legend>
	
	<input type="hidden" name="page_no" value="${paramMap.page_no }" />
	
	<div class="tableWrite">
		<table summary="우편번호 검색">
			<caption>우편번호 검색</caption>
			<colgroup>
				<col style="width:20%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<c:if test="${paramMap.zip_yn eq 63}">
						<th scope="row">동/읍/면</th>
						<td>
							<input type="text" name="dong" value="${paramMap.dong }" />
							<span class="btn darkS">
								<button type="button" name="search_btn">검색</button>
							</span>
						</td>
					</c:if>
					<c:if test="${paramMap.zip_yn eq 64}">
						<th scope="row">도로명</th>
						<td>
							<input type="text" name="road" value="${paramMap.road }" />
							<span class="btn darkS">
								<button type="button" name="search_btn">검색</button>
							</span>
						</td>
					</c:if>
				</tr> 
			</tbody>
		</table>
	</div>
</fieldset>

<div class="topBehavior">
	<p class="totalCnt">총 <span><fmt:formatNumber value="${empty count ? 0 : count }" pattern="###,###" /></span>건</p>
</div>

<!-- table list -->
<div class="tableList">
	<input type="hidden" name="searchYN" value=""/>
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<c:if test="${paramMap.zip_yn eq 63}">
				<col style="width:30%" />
				<col style="width:70%" />
			</c:if>
			<c:if test="${paramMap.zip_yn eq 64}">
				<col style="width:50%" />
				<col style="width:50%" />
			</c:if>
		</colgroup>
		<thead>
			<tr>
				<c:if test="${paramMap.zip_yn eq 63}">
					<th scope="col">우편번호</th>
					<th scope="col">주소</th>
				</c:if>
				<c:if test="${paramMap.zip_yn eq 64}">
					<th scope="col">구주소</th>
					<th scope="col">신주소</th>
				</c:if>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty postalCodeList }">
				<tr>
					<td colspan=2>검색된 결과가 없습니다.</td>
				</tr>
			</c:if>
			<c:if test="${not empty postalCodeList }">
				<c:forEach items="${postalCodeList }" var="list" varStatus="status">
					<tr 
						data-sido_name="${list.sido_name}"
						data-gu_name="${list.gu_name}"
						data-dong_name1="${list.dong_name1}"
						data-gi_num1="${list.gi_num1}"
						data-gi_num2="${list.gi_num2}"
						data-zip_code="${list.zip_code}"
						data-road_name="${list.road_name}"
						data-buil_num1="${list.buil_num1}"
						data-buil_num2="${list.buil_num2}"
						data-location="${list.location}"					
					>
						<c:if test="${paramMap.zip_yn eq 63}">
							<td>
								<a href="#">
									<c:out value="${fn:substring(list.zip_code, 0, 3)}"/> - <c:out value="${fn:substring(list.zip_code, 3 , 6)}"/>   
								</a>
							</td>
							<td>
								<a href="#">
									<c:out value="${list.sido_name }" />
									<c:out value="${list.gu_name }" /> 
									<c:out value="${list.dong_name1 }" />
									<c:out value="${list.gi_num1 }" />
								</a>
							</td>
						</c:if>
						<c:if test="${paramMap.zip_yn eq 64}">
							<td>
								<a href="#">
									<c:out value="${list.sido_name }" />
									<c:out value="${list.gu_name }" />
									<c:out value="${list.dong_name1 }" />
									<c:choose>
										<c:when test="${not empty list.gi_num1 && not empty list.gi_num2 }">
											<c:out value="${list.gi_num1 }" />-<c:out value="${list.gi_num2 }" />
										</c:when>
										<c:otherwise>
											<c:out value="${list.gi_num1 }" />
										</c:otherwise>
									</c:choose>	
								</a>
							</td>
							<td>
								<a href="#" >
									<c:out value="${list.sido_name }" />
									<c:out value="${list.gu_name }" />
									<c:out value="${list.road_name }" />
									<c:out value="${list.buil_num1 }" />
									<%//지번 %>
									<c:if test="${not empty list.buil_num2 }">
										-<c:out value="${list.buil_num2 }" />
									</c:if>							
									<c:choose>
										<c:when test="${not empty list.dong_name1 && not empty list.buil_name }">
											(<c:out value="${list.dong_name1 }" /> ,<c:out value="${list.buil_name }" />)
										</c:when>
										<c:otherwise>
											(<c:out value="${list.dong_name1 }" />)
										</c:otherwise>
									</c:choose>	
								</a>
							</td>
						</c:if>
					</tr>
				</c:forEach>
			</c:if>
		</tbody>
	</table>
</div>

<div id="pagination"></div>

<div class="btnBox">
	<span class="btn dark fr"><a href="#" class="close_btn">닫기</a></span>
</div>
</form>

</body>
</html>