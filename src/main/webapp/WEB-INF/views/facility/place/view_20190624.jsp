<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- 
	20151006 : 이용환 : 에디터 변경을 위해 수정 
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
 -->
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="/crosseditor/js/namo_scripteditor.js"></script>

<!-- 2016.03.16 PCN Choi Won-Young -->
<!-- 좌표변환 -->
<script type="text/javascript" src="/js/map/proj4.js"></script>
<script type="text/javascript" src="/js/map/ol.js"></script>
<!-- 좌표변환 -->

<script type="text/javascript">
//2016.03.16 PCN Choi Won-Young
//좌표변환
proj4.defs("EPSG:5186", "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs");

var callback = {
	place : function(res) {
		if (res == null) {
			alert('callback data null');
			return false;
		}
		$('input[name=publisher]').val(res.orgCode);
		$('input[name=cate_type]').val(res.cateType);
		$('input[name=creator]').val(res.name);
	}, 
	postalcode :function(res) {
		// res = {"buil_num2":0,"buil_num1":63,"road_name":"구로동로13길","zip_code":152800,"gi_num2":2,"gi_num1":1,"dong_name1":"가리봉동","gu_name":"구로구","sido_name":"서울특별시"}
		var culZipYn = $('input[name=cul_zip_yn]:checked').val();		//$('input[name=cul_zip_yn]').val()
		var zip_code = res.zip_code.toString();
		
		if (res == null) {
			alert('callback data null');
			return false;
		}
		
		if(culZipYn == 63) {
			setZipCode(res.sido_name , res.gu_name , res.dong_name1 , res.gi_num1 , res.gi_num2 , zip_code.substring(0,3)+"-"+zip_code.substring(3,6));
		} else if(culZipYn == 64) {
			setZipCode(res.sido_name , res.gu_name , res.road_name , res.buil_num1 , res.buil_num2 , zip_code.substring(0,3)+"-"+zip_code.substring(3,6));
		}
	}
}
var strGrp2 = new Array();
strGrp2[0] = '<option value="">2차선택</option>';
strGrp2[1] = '<option value="">2차선택</option><option value="100">일반공연장</option><option value="101">종합공연장</option>';
strGrp2[2] = '<option value="">2차선택</option><option value="200">공공미술관</option><option value="201">사립미술관</option>';
strGrp2[3] = '<option value="">2차선택</option><option value="300">국립박물관</option><option value="301">대학박물관</option><option value="302">기타박물관</option>';
strGrp2[4] = '<option value="">2차선택</option><option value="400">문화의집</option><option value="401">복지회관</option><option value="402">자치센터</option>';
strGrp2[5] = '<option value="">2차선택</option><option value="500">공공도서관</option><option value="501">기타도서관</option>';
strGrp2[6] = '<option value="">2차선택</option><option value="600">기타문화공간</option>';
strGrp2[7] = '<option value="">2차선택</option><option value="700">영화관</option>';
strGrp2[8] = '<option value="">2차선택</option><option value="800">문화재</option>';

function getCodeList(val){
	if(val.length == 0) {
		val = "0";
	} else {
		val = new String(val);
	}
	$('#cul_grp2').html(strGrp2[val.substring(0,1)]);
}

