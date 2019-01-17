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
	place : function (res) {
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
			return false;
		}
		
		$('input[name=venue]').val(res.cul_name);
		$('input[name=location]').val(res.cul_addr);
	}
};

$(function () {

	var frm = $('form[name=frm]');
	var reg_date_start = frm.find('input[name=reg_start]');
	var reg_date_end = frm.find('input[name=reg_end]');
	
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
	
	new Datepicker(reg_date_start, reg_date_end);
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	if('${view.note1}')$('input:radio[name="note1"][value="${view.note1}"]').prop('checked', 'checked');
	
	//select selected
	if('${view.location}')$("select[name=location]").val('${view.location}').attr("selected", "selected");
	
	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
//	nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	 
	//썸네일 이미지 	 
	changeNote();
	
	$('input[name=note1]').change(function(){
		changeNote($(this));
	})
		
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
	    	}
	  	});
	});
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		console.log('수정');
        		frm.attr('action' ,'/festival/education/update.do');
        		//oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
        		document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		console.log('삭제');
        		frm.attr('action' ,'/festival/education/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		console.log('등록');
        		frm.attr('action' ,'/festival/education/insert.do');
        		//oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
        		document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		console.log('목록');
        		location.href='/festival/education/list.do';
        	}   		
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/festival/education/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.uci}'>
				<input type="hidden" name="uci" value="${view.uci}"/>
			</c:if>
			<table summary="공연/전시  작성">
				<caption>공연/전시 글쓰기</caption>
				<colgroup>
					<col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">제목</th>
						<td colspan="3">
							<input type="text" name="title" id="title" style="width:670px"  value="${view.title }">
						</td>
					</tr>
					<c:if test="${ not empty view } ">
						<tr>
							<th scope="row">출처/작성자</th>
							<td>
								${view.creator}
							</td>
							<th scope="row">등록일</th>
							<td>
								${view.reg_date}
							</td>
						</tr>
					</c:if>
					<tr>
						<th scope="row">기간</th>
						<td colspan="3">
							<input type="text" name="reg_start" value="${view.reg_start }" />
							<span>~</span>
							<input type="text" name="reg_end" value="${view.reg_end }" />
						</td>
					</tr>
					<tr>
						<th scope="row">지역</th>
						<td>
							<select title="출처 선택" name="location">
								<c:forEach items="${locationList}" var="list" varStatus="status">
									<option value="${list.value}">${list.name}</option>	
								</c:forEach>
							</select>
						</td>
							<th scope="row">장소</th>
						<td>
							<input type="text" name="venue" style="width:250px" value="${view.venue}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">주최/주관</th>
						<td colspan="3">
							<input type="text" name="rights" style="width:670px" value="${view.rights}" />
						</td>
					</tr>
					<tr>
						<th scope="row">공식홈페이지</th>
						<td colspan="3">
							<input type="text" name="home_page" style="width:670px" value="${view.home_page}" />
						</td>
					</tr>
					<tr>
						<th scope="row">내용</th>
						<td colspan="3">
		        			<!-- 20151006 : 이용환 : 에디터 변경을 위해 수정 
							<textarea id="contents" name="description" style="width:100%;height:400px;"><c:out value="${view.description }" escapeXml="true" /></textarea>
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
							<textarea id="contents" name="description" style="width:100%;height:400px;display:none;"><c:out value="${view.description }" escapeXml="true" /></textarea>
						
						</td>	
					</tr>
					<tr>
						<th scope="row">요청사항</th>
						<td colspan="3">
							<textarea name="request" style="width:100%;height:100px;"><c:out value="${view.request }" escapeXml="true" /></textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval" value="W"/> 대기</label>
								<label><input type="radio" name="approval" value="Y"/> 사용</label>
								<label><input type="radio" name="approval" value="N"/> 미사용</label>
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