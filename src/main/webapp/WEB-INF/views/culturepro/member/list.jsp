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
			console.log('pageIndex : ' + pageIndex);
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});
	

	// 성별 radio check
	if ('${paramMap.gender}') {
		$('input:radio[name="gender"][value="${paramMap.gender}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="gender"][value=""]').prop('checked', 'checked');
	}
	

	// Id type radio check
	if ('${paramMap.social_incoming}') {
		$('input:radio[name="social_incoming"][value="${paramMap.social_incoming}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="social_incoming"][value=""]').prop('checked', 'checked');
	}

	// email check
	if ('${paramMap.email}') {
		$('input:text[name="email"]').val("${paramMap.email}");
	}
	
	// name check
	if ('${paramMap.name}') {
		$('input:text[name="name"]').val("${paramMap.name}");
	}
	
	//검색
	$('button[name=searchButton]').click(function(){
		$('input[name=page_no]').val('1');
		$('form[name=frm]').submit();
	});
	
	search = function() { 
		frm.submit();
	}

	//엑셀 다운로드
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '엑셀 다운로드') {
        		excel_download();
        	}
    	});
	});
	
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
	<form name="frm" method="get" action="/culturepro/cultureMember/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="앱회원관리 검색">
					<caption>앱회원관리</caption>
					<colgroup>
						<col style="width:13%" />
						<col style="width:%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">성별</th>
							<td>
								<div class="inputBox">
									<label><input type="radio" name="gender" value=""/> 전체</label>
									<label><input type="radio" name="gender" value="M"/> 남</label>
									<label><input type="radio" name="gender" value="F"/> 여</label>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">ID타입 </th>
							<td>
								<div class="inputBox">
									<label><input type="radio" name="social_incoming" value=""/> 전체</label>
									<!-- <label><input type="radio" name="social_incoming" value="F"/>페이스북</label> -->
									<label><input type="radio" name="social_incoming" value="NAVER"/>네이버</label>
									<label><input type="radio" name="social_incoming" value="KAKAO"/>카카오</label>
									<label><input type="radio" name="social_incoming" value="CULTURE_POTAL"/>문화포털</label>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">이메일 / 이름</th>
							<td>
								<div class="inputBox">
									<input type="text" name="email" value=""/>
									<input type="text" name="name" value=""/>
									<span class="btn darkS">
										<button name="searchButton" type="button">검색</button>
									</span>
								</div>
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
			<table summary="앱 회원 관리 목록">
				<caption>앱 회원 관리</caption>
				<colgroup>
					<col style="width:5%" />
					<%-- <col style="width:12%" /> --%>
					<col style="width:8%" />
					<col style="width:23%" />
					<col style="width:5%" />
					<col style="width:10%" />
					<col style="width:8%" />
					<col style="width:10%" />
					<col style="width:4%" />
					<col style="width:4%" />
					<col style="width:4%" />
					<col style="width:10%" />
				</colgroup>
				<thead>
				<tr>
					<th scope="col">NO</th>
					<!-- <th scope="col">CID </th> -->
					<th scope="col">이름 </th>
					<th scope="col">이메일 </th>
					<th scope="col">성별 </th>
					<th scope="col">생년월일 </th>
					<th scope="col">SNS </th>
					<th scope="col">디바이스 </th>
					<th scope="col">문화<br />공지 </th>
					<th scope="col">주변<br />알림 </th>
					<th scope="col">개인<br />알림 </th>
					<th scope="col">앱회원<br />가입일 </th>
				</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index}" />
						<tr>
							<td>${num}</td>
							<%-- <td>${item.social_cid}</td> --%>
							<td>${item.name}</td>
							<td>${item.email}</td>
							<td>${item.gender }</td>
							<td>${item.birth}</td>
							<td>
							<c:choose>
							<c:when test="${item.social_incoming eq 'KAKAO'}">카카오</c:when>
							<c:when test="${item.social_incoming eq 'NAVER'}">네이버</c:when>
							<c:when test="${item.social_incoming eq 'CULTURE_POTAL'}">문화포털</c:when>
							<c:otherwise></c:otherwise>
							</c:choose>
							</td>							
							<td>${item.device_type_nm }</td>
							<td>${item.culture_alarm }</td>
							<td>${item.around_alarm }</td>
							<td>${item.personal_alarm }</td>
							<td>${item.join_date }</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</form>
	<div id="pagination">
	</div>
	<!-- <div class="btnBox">
		<span class="btn dark fr"><a href="#url">엑셀 다운로드</a></span>
	</div> -->
</body>	
</html>
