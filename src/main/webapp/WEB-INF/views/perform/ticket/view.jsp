<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

var callback = {
		rdfMetadata : function (res) {
		/*
			JSON.stringify(res) = {
				"cateType"	:	"F"
				,"orgCode"	:	"NLKF02"
				,"orgId"	:	86
				,"category"	:	"도서"
				,"name"		:	"국립중앙도서관"
			}
		*/
		if (res == null) {
			alert('CallBack Res Null');
			return false;
		} 
		
		$('#preformCopy').show();
		
		//공연 uci
		if(res.uci) {$('input[name=uci]').val(res.uci);}
		else {alert('공연 uci 값이 존재하지 않습니다.'); return false;}
		//이미지
		if(res.referenceIdentifier)$('#selectedShowImg').attr('src', res.referenceIdentifier);
		if(res.referenceIdentifierOrg)$('#selectedShowImg').attr('src', '/upload/rdf/' + res.referenceIdentifierOrg);
		
		$('input[name=title]').val(res.title);
		//공연정보
		$('#performInfo').empty();//다 지우고
		
		if(res.title)$('#performInfo').append('제목 : '+ res.title + '</br>');
		if(res.time)$('#performInfo').append('시간 : '+ res.time + '</br>');
		if(res.venue)$('#performInfo').append('장소 : '+ res.venue + '</br>');
		if(res.extent)$('#performInfo').append('런닝타임: '+ res.extent + '</br>');
		if(res.grade)$('#performInfo').append('연령 : '+ res.grade + '</br>');
		if(res.rights)$('#performInfo').append('주최 : '+ res.rights + '</br>');
		if(res.reference)$('#performInfo').append('제목 : '+ res.reference + '</br>');
	}
};

