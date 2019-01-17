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
	
	// 기간
	var strt_dt = frm.find('input[name=strt_dt]');
	var end_dt = frm.find('input[name=end_dt]');
	// 등록일
	var reg_start = frm.find('input[name=reg_start]'); 
	var reg_end = frm.find('input[name=reg_end]');
	
	new Datepicker(strt_dt, end_dt);
	new Datepicker(reg_start, reg_end);
	
	//paging
// 	var p = new Pagination({
// 		view		:	'#pagination',
// 		page_count	:	'${count }',
// 		page_no		:	'${paramMap.page_no }',
// 		callback	:	function(pageIndex, e) {
// 			console.log('pageIndex : ' + pageIndex);
// 			page_no.val(pageIndex + 1);
// 			search();
// 			return false;
// 		}
// 	});
	if ('${paramMap.approval_yn}') {
		$('input:radio[name="approval_yn"][value="${paramMap.approval_yn}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="approval_yn"][value=""]').prop('checked', 'checked');
	}

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

	
	view = function(seq) { 
		url = '/culturepro/cultureSale/view.do';
		if(seq)
			url += '?seq=' + seq;
		
		location.href = url;
	}
	
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
	<form name="frm" method="get" action="/culturepro/cultureSale/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/> 
		<input type="hidden" name="fromUrl" value="list"/>
		
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="HOT 할인정보 관리">
					<caption>HOT 할인정보 관리</caption>
					<colgroup>
						<col style="width:13%" />
						<col style="width:%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">등록일</th>
							<td>
								<input type="text" name="reg_start" class="datepicker" value="${paramMap.reg_start }" />
								<span>~</span>
								<input type="text" name="reg_end" class="datepicker" value="${paramMap.reg_end }" />
							</td>
						</tr>
						<tr>
							<th scope="row">기간</th>
							<td>
								<input type="text" name="strt_dt" class="datepicker" value="${paramMap.strt_dt }" />
								<span>~</span>
								<input type="text" name="end_dt" class="datepicker" value="${paramMap.end_dt }" />
							</td>
						</tr>
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
							<th scope="row">검색어</th>
							<td>
								<select name="searchGubun" style="width: 100px;">
									<option value="">전체</option>
									<option value="title">제목</option>
									<option value="contents">내용</option>
								</select>
								<input type="text" name="searchKeyword" title="검색어 입력" value="${paramMap.searchKeyword}"/>
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
			<table summary="HOT 할인정보 관리 목록">
				<caption>HOT 할인정보 관리</caption>
				<colgroup>
					<col style="width:5%" />
					<col style="width:8%" />
					<col style="width:25%" />
					<col style="width:*" />
					<col style="width:10%" />
					<col style="width:8%" />
					<col style="width:8%" />
				</colgroup>
				<thead>
				<tr>
					<th scope="col">NO</th>
					<th scope="col">할인율</th>
					<th scope="col">기간</th> 
					<th scope="col">제목</th>
					<th scope="col">등록일</th>
					<th scope="col">조회수</th>
					<th scope="col">승인여부</th>
				</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<tr>
							<td>${status.index}</td>
							<td>${item.view_discount}%</td>
							<td><c:out value="${item.start_dt}"/> ~ <c:out value="${item.end_dt}"/></td>
							<td class="subject">
								<!-- <a href="/culturepro/cultureSale/view.do?seq=${item.type}-${item.seq}"> -->
								<a href="/culturepro/cultureSale/view.do?seq=${item.seq}&type=${item.type}">
									<c:out value="${item.title}"/>
								</a>
							</td>
							<td>${item.reg_dt }</td>
							<td>${item.hit_count}</td>
							<td>
								<c:choose>
									<c:when test="${item.app_approval eq 'Y'}">
										승인
									</c:when>
									<c:when test="${item.app_approval eq 'W'}">
										대기
									</c:when>
									<c:otherwise>
										미승인
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</form>
</body>
</html>
