<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="/crosseditor/js/namo_scripteditor.js"></script>

<script type="text/javascript">

var callback = {
	facilityConn: function(res) {		
		$('input[name=type_code]').val(res.type_code);
		$('input[name=facility_name]').val(res.facility_name);
		$('input[name=gps_lat]').val(res.gps_lat);
		$('input[name=gps_lng]').val(res.gps_lng);
		$('input[name=g_seq2]').val(res.g_seq);

		var frm = $('form[name=frm]');
		frm.attr('action' ,'/culturepro/manage/mappingInsert.do');
		frm.submit();
	}
};

$(function() {
	var frm = $('form[name=frm]');

	frm.submit(function() {
		return true;
	});

	//삭제 , 목록 
	$('span > button').each(function() {
		$(this).click(function() {
			if ($(this).html() == '삭제') {
				if (!confirm('삭제 하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/manage/delete.do');
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = '/culturepro/manage/list.do';
			}
		});
	});
	
	//추가연결
	$('button[name=setupAddBtn]').each(function() {
		$(this).click(function() {
			window.open('/culturepro/manage/popup/facilityList.do?g_seq=${paramMap.g_seq}', 'placePopup', 'scrollbars=yes,width=550,height=650');
			return false;
		});
	});
	
	//연결해제
	$('button[name=setupCloseBtn]').each(function() {
		$(this).click(function() {
    		if (!confirm('선택한 정보의 연결을 해제하시겠습니까?')) {
    			return false;
    		}
			var p =	$(this).parents('tr:eq(0)');
			var ele = p.find("input[name='facility_seq']");

			$('input[name=m_seq]').val(ele.val());
			
			var frm = $('form[name=frm]');
			frm.attr('action' ,'/culturepro/manage/mappingRelease.do');
			frm.submit();
			
			return false;
		});
	});
});
</script>
</head>
<body>
<!-- 검색 필드 -->
<div class="tableWrite">
	<form name="frm" method="post" action="/culturepro/manage/form.do" enctype="multipart/form-data">
		<input type="hidden" name="g_seq" value="${paramMap.g_seq}"/>
		<!-- 업데이트용 -->
		<input type="hidden" name="g_seq2" value=""/>
		<input type="hidden" name="m_seq" value=""/>
		<input type="hidden" name="type_code" value=""/>
		<input type="hidden" name="facility_name" value=""/>
		<input type="hidden" name="gps_lat" value=""/>
		<input type="hidden" name="gps_lng" value=""/>
		
		<div class="tableWrite">	
			<table summary="문화융성앱 게시시설관리 Mapping 컨텐츠">
				<caption>문화융성앱 게시시설관리 Mapping 컨텐츠</caption>
				<colgroup>
					<col style="width:15%" />
					<col style="width:%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">고유번호</th>
						<td>
							${paramMap.g_seq }
						</td>
					</tr>
				</tbody>
			</table>	
		</div>
		<br/>
		
		<!-- 연결정보  -->
		<div>
			<table summary="문화융성앱 게시시설관리 Mapping 컨텐츠">
				<caption>문화융성앱 게시시설관리 Mapping 컨텐츠</caption>
				<colgroup>
					<col style="width:15%" />
					<col style="width:15%" />
					<col style="width:%" />
				</colgroup>
				<tbody>
					<tr>
						<td><h3 class="subtitle01">연결정보</h3></td>
						<td><span class="btn white"><button name="setupAddBtn" type="button">추가연결</button></span></td>
						<td><b>※ 시설명이 다른 경우, 검색하여 연결할 수 있습니다.</b></td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<!-- 리스트 -->
		<div class="tableList">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col style="width:20%" />
					<col style="width:%" />
					<col style="width:15%" />
					<col style="width:15%" />
					<col style="width:13%" />
				</colgroup>
				<thead>
				<tr>
					<th scope="col">구분</th>
					<th scope="col">시설명</th>
					<th scope="col">위치정보 X</th>
					<th scope="col">위치정보 Y</th>
					<th scope="col">연결해제</th>
				</tr>
				</thead>
				<tbody>
					<c:forEach items="${formlist }" var="item" varStatus="status">
						<tr>
							<td>
								<input type="hidden" name="facility_seq" value="${item.seq}"/>
								<input type="hidden" name="facility_g_seq" value="${item.g_seq}"/>
								<c:out value="${item.type_code_nm}"/>
							</td>
							<td class="subject"><c:out value="${item.facility_name}"/></td>
							<td>${item.gps_lat}</td>
							<td>${item.gps_lng}</td>
							<td>
							<c:if test="${ fn:length(formlist) > 1 }">
								<span class="btn white"><button name="setupCloseBtn" type="button">연결해제</button></span>
							</c:if></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</form>
</div>
<div class="btnBox textRight">
	<span class="btn white"><button type="button">삭제</button></span>
	<span class="btn gray"><button type="button">목록</button></span>
</div>
</body>
</html>