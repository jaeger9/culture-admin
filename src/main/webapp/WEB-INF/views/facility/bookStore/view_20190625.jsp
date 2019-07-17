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

	frm.submit(function(){
	
		if(frm.attr('action') != '/facility/bookStore/delete.do'){
			
			if($('input[name=title]').val() == '') {
			    alert("시설명을 입력해주세요.");
			    $('input[name=title]').focus();
			    return false;
			}

			if($('input[name=address]').val() == '') {
			    alert("도로명주소를 입력해주세요.");
			    $('input[name=address]').focus();
			    return false;
			}
			
			if($('input[name=sido]').val() == '') {
			    alert("시도명을 입력해주세요.");
			    $('input[name=sido]').focus();
			    return false;
			}
			
			if($('input[name=gugun]').val() == '') {
			    alert("구군명을 입력해주세요.");
			    $('input[name=gugun]').focus();
			    return false;
			}
			
			if($('input[name=tel]').val() == '') {
			    alert("전화번호를 입력해주세요.");
			    $('input[name=tel]').focus();
			    return false;
			}
			
			if($('input[name=homepage]').val() != '') {
				var chkStr = $('input[name=homepage]').val();
				if(chkStr.match('http')){
			   		alert("http:// 또는 https:// 이하의 주소를 입력해주세요. \n 예) http://www.naver.com -> www.naver.com 으로 입력");
				}
			    $('input[name=tel]').focus();
			    return false;
			}
			
		}
		return true;
	});
	
	
	$('span.btn.whiteS a').click(function(){
		if( $(this).html() == '우편번호찾기'){
    		window.open('/popup/jusoPopup.do','postalcodePopup' , 'width=570, height=420, scrollbars=yes, resizable=yes');
    	} else if( $(this).html() == '좌표찾기'){
    		if($('input[name=address]').val() == ''){
    			alert('도로명주소를 입력해주세요');
    			return false;
    		}else{
    			window.open('/popup/coordinate.do','coordinatePopup', 'scrollbars=yes,width=500,height=550');	
    		}
    	}
  	});

	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		if (!confirm('수정하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/facility/bookStore/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/facility/bookStore/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/facility/bookStore/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/facility/bookStore/list.do';
        	}   		
    	});
	});
	
	
	//좌표
	setCoordinate = function (cul_gps_x , cul_gps_y){
		$('input[name=gpsx]').val(cul_gps_y);
		$('input[name=gpsy]').val(cul_gps_x);
	}

});




//도로명주소 Open Api
function jusoCallBack(sido, gugun, addr, addr2, zipNo){
	sido = sido.replace('특별시', '');
	sido = sido.replace('광역시', '');
	sido = sido.replace('세종특별자치시', '세종');
	sido = sido.replace('세종시', '세종');
	sido = sido.replace('경기도', '경기');
	sido = sido.replace('강원도', '강원');
	sido = sido.replace('충청북도', '충북');
	sido = sido.replace('충청남도', '충남');
	sido = sido.replace('전라북도', '전북');
	sido = sido.replace('전라남도', '전남');
	sido = sido.replace('경상북도', '경북');
	sido = sido.replace('경상남도', '경남');
	sido = sido.replace('제주특별자치도', '제주');
	sido = sido.replace('제주도', '제주');
	
	$('input[name="sido"]').val(sido);		//시도
	$('input[name="gugun"]').val(gugun);	//구군
	$('input[name="address"]').val(addr + ' ' + addr2);		//기본주소 + 상세주소
	
	$('input[name="cul_addr"]').val(addr);		//기본주소
	$('input[name="cul_addr2"]').val(addr2);	//상세주소
}

</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/facility/bookStore/insert.do">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			
			<input type="hidden"  name="cul_addr" value="${view.address }"/>
			<input type="hidden"  name="cul_addr2" value=""/>
			
			
			<table summary="체육시설 등록/수정">
				<caption>체육시설 등록/수정</caption>
				<colgroup>
					<col style="width:20%" /><col style="width:30%" /><col style="width:22%" /><col style="width:28%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row"><span style="color: red">*</span> 시설명</th>
						<td colspan="3">
							<input type="text" name="title" value="${view.title }" maxlength="300" style="width:450px;"/>
						</td>
					</tr>
					<tr>
						<th scope="row"><span style="color: red">*</span> 도로명주소</th>
						<td colspan="3">
							<div class="inputBox">
								<input type="text" name="address" value="${view.address }" maxlength="500" style="width:450px;"/>
								<span class="btn whiteS"><a href="#url">우편번호찾기</a></span>
								<span class="btn whiteS"><a href="#url">좌표찾기</a></span>
							</div>						
						</td>
					</tr>
					<tr>
						<th scope="row"><span style="color: red">*</span> 시도명</th>
						<td>
							<input type="text" name="sido" value="${view.sido}" maxlength="50" style="width:200px;"/>
						</td>
						<th scope="row"><span style="color: red">*</span> 구군명</th>
						<td>
							<input type="text" name="gugun" value="${view.gugun}" maxlength="50" style="width:200px;"/>
						</td>
					</tr>
					<tr>
						<th scope="row">위도</th>
						<td>
							<input type="text" name="gpsx" value="${view.gpsx}" maxlength="50" style="width:200px;"/>
						</td>
						<th scope="row">경도</th>
						<td>
							<input type="text" name="gpsy" value="${view.gpsy}" maxlength="50" style="width:200px;"/>
						</td>					
					</tr>
					<tr>
						<th scope="row">북카페여부</th>
						<td>
							<select name="bookCafeYn">
								<option value="" ${empty view.bookcafe_yn}>선택</option>
								<option value="Y" ${view.bookcafe_yn eq 'Y' ? 'selected' : ''}>Y</option>
								<option value="N" ${view.bookcafe_yn eq 'N' ? 'selected' : ''}>N</option>
							</select>
						</td>
						<th scope="row"><span style="color: red">*</span>전화번호</th>
						<td>
							<input type="text" name="tel" value="${view.tel}" maxlength="50" style="width:200px;"/>
						</td>
					</tr>
					<tr>
						<th scope="row">영업시간</th>
						<td>
							<input type="text" name="businessTime" value="${view.businesstime}" maxlength="50" style="width:200px;"/>
						</td>
						<th scope="row">휴무일</th>
						<td>
							<input type="text" name="rest" value="${view.rest}" maxlength="50" style="width:200px;"/>
						</td>
					</tr>
					<tr>
						<th scope="row">서점인증여부</th>
						<td colspan="3">
							<select name="bookStoreCert">
								<option value="" ${empty view.bookstore_cert}>선택</option>
								<option value="Y" ${view.bookstore_cert eq 'Y' ? 'selected' : ''}>Y</option>
								<option value="N" ${view.bookstore_cert eq 'N' ? 'selected' : ''}>N</option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">홈페이지</th>
						<td colspan="3">
							http://<input type="text" name="homepage" value="${view.homepage}" maxlength="2000" style="width:450px;"/>
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