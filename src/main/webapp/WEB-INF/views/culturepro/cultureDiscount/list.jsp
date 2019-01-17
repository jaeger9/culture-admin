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
	
	var strt_dt = frm.find('input[name=strt_dt]');
	var end_dt = frm.find('input[name=end_dt]');
	
	new Datepicker(strt_dt, end_dt);
	
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
	
	if ('${paramMap.field}') {
		$('input:radio[name="field"][value="${paramMap.field}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="field"][value=""]').prop('checked', 'checked');
	}
	
	if ('${paramMap.approval_yn}') {
		$('input:radio[name="approval_yn"][value="${paramMap.approval_yn}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="approval_yn"][value=""]').prop('checked', 'checked');
	}

	//검색
	$('button[name=searchButton]').click(function(){
		$('input[name=page_no]').val('1');
		$('form[name=frm]').submit();
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
	
	
	//저장 
	$('span.btn.dark.fr').click(function(){
		
		var changeYn = false;
		$("select[name=discount_percent]").each(function(index,item){
			var value = $(this).val();
			if(value != ""){
				changeYn = true;
				return false;
			}
		});
		
		var field = "${paramMap.field}";
		if(field == "") field = "D";
		$("input[name=field]").val(field);
			
		
		if(!changeYn){
			alert("변경된 표시할인율이 없습니다.");
			return false;
		}
		
		formSubmit("/culturepro/cultureDiscount/save.do");
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
	<form name="frm" method="get" action="/culturepro/cultureDiscount/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/> 
		<input type="hidden" name="fromUrl" value="list"/>
		
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="할인율관리">
					<caption>할인율관리</caption>
					<colgroup>
						<col style="width:13%" />
						<col style="width:%" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">분류</th>
							<td>
								<div class="inputBox">
									<label><input type="radio" name="field" value="D" checked="checked"/> 할인이벤트</label>
									<label><input type="radio" name="field" value="R"/> 문화릴레이</label>
									<label><input type="radio" name="field" value="N"/> 문화소식</label>
									<label><input type="radio" name="field" value="F"/> 참여시설</label>
									<!-- <label><input type="radio" name="field" value="C"/> 공연/전시</label> -->
								</div>
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
			<table summary="할인율 관리 목록">
				<caption>할인율 관리</caption>
				<colgroup>
					<col style="width:4%" />
					<col style="width:35%" />
					<col style="width:*" />
					<col style="width:25%" />
					<col style="width:13%" />
				</colgroup>
				<thead>
				<tr>
					<th scope="col">NO</th>
					<th scope="col">제목</th>
					<th scope="col">할인</th>
					<th scope="col">기간</th>
					<th scope="col">표시할인율</th>
				</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index}" />
						<tr>
							<td>${num}</td>
							<td class="subject" >
									<c:out value="${item.title}"/>
							</td>
							<td>${item.discount }</td>
							<td><c:out value="${item.start_dt}"/> ~ <c:out value="${item.end_dt}"/></td>
							<td>
								<select name="discount_percent">
									<option value="">표시할인율</option>
									<option value="100">무료(100%)</option>
									<option value="30">30%</option>
									<option value="50">50%</option>
									<c:forEach begin="1" end="100" var="nums">
										<c:if test="${item.view_discount == nums }">
											<option value="${nums}" selected="selected">${nums}%</option>
										</c:if>
										<c:if test="${item.view_discount != nums}">
											<option value="${nums}">${nums}%</option>
										</c:if>
									</c:forEach>
									
								</select>
								<input type="hidden" name="seq" value="${item.seq}"/>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		<input type="hidden" name="filed"/>
	</form>
	<div id="pagination">
	</div>
	<div class="btnBox">
		<span class="btn dark fr"><a href="#url">저장</a></span>
	</div>
</body>
</html>
