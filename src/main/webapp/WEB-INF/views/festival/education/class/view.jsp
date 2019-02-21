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

<script type="text/javascript">
var action = "";

var callback = {
	postalcode :function(res) {
		// res = {"buil_num2":0,"buil_num1":63,"road_name":"구로동로13길","zip_code":152800,"gi_num2":2,"gi_num1":1,"dong_name1":"가리봉동","gu_name":"구로구","sido_name":"서울특별시"}
		
		if (res == null) {
			alert('callback data null');
			return false;
		}
		
		var zip_code = res.zip_code.toString();
	
		$('input[name=location]').val(res.location);
		if($('input[name=zip_yn]:checked').val() == 63)
			setZipCode(res.sido_name , res.gu_name , res.dong_name1 , res.gi_num1 , res.gi_num2 , zip_code.substring(0,3)+"-"+zip_code.substring(3,6));
		else if($('input[name=zip_yn]:checked').val() == 64)
			setZipCode(res.sido_name , res.gu_name , res.road_name , res.buil_num1 , res.buil_num2 , zip_code.substring(0,3)+"-"+zip_code.substring(3,6));
	}
}

function changeName(){
	$("input[name=genre]").each(function(){
		if($(this).prop("checked")){
			if($(this).val()=="1"){
				$("#venueName").text("교육장소");
				$("#instructorName").text("강사");
				$("#chargeName").text("수강료");
			}else if($(this).val()=="2"){
				$("#venueName").text("마을명");
				$("#instructorName").text("담당자");
				$("#chargeName").text("가격");
			}
		}
	});
}


