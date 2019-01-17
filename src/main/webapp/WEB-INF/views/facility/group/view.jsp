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


var callback = {
		postalcode :function(res) {
			// res = {"buil_num2":0,"buil_num1":63,"road_name":"구로동로13길","zip_code":152800,"gi_num2":2,"gi_num1":1,"dong_name1":"가리봉동","gu_name":"구로구","sido_name":"서울특별시"}
			
			if (res == null) {
				alert('callback data null');
				return false;
			}
			
			var zip_code = res.zip_code.toString();
			
			if($('input[name=zip_yn]:checked').val() == 63)
				setZipCode(res.sido_name , res.gu_name , res.dong_name1 , res.gi_num1 , res.gi_num2 , zip_code.substring(0,3)+"-"+zip_code.substring(3,6));
			else if($('input[name=zip_yn]:checked').val() == 64)
				setZipCode(res.sido_name , res.gu_name , res.road_name , res.buil_num1 , res.buil_num2 , zip_code.substring(0,3)+"-"+zip_code.substring(3,6));
		}
};

$(function () {

	var frm = $('form[name=frm]');
	var cul_place		= frm.find('input[name=cul_place]');
	var cul_place2		= frm.find('input[name=cul_place2]');
	var name			= frm.find('input[name=name]');
	var uploadFile		= frm.find('input[name=uploadFile]');
	var undefined		= frm.find('input[name=undefined]');
	var title			= frm.find('input[name=title]');
	var url				= frm.find('input[name=url]');
	var tel				= frm.find('input[name=tel]');
	var zip_code		= frm.find('input[name=zip_code]');
	//2
	var zip_yn			= frm.find('input[name=zip_yn]');
	var addr1			= frm.find('input[name=addr1]');
	var addr2			= frm.find('input[name=addr2]');
	//3
	var approval		= frm.find('input[name=approval]');
	
	//layout
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	if('${view.zip_yn}')$('input:radio[name="zip_yn"][value="${view.zip_yn}"]').prop('checked', 'checked');

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
//	nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	 
	$('input[name=note1]').change(function(){
		changeNote($(this));
	})
		
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		if($('#group_type_code').val() == ''){
			alert('단체구분을 입력하세요');
			$('#group_type_code').focus();
			return false;
		}
		if(name.val() ==''){
			alert('단체명 입력하세요');
			name.focus();
			return false;
		}
		
		if(title.val() ==''){
			alert('대표작 입력하세요');
			title.focus();
			return false;
		}

		if($('textarea[name=sub_content]').val() ==''){
			alert('간략한소개 입력하세요');
			$('textarea[name=sub_content]').focus();
			return false;
		}
		
		<%--
		if(url.val() ==''){
			alert('홈페이지 입력하세요');
			url.focus();
			return false;
		}
		--%>
		
		if(tel.val() ==''){
			alert('연락처 입력하세요');
			tel.focus();
			return false;
		}
		
		if(zip_code.val() ==''){
			alert('우편번호 입력하세요');
			zip_code.focus();
			return false;
		}
		
		if(addr1.val() ==''){
			alert('상세주소 입력하세요');
			addr1.focus();
			return false;
		}
		
		if(addr2.val() ==''){
			alert('주소 입력하세요');
			addr2.focus();
			return false;
		}
		
		return true;
	});
	//공연상 선택
	$('span.btn.whiteS a').each(function(){
	  	$(this).click(function(){
	    	if( $(this).html() == '우편번호찾기'){
	    		//window.open('/popup/postalcode.do?zip_yn=' + $('input[name=zip_yn]:checked').val(),'postalcodePopup' , 'scrollbars=yes,width=500,height=420');
	    		window.open('/popup/jusoPopup.do','postalcodePopup' , 'width=570, height=420, scrollbars=yes, resizable=yes');
	    	} else if( $(this).html() == '유효성검사'){
	    		window.open($('input[name=url]').val());
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
        		frm.attr('action' ,'/facility/group/update.do');
        		//oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
        		document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/facility/group/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/facility/group/insert.do');
        		//oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
        		document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/facility/group/list.do';
        	}   		
    	});
	});
	
	setZipCode = function (sido,gugun, dong, gi_num1, gi_num2,zip_code){
		$('input[name=zip_code]').val(zip_code);
		$('input[name=addr1]').val(sido+ " " +gugun+ " " +dong+ " " +(gi_num2 != "" ? gi_num1+"-"+gi_num2 : gi_num1) );
	};
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
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/facility/place/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<input type="hidden" value="서울" name="cul_place"/>
			<input type="hidden" value="영등포구" name="cul_place2"/>
			<table summary="공연장 등록/수정">
				<caption>공연장 등록/수정</caption>
				<colgroup>
					<col style="width:17%" /><col style="width:33%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">단체구분</th>
						<td colspan="3">
							<select title="단체구분" name="group_type_code" id="group_type_code">
								<option value="" ${view.group_type_code eq '' ? 'selected="selected"':''}>단체구분</option>							
								<c:forEach  items="${facilityGroupTypeList}" var="li">
									<option value="${li.code}" ${view.group_type_code eq li.code ? 'selected="selected"':''}>${li.name}</option>							
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">단체명</th>
						<td colspan="3">
							<input type="text" name="name" style="width:670px" value="${view.name}" />
						</td>
					</tr>
					<tr>
						<th scope="row">썸네일이미지</th>
						<td colspan="3">
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
							<c:if test="${not empty view.img_file}">
								<div class="inputBox">
									<label><input type="checkbox" name="imagedelete" value="Y" /> <strong>삭제</strong>  ${view.img_file}</label>
									<%-- <input type="hidden" name="reference_identifier_org" value="${view.reference_identifier }"/> --%>
								</div>
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">대표작</th>
						<td colspan="3">
							<input type="text" name="title" style="width:670px" value="${view.title }" />
						</td>
					</tr>
					<tr>
						<th scope="row">간략한 소개</th>
						<td colspan="3">
							<textarea name="sub_content" style="width:100%;height:100px;"><c:out value="${view.sub_content }" escapeXml="true" /></textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">홈페이지</th>
						<td colspan="3">
							<input type="text" name="url" style="width:560px" value="${view.url}" />
							<span class="btn whiteS"><a href="#url">유효성검사</a></span>
						</td>
					</tr>
					<tr>
						<th scope="row">연락처</th>
						<td colspan="3">
							<input type="text" name="tel" style="width:260px" value="${view.tel }" />
						</td>

					</tr>
					<tr>
						<th scope="row">주소</th>
						<td colspan="3">
							<div class="inputBox">
								<input type="text" name="zip_code" style="width:150px" value="${view.zip_code }" readonly="readonly"/>
								<span class="btn whiteS"><a href="#url">우편번호찾기</a></span>
								<div style="display:none">
									<label><input type="radio" value="63" name="zip_yn" checked="checked"/>지번주소</label>
									<label><input type="radio" value="64" name="zip_yn"/>도로명주소</label>
								</div>
							</div>
							<div class="inputBox">
								<input type="text" name="addr1" style="width:670px" value="${view.addr1 }" readonly="readonly"/>
								<input type="text" name="addr2" style="width:670px" value="${view.addr2 }" />
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">내용</th>
						<td colspan="3">
		        			<!-- 20151006 : 이용환 : 에디터 변경을 위해 수정 
							<textarea id="contents" name="content" style="width:100%;height:400px;"><c:out value="${view.content }" escapeXml="true" /></textarea>
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
							<textarea id="contents" name="content" style="width:100%;height:400px;display:none;"><c:out value="${view.content }" escapeXml="true" /></textarea>
						</td>	
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval" value="W"/> 대기</label>
								<label><input type="radio" name="approval" value="Y"/> 승인</label>
								<label><input type="radio" name="approval" value="N" checked="checked"/> 미승인</label>
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