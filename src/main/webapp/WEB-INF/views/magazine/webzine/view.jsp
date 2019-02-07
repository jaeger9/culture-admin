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

var metaType = "";

var cultureIssIndex = 0; 		//문화이슈
var cultureRecomIndex = 0; 		//문화공감
//var columnIndex = 0; 			//칼럼
var relayticketIndex = 0; 		//릴레이티켓
var eventIndex = 0;				//이벤트
var performIndex = 0;			//공연/전시
var cultureImageIndex = 0;		//문화영상
var patternIndex = 0;			//전통디자인
var culturenewsIndex = 0;		//문화소식
var festivalIndex = 0;			//행사/축제/교육

//시퐁 hidden 다 똑같네....이걸로 hidden 값 처리 해줘도 되잖아 그냥 pass
setResponseData = function(selectorname , res){
	$('#' + selectorname).find('input').each(function(){
		inputForm = $(this);
		name = inputForm.attr('name');
		
		if(name == 'subTitle')inputForm.val(res.title);
		if(name == 'file_name')inputForm.val(res.referenceIdentifier);
		if(name == 'url')inputForm.val(res.url);
		
		if(name == 'period')inputForm.val(res.period);
		if(name == 'place')inputForm.val(res.venue);
		if(name == 'rights')inputForm.val(res.rights);
		if(name == 'uci')inputForm.val(res.uci);
		
		$('#' + performType + eval(performType + 'Index') + ' td span:first').html(res.title);
	});
};

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

			console.log('id:' +  metaType + eval(metaType + 'Index'));
			$('#' + metaType + eval(metaType + 'Index')).find('input').each(function(){
				inputForm = $(this);
				name = inputForm.attr('name');
				
				if(name == 'subTitle')inputForm.val(res.title);
				if(name == 'file_name'){
					if(res.referenceIdentifier)inputForm.val(res.referenceIdentifier);
					if(res.referenceIdentifierOrg)inputForm.val('/upload/rdf/'+res.referenceIdentifierOrg);
				}
				if(name == 'content')inputForm.val(res.content);
				if(name == 'url')inputForm.val('/perform/performView.do?uci=' + res.uci);
				
				$('#' + metaType + eval(metaType + 'Index') + ' td span:first').html(res.title);
			});
			
			return true;
		},rdfMetadataBoth : function (res) {
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

		console.log('id:' +  metaType + eval(metaType + 'Index'));
		$('#' + metaType + eval(metaType + 'Index')).find('input').each(function(){
			inputForm = $(this);
			name = inputForm.attr('name');
			
			if(name == 'subTitle')inputForm.val(res.title);
			if(name == 'file_name'){
				if(res.referenceIdentifier)inputForm.val(res.referenceIdentifier);
				if(res.referenceIdentifierOrg)inputForm.val('/upload/rdf/'+res.referenceIdentifierOrg);
			}
			if(name == 'content')inputForm.val(res.content);
			if(name == 'url')inputForm.val('/festival/festivalView.do?uci=' + res.uci);
			
			$('#' + metaType + eval(metaType + 'Index') + ' td span:first').html(res.title);
		});
		
		return true;
	},cultureiss : function(res) { 
			if (res == null) {
				alert('CallBack Res Null');
				return false;
			};
			
			console.log(JSON.stringify(res));
			$('#cultureIss' + cultureIssIndex).find('input').each(function(){
				inputForm = $(this);
				name = inputForm.attr('name');
					
				if(name == 'subTitle')inputForm.val(res.title);
				if(name == 'file_name')inputForm.val(res.image);
				if(name == 'content')inputForm.val(res.content);
				if(name == 'url')inputForm.val(res.url);
				
				$('#cultureIss' + cultureIssIndex + ' td span:first').html(res.title);
			});
		},culturerecom : function(res) { 
			if (res == null) {
				alert('CallBack Res Null');
				return false;
			};
			
			console.log(JSON.stringify(res));
			$('#cultureRecom' + cultureRecomIndex).find('input').each(function(){
				inputForm = $(this);
				name = inputForm.attr('name');
					
				if(name == 'subTitle')inputForm.val(res.title);
				if(name == 'file_name')inputForm.val(res.image);
				if(name == 'content')inputForm.val(res.content);
				if(name == 'url')inputForm.val(res.url);
				
				$('#cultureRecom' + cultureRecomIndex + ' td span:first').html(res.title);
			});
		},portalcolumn : function(res) {
			if (res == null) {
				alert('CallBack Res Null');
				return false;
			};
			
			$('#column' + columnIndex).find('input').each(function(){
				inputForm = $(this);
				name = inputForm.attr('name');
					
				if(name == 'subTitle')inputForm.val(res.title);
				if(name == 'file_name')inputForm.val(res.image);
				if(name == 'content')inputForm.val(res.content);
				if(name == 'url')inputForm.val('/magazine/columnView.do?seq=' + res.seq);
				
				$('#column' + columnIndex + ' td span:first').html(res.title);
			});
		},event : function(res) {
			if (res == null) {
				alert('CallBack Res Null');
				return false;
			};
			
			console.log(JSON.stringify(res));
			$('#event' + eventIndex).find('input').each(function(){
				inputForm = $(this);
				name = inputForm.attr('name');
					
				if(name == 'subTitle')inputForm.val(res.title);
				if(name == 'file_name')inputForm.val(res.image);
				if(name == 'content')inputForm.val(res.content);
				//if(name == 'url')inputForm.val('/magazine/columnView.do?seq=' + res.seq);
				if(name == 'url')inputForm.val(res.url);
				
				$('#event' + eventIndex + ' td span:first').html(res.title);
			});
		},ucc : function(res) { 
			if (res == null) {
				alert('CallBack Res Null');
				return false;
			};
			
			$('#cultureImage' + cultureImageIndex).find('input').each(function(){
				inputForm = $(this);
				name = inputForm.attr('name');
				
				if(name == 'subTitle')inputForm.val(res.title);
				if(name == 'url')inputForm.val(res.url);
				if(name == 'file_name')inputForm.val(res.image);
				if(name == 'content')inputForm.val(res.summary);
				
				$('#cultureImage' + cultureImageIndex + ' td span:first').html(res.title);
			});
		}, patterncode : function(res) { 
			if (res == null) {
				alert('CallBack Res Null');
				return false;
			};
			console.log(JSON.stringify(res));
			$('#pattern' + patternIndex).find('input').each(function(){
				inputForm = $(this);
				name = inputForm.attr('name');
					
				if(name == 'subTitle')inputForm.val(res.xtitle);
				if(name == 'file_name')inputForm.val(res.image);
				if(name == 'url')inputForm.val(res.url);
				if(name == 'content')inputForm.val(res.xabstract);
				
				
				$('#pattern' + patternIndex + ' td span:first').html(res.xtitle);
			});
		},culturenews : function(res){
			if (res == null) {
				alert('CallBack Res Null');
				return false;
			};
			console.log(JSON.stringify(res));
			$('#culturenews' + culturenewsIndex).find('input').each(function(){
				inputForm = $(this);
				name = inputForm.attr('name');
				var type = "";
				if(res.type == "46"){
					type = "[뉴스]"+res.title;
				}else if(res.type == "52"){
					type = "[채용]"+res.title;
				}
				if(name == 'subTitle')inputForm.val(type);
				//if(name == 'file_name')inputForm.val(res.image);
				if(name == 'url')inputForm.val(res.url);
				//if(name == 'content')inputForm.val(res.xabstract);
				
				
				$('#culturenews' + culturenewsIndex + ' td span:first').html(type);
			});
		},education:function(res){
			if (res == null) {
				alert('CallBack Res Null');
				return false;
			};

			console.log(JSON.stringify(res));
			$('#festival' + festivalIndex).find('input').each(function(){
				inputForm = $(this);
				name = inputForm.attr('name');
				
				if(name == 'subTitle')inputForm.val(res.title);
				if(name == 'url')inputForm.val('/edu/educationView.do?seq=' + res.seq);
				if(name == 'uci')inputForm.val(res.uci);
				if(name == 'summary')inputForm.val(res.seq);
				
				$('#festival' + festivalIndex + ' td span:first').html(res.title);
			});
		},relayticket : function(res) { 
			if (res == null) {
				alert('CallBack Res Null');
				return false;
			};
			
			console.log(JSON.stringify(res));
			$('#relayticket' + relayticketIndex).find('input').each(function(){
				inputForm = $(this);
				name = inputForm.attr('name');
					
				if(name == 'subTitle')inputForm.val(res.title);
				if(name == 'file_name')inputForm.val(res.imgUrl);
				
				var content = "";
				if(res.place != "") content += '장소:' + res.place;
				if(res.period != ""){
					if(content == "") content += '기간:' + res.period;
					else content += '/ 기간:' + res.period;
				}
				if(name == 'content')inputForm.val(content);
				if(name == 'url')inputForm.val(res.url);
				
				$('#relayticket' + relayticketIndex + ' td span:first').html(res.title);
			});
		}
	};

$(function () {
	var frm 		= $('form[name=frm]');
	var title		= frm.find('input[name=title]');
	var url		= frm.find('input[name=url]');
	
	//layout
	/* if('${paramMap.seq}') {
		var p = new Pagination({
			view		:	'#pagination',
			page_count	:	'${commentListCnt }',
			page_no		:	'${paramMap.page_no }',
			callback	:	function(pageIndex, e) {
				page_no.val(pageIndex + 1);
				search();
				return false;
			}
		});
	} */
	
	//main image upload change
	$('input[name=uploadFile]').change(function(){
		var path = $(this).val();
		var idx;
		if(path.lastIndexOf('\\') > -1){
			var idx = path.lastIndexOf('\\');
			path = path.substr(idx+1);
		}
	    $(this).parent().parent().find('input[name=file_name]').val('/upload/webzine/' + path);
	});
	
	//upload file 변경시 fake file div text 변경
	$('input[name=uploadFile]').each(function(){
		$(this).change(function(){
			$(this).next().find('input.inputText').val($(this).val());
		});
	});
	
	//main image upload change
	$('input[name=uploadFileEvent]').change(function(){
		var path = $(this).val();
		var idx;
		if(path.lastIndexOf('\\') > -1){
			var idx = path.lastIndexOf('\\');
			path = path.substr(idx+1);
		}
	    $(this).parent().parent().find('input[name=file_name]').val('/upload/webzine/' + path);
	});
	
	//upload file 변경시 fake file div text 변경
	$('input[name=uploadFileEvent]').each(function(){
		$(this).change(function(){
			$(this).next().find('input.inputText').val($(this).val());
		});
	});
	
	// 에디터 HTML 적용
	//if(menu_type == '206')nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		 if(action != 'insert'){
		 	return true;
		 }

		if($("input[name='agency_name']").val() == '') {
			alert("기관/업체명을 입력하세요.");
			$("input[name='agency_name']").focus();
			return false;
		}

		if ( $("input[name='phone2']").val() == "" ){
			alert("연락처를 입력하여 주세요.");
			$("input[name='phone2']").focus();
			return false;
		}

		if ( $("input[name='phone3']").val() == "" ){

			alert("연락처를 입력하여 주세요.");
			$("input[name='phone3']").focus();
			return false;
		}

		if(isNaN($("input[name='phone2']").val())){
			alert('연락처는 숫자만 입력 가능합니다');
			$("input[name='phone2']").focus();
			return false;
		}

		if(isNaN($("input[name='phone3']").val())){
			alert('연락처는 숫자만 입력 가능합니다');
			$("input[name='phone3']").focus();
			return false;
		}


		if(title.val() == '') {
		    alert("제목 입력하세요");
		    title.focus();
		    return false;
		}
		
		if(url.val() == '') {
		    alert("연결 URL 입력하세요");
		    url.focus();
		    return false;
		}
		
		if(cultureIssIndex == 0) {
		    alert("문화이슈 선택하세요");
		    return false;
		}
		
		if(cultureRecomIndex == 0) {
		    alert("문화공감 선택하세요");
		    return false;
		}
		
	/* 	if(columnIndex == 0) {
		    alert("칼럼 선택하세요");
		    return false;
		} */
		
		/* if(eventIndex == 0) {
		    alert("이벤트 선택하세요");
		    return false;
		}
		 */
		 
		 
		if(performIndex == 0) {
		    alert("공연/전시 선택하세요");
		    return false;
		}
		
		if(cultureImageIndex == 0) {
		    alert("문화영상 선택하세요");
		    return false;
		}
		
		if(patternIndex == 0) {
		    alert("전통디자인 선택하세요");
		    return false;
		}
		
		if(culturenewsIndex == 0) {
		    alert("문화소식 선택하세요");
		    return false;
		}
		
		if(festivalIndex == 0) {
		    alert("행사/축제/교육 선택하세요");
		    return false;
		}
		
		return true;
	});
	
	$('span.btn.whiteS a').each(function(){
		$(this).click(function() { 
			console.log('$(this).html():' + $(this).html());
			if($(this).html() == '공연/전시 선택') {
				metaType = "perform";
				performIndex = $(this).attr('index');
				window.open('/popup/rdfMetadataNew.do', 'webzinePopup', 'scrollbars=yes,width=400,height=630');
			} else if($(this).html() == '행사/축제 선택') {
				metaType = "festival";
				festivalIndex = $(this).attr('index');
				window.open('/popup/rdfMetadataBoth.do', 'webzinePopup', 'scrollbars=yes,width=600,height=450');
			} else if($(this).html() == '교육 선택') {
				festivalIndex = $(this).attr('index');
				window.open('/popup/education.do?approval=Y&delete_yn=N', 'educationPopup', 'scrollbars=yes,width=600,height=450');
			}else if($(this).html() == '문화이슈 선택') {
				cultureIssIndex = $(this).attr('index');
				window.open('/popup/cultureExp.do?type=con&subType=3&tab=none', 'webzinePopup', 'scrollbars=yes,width=600,height=630');
			}else if($(this).html() == '문화공감 선택') {
				cultureRecomIndex = $(this).attr('index');
				window.open('/popup/culturerecom.do', 'webzinePopup', 'scrollbars=yes,width=600,height=630');
			}/*  else if($(this).html() == '칼럼 선택') {
				columnIndex = $(this).attr('index');
				window.open('/popup/portalcolumn.do', 'webzinePopup', 'scrollbars=yes,width=600,height=630');
			}  */else if($(this).html() == '릴레이티켓 선택') {
				relayticketIndex = $(this).attr('index');
				window.open('/popup/relayticket.do', 'webzinePopup', 'scrollbars=yes,width=600,height=630');
			} else if($(this).html() == '이벤트 선택') {
				eventIndex = $(this).attr('index');
				window.open('/popup/event.do', 'webzinePopup', 'scrollbars=yes,width=600,height=630');
			} else if($(this).html() == '문화영상 선택') {
				cultureImageIndex = $(this).attr('index');
				window.open('/popup/cultureExp.do?type=ucc&subType=0', 'webzinePopup', 'scrollbars=yes,width=600,height=630');
			} else if($(this).html() == '전통디자인 선택') {
				patternIndex = $(this).attr('index');
				window.open('/popup/patterncode.do', 'placePopup', 'scrollbars=yes,width=600,height=630');
			} else if($(this).html() == '문화소식 선택') {
				culturenewsIndex = $(this).attr('index');
				window.open('/popup/culturenews.do', 'webzinePopup', 'scrollbars=yes,width=600,height=630');
			}  else if ($(this).html() == '태그선택') {
				window.open('/popup/newTag.do', 'placePopup', 'scrollbars=yes,width=400,height=630');
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
        		frm.attr('action' ,'/magazine/webzine/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/magazine/webzine/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		action = "insert";
        		frm.attr('action' ,'/magazine/webzine/insert.do');
        		action = "delete";
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		console.log('목록');
        		frm.attr('action' ,'/magazine/webzine/list.do');
        		frm.submit();
        	}   		
    	});
	});
	
	// 태그선택
	$('input[name=tags]').click(function() {
		window.open('/popup/newTag.do', 'placePopup', 'scrollbars=yes,width=400,height=630');
	});
});

function tagInit(){
	$('input[name=tagSeqs]').val('');
	$('input[name=tags]').val('');
}

function setVal(data){
	if(data['gbn'] != null){
		//문화영상
		$('#cultureImage' + cultureImageIndex).find('input').each(function(){
			inputForm = $(this);
			name = inputForm.attr('name');
			
			if(name == 'subTitle')inputForm.val(data['title']);
			if(name == 'url')inputForm.val(data['url']);
			if(name == 'file_name')inputForm.val(data['image']);
			if(name == 'content')inputForm.val(data['summary']);
			
			$('#cultureImage' + cultureImageIndex + ' td span:first').html(data['title']);
		});
	}else{
		//문화이슈
		$('#cultureIss' + cultureIssIndex).find('input').each(function(){
			inputForm = $(this);
			name = inputForm.attr('name');
			
			if(name == 'subTitle')inputForm.val(data['title']);
			if(name == 'url')inputForm.val(data['url']);
			if(name == 'file_name')inputForm.val(data['thumb_url']);
			if(name == 'content')inputForm.val(data['summary']);
			
			$('#cultureIss' + cultureIssIndex + ' td span:first').html(data['title']);
		});
	}
}
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/magazine/webzine/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.seq }'>
				<input type="hidden" name="seq" value="${view.seq }"/>
			</c:if>
			<input type="hidden" name="menu_type" value="${paramMap.menu_type }"/>
			<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
			<div class="tableWrite">
				<table summary="웹진 작성">
					<caption>웹진 작성</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">회차</th>
							<td>
								<input type="text" name="numbers" style="width:200px" value="${view.numbers}${emptyView.numbers}"/> 호
							</td>
							<th scope="row">발송일</th>
							<td>
								${view.reg_date}${emptyView.reg_date}
							</td>
						</tr>
						<tr>
							<th scope="row">기관/업체명</th>
							<td><input type="text" name="agency_name" maxlength="60" value="<c:out value="${view.agency_name}"/>"/></td>
							<th scope="row">웹진유형</th>
							<td>
								<select name="template_type">
									<c:forEach items="${templateTypeList }" var="templateTypeList" varStatus="status">
									<option value="<c:out value="${templateTypeList.value}"/>" <c:if test="${templateTypeList.value eq view.template_type}">selected="selected"</c:if> ><c:out value="${templateTypeList.name}"/></option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">담당자연락처</th>
							<td colspan="3">
								<select name="phone1">
									<c:forEach items="${phoneList }" var="phoneList" varStatus="status">
										<option value="<c:out value="${phoneList.value}"/>" <c:if test="${phoneList.value eq view.phone1}">selected="selected"</c:if> ><c:out value="${phoneList.name}"/></option>
									</c:forEach>
								</select>
								-
								<input type="text" name="phone2" maxlength="4" style="width:50px" value="<c:out value="${view.phone2}"/>"/>
								-
								<input type="text" name="phone3" maxlength="4" style="width:50px" value="<c:out value="${view.phone3}"/>"/>
							</td>
						</tr>
						<tr>
							<th scope="row">제목</th>
							<td colspan="3">
								<input type="text" name="title" style="width:670px" value="${view.title}" />
							</td>
						</tr>
						<c:if test="${not empty subList}">
							<c:forEach begin="0" end="0" items="${subList }" var="subList" varStatus="status">
								<tr id="mainImage${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="1">메인 이미지</th>
									</c:if>
									<td>
										<div class="fileInputs">
											<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
											<div class="fakefile">
												<input type="text" title="" class="inputText" value="${subList.file_name}" />
												<span class="btn whiteS"><button>찾아보기</button></span>
											</div>
										</div>
										<div class="inputBox">
											연결 URL <input type="text" name="url" style="width:300px" value="${subList.url}" /> 
										</div>
										<div class="inputBox">
											제목 <input type="text" value="${subList.title}" name="subTitle" style="width:300px;" />
										</div>
										<div class="inputBox">
											내용 <textarea name="content" style="width:300px;height:40px;" maxlength="1000"><c:out value="${subList.content }" escapeXml="true" /></textarea>
										</div>
										<input type="hidden" value="${subList.file_name}" name="file_name">
										<input type="hidden" value="${subList.seq}" name="subSeq">
										<input type="hidden" value="${subList.code}" name="type">
									</td>
								</tr>
							</c:forEach>
							<%-- <tr style="display:none;">
								<th scope="row">관련태그</th>
								<td colspan="3">
									<input type="text" name="tags" id="title" style="width:400px"  value="${tagName }" readonly="readonly"/>
									<input type="hidden" name="tagSeqs" id="tagSeqs"/>
									<!-- 태그맵 테이블에 등록될 문화공감 메뉴 코드/시퀀스 -->
									<input type="hidden" name="menuType" id="menuType" value="${paramMap.menuType}"/>
									<input type="hidden" name="boardSeq" id="boardSeq" value="${view.seq}"/>
									<span class="btn whiteS"><a href="#">태그선택</a></span>
									<span class="btn darkS"><a href="#" onclick="javascript:tagInit();return;">초기화</a></span>
								</td>
							</tr> --%>
							<!-- 기존  테마문화추천 -->
							<c:forEach begin="1" end="1" items="${subList }" var="subList" varStatus="status">
								<tr id="cultureIss${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="1">${subList.name}</th>
									</c:if>
									<td colspan="3">
										<span>${subList.title}</span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">문화이슈 선택</a></span>
										<input type="hidden" value="${subList.title}" name="subTitle"/>
										<input type="hidden" value="${subList.file_name}" name="file_name"/>
										<input type="hidden" value="${subList.content}" name="content"/>
										<input type="hidden" value="${subList.url}" name="url"/>
										<input type="hidden" value="${subList.seq}" name="subSeq"/>
										<input type="hidden" value="${subList.code}" name="type"/>
									</td>
								</tr>
							</c:forEach>
							<c:forEach begin="2" end="2" items="${subList }" var="subList" varStatus="status">
								<tr id="cultureRecom${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="1">${subList.name}</th>
									</c:if>
									<td colspan="3">
										<span>${subList.title}</span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">문화공감 선택</a></span>
										<input type="hidden" value="${subList.title}" name="subTitle"/>
										<input type="hidden" value="${subList.file_name}" name="file_name"/>
										<input type="hidden" value="${subList.content}" name="content"/>
										<input type="hidden" value="${subList.url}" name="url"/>
										<input type="hidden" value="${subList.seq}" name="subSeq"/>
										<input type="hidden" value="${subList.code}" name="type"/>
									</td>
								</tr>
							</c:forEach>
							<c:forEach begin="3" end="3" items="${subList }" var="subList" varStatus="status">
								<tr id="relayticket${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="1">${subList.name}</th>
									</c:if>
									<td colspan="3">
										<span>${subList.title}</span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">릴레이티켓 선택</a></span>
										<input type="hidden" value="${subList.title}" name="subTitle"/>
										<input type="hidden" value="${subList.file_name}" name="file_name"/>
										<input type="hidden" value="${subList.content}" name="content"/>
										<input type="hidden" value="${subList.url}" name="url"/>
										<input type="hidden" value="${subList.seq}" name="subSeq"/>
										<input type="hidden" value="${subList.code}" name="type"/>
									</td>
								</tr>
								
								<%-- <tr id="column${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="1">${subList.name}</th>
									</c:if>
									<td colspan="3">
										<span>${subList.title}</span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">칼럼 선택</a></span>
										<input type="hidden" value="${subList.title}" name="subTitle"/>
										<input type="hidden" value="${subList.file_name}" name="file_name"/>
										<input type="hidden" value="${subList.content}" name="content"/>
										<input type="hidden" value="${subList.url}" name="url"/>
										<input type="hidden" value="${subList.seq}" name="subSeq"/>
										<input type="hidden" value="${subList.code}" name="type"/>
									</td>
								</tr> --%>
							</c:forEach>
							<c:forEach begin="4" end="4" items="${subList }" var="subList" varStatus="status">
								<tr id="event${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="1">${subList.name}</th>
									</c:if>
									<td colspan="3">
										<!-- 이벤트 수정 -->
										<div class="fileInputs" style="float:none;">
											<input type="file" name="uploadFileEvent" class="file hidden" title="첨부파일 선택" />
											<div class="fakefile">
												<input type="text" title="" class="inputText" value="${subList.file_name}" />
												<span class="btn whiteS"><button>찾아보기</button></span>
											</div>
										</div>
										<div class="inputBox">
											연결 URL <br/><input type="text" name="url" style="width:300px" value="${subList.url}" /> 
										</div>
										<div class="inputBox">
											제목 <br/><input type="text" value="${subList.title}" name="subTitle" style="width:300px;" />
										</div>
										<input type="hidden" value="${subList.file_name}" name="file_name">
										<input type="hidden" value="${subList.seq}" name="subSeq">
										<input type="hidden" value="" name="content">
										<input type="hidden" value="${subList.code}" name="type">
									</td>
								</tr>
							</c:forEach>
							<c:forEach begin="5" end="7" items="${subList }" var="subList" varStatus="status">
								<tr id="perform${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="3">${subList.name}</th>
									</c:if>
									<td colspan="3">
										<span>${subList.title}</span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">공연/전시 선택</a></span>
										<input type="hidden" value="${subList.title}" name="subTitle">
										<input type="hidden" value="${subList.file_name}" name="file_name">
										<input type="hidden" value="${subList.content}" name="content">
										<input type="hidden" value="${subList.url}" name="url">
										<input type="hidden" value="${subList.seq}" name="subSeq">
										<input type="hidden" value="${subList.code}" name="type">
									</td>
								</tr>
							</c:forEach>
							<c:forEach begin="8" end="9" items="${subList }" var="subList" varStatus="status">
								<tr id="cultureImage${status.count}" ${subList.code eq '593' ? 'style="display:none;"':'' }>
									<c:if test="${status.first }">
										<th scope="row" rowspan="1">${subList.name}</th>
									</c:if>
									<td colspan="3">
										<span>${subList.title}</span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">문화영상 선택</a></span>
										<input type="hidden" value="${subList.title}" name="subTitle">
										<input type="hidden" value="${subList.file_name}" name="file_name">
										<input type="hidden" value="${fn:escapeXml(subList.content)}" name="content">
										<input type="hidden" value="${subList.url}" name="url">
										<input type="hidden" value="${subList.seq}" name="subSeq">
										<input type="hidden" value="${subList.code}" name="type">
									</td>
								</tr>
							</c:forEach>
							<c:forEach begin="10" end="10" items="${subList }" var="subList" varStatus="status">
								<tr id="pattern${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="1">${subList.name}</th>
									</c:if>
									<td colspan="3">
										<span>${subList.title}</span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">전통디자인 선택</a></span>
										<input type="hidden" value="${subList.title}" name="subTitle">
										<input type="hidden" value="${subList.file_name}" name="file_name">
										<input type="hidden" value="${subList.content}" name="content">
										<input type="hidden" value="${subList.url}" name="url">
										<input type="hidden" value="${subList.seq}" name="subSeq">
										<input type="hidden" value="${subList.code}" name="type">
									</td>
								</tr>
							</c:forEach>
							<c:forEach begin="11" end="15" items="${subList }" var="subList" varStatus="status">
								<tr id="culturenews${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="5">${subList.name}</th>
									</c:if>
									<td colspan="3">
										<span>${subList.title}</span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">문화소식 선택</a></span>
										<input type="hidden" value="${subList.title}" name="subTitle">
										<input type="hidden" value="${subList.file_name}" name="file_name">
										<input type="hidden" value="${subList.content}" name="content">
										<input type="hidden" value="${subList.url}" name="url">
										<input type="hidden" value="${subList.seq}" name="subSeq">
										<input type="hidden" value="${subList.code}" name="type">
									</td>
								</tr>
							</c:forEach>
							<c:forEach begin="16" end="19" items="${subList }" var="subList" varStatus="status">
								<tr id="festival${status.count}" ${(subList.code eq '602' or subList.code eq '603') ? 'style="display:none;"':''}>
									<c:if test="${status.first }">
										<th scope="row" rowspan="5">${subList.name}</th>
									</c:if>
									<td colspan="2">
										<span>${subList.title}</span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">행사/축제 선택</a></span><span class="btn whiteS"><a href="#url" index="${status.count}">교육 선택</a></span>
										<input type="hidden" value="${subList.title}" name="subTitle">
										<input type="hidden" value="${subList.file_name}" name="file_name">
										<input type="hidden" value="${subList.content}" name="content">
										<input type="hidden" value="${subList.url}" name="url">
										<input type="hidden" value="${subList.seq}" name="subSeq">
										<input type="hidden" value="${subList.code}" name="type">
									</td>
								</tr>
							</c:forEach>
						</c:if>
						<c:if test="${not empty emptySubList}">
							<c:forEach begin="0" end="0" items="${emptySubList }" var="emptySubList" varStatus="status">
								<tr id="mainImage${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="1">메인 이미지</th>
									</c:if>
									<td>
										<div class="fileInputs">
											<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
											<div class="fakefile">
												<input type="text" title="" class="inputText" />
												<span class="btn whiteS"><button>찾아보기</button></span>
											</div>
										</div>
										<div class="inputBox">
											연결 URL <input type="text" name="url" style="width:300px" value="" /> 
										</div>
										<div class="inputBox">
											제목 <input type="text" value="" name="subTitle" style="width:300px;" />
										</div>
										<div class="inputBox">
											내용 <textarea name="content" style="width:300px;height:40px;" maxlength="1000"></textarea>
										</div>
										<input type="hidden" value="" name="file_name">
										<input type="hidden" value="" name="subSeq">
										<input type="hidden" value="${emptySubList.code}" name="type">
									</td>
								</tr>
							</c:forEach>
							<%-- <tr>
								<th scope="row">관련태그</th>
								<td colspan="3">
									<input type="text" name="tags" id="title" style="width:400px"  value="${tagName }" readonly="readonly"/>
									<input type="hidden" name="tagSeqs" id="tagSeqs"/>
									<!-- 태그맵 테이블에 등록될 문화공감 메뉴 코드/시퀀스 -->
									<input type="hidden" name="menuType" id="menuType" value="${paramMap.menuType}"/>
									<input type="hidden" name="boardSeq" id="boardSeq" value="${view.seq}"/>
									<span class="btn whiteS"><a href="#">태그선택</a></span>
									<span class="btn darkS"><a href="#" onclick="javascript:tagInit();return;">초기화</a></span>
								</td>
							</tr> --%>
							<!-- 기존  테마문화추천 -->
							<c:forEach begin="1" end="1" items="${emptySubList }" var="emptySubList" varStatus="status">
								<tr id="cultureIss${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="1">${emptySubList.name}</th>
									</c:if>
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">문화이슈 선택</a></span>
										<input type="hidden" value="" name="subTitle">
										<input type="hidden" value="" name="file_name">
										<input type="hidden" value="" name="content">
										<input type="hidden" value="" name="url">
										<input type="hidden" value="" name="subSeq">
										<input type="hidden" value="${emptySubList.code}" name="type">
									</td>
								</tr>
							</c:forEach>
							<!-- 기존  테마문화추천 -->
							<c:forEach begin="2" end="2" items="${emptySubList }" var="emptySubList" varStatus="status">
								<tr id="cultureRecom${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="1">${emptySubList.name}</th>
									</c:if>
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">문화공감 선택</a></span>
										<input type="hidden" value="" name="subTitle">
										<input type="hidden" value="" name="file_name">
										<input type="hidden" value="" name="content">
										<input type="hidden" value="" name="url">
										<input type="hidden" value="" name="subSeq">
										<input type="hidden" value="${emptySubList.code}" name="type">
									</td>
								</tr>
							</c:forEach>
							<c:forEach begin="3" end="3" items="${emptySubList }" var="emptySubList" varStatus="status">
								<%-- <tr id="column${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="1">${emptySubList.name}</th>
									</c:if>
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">칼럼 선택</a></span>
										<input type="hidden" value="" name="subTitle">
										<input type="hidden" value="" name="file_name">
										<input type="hidden" value="" name="content">
										<input type="hidden" value="" name="url">
										<input type="hidden" value="" name="subSeq">
										<input type="hidden" value="${emptySubList.code}" name="type">
									</td>
								</tr> --%>
								<tr id="relayticket${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="1">${emptySubList.name}</th>
									</c:if>
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">릴레이티켓 선택</a></span>
										<input type="hidden" value="" name="subTitle">
										<input type="hidden" value="" name="file_name">
										<input type="hidden" value="" name="content">
										<input type="hidden" value="" name="url">
										<input type="hidden" value="" name="subSeq">
										<input type="hidden" value="${emptySubList.code}" name="type">
									</td>
								</tr>
							</c:forEach>
							<c:forEach begin="4" end="4" items="${emptySubList }" var="emptySubList" varStatus="status">
								<tr id="event${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="1">${emptySubList.name}</th>
									</c:if>
									<td colspan="3">
										<div class="fileInputs" style="float:none;">
											<input type="file" name="uploadFileEvent" class="file hidden" title="첨부파일 선택" />
											<div class="fakefile">
												<input type="text" title="" class="inputText" value="" />
												<span class="btn whiteS"><button>찾아보기</button></span>
											</div>
										</div>
										<div class="inputBox">
											연결 URL <br/><input type="text" name="url" style="width:300px" value="" /> 
										</div>
										<div class="inputBox">
											제목 <br/><input type="text" value="" name="subTitle" style="width:300px;" />
										</div>
										<input type="hidden" value="" name="file_name">
										<input type="hidden" value="" name="subSeq">
										<input type="hidden" value="${emptySubList.code}" name="type">
										<input type="hidden" value="" name="content">
									</td>
								</tr>
							</c:forEach>
							<c:forEach begin="5" end="7" items="${emptySubList }" var="emptySubList" varStatus="status">
								<tr id="perform${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="3">${emptySubList.name}</th>
									</c:if>
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">공연/전시 선택</a></span>
										<input type="hidden" value="" name="subTitle">
										<input type="hidden" value="" name="file_name">
										<input type="hidden" value="" name="content">
										<input type="hidden" value="" name="url">
										<input type="hidden" value="" name="subSeq">
										<input type="hidden" value="${emptySubList.code}" name="type">
									</td>
								</tr>
							</c:forEach>
							<c:forEach begin="8" end="9" items="${emptySubList }" var="emptySubList" varStatus="status">
								<tr id="cultureImage${status.count}" ${emptySubList.code eq '593' ? 'style="display:none;"':'' }>
									<c:if test="${status.first }">
										<th scope="row">${emptySubList.name}</th>
									</c:if>
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">문화영상 선택</a></span>
										<input type="hidden" value="" name="subTitle">
										<input type="hidden" value="" name="file_name">
										<input type="hidden" value="" name="content">
										<input type="hidden" value="" name="url">
										<input type="hidden" value="" name="subSeq">
										<input type="hidden" value="${emptySubList.code}" name="type">
									</td>
								</tr>
							</c:forEach>
							<c:forEach begin="10" end="10" items="${emptySubList }" var="emptySubList" varStatus="status">
								<tr id="pattern${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="1">${emptySubList.name}</th>
									</c:if>
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">전통디자인 선택</a></span>
										<input type="hidden" value="" name="subTitle">
										<input type="hidden" value="" name="file_name">
										<input type="hidden" value="" name="content">
										<input type="hidden" value="" name="url">
										<input type="hidden" value="" name="subSeq">
										<input type="hidden" value="${emptySubList.code}" name="type">
									</td>
								</tr>
							</c:forEach>
							<c:forEach begin="11" end="15" items="${emptySubList }" var="emptySubList" varStatus="status">
								<tr id="culturenews${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="5">${emptySubList.name}</th>
									</c:if>
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">문화소식 선택</a></span>
										<input type="hidden" value="" name="subTitle">
										<input type="hidden" value="" name="file_name">
										<input type="hidden" value="" name="content">
										<input type="hidden" value="" name="url">
										<input type="hidden" value="" name="subSeq">
										<input type="hidden" value="${emptySubList.code}" name="type">
									</td>
								</tr>
							</c:forEach>
							<c:forEach begin="16" end="19" items="${emptySubList }" var="emptySubList" varStatus="status">
								<tr id="festival${status.count}" ${(emptySubList.code eq '602' or emptySubList.code eq '603') ? 'style="display:none;"':''}>
									<c:if test="${status.first }">
										<th scope="row" rowspan="2">${emptySubList.name}</th>
									</c:if>
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">행사/축제 선택</a></span><span class="btn whiteS"><a href="#url" index="${status.count}">교육 선택</a></span>
										<input type="hidden" value="" name="subTitle">
										<input type="hidden" value="" name="file_name">
										<input type="hidden" value="" name="content">
										<input type="hidden" value="" name="url">
										<input type="hidden" value="" name="subSeq">
										<input type="hidden" value="${emptySubList.code}" name="type">
									</td>
								</tr>
							</c:forEach>
						</c:if>
					</tbody>
				</table>
				<c:if test="${paramMap.seq }">
					<textarea name="content" style="width:500px" rows="5"></textarea><input type="submit" value="댓글"/>
					<div id="pagination">
					</div>
				</c:if>
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