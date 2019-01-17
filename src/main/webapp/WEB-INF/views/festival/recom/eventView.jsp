<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
var action = "";
var subListYN = false;

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
			/* <input type="text" id="tmp_seq" />" name="tmp_seq" value="${subList[0].seq}"/>
			<input type="text" id="s_seq" />" name="s_seq" value="${subList[0].s_seq}"/>
			<input type="text" id="s_thumb_url" name="s_thumb_url" value="${subList[0].s_thumb_url}"/>
			<input type="text" id="uci" name="uci" value="${subList[0].uci}"/>
			<input type="text" id="place" name="place" value="${subList[0].place}"/>
			<input type="text" id="period" name="period" value="${subList[0].period}"/>
			
			<input type="text" id="s_title_<c:out value="${status.count}" />" name="s_title" style */
			console.log(JSON.stringify(res));
			$('#s_title').val(res.title);
			$('#s_seq').val(res.seq);
			$('#uci' ).val(res.uci);
			$('#place').val(res.rights);
			$('#period').val(res.period);
			
			if(res.referenceIdentifier){
				$('#s_thumb_url').val(res.referenceIdentifier);
				if(subListYN){
					$('#displayThumbImg').attr('src' , res.referenceIdentifier);
				} else {
					$('#img').remove();
					$('#preformCopy').append('<img id="img' + '" src="' + res.referenceIdentifier + '"/>');
				}
			}
			if(res.referenceIdentifierOrg){
				$('#s_thumb_url').val('/upload/rdf/' + res.referenceIdentifierOrg);
				if(subListYN){
					$('#displayThumbImg').attr('src' , 'http://www.culture.go.kr/upload/rdf/' + res.referenceIdentifierOrg);
				}else {
					$('#img').remove();
					$('#preformCopy').append('<img id="img' + '" src="http://www.culture.go.kr/upload/rdf/' + res.referenceIdentifierOrg + '"/>');
				}
			}
		}
}

$(function () {

	var frm = $('form[name=frm]');
	var menuType = frm.find('input[name=menuType]');
	
	var menuType		= frm.find('input[name=menuType]');
	var title		= frm.find('input[name=title]');
	var s_title		= frm.find('input[name=s_title]');

	//layout
	
	if('${subList[0].seq}') subListYN = true;
	
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');

	//공연상 선택
	$('span.btn.whiteS a').each(function(){
	  	$(this).click(function(){
	  		if( $(this).html() == '행사선택'){
	    		performIndex = $(this).attr("index");
	      		window.open('/popup/rdfMetadataEvent.do', 'placePopup', 'scrollbars=yes,width=400,height=300');
	    	} 
	  	});
	});
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		if(action == 'delete'){
			return true;
		}
		
		if(title.val() ==''){
			alert('테마제목 입력하세요');
			title.focus();
			return false;
		}

		if($('textarea[name=description]').val() == ''){
			alert('테마소개 입력하세요');
			$('textarea[name=description]').focus();
			return false;
		}
		
		if(s_title.val() ==''){
			alert('행사 선택하세요');
			s_title.focus();
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
        		frm.attr('action' ,'/festival/recom/' + menuType.val() + '/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		action = "delete";
        		frm.attr('action' ,'/festival/recom/' + menuType.val() + '/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/festival/recom/' + menuType.val() + '/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/festival/recom/' + menuType.val() + '/list.do';
        	}   		
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/festival/recom/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<input type="hidden" name="menuType" value="${paramMap.menuType}"/>
			<table summary="공연장 등록/수정">
				<caption>공연장 등록/수정</caption>
				<colgroup>
					<col style="width:17%" /><col style="width:33%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">테마제목</th>
						<td colspan="3">
							<input type="text" name="title" style="width:670px" value="${view.title}" />
						</td>
					</tr>
					<tr>
						<th scope="row">테마소개</th>
						<td colspan="3">
							<textarea id="description" name="description" style="width:100%;height:100px;"><c:out value="${view.description }" escapeXml="true" /></textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">행사명</th>
						<td colspan="3">
							<input type="hidden" id="tmp_seq" name="tmp_seq" value="${subList[0].seq}"/>
							<input type="hidden" id="s_seq" name="s_seq" value="${subList[0].s_seq}"/>
							<input type="hidden" id="s_thumb_url" name="s_thumb_url" value="${subList[0].s_thumb_url}"/>
							<input type="hidden" id="uci" name="uci" value="${subList[0].uci}"/>
							<input type="hidden" id="place" name="place" value="${subList[0].place}"/>
							<input type="hidden" id="period" name="period" value="${subList[0].period}"/>
							
							<input type="text" id="s_title" name="s_title" style="width:550px" value="${subList[0].s_title}">
							<span class="btn whiteS"><a href="#url" index="${status.count}">행사선택</a></span>
						</td>
					</tr>
					<%-- <tr>
						<th scope="row">전시 이미지</th>
						<td colspan="3">
							<span id="preformCopy">
								<c:if test="${ not empty subList[0].s_thumb_url}">
									<img id="displayThumbImg" src="/upload/rdf/<c:out value="${subList[0].s_thumb_url}" />" />
								</c:if>
							<br/>
							<div id="performInfo">
							</div>
							</span>
						</td>
					</tr> --%>
					<tr>
						<th scope="row">행사이미지</th>
						<td colspan="3">
						1037*195 사이즈로 등록해주세요.
						<c:if test="${not empty subList[0].img_name1}">
									<img src="/upload/theme/<c:out value="${subList[0].img_name1}" />"style="width:650px;height:122px" />
							</c:if>
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
							<c:if test="${not empty subList[0].img_name1}">
								<div class="inputBox">
									<label><input type="checkbox" name="imagedelete" value="Y" /> <strong>삭제</strong>  ${subList[0].img_name1}</label>
								</div>
							</c:if>
						</td>
					</tr>
					<%-- <tr>
						<th scope="row">추가 이미지2</th>
						<td colspan="3">
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
							<c:if test="${not empty subList[0].img_name2}">
								<div class="inputBox">
									<label><input type="checkbox" name="imagedelete" value="Y" /> <strong>삭제</strong>  ${subList[0].img_name2}</label>
								</div>
							</c:if>
						</td>
					</tr> --%>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval" value="W"/> 대기</label>
								<label><input type="radio" name="approval" value="Y"/> 사용</label>
								<label><input type="radio" name="approval" value="N" checked/> 미사용</label>
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