$(function () {
	
	changeName();
	$("input[name=genre]").on("click",function(){
		changeName();
	});
	
	$('input[name=free_yn_before]').change(function(){		
		changeNote1($(this));
	})
	
	changeNote1 = function(ele) {
		checked = ele.val();				
		if(checked == 'Y') {
			$('#anoN').prop('checked', '');
		} else if(checked == 'N') {
			$('#anoY').prop('checked', '');
		}
	
		$('#free_yn').val(checked);
	}
	
	var frm = $('form[name=frm]');
	var start_dt = frm.find('input[name=start_dt]');
	var end_dt = frm.find('input[name=end_dt]');
	var apply_start_dt = frm.find('input[name=apply_start_dt]');
	var apply_end_dt = frm.find('input[name=apply_end_dt]');
	
	var home_page					= frm.find('input[name=home_page]');
	var tel							= frm.find('input[name=tel]');
	var zip_code					= frm.find('input[name=zip_code]');

	//2
	var zip_yn						= frm.find('input[name=zip_yn]');
	var addr1						= frm.find('input[name=addr1]');
	var addr2						= frm.find('input[name=addr2]');

	var location					= frm.find('input[name=location]');

	var title						= frm.find('input[name=title]');
	var rights						= frm.find('input[name=rights]');
	var user_id						= frm.find('input[name=user_id]');
	var auto_yn						= frm.find('input[name=auto_yn]');
	var apply_type					= frm.find('input[name=apply_type]');
	var apply_person_apply			= frm.find('input[name=apply_person_apply]');
	var apply_type					= frm.find('input[name=apply_type]');
	var apply_person_order			= frm.find('input[name=apply_person_order]');
	var apply_person				= frm.find('input[name=apply_person]');
	var venue						= frm.find('input[name=venue]');
	var instructor					= frm.find('input[name=instructor]');
	var charge						= frm.find('input[name=charge]');
	
	changeNote = function(ele) {
		if(ele) checked = ele.val();
		else checked = $(':radio[name=note1]:checked').val();
	
		if(checked == 'Y') {
			$('input[name=reference_identifier]').hide();
		    $('div.fileInputs').show();
		    $('input[name=imagedelete]').parent().show();
		} else if(checked == 'N') {
			$('input[name=reference_identifier]').show();
			$('div.fileInputs').hide();
			$('input[name=imagedelete]').parent().hide();
		}
	}
	//layout
	
	new Datepicker(start_dt, end_dt);
	new Datepicker(apply_start_dt, apply_end_dt);
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	if('${view.auto_yn}')$('input:radio[name="auto_yn"][value="${view.auto_yn}"]').prop('checked', 'checked');
	if('${view.apply_type}') { 
		$('input:radio[name="apply_type"][value="${view.apply_type}"]').prop('checked', 'checked');
		
		value = '${view.apply_type}';
//	  	$('input[name=apply_person]').val(value);
	  
	  	if(value == 'apply') {
	      	$('input[name=apply_person_apply]').val('${view.apply_person}');
	      	$('input[name=apply_person]').val('${view.apply_person}');
	  	} else if(value == 'order') {
	      	$('input[name=apply_person_order]').val('${view.apply_person}');
	      	$('input[name=apply_person]').val('${view.apply_person}');
		}    
	}
	
	//select selected
	if('${view.location}')$("select[name=location]").val('${view.location}').attr("selected", "selected");
	
	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
//	nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	 
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		if(action == 'delete'){
			return true;
		}
		/* 
		if(home_page.val() ==''){
			alert('홈페이지 입력하세요');
			home_page.focus();
			return false;
		}
		
		if(tel.val() ==''){
			alert('전화번호 입력하세요');
			tel.focus();
			return false;
		}
		
		if(zip_code.val() ==''){
			alert('우편번호 선택하세요');
			zip_code.focus();
			return false;
		}

		if(addr1.val() ==''){
			alert('주소 입력하세요');
			addr1.focus();
			return false;
		}
		
		if(addr2.val() ==''){
			alert('상세주소 입력하세요');
			addr2.focus();
			return false;
		}
		
		if(title.val() ==''){
			alert('교육명 입력하세요');
			title.focus();
			return false;
		}
		
		if(rights.val() ==''){
			alert('주회/주관 입력하세요');
			rights.focus();
			return false;
		}
		
		if(user_id.val() ==''){
			alert('작성자 입력하세요');
			user_id.focus();
			return false;
		}
		
		if($('input[name=apply_type]:checked').val() == 'apply' && apply_person_apply.val() == ''){
			alert('모집인원 입력하세요');
			$('input[name=apply_type]').focus();
			return false;
		}

		if($('input[name=apply_type]:checked').val() == 'order' && apply_person_order.val() == ''){
			alert('선착순인원 입력하세요');
			$('input[name=apply_type]').focus();
			return false;
		}

		if(venue.val() ==''){
			alert('교육 장소 입력하세요');
			venue.focus();
			return false;
		}
		
		if(instructor.val() ==''){
			alert('강사 입력하세요');
			instructor.focus();
			return false;
		}
		 
		if(start_dt.val() ==''){
			alert('교육시작일 입력하세요');
			start_dt.focus();
			return false;
		}

		if(end_dt.val() ==''){
			alert('교육종료일 입력하세요');
			end_dt.focus();
			return false;
		}
		
		if(apply_start_dt.val() ==''){
			alert('모집 시작일 입력하세요');
			apply_start_dt.focus();
			return false;
		}

		if(apply_end_dt.val() ==''){
			alert('모집 종료일 입력하세요');
			apply_end_dt.focus();
			return false;
		}
		
		if(charge.val() ==''){
			alert('수강료 입력하세요');
			charge.focus();
			return false;
		}
		 */
		return true;
	});
	
	$('input[name=apply_type]').change(function(){
	  	value = $(this).val();
	  	$('input[name=apply_person]').val('');
	  
	  	if(value == 'ad') {
	  		$('.jqApplyType').hide();
	      	$('input[name=apply_person_apply]').val('');
	      	$('input[name=apply_person_order]').val('');
	  	} else if(value == 'apply') {
	  		$('.jqApplyType').show();
	      	$('input[name=apply_person_order]').val('');
	  	} else if(value == 'order') {
	  		$('.jqApplyType').show();
	      	$('input[name=apply_person_order]').val('');
	      	$('input[name=apply_person_apply]').val('');
		}    
	});
	
	if($('input[name=apply_type]').val() == 'ad'){
		$('.jqApplyType').hide();
	} else {
		$('.jqApplyType').show();
	}
	
	$('input[name=apply_person_apply]').keyup(function(){
		$('input[name=apply_person]').val($('input[name=apply_person_apply]').val());
	});
	
	$('input[name=apply_person_order]').keyup(function(){
		$('input[name=apply_person]').val($('input[name=apply_person_order]').val());
	});
	//주소
	$('span.btn.whiteS a').each(function(){
	  	$(this).click(function(){
	  		if( $(this).html() == '우편번호찾기'){
	  			addrType = $(this).attr("addrType");
	    		//window.open('/popup/postalcode.do?zip_yn=' + $('input[name=zip_yn]:checked').val(),'postalcodePopup' , 'scrollbars=yes,width=570,height=625');
	    		window.open('/popup/jusoPopup.do','postalcodePopup' , 'width=570, height=420, scrollbars=yes, resizable=yes');
	    	} else if( $(this).html() == '좌표찾기'){
	    		window.open('/popup/coordinate.do?from=edu', 'coordinatePopup', 'scrollbars=yes,width=500,height=450');
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
        		frm.attr('action' ,'/festival/education/class/update.do');
 //       		oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
        		document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		action = "delete";
        		frm.attr('action' ,'/festival/education/class/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/festival/education/class/insert.do');
//        		oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
        		document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		window.location.href='/festival/education/class/list.do';
        	}   		
    	});
	});
	
	setZipCode = function (sido,gugun, dong, gi_num1, gi_num2,zip_code){
		$('input[name=zip_code]').val(zip_code);
		$('input[name=addr1]').val(sido+ " " +gugun+ " " +dong+ " " +(gi_num2 != "" ? gi_num1+"-"+gi_num2 : gi_num1) );
	}
	
	setCoordinate = function (cul_gps_x , cul_gps_y){
		$('input[name=gps_lng]').val(cul_gps_x);
		$('input[name=gps_lat]').val(cul_gps_y);
	}
});

//도로명주소 Open Api
function jusoCallBack(sido, gugun, addr, addr2, zipNo){	
	$('input[name=zip_code]').val(zipNo);	//우편번호
	$('input[name=addr1]').val(addr);		//기본주소
	$('input[name=addr2]').val(addr2);		//상세주소
}
</script>
</head>
<body>
	<form name="frm" method="post" action="/festival/education/class/insert.do" enctype="multipart/form-data">
		<input type="hidden" name="free_yn" id="free_yn"/>
		<c:if test='${not empty view.seq}'>
			<input type="hidden" name="seq" value="${view.seq}"/>
		</c:if>
		<div class="tableWrite">	
			<div class="tableWrite">
				<table summary="교육  작성">
					<caption>교육 작성</caption>
					<colgroup>
						<col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						
						<tr>
							<th scope="row">장르</th>
								<c:if test="${empty view }">
								<td colspan="3">
									<div class="inputBox">
										<label><input type="radio" name="genre" value="1" checked/>교육</label>
										<label><input type="radio" name="genre" value="2"/>체험</label>
									</div>
								</td>
								</c:if>
								<c:if test="${!empty view }">
								<td colspan="3">
									<div class="inputBox">
										<label><input type="radio" name="genre" value="1" <c:if test="${view.genre eq 1 }">checked</c:if>/>교육</label>
										<label><input type="radio" name="genre" value="2" <c:if test="${view.genre eq 2 }">checked</c:if>/>체험</label>
									</div>
								</td>
								</c:if>
							</th>
						</tr>
						<tr>
							<th scope="row">프로그램명</th>
							<td colspan="3">
								<input type="text" name="title" id="title" style="width:670px"  value="${view.title }">
							</td>
						</tr>
							<tr>
							<th scope="row">주최/주관</th>
							<td colspan="3">
								<input type="text" name="rights" style="width:670px"  value="${view.rights }">
							</td>
						</tr>
						<tr>
							<th scope="row">교육/체험기간</th>
							<td colspan="3">
								<input type="text" name="start_dt" value="${view.start_dt}" />
								<span>~</span>
								<input type="text" name="end_dt" value="${view.end_dt}" />
							</td>
						</tr>
						<tr>
							<th scope="row" id="venueName">교육장소</th>
							<td colspan="3">
								<input type="text" name="venue" style="width:670px" value="${view.venue }" />
							</td>
						</tr>
					
					
						
					
						<tr>
							<th scope="row" id="instructorName">강사</th>
							<td colspan="3">
								<input type="text" name="instructor" style="width:670px" value="${view.instructor }" />
							</td>
						</tr>
						<tr>
							<th scope="row" id="chargeName">수강료</th>
							<td colspan="3">		
							<input type="checkbox" id="anoY" value="Y" name="free_yn_before" <c:if test="${view.free_yn eq 'Y' }">checked</c:if>/>
							<label for="anoY">유료</label>
							<input type="checkbox" id="anoN" value="N" name="free_yn_before" <c:if test="${view.free_yn eq 'N' }">checked</c:if> />
							<label for="anoN">무료</label>
							<br/>
							<input type="text" name="charge" style="width:400px" value="${view.charge }" />
							</td>
						</tr>
						<tr>
							<th scope="row">홈페이지</th>
							<td colspan="3">
								<%-- 
								<c:if test="${empty view or empty view.home_page }">
									<c:set target="${view }" property="home_page" value="http://" />
								</c:if>
								 --%>
								 <c:if test="${empty view }">
									<input type="text" name="home_page" style="width:670px"  value="http://">
								</c:if>
								<c:if test="${not empty view }">
									<input type="text" name="home_page" style="width:670px"  value="${view.home_page }">
								</c:if>
							</td>
						</tr>
						<tr>
							<th scope="row">문의처</th>
							<td colspan="3">
								<%-- <select title="지역번호 선택하세요" name="tel1" style="width:70px">
									<c:forEach items="${areaTelNumList }" var="areaTelNumList" varStatus="status">
										<option value="${areaTelNumList.value}">${areaTelNumList.name}</option>
									</c:forEach>
								</select>
								-
								<input type="text" maxlength="4" name="tel2" style="width:100px" value="${view.tel2}"/>
								-
								<input type="text" maxlength="4" name="tel3" style="width:100px" value="${view.tel3}"/> --%>
								<input type="text" name="tel" style="width:100px" value="${view.tel}"/>
							</td>
						</tr>
						
							<tr>
							<th scope="row">교육기관<br/>주소</th>
							<td colspan="3">
								<div class="inputBox">
									<input type="text" name="zip_code" style="width:150px" value="${view.zip_code }" readonly="readonly"/>
									<span class="btn whiteS"><a href="#url" addrType="academy">우편번호찾기</a></span>
									<span class="btn whiteS"><a href="#url">좌표찾기</a></span>
									<div style="display:none">
										<label><input type="radio" value="63" name="zip_yn" checked/>지번주소</label>
										<label><input type="radio" value="64" name="zip_yn"/>도로명주소</label>
									</div>
								</div>
								<div class="inputBox">
									<input type="text" name="addr1" style="width:670px" value="${view.addr1 }" readonly="readonly"/>
									<input type="text" name="addr2" style="width:670px" value="${view.addr2 }" />
								</div>
								<div class="inputBox">
									<input type="hidden" name="gps_lat" style="width:150px" value="${view.gps_lat }" />
									<input type="hidden" name="gps_lng" style="width:150px" value="${view.gps_lng }" />
									
									<input type="hidden" name="location" style="width:150px" value="${view.location }" />
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">승인여부</th>
							<td colspan="3">
								<div class="inputBox">
									<label><input type="radio" name="approval" value="W"/> 대기</label>
									<label><input type="radio" name="approval" value="Y"/> 승인</label>
									<label><input type="radio" name="approval" value="N"/> 미승인</label>
								</div>
							</td>
						</tr>
							<tr>
							<th scope="row">작성자</th>
							<td colspan="3">
								<input type="hidden" name="user_id" value="${empty view.user_id ? sessionScope.admin_id : view.user_id }">${empty view.user_id ? sessionScope.admin_id : view.user_id }
							</td>
						</tr>
						
						<!-- <tr>
							<th scope="row">모집구분</th>
							<td colspan="3">
								<select title="지역번호 선택하세요" name="apply_type">
									<option value="">교육 신청자 모집구분을 선택하세요</option>
									<option value="ad">홍보</option>
									<option value="order">선착순</option>
									<option value="apply">모집(신청모집)</option>
								</select>
								<div class="inputBox">
									<label><input type="radio" name="apply_type" value="ad" checked/>&nbsp;홍보</label>
									<label><input type="radio" name="apply_type" value="apply"/>&nbsp;모집</label>
									<input type="text" style="width:50px"  name="apply_person_apply"/> 명
									<label><input type="radio" name="apply_type" value="order"/>&nbsp;선착순</label>
									<input type="text" style="width:50px"  name="apply_person_order"/> 명
									<input type="hidden" style="width:50px" name="apply_person"/> 
								</div>
							</td>
						</tr> -->
						<input type="hidden" name="apply_type" value="ad"/>
						<tr class="jqApplyType">
							<th scope="row">모집 기간</th>
							<td colspan="3">
								<input type="text" name="apply_start_dt" value="${view.apply_start_dt}" />
								<span>~</span>
								<input type="text" name="apply_end_dt" value="${view.apply_end_dt}" />
							</td>
						</tr>
						
						<tr class="jqApplyType">
							<th scope="row">승인구분</th>
							<td colspan="3">
								<!-- <select title="지역번호 선택하세요" name="auto_yn">
									<option value="">교육 신청자 승인구분을 선택하세요</option>
									<option value="Y">승인</option>
									<option value="N">비승인</option>
								</select> -->
								<div class="inputBox">
									<label><input type="radio" name="auto_yn" value="Y" checked/>&nbsp;자동승인</label>
									<label><input type="radio" name="auto_yn" value="N"/>&nbsp;관리자 승인</label>
									<span>※ 모집 또는 선착순일 경우 선택하세요.</span>
								</div>
							</td>
						</tr>
						</tr>
						
					
					</tbody>
				</table>
			</div>
		</div>
		
		<div class="sTitBar">
			<h4>
				<label>상세정보</label>
			</h4>
		</div>
		
		<div class="tableWrite">	
			<table summary="축제/행사 컨텐츠 작성">
			<caption>축제/행사 컨텐츠 글쓰기</caption>
			<colgroup>
				<col style="width:15%" />
				<col style="width:35%" />
				<col style="width:15%" />
				<col style="width:35%" />
			</colgroup>
			<tbody>
				<tr>
					<td colspan="4">
	        			<!-- 20151006 : 이용환 : 에디터 변경을 위해 수정 
						<textarea id="contents" name="content" style="width:100%;height:400px;"><c:out value="${view.content }" escapeXml="true" /></textarea>
						-->
						<script type="text/javascript" language="javascript">
							var CrossEditor = new NamoSE('contents');
							CrossEditor.params.Width = "100%";
							CrossEditor.params.Height = "900px";
							CrossEditor.params.UserLang = "auto";
							CrossEditor.params.UploadFileSizeLimit = "image:10485760";
							CrossEditor.params.Font = {"NanumGothic":"나눔고딕","Dotum":"돋움", "Gulim":"굴림", "Batang":"바탕", "Gungsuh":"궁서", "맑은 고딕":"맑은 고딕"  ,"David":"David", "MS Pgothic":"MS Pgothic","Simplified Arabic":"Simplified Arabic","SimSun":"SimSun","Arial":"Arial","Courier New":"Courier New", "Tahoma":"Tahoma", "Times New Roman":"Times New Roman", "verdana":"Verdana"};
							CrossEditor.EditorStart();
							function OnInitCompleted(e){
								e.editorTarget.SetBodyValue(document.getElementById("contents").value);
							}
						</script>
						<textarea id="contents" name="content" style="width:100%;height:400px;display:none;"><c:out value="${view.content }" escapeXml="true" /></textarea>
					</td>
				</tr>
			</tbody>
			</table>
		</div>
		
	</form>
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