$(function () {

	//upload file 변경시 fake file div text 변경
	$('input[name=uploadFile]').each(function(){
		$(this).change(function(){
			$(this).next().find('input.inputText').val($(this).val());
		});
	});
	
	var frm = $('form[name=frm]');
	var addr1=frm.find('input[name=addr1]');
	
	$("input[name=cul_addr]").on("change",function(){
		addr1.val(frm.find("input[name=cul_addr]").val());
		console.log(addr1.val()+" addr1change");
	});
	
	var reg_date_start = frm.find('input[name=reg_start]');
	var reg_date_end = frm.find('input[name=reg_end]');

	var cul_name					=frm.find('input[name=cul_name]');
	var rental_yn					=frm.find('input[name=rental_yn]');
	var rental_person				=frm.find('input[name=rental_person]');
	var rental_charge_yn			=frm.find('input[name=rental_charge_yn]');
	var rental_charge				=frm.find('input[name=rental_charge]');
	var rental_pay_option			=frm.find('input[name=rental_pay_option]');
	var rental_approval				=frm.find('input[name=rental_approval]');
	var apply_url					=frm.find('input[name=apply_url]');
	addr1.val(frm.find("input[name=cul_addr]").val());
	console.log(addr1.val()+" addr1init");
	/* var cul_place			=frm.find('input[name=cul_place]');
	var cul_place2			=frm.find('input[name=cul_place2]');
	var cul_gps_x			=frm.find('input[name=cul_gps_x]');
	var cul_gps_y			=frm.find('input[name=cul_gps_y]');
	var cul_openname			=frm.find('input[name=cul_openname]');
	var cul_bestname			=frm.find('input[name=cul_bestname]');
	var cul_user			=frm.find('input[name=cul_user]');
	var cul_email			=frm.find('input[name=cul_email]');
	var cul_tel			=frm.find('input[name=cul_tel]');
	var cul_fax			=frm.find('input[name=cul_fax]');
	
	//2
	var cul_zip_yn			=frm.find('input[name=cul_zip_yn]');

	var cul_post_num			=frm.find('input[name=cul_post_num]');
	var cul_addr			=frm.find('input[name=cul_addr]');
	var cul_openday			=frm.find('input[name=cul_openday]');
	var cul_closeday			=frm.find('input[name=cul_closeday]');
	var cul_homeurl			=frm.find('input[name=cul_homeurl]');

	//3
	var post_flag			=frm.find('input[name=post_flag]');

	///2
	var rental_dt			=frm.find('input[name=rental_dt]');
	var rental_info			=frm.find('input[name=rental_info]');
	
	//3
	var rental_approval			=frm.find('input[name=rental_approval]'); */
	
	///////////////////////////////////////////
	changeNote = function(ele) {
		if(ele) checked = ele.val();
		else checked = $(':radio[name=note1]:checked').val();
	
		if(checked == 'Y') {
			$('input[name=reference_identifier]').hide();
		    $('div.fileInputs').show();
		} else if(checked == 'N') {
			$('input[name=reference_identifier]').show();
			$('div.fileInputs').hide();
		}
	}
	
	changeRental = function() {
		if(rental_yn.prop('checked')) {
			$('.rentalTable').show();
			changeRentalRadio();
		} else {
			$('.rentalTable').hide();
		}
	}
	
	changeRentalRadio = function() {
		checked = $(':radio[name=rental_radio]:checked').val();
		if(checked == 'in') {
			$('.out').hide();
			$('.in').show();
			$('input[name=apply_url]').val('');
		} else if(checked == 'out') {
			$('.in').hide();
			$('.out').show();
		} else {
			$('.out').hide();
			$('.in').hide();
			$('input[name=apply_url]').val('');
		}
	}
	
	//layout
	
	new Datepicker(reg_date_start, reg_date_end);
	
	//radio check
	if('${view.post_flag}')$('input:radio[name="post_flag"][value="${view.post_flag}"]').prop('checked', 'checked');
	if('${view.note1}')$('input:radio[name="note1"][value="${view.note1}"]').prop('checked', 'checked');
	if('${rentalView.approval}')$('input:radio[name="rental_approval"][value="${rentalView.approval}"]').prop('checked', 'checked');
	if('${rentalView.charge_yn}')$('input:radio[name="rental_charge_yn"][value="${rentalView.charge_yn}"]').prop('checked', 'checked');
	
	//select selected
	getCodeList('${view.cul_grp1}');
	if('${view.genre}')$("select[name=genre]").val('${view.genre}').attr("selected", "selected");
	if('${view.cul_grp1}')$("select[name=cul_grp1]").val('${view.cul_grp1}').attr("selected", "selected");
	if('${view.cul_grp2}')$("select[name=cul_grp2]").val('${view.cul_grp2}').attr("selected", "selected");
	
	//if('${rentalView.seq}' || '${view.apply_url}')$('input:checkbox[name=rental_yn]').prop('checked' , 'checked');
	if('${view.apply_yn}' == 'Y')$('input:checkbox[name=rental_yn]').prop('checked' , 'checked');
	if('${view.apply_url}') {
		$('input[name=rental_radio][value=out]').prop('checked', 'checked');
	} else if('${rentalView.seq}') {
		$('input[name=rental_radio][value=in]').prop('checked', 'checked');
	}
	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
//	nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	 
	//썸네일 이미지 	 
	changeNote();
	
	$('input[name=note1]').change(function(){
		changeNote($(this));
	});
	
	//대관 여부
	changeRental();
	
	$('input[name=rental_yn]').change(function(){
		changeRental();
	});
	
	$('input[name=rental_radio]').change(function(){
		changeRentalRadio();
	});
	
	//URL 미리보기
	goLink = function() { 
		window.open($('input[name=url]').val());
	}
	
	//공연상 선택
	$('span.btn.whiteS a').each(function(){
	  	$(this).click(function(){
	    	if( $(this).html() == '선택'){
	      		window.open('/popup/place.do', 'placePopup', 'scrollbars=yes,width=400,height=300');
	    	} else if( $(this).html() == '장소등록'){
	    		location.href='/facility/place/list.do';
	    	} else if( $(this).html() == '미리보기'){
	    		goLink();
	    	} else if( $(this).html() == '좌표찾기'){
	    		window.open('/popup/coordinate.do','coordinatePopup', 'scrollbars=yes,width=500,height=550');
	    	} else if( $(this).html() == '우편번호찾기'){
	    		//window.open('/popup/postalcode.do?zip_yn=' + $('input[name=cul_zip_yn]:checked').val(),'postalcodePopup' , 'scrollbars=yes,width=500,height=600');
	    		//window.open('/popup/postalcode.do?zip_yn='+$('input[name=cul_zip_yn]').val(),'postalcodePopup' , 'scrollbars=yes,width=500,height=600');
	    		window.open('/popup/jusoPopup.do','postalcodePopup' , 'width=570, height=420, scrollbars=yes, resizable=yes');
	    	} else if( $(this).html() == '유효성검사'){
	    		window.open($('input[name=cul_homeurl]').val());
	    	}
	  	});
	});
	
	setPlace = function(name , location) {
		$('input[name=venue]').val(name);
		$('input[name=location]').val(location);
	}
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		
		if(!$('select[name=cul_grp1] > option:selected').val()) {
		    alert("구분 1차 선택하세요");
		    return false;
		}
		
		if(!$('select[name=cul_grp2] > option:selected').val()) {
		    alert("구분 2차 선택하세요");
		    return false;
		}
		
		if(cul_name.val() == ''){
			alert('문화공간명 입력하세요');
			cul_name.focus();
			return false;
		}
		
		/* 필수값 정의가 안됨 필요시 주석 제거 
		if(cul_openname.val() == ''){
			alert('운영주체 입력하세요');
			cul_openname.focus();
			return false;
		} 
		
		if(cul_bestname.val() == ''){
			alert('대표자명 입력하세요');
			cul_bestname.focus();
			return false;
		}
		
		if(cul_user.val() == ''){
			alert('담당자명 입력하세요');
			cul_user.focus();
			return false;
		}
		
		if(cul_email.val() == ''){
			alert('E-mail 입력하세요');
			cul_email.focus();
			return false;
		}
		
		if(cul_tel.val() == ''){
			alert('전화번호 입력하세요');
			cul_tel.focus();
			return false;
		}
		
		if(cul_fax.val() == ''){
			alert('팩스번호 입력하세요');
			cul_fax.focus();
			return false;
		}
		
		if(cul_post_num.val() == ''){
			alert('우편번호 입력하세요');
			cul_post_num.focus();
			return false;
		}
		
		if(cul_addr.val() == ''){
			alert('주소 입력하세요');
			cul_addr.focus();
			return false;
		}
		
		if(cul_openday.val() == ''){
			alert('개관일 입력하세요');
			cul_openday.focus();
			return false;
		}
		
		if(cul_closeday.val() == ''){
			alert('휴관일 입력하세요');
			cul_closeday.focus();
			return false;
		}
		
		if(cul_homeurl.val() == ''){
			alert('홈페이지URL 입력하세요');
			cul_homeurl.focus();
			return false;
		}
		*/
		
		//rental 여부 체크
		if(rental_yn.prop('checked')){
			if($(':radio[name=rental_radio]:checked').val() == 'in'){
				if(rental_person.val() == ''){
					alert('수용인원을 입력하세요');
					rental_person.focus();
					return false;
				}
				
				if(!rental_charge_yn.is(':checked')){
					alert('대관 금액 구분을 선택하세요');
					rental_charge_yn.focus();
					return false;
				}
				
				if($('input[name=rental_charge_yn]:checked').val() == 'Y'){
					
					if(rental_charge.val() == ''){
						alert('대관 금액을 입력하세요');
						rental_charge.focus();
						return false;
					}
					
					if($('textarea[name=rental_pay_option]').val() == ''){
						alert('결제방법을 입력하세요');
						rental_pay_option.focus();
						return false;
					}
				}
				
				if(!rental_approval.is(':checked')){
					alert('대관 시설 승인 여부를 선택 하세요');
					rental_approval.focus();
					return false;
				}
			} else {
				if(apply_url.val() == ''){
					alert('대관 URL을 입력하세요');
					apply_url.focus();
					return false;
				}
			}
		};
		
		return true;
	});
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		if (!confirm('수정하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/facility/place/update.do');
        		//좌표변환
        		transCoordinate();
        		//oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
        		document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/facility/place/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/facility/place/insert.do');
        		//좌표변환
        		transCoordinate();
        		//oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
        		document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/facility/place/list.do';
        	}   		
    	});
	});
	
	setZipCode = function (sido,gugun, dong, gi_num1, gi_num2,zip_code){
		$('input[name=cul_post_num]').val(zip_code);
		$('input[name=cul_addr]').val(sido+ " " +gugun+ " " +dong+ " " +(gi_num2 != "" ? gi_num1+"-"+gi_num2 : gi_num1) );
		$('input[name="cul_place"]').val(sido);
		$('input[name="cul_place2"]').val(gugun);
	}
	
	setCoordinate = function (cul_gps_x , cul_gps_y){
		$('input[name=cul_gps_x]').val(cul_gps_x);
		$('input[name=cul_gps_y]').val(cul_gps_y);
	}
	
	//2016.03.16 PCN Choi Won-Young
	//좌표변환 
	transCoordinate = function() {
		var cul_gps_x = $('input[name=cul_gps_x]').val();
		var cul_gps_y = $('input[name=cul_gps_y]').val();
		
		var gisData = ol.proj.transform([cul_gps_x, cul_gps_y], 'EPSG:4326', 'EPSG:5186');
		console.log(gisData[0] + " , " +  gisData[1]);
		
		$('input[name=cul_gis_x]').val(gisData[0]);
		$('input[name=cul_gis_y]').val(gisData[1]);
	}
	//좌표변환
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
	
	$('input[name="cul_place"]').val(sido);		//시도
	$('input[name="cul_place2"]').val(gugun);	//구군
	$('input[name=cul_post_num]').val(zipNo);	//우편번호
	$('input[name=cul_addr]').val(addr);		//기본주소
	$('input[name=cul_addr2]').val(addr2);		//상세주소
}
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/facility/place/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.cul_seq}'>
				<input type="hidden" name="cul_seq" value="${view.cul_seq}"/>
			</c:if>
			<input type="hidden" value="${view.cul_place}" name="cul_place">
			<input type="hidden" value="${view.cul_place2}" name="cul_place2">
			<input type="hidden" value="${view.cul_gps_x }" name="cul_gps_x">
			<input type="hidden" value="${view.cul_gps_y }" name="cul_gps_y">
			<input type="hidden" value="" name="cul_gis_x">
			<input type="hidden" value="" name="cul_gis_y">
			<table summary="공연장 등록/수정">
				<caption>공연장 등록/수정</caption>
				<colgroup>
					<col style="width:17%" /><col style="width:33%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">구분</th>
						<td colspan="3">
							<select name="cul_grp1" id="cul_grp1" onchange="getCodeList(this.value)">
								<option value="" >1차선택</option>
								<option value="100" <c:if test="${culView.CUL_GRP1 eq '100'}">selected="selected"</c:if>>공연장</option>
								<option value="200" <c:if test="${culView.CUL_GRP1 eq '200'}">selected="selected"</c:if>>미술관</option>
								<option value="300" <c:if test="${culView.CUL_GRP1 eq '300'}">selected="selected"</c:if>>박물관</option>
								<option value="400" <c:if test="${culView.CUL_GRP1 eq '400'}">selected="selected"</c:if>>문화/복지/시군구회관</option>
								<option value="500" <c:if test="${culView.CUL_GRP1 eq '500'}">selected="selected"</c:if>>도서관</option>
								<option value="600" <c:if test="${culView.CUL_GRP1 eq '600'}">selected="selected"</c:if>>기타문화공간</option>
								<option value="700" <c:if test="${culView.CUL_GRP1 eq '700'}">selected="selected"</c:if>>영화관</option>
								<option value="800" <c:if test="${culView.CUL_GRP1 eq '800'}">selected="selected"</c:if>>문화재</option>
							</select>
							<select name="cul_grp2" id="cul_grp2">
								<option value="">2차선택</option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">문화공간명</th>
						<td colspan="3">
							<input type="text" name="cul_name" style="width:670px" value="${view.cul_name}" />
						</td>
					</tr>
					<tr>
						<th scope="row">운영주체</th>
						<td>
							<input type="text" name="cul_openname" style="width:260px" value="${view.cul_openname }" />
						</td>
						<th scope="row">대표자명</th>
						<td>
							<input type="text" name="cul_bestname" style="width:260px" value="${view.cul_bestname }" />
						</td>
					</tr>
					<tr>
						<th scope="row">담당자명</th>
						<td>
							<input type="text" name="cul_user" style="width:260px"  value="${view.cul_user }" />
						</td>
						<th scope="row">E-mail</th>
						<td>
							<input type="text" name="cul_email" style="width:260px"  value="${view.cul_email }" />
						</td>
					</tr>
					<tr>
						<th scope="row">전화</th>
						<td>
							<input type="text" name="cul_tel" style="width:260px" value="${view.cul_tel }" />
						</td>
						<th scope="row">팩스</th>
						<td>
							<input type="text" name="cul_fax" style="width:260px" value="${view.cul_fax }" />
						</td>
					</tr>
					<tr>
						<th scope="row">주소</th>
						<td colspan="3">
							<div class="inputBox">
								<input type="text" name="cul_post_num" style="width:150px" value="${view.new_post_num }" readonly="readonly"/>
								<span class="btn whiteS"><a href="#url">우편번호찾기</a></span>
								<span class="btn whiteS"><a href="#url">좌표찾기</a></span>
								<div style="display:none">
									<label><input type="radio" value="63" name="cul_zip_yn" ${view.cul_zip_yn eq '63' or empty view.cul_zip_yn ? 'checked="checked"':'' }/>지번주소</label>
									<label><input type="radio" value="64" name="cul_zip_yn" ${view.cul_zip_yn eq '64' ? 'checked="checked"':'' }/>도로명주소</label>
								</div>
								<%--<input type="hidden" name="cul_zip_yn" value="64"/> --%>
							</div>
							<div class="inputBox">
								<input type="text" name="cul_addr" id="cul_addr" style="width:670px" value="${view.new_addr }" readonly="readonly"/>
								<input type="text" name="cul_addr2" style="width:670px" value="${view.new_addr2 }" />
								<input type="hidden" name="addr1" id="addr1"/>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">개관일</th>
						<td colspan="3">
							<input type="text" name="cul_openday" style="width:670px" value="${view.cul_openday}" />
						</td>
					</tr>
					<tr>
						<th scope="row">휴관일</th>
						<td colspan="3">
							<input type="text" name="cul_closeday" style="width:670px" value="${view.cul_closeday}" />
						</td>
					</tr>
					<tr>
						<th scope="row">홈페이지 URL</th>
						<td colspan="3">
							<input type="text" name="cul_homeurl" style="width:560px" value="${view.cul_homeurl}" />
							<span class="btn whiteS"><a href="#url">유효성검사</a></span>
						</td>
					</tr>
					<tr>
						<th scope="row">전경/구성원 이미지</th>
						<td colspan="3">
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
							<br><br> 300 * 160 px에 맞추어 등록해주시기 바랍니다.
							<c:if test="${not empty view.cul_viewimg1}">
								<div class="inputBox">
									<input type="hidden" name="file_delete" value="${view.cul_viewimg1}" />
									<label><input type="checkbox" name="imagedelete" value="Y" /> <strong>삭제</strong>  ${view.cul_viewimg1}</label>
									<img src="/upload/culSpace/${view.cul_viewimg1}" alt="" />
									<%-- <input type="hidden" name="reference_identifier_org" value="${view.reference_identifier }"/> --%>
								</div>
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">내용</th>
						<td colspan="3">
		        			<!-- 20151006 : 이용환 : 에디터 변경을 위해 수정 
							<textarea id="contents" name="cul_cont" style="width:100%;height:400px;"><c:out value="${view.cul_cont }" escapeXml="true" /></textarea>
							-->
							<script type="text/javascript" language="javascript">
								var CrossEditor = new NamoSE('contents');
								CrossEditor.params.Width = "100%";
								CrossEditor.params.Height = "400px";
								CrossEditor.params.UserLang = "auto";
								CrossEditor.params.UploadFileSizeLimit = "image:10485760";
								CrossEditor.params.Font = {"NanumGothic":"나눔고딕","Dotum":"돋움", "Gulim":"굴림", "Batang":"바탕", "Gungsuh":"궁서", "맑은 고딕":"맑은 고딕"  ,"David":"David", "MS Pgothic":"MS Pgothic","Simplified Arabic":"Simplified Arabic","SimSun":"SimSun","Arial":"Arial","Courier New":"Courier New", "Tahoma":"Tahoma", "Times New Roman":"Times New Roman", "verdana":"Verdana"};
								CrossEditor.EditorStart();
								function OnInitCompleted(e){
									e.editorTarget.SetBodyValue(document.getElementById("contents").value);
								}
							</script>
							<textarea id="contents" name="cul_cont" style="width:100%;height:400px;display:none;"><c:out value="${view.cul_cont }" escapeXml="true" /></textarea>
						
						</td>	
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="post_flag" value="W"/> 대기</label>
								<label><input type="radio" name="post_flag" value="Y"/> 사용</label>
								<label><input type="radio" name="post_flag" value="N" checked/>미사용</label>
							</div>
						</td>
					</tr>
					<c:if test='${not empty view.cul_seq}'>
						<tr>
						<th scope="row">모바일사용여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="mobile_yn" value="Y"  ${not empty view.mdescription ? 'checked="checked"' : '' }/>사용</label>
								<label><input type="radio" name="mobile_yn" value="N" ${empty view.mdescription ? 'checked="checked"' : '' }/>사용안함</label>
							</div>
						</td>
					</tr>
					</c:if>
				</tbody>
			</table>
			
			<div class="sTitBar">
				<h4><label><input type="checkbox" name="rental_yn" value="Y"/>대관 시설 여부(대관 시설일 경우 체크 후 입력)</label></h4>
			</div>
			<div class="tableWrite rentalTable">	
				<table name="recomImgTable" summary="대관시설 정보 등록">
					<caption>대관시설 정보 등록</caption>
					<colgroup>
						<col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row"></th>
							<td colspan="3">
								<label><input id="rental_radio1" name="rental_radio" type="radio" value="out"/> 해당시설 홈페이지 자체 예약</label>
        						<label><input id="rental_radio2" name="rental_radio" type="radio" value="in"/> 문화포털 예약</label>
							</td>
						</tr>
						<tr class="out">
							<th scope="row">시설 예약 URL</th>
							<td colspan="3">
								<input type="text" value="${view.apply_url}" name="apply_url" style="width:535px" />
							</td>
						</tr>
						<tr class="in">
							<th scope="row">수용인원</th>
							<td colspan="3">
								<c:if test="${not empty rentalView.seq}">
									<input type="hidden" name="rental_seq" value="${rentalView.seq}"/>
								</c:if>
								<input type="text" value="${rentalView.person}" name="rental_person" style="width:100px" /> 명
							</td>
						</tr>
						<tr class="in">
							<th scope="row">대관금액</th>
							<td colspan="3">
								<label><input id="charge_yn1" name="rental_charge_yn" type="radio" value="N"/> 무료</label>
        						<label><input id="charge_yn2" name="rental_charge_yn" type="radio" value="Y"/> 유료</label>
        						<span class="block">
         							<input id="charge" value="${rentalView.charge}" name="rental_charge" title="대관금액 입력" style="width:670px" placeholder="평일/주말/공휴일/시간별 등 자세하게 작성해 주시기 바랍니다." type="text" value="" maxlength="1000"/>
        						</span>
        						<p style="margin-top:5px;">ex) 평일 무료, 주말 유료 1시간 기준 000원 , 30분 단위 1000원 추가</p>
							</td>
						</tr>
						<tr class="in">
							<th scope="row">결제방법</th>
							<td colspan="3">
								<textarea id="pay_option" name="rental_pay_option" style="width:99%" title="결제방법 입력" maxlength="1000" placeholder="대관금액 유료의 경우, 결제방법 및 결제관련 유의사항을 작성해 주시기 바랍니다.">${rentalView.pay_option}</textarea>
        						<p style="margin-top:5px;">ex) 실시간 계좌이체 이용  입금 계좌: 신한 000-0000-0000-00 홍길동 <br />관리자의 ‘승인대기’ 후, 익일까지 대관금액 미입금 시 예약이 ‘미 승인’ 처리되오니 유의하시기 바랍니다. </p>
							</td>
						</tr>
						<tr class="in">
							<th scope="row">대관일</th>
							<td colspan="3">
								<input id="rental_dt" value="${rentalView.rental_dt}" name="rental_dt" title="대관일 입력" style="width:535px" placeholder="대관가능 시간이 정해져 있을 경우, 작성해 주시기 바랍니다." type="text" value="" maxlength="400"/>
        						<p style="margin-top:5px;">ex) 평일/주말 09:00 ~ 24:00  주말/주일/공휴일 대관 가능</p>
							</td>
						</tr>
						<tr class="in">
							<th scope="row">지원사항</th>
							<td colspan="3">
								<input id="rental_info" value="${rentalView.rental_info}" name="rental_info" title="지원사항 입력" style="width:535px" placeholder="시설에서 지원하는 사항을 기입해 주시기 바랍니다." type="text" value="" maxlength="1000"/>
        						<p style="margin-top:5px;">ex) 주차시설 지원, 마이크, 프로젝터 지원 </p>
							</td>
						</tr>
						<tr class="in">
							<th scope="row">기타사항</th>
							<td colspan="3">
								<textarea id="other" name="rental_other" style="width:99%" title="기타사항 입력" maxlength="1000" placeholder="기타 안내하실 사항을 입력해 주시기 바랍니다.">${rentalView.other}</textarea>
							</td>
						</tr>
						<tr class="in">
							<th scope="row">승인여부</th>
							<td colspan="3">
								<div class="inputBox">
									<label><input type="radio" name="rental_approval" value="W"/> 대기</label>
									<label><input type="radio" name="rental_approval" value="Y"/> 사용</label>
									<label><input type="radio" name="rental_approval" value="N"/> 미사용</label>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
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