$(function () {

	var frm = $('form[name=frm]');
	var reg_date_start = frm.find('input[name=start_dt]');
	var reg_date_end = frm.find('input[name=end_dt]');
	
	var title		= frm.find('input[name=title]');
	var uci		= frm.find('input[name=uci]');
	var location		= frm.find('input[name=location]');
	var reference		= frm.find('input[name=reference]');
	var terms		= frm.find('input[name=terms]');
	var admission		= frm.find('input[name=admission]');
	var discount		= frm.find('input[name=discount]');
	var discount_yn		= frm.find('input[name=discount_yn]');
	
	//layout
	new Datepicker(reg_date_start, reg_date_end);
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	
	//checkbox selected
	if('${view.discount_yn}')$('input:checkbox[name="discount_yn"][value="${view.discount_yn}"]').prop('checked', 'checked')
	
	
	if(!'${view.seq}') $('#preformCopy').hide();
	//공연상 선택
	$('span.btn.whiteS a').each(function(){
	  	$(this).click(function(){
	    	if( $(this).html() == '공연선택'){
	      		window.open('/popup/rdfMetadataPerform.do', 'placePopup', 'scrollbars=yes,width=400,height=300');
	    	} 
	  	});
	});
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		if (!confirm('수정하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/perform/ticket/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/perform/ticket/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/perform/ticket/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/perform/ticket/list.do';
        		return false;
        	}   		
    	});
	});
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		
		if(title.val() ==''){
			alert('공연/전시 선택하세요');
			title.focus();
			return false;
		}

		if(reg_date_start.val() ==''){
			alert('할인기간 시작일 입력하세요');
			reg_date_start.focus();
			return false;
		}

		if(reg_date_end.val() ==''){
			alert('할인기간 종료일 입력하세요');
			reg_date_end.focus();
			return false;
		}
		
		if(location.val() ==''){
			alert('지역 입력하세요');
			location.focus();
			return false;
		}

		if(reference.val() ==''){
			alert('문의 입력하세요');
			reference.focus();
			return false;
		}
		
		if(terms.val() ==''){
			alert('사용조건 입력하세요');
			terms.focus();
			return false;
		}
		
		if(admission.val() ==''){
			alert('관람료 입력하세요');
			admission.focus();
			return false;
		}
		
		if(discount.val() ==''){
			alert('할인률 입력하세요');
			discount.focus();
			return false;
		}
		
		if(discount_yn.prop('checked')){
			if(discount.val() ==''){
				alert('할인률 입력하세요');
				discount.focus();
				return false;
			}
		}
		
		return true;
	});
	
	
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/perform/ticket/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<table summary="할인티켓 작성">
				<caption>할인티켓 글쓰기</caption>
				<colgroup>
					<col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">공연/전시 제목</th>
						<td colspan="3">
							<input type="text" name="title" id="title" style="width:600px"  value="${view.title }" readonly>
							<span class="btn whiteS"><a href="#url">공연선택</a></span>
						</td>
					</tr>
					<tr>
						<th scope="row">선택한</br>공연/전시 정보</th>
						<td colspan="3">
							<input type="hidden" name="uci" value="<c:out value="${showView.uci }" />"/>
							
							<span id="preformCopy">
							<c:if test="${not empty showView.uci }">
								<c:choose>
									<c:when test="${not empty showView.reference_identifier_org }">
										<img id="selectedShowImg" src="/upload/rdf/<c:out value="${showView.reference_identifier_org }" />" />
									</c:when>
									<c:otherwise>
										<img id="selectedShowImg" src="<c:out value="${showView.reference_identifier }" />" />
									</c:otherwise>
								</c:choose>
							</c:if>
							<c:if test="${empty showView.uci }">
								<img id="selectedShowImg" src="" />
							</c:if>
							<br/>
							<div id="performInfo">
								<c:if test="${not empty showView.title }">제목 :<c:out value="${showView.title }" /> <br /></c:if>
								<c:if test="${not empty showView.reg_start }">공연기간 :<c:out value="${showView.reg_start }" />~<c:out value="${showView.reg_end }" /><br /></c:if>
								<c:if test="${not empty showView.time }">시간 : <c:out value="${showView.time }" /> <br /></c:if>
								<c:if test="${not empty showView.venue }">장소 : <c:out value="${showView.venue }" /><br /></c:if>
								<c:if test="${not empty showView.extent }">런닝타임 :<c:out value="${showView.extent }" /> <br /></c:if>
								<c:if test="${not empty showView.grade }">연령 : <c:out value="${showView.grade }" /><br /></c:if>
								<c:if test="${not empty showView.rights }">주최 : <c:out value="${showView.rights }" /><br /></c:if>
								<c:if test="${not empty showView.reference }">문의 :<c:out value="${showView.reference }" /></c:if>
							</div>
							</span>
						</td>
					</tr>
					<tr>
						<th scope="row">할인기간</th>
						<td colspan="3">
							<input type="text" name="start_dt" value="${view.start_dt }" />
							<span>~</span>
							<input type="text" name="end_dt" value="${view.end_dt }" />							
						</td>
					</tr>
					<tr>
						<th scope="row">지역</th>
						<td colspan="3">
							<input type="text" name="location" style="width:400px" value="${view.location}" /> ex)대학로
						</td>
					</tr>
					<tr>
						<th scope="row">문의</th>
						<td colspan="3">
							<input type="text" name="reference" style="width:400px" value="${view.reference}" />
						</td>
					</tr>
					<tr>
						<th scope="row">사용조건</th>
						<td colspan="3">
							<input type="text" name="terms" style="width:400px" value="${view.terms}" /> ex)공연 관람 3일 전 전화 예약
						</td>
					</tr>
					<tr>
						<th scope="row">관람료</th>
						<td colspan="3">
							<input type="text" name="admission" style="width:400px" value="${view.admission}" /> 
						</td>
					</tr>
					<tr>
						<th scope="row">할인률</th>
						<td colspan="3">
							<input type="text" name="discount" style="width:400px" value="${view.discount}" /> 
							<input type="checkbox" name="discount_yn" value="Y" />공연.전시안내 할인율표기
						</td>
					</tr>
					
					<tr>
						<th scope="row">요청사항</th>
						<td colspan="3">
							<textarea rows="10" cols="82" name="content" ><c:out value="${view.content }" /></textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval" value="W" checked/> 대기</label>
								<label><input type="radio" name="approval" value="Y"/> 승인</label>
								<label><input type="radio" name="approval" value="N"/> 미승인</label>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div class="btnBox textRight">
		<c:if test='${not empty view}'>
			<span class="btn white"><button type="button">수정</button></span>
			<span class="btn white"><button type="button">삭제</button></span>
		</c:if>
		<c:if test='${empty view }'>
			<span class="btn white"><button type="button">등록</button></span>
		</c:if>
		<span class="btn gray"><button type="button">목록</button></span>
	</div>
</body>
</html>