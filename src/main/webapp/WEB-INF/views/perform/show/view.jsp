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
	},
	culturegroup : function(res){
		if(res==null){
			return false;
		}
		$('input[name=rights]').val(res.title);
	}
};

$(function () {
	
	$('input[name=uploadFile]').on('change', function(){
		$('.inputText:not(.styurl)').val($(this).val().substr(12));
	})
	
	$('input[name^=styurl]').on('change',function(){
		var className=$(this).attr("name");
		$('.'+className).val($(this).val().substr(12));
	});
	
	var frm = $('form[name=frm]');
	var reg_date_start = frm.find('input[name=reg_start]');
	var reg_date_end = frm.find('input[name=reg_end]');
	
	var title		= frm.find('input[name=title]');
	var url		= frm.find('input[name=url]');
	var venue		= frm.find('input[name=venue]');
	var time		= frm.find('input[name=time]');
	var extent		= frm.find('input[name=extent]');
	var grade		= frm.find('input[name=grade]');
	var rights		= frm.find('input[name=rights]');
	var charge		= frm.find('input[name=charge]');
	var reference		= frm.find('input[name=reference]');
	
	
	changeNote = function(ele) {
		if(ele) checked = ele.val();
		else checked = $(':radio[name=note1]:checked').val();
	
		if(checked == 'Y') {
			$('input[name=reference_identifier]').hide();
		    $('div.fileInputs:not(.styurl)').show();
		    $('input[name=imagedelete]').parent().show();
		} else if(checked == 'N') {
			$('input[name=reference_identifier]').show();
			$('div.fileInputs:not(.styurl)').hide();
			$('input[name=imagedelete]').parent().hide();
		}
	}
	//layout
	
	new Datepicker(reg_date_start, reg_date_end);
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	if('${view.note1}')$('input:radio[name="note1"][value="${view.note1}"]').prop('checked', 'checked');
	
	//select selected
	if('${view.genre}')$("select[name=genre]").val('${view.genre}').attr("selected", "selected");
	
	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
	/* 20151006 : 이용환 : 에디터 변경을 위해 삭제
	nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	*/
	 
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
	    	if( $(this).data('org') == 'venue'){
	      		window.open('/popup/place.do', 'placePopup', 'scrollbars=yes,width=600,height=630');
	    	} else if( $(this).data('org') == 'rights'){
	      		window.open('/popup/culturegroup.do', 'culturegroupPopup', 'scrollbars=yes,width=600,height=630');
	    	} 
	    	/* else if( $(this).html() == '장소등록'){
	    		location.href='/facility/place/list.do';
	    	}
	    	else if($(this).html() == '주최등록'){
	    		location.href='/facility/group/list.do';
	    	} */
	    	else if( $(this).html() == '미리보기'){
	    		goLink();
	    	}
	  	});
	});
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		if(action == 'delete'){
			return true;
		}
		
		if(title.val() == '') {
		    alert("제목 입력하세요");
		    title.focus();
		    return false;
		}
		
		if($('input[name=note1]:checked').val() == 'Y'){
			if($('input[name=reference_identifier]').val() == ''){
				 alert("썸네일 이미지 선택하세요");
				 $('input[name=reference_identifier]').focus();
				 return false;
			}
		}
		
		if($('input[name=note1]:checked').val() == 'N'){
			if($('input[name=reference_identifier]').val() == ''){
				 alert("이미지 경로 입력하세요");
				 $('input[name=reference_identifier]').focus();
				 return false;
			}
		}
		
		if(url.val() ==''){
			alert('URL 입력하세요');
			url.focus();
			return false;
		}

		if(reg_date_start.val() ==''){
			alert('시작일 입력하세요');
			reg_date_start.focus();
			return false;
		}

		if(reg_date_end.val() ==''){
			alert('종료일 입력하세요');
			reg_date_end.focus();
			return false;
		}
		
		if(venue.val() ==''){
			alert('장소를 입력하세요');
			venue.focus();
			return false;
		}

		if(time.val() ==''){
			alert('시간을 입력하세요');
			time.focus();
			return false;
		}

		if(extent.val() ==''){
			alert('러닝타임을 입력하세요');
			extent.focus();
			return false;
		}
		
		if(grade.val() ==''){
			alert('연령을 입력하세요');
			grade.focus();
			return false;
		}

		if(rights.val() ==''){
			alert('주최 입력하세요');
			rights.focus();
			return false;
		}

		if(charge.val() ==''){
			alert('관람료 입력하세요');
			charge.focus();
			return false;
		}

		if(reference.val() ==''){
			alert('문의 입력하세요');
			reference.focus();
			return false;
		}
		 
		return true;
	});
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		if (!confirm('수정하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/perform/show/update.do');
        		/* 20151006 : 이용환 : 에디터 변경을 위해 수정 
        		oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
        		*/
        		document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		$('input[name=venue2]').val($('input[name=venue]').val());	
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		action = "delete";
        		frm.attr('action' ,'/perform/show/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/perform/show/insert.do');
        		/* 20151006 : 이용환 : 에디터 변경을 위해 수정 
        		oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
        		*/
    			document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		$('input[name=venue2]').val($('input[name=venue]').val());	
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/perform/show/list.do?${paramMap.qr_dec }';
        	}   		
    	});
	});
	
});
</script>
</head>
<body>
	<form name="frm" method="post" action="/perform/show/insert.do" enctype="multipart/form-data">
		<input type="hidden" name="venue2" value=""/>
		<input type="hidden" name="mode" value="view"/>
		<c:if test='${not empty view.uci}'>
			<input type="hidden" name="uci" value="${view.uci}"/>
		</c:if>
		<div class="tableWrite">
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
					<tr>
						<th scope="row">장르</th>
						<td colspan="3">
							<select title="출처 선택" name="genre">
								<c:forEach items="${genreList}" var="list" varStatus="status">
									<option value="${list.value}">${list.name}</option>	
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">기간</th>
						<td colspan="3">
							<input type="text" name="reg_start" value="${view.reg_start }" />
							<span>~</span>
							<input type="text" name="reg_end" value="${view.reg_end }" />
						</td>
					</tr>
					<tr>
						<th scope="row">시간</th>
						<td colspan="3">
							<input type="text" name="time" style="width:670px" value="${view.time}" />
						</td>
					</tr>
					<tr>
						<th scope="row">장소</th>
						<td colspan="3">
							<input type="text" name="venue" style="width:500px" value="${view.venue}" readOnly/><span class="btn whiteS"><a href="#url" data-org='venue'>선택</a></span><span class="btn whiteS"><a href="/facility/place/view.do" target="_blank">장소등록</a></span>
							<input type="hidden" name="location" style="width:500px" value="${view.location}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">문화예술단체</th>
						<td colspan="3">
							<input type="text" name="rights" style="width:500px" value="${view.rights}" readOnly/><span class="btn whiteS"><a href="#url" data-org='rights'>선택</a></span><span class="btn whiteS"><a href="/facility/group/view.do" target="_blank">주최등록</a></span>
<%-- 							<input type="hidden" name="location" style="width:500px" value="${view.rights}"/>
 --%>						</td>
					</tr>
					<tr>
						<th scope="row">관람료</th>
						<td colspan="3">
							<input type="text" name="charge" style="width:670px" value="${view.charge}" />
						</td>
					</tr>
					<tr>
						<th scope="row">러닝타임</th>
						<td colspan="3">
							<input type="text" name="extent" style="width:670px" value="${view.extent}" />
						</td>
					</tr>
							<tr>
						<th scope="row">연령</th>
						<td colspan="3">
							<input type="text" name="grade" style="width:670px" value="${view.grade}" />
						</td>
					</tr>
						<tr>
						<th scope="row">문의</th>
						<td colspan="3">
							<input type="text" name="reference" style="width:670px" value="${view.reference}" />
						</td>
					</tr>
					<tr>
						<th scope="row">썸네일 이미지</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" value="Y" name="note1" checked/> 이미지</label>
								<label><input type="radio" value="N" name="note1"/> url</label>
							</div>
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
							<c:if test="${'Y' eq view.note1}">
								<div class="inputBox">
									<input type="hidden" name="file_delete" value="${view.reference_identifier_org}" />
									<label><input type="checkbox" name="imagedelete" value="Y" /> <strong>삭제</strong>  ${view.reference_identifier_org}</label>
									<input type="hidden" name="reference_identifier_name" value="${view.reference_identifier_org }"/>
								</div>
							</c:if>
<%-- 							<input type="text" name="reference_identifier" id="reference_identifier" style="width:670px"  value="${view.reference_identifier }">
 --%>						</td>
					</tr>
						<tr>
						<th scope="row">홈페이지 URL</th>
						<td colspan="3">
							<input type="text" name="url" style="width:500px" value="${view.url}" /><span class="btn whiteS"><a href="#url">미리보기</a></span>
						</td>
					</tr>
					<!--  상세정보 시작 -->
					<tr>
						<th scope="row">출연진</th>
						<td colspan="3">
							<input type="text" name="prfcast" style="width:670px" value="${view.prfcast}" />
						</td>
					</tr>
					<tr>
						<th scope="row">제작진</th>
						<td colspan="3">
							<input type="text" name="prfcrew" style="width:670px" value="${view.prfcrew}" />
						</td>
					</tr>
					<tr>
						<th scope="row">소개이미지1</th>
						<td colspan="3">
							<div class="fileInputs styurl">
								<input type="file" name="styurl1" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile" style="width:700px;">
									<input type="text" title="" class="inputText styurl styurl1" />
									<span class="btn whiteS"><button>찾아보기</button></span>
									<c:if test="${!empty view.styurl1}">
											<input type="hidden" name="file_delete_styurl1" value="${view.styurl1}" />
											<label><input style="width:13px"  type="checkbox" name="imagedelete_styurl1" value="Y" /> <strong>삭제</strong>  ${view.styurl1}</label>
									</c:if>
								</div>
								
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">소개이미지2</th>
						<td colspan="3">
							<div class="fileInputs styurl">
								<input type="file" name="styurl2" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile" style="width:700px">
									<input type="text" title="" class="inputText styurl styurl2" />
									<span class="btn whiteS"><button>찾아보기</button></span>
									<c:if test="${!empty view.styurl2}">
											<input type="hidden" name="file_delete_styurl2" value="${view.styurl2}" />
											<label><input style="width:13px" type="checkbox" name="imagedelete_styurl2" value="Y" /> <strong>삭제</strong>  ${view.styurl2}</label>
								</c:if>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">소개이미지3</th>
						<td colspan="3">
							<div class="fileInputs styurl">
								<input type="file" name="styurl3" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile" style="width:700px">
									<input type="text" title="" class="inputText styurl styurl3" />
									<span class="btn whiteS"><button>찾아보기</button></span>
									<c:if test="${!empty view.styurl3}">
											<input type="hidden" name="file_delete_styurl3" value="${view.styurl3}" />
											<label><input style="width:13px" type="checkbox" name="imagedelete_styurl3" value="Y" /> <strong>삭제</strong>  ${view.styurl3}</label>
									</c:if>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">소개이미지4</th>
						<td colspan="3">
							<div class="fileInputs styurl">
								<input type="file" name="styurl4" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile" style="width:700px">
									<input type="text" title="" class="inputText styurl styurl4" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								<c:if test="${!empty view.styurl4}">
									<input type="hidden" name="file_delete_styurl4" value="${view.styurl4}" />
									<label><input style="width:13px" type="checkbox" name="imagedelete_styurl4" value="Y" /> <strong>삭제</strong>  ${view.styurl4}</label>
								</c:if>
																</div>
							</div>
						</td>
					</tr>
				
					<!--  상세정보 끝 -->
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
					<c:if test='${not empty view.uci}'>
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
					
					<tr>
						<th scope="row">다운로드</th>
						<td colspan="3">
							<c:if test="${not empty view.web_accessibility_file }">
								<c:url var="urlFile" value="http://www.culture.go.kr/download.do">
									<c:param name="filename" value="${view.web_accessibility_file}" />
									<c:param name="orgname" value="${view.web_accessibility_file_org }" />
								</c:url>
								<a href="${urlFile }" target="_blank">첨부파일 다운로드</a>
							</c:if>
							<c:if test="${empty view.web_accessibility_file  }">-</c:if>
						</td>
					</tr>
				<%-- 	<tr>
						<th scope="row">내용</th>
						<td colspan="3">
		        			<!-- 20151006 : 이용환 : 에디터 변경을 위해 수정 
							<textarea id="contents" name="description" style="width:100%;height:400px;"><c:out value="${view.description }" escapeXml="true" /></textarea>
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
							<textarea id="contents" name="description" title="initText" style="display:none;"><c:out value="${view.description }" escapeXml="true" /></textarea>
						</td>	
					</tr> --%>
					
				</tbody>
			</table>
		
		</div>
		
		<div class="sTitBar">
			<h4>
				<label>줄거리</label>
			</h4>
		</div>
		
		<div class="tableWrite">	
			<table summary="공연/전시 컨텐츠 작성">
			<caption>공연/전시 컨텐츠 글쓰기</caption>
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
						<textarea id="contents" name="description" style="width:100%;height:400px;"><c:out value="${view.description }" escapeXml="true" /></textarea>
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
						<textarea id="contents" name="description" title="initText" style="display:none;"><c:out value="${view.description }" escapeXml="true" /></textarea>
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