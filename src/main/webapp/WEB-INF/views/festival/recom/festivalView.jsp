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

var viewYN = false;
var performIndex = 0 ;
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
			
			console.log(JSON.stringify(res));
			$('#s_title_' + performIndex).val(res.title);
			$('#s_seq_' + performIndex).val(res.seq);
			$('#uci_' + performIndex).val(res.uci);
			$('#place_' + performIndex).val(res.rights);
			$('#period_' + performIndex).val(res.period);
			
			if(res.referenceIdentifier){
				$('#s_thumb_url_' + performIndex).val(res.referenceIdentifier);
				if(viewYN){
					$('#img' + performIndex).attr('src' , res.referenceIdentifier);
				} else {
					$('#img' + performIndex).remove();
					$('#preformCopy' + performIndex).append('<img id="img' + performIndex + '" src="' + res.referenceIdentifier + '"/>');
				}
			}
			if(res.referenceIdentifierOrg){
				$('#s_thumb_url_' + performIndex).val('/upload/rdf/' + res.referenceIdentifierOrg);
				if(viewYN){
					$('#img' + performIndex).attr('src' , 'http://www.culture.go.kr/upload/rdf/' + res.referenceIdentifierOrg);
				}else {
					$('#img' + performIndex).remove();
					$('#preformCopy' + performIndex).append('<img id="img' + performIndex + '" src="http://www.culture.go.kr/upload/rdf/' + res.referenceIdentifierOrg + '"/>');
				}
			}
	}
}

$(function () {

	var frm = $('form[name=frm]');
	var menuType = frm.find('input[name=menuType]');
	var title		= frm.find('input[name=title]');
	var s_title		= frm.find('input[name=s_title]');
	
	if("${view.seq}") viewYN=true;
	//layout
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	
	//축제/행사 선택
	$('span.btn.whiteS a').each(function(){
	  	$(this).click(function(){
	    	if( $(this).html() == '축제/행사선택'){
	    		performIndex = $(this).attr("index");
	      		window.open('/popup/rdfMetadataFestival.do', 'placePopup', 'scrollbars=yes,width=600,height=600');
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
		
		var recomFestivalCnt = 0;

		s_title.each(function(){
		  if(!$(this).val() =='')
		        recomFestivalCnt++;
		  
		});

		var rtnFlg = true;
		$('input[name=s_title]').each(function(){
			if($(this).val() == '' && rtnFlg){
				alert("축제/행사를 선택해주세요.");
				$(this).focus();
				rtnFlg = false;
			}
		});
		return rtnFlg;
		
/* 		if(s_title.val() ==''){
			alert('축제 선택하세요');
			s_title.focus();
			return false;
		} */
		
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
		<form name="frm" method="post" action="/perform/place/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<input type="hidden" name="menuType" value="${paramMap.menuType}"/>
			<table summary="추천축제/행사 등록/수정">
				<caption>추천축제/행사 등록/수정</caption>
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
						<th scope="row">백그라운드 이미지</th>
						<td colspan="3">
							310*70 사이즈로 등록해주세요.<br />
							<c:if test="${not empty view.bg_img}">
								<div class="inputBox">
									<img src="/upload/theme/<c:out value="${view.bg_img}" />" style="width:310px;height:70px" />
								</div>
							</c:if>
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
							<c:if test="${not empty view.bg_img}">
								<div class="inputBox">
									<input type="hidden" name="file_delete" value="${view.bg_img}" />
									<label><input type="checkbox" name="imagedelete" value="Y" /> <strong>삭제</strong>  ${view.bg_img}</label>
									<%-- <input type="hidden" name="reference_identifier_org" value="${view.reference_identifier }"/> --%>
								</div>
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">소개</th>
						<td colspan="3">
							<textarea id="description" name="description" style="width:100%;height:100px;"><c:out value="${view.description }" escapeXml="true" /></textarea>
						</td>
					</tr>
					
					<!-- sub list start -->
					<c:if test="${ empty subList}">
						<c:forEach begin="0" end="4" varStatus="status">
							<tr>
								<th scope="row">축제/행사${status.count}</th>
								<td colspan="3">
									<input type="hidden" id="tmp_seq_<c:out value="${status.count}" />" name="tmp_seq"/>
									<input type="hidden" id="s_seq_<c:out value="${status.count}" />" name="s_seq"/>
									<input type="hidden" id="s_thumb_url_<c:out value="${status.count}" />" name="s_thumb_url"/>
									<input type="hidden" id="uci_<c:out value="${status.count}" />" name="uci"/>
									<input type="hidden" id="place_<c:out value="${status.count}" />" name="place"/>
									<input type="hidden" id="period_<c:out value="${status.count}" />" name="period"/>
									
									<input type="text" id="s_title_<c:out value="${status.count}" />" name="s_title" style="width:500px">
									<span class="btn whiteS"><a href="#url" index="${status.count}">축제/행사선택</a></span>
								</td>
							</tr>
						</c:forEach>
					</c:if>
					<c:if test="${ not empty subList}">
						<c:forEach items="${subList}" var="subList" varStatus="status">
							<tr>
								<th scope="row">축제/행사${status.count}</th>
								<td colspan="3">
									<input type="hidden" id="tmp_seq_<c:out value="${status.count}" />" name="tmp_seq" value="<c:out value="${subList.seq}" />" />
									<input type="hidden" id="s_seq_<c:out value="${status.count}" />" name="s_seq" value="<c:out value="${subList.s_seq}" />" />
									<input type="hidden" id="s_thumb_url_<c:out value="${status.count}" />" name="s_thumb_url" value="<c:out value="${subList.s_thumb_url}" />" style="width:180px;height:130px" />
									<input type="hidden" id="uci_<c:out value="${status.count}" />" name="uci" value="<c:out value="${subList.uci}" />" />
									<input type="hidden" id="place_<c:out value="${status.count}" />" name="place" value="<c:out value="${subList.place}" />" />
									<input type="hidden" id="period_<c:out value="${status.count}" />" name="period" value="<c:out value="${subList.period}" />" />
								
									<input type="text" id="s_title_<c:out value="${status.count}" />" name="s_title" style="width:500px" value='<c:out value="${subList.s_title}"/>'>
									<span class="btn whiteS"><a href="#url" index="${status.count}">축제/행사선택</a></span>
								</td>
							</tr>
						</c:forEach>
						<c:if test="${fn:length(subList) lt 5  }">
							<c:forEach begin="${fn:length(subList) + 1}" end="5" var="status">
								<tr>
									<th scope="row">축제/행사${status}</th>
									<td colspan="3">
										<input type="hidden" id="tmp_seq_<c:out value="${status}" />" name="tmp_seq"/>
										<input type="hidden" id="s_seq_<c:out value="${status}" />" name="s_seq"/>
										<input type="hidden" id="s_thumb_url_<c:out value="${status}" />" name="s_thumb_url"/>
										<input type="hidden" id="uci_<c:out value="${status}" />" name="uci"/>
										<input type="hidden" id="place_<c:out value="${status}" />" name="place"/>
										<input type="hidden" id="period_<c:out value="${status}" />" name="period"/>
										
										<input type="text" id="s_title_<c:out value="${status}" />" name="s_title" style="width:500px">
										<span class="btn whiteS"><a href="#url" index="${status}">축제/행사선택</a></span>
									</td>
								</tr>
							</c:forEach>
						</c:if>
					</c:if>
					<!-- sub list end -->
					
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