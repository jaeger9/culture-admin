<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
$(function () {
	/*
	/리뉴얼에 의한 하단 메뉴명 사용 안함/
	100	공연/전시
	200	행사/교육
	300	매거진/문화영상
	400	시설/단체
	500	지식/통계
	600	소식
	/리뉴얼에 의한 상단 메뉴명 사용 안함/
	 * 
	/리뉴얼에 의한 하단 메뉴명으로 변경/
	 * 
	703 함께 즐겨요
	704 지식이 더해집니다
	705 문화포털 콘텐츠
	706 소식/교육/채용
	707 문화산업URL
	*/
	
	//최초접근 시 input 폼 생성
	if('${fn:length(view)}' < 1){
		for( var i=1; i<5; i++ ){
			$('#group_type_grp'+i+' option:eq(0)').attr('selected','selected');
			$('#group_type_grp'+i).change();
		}
	}

});

function setVal(data){
	var name = "";

	/*
	 * gbn :
	 * 1 : 공연
	 * 2 : 전시
	 * 3 : 문화릴레이티켓
	 * 4 : 할인티켓
	 * 5 : 행사
	 * 6 : 축제
	 *
	 * type > ucc:문화영상, exp:문화체험
	 */
	 
	 if( data['type'] == 'exp' ){
		 if( data['gbn'] == '3' ){
			$('#'+grpId).children().find('span:first').each(function(){
				$(this).html(data['title']);
			});
			$('#'+grpId).children().find('input').each(function(){
				name = $(this).attr("name");
			
				if( name.indexOf('title') > -1 ) $(this).val(data['title']);
				if( name.indexOf('url') > -1 ) $(this).val('/perform/performView.do?uci=' + data['uci'].replace('+','%2b'));
				if( name.indexOf('image_name') > -1 ) $(this).val(data['img_url']);
				if( name.indexOf('image_name2') > -1 ) $(this).val('');
				if( name.indexOf('period') > -1 ) $(this).val(data['period']);
				if( name.indexOf('place') > -1 ) $(this).val(data['place']);
				if( name.indexOf('discount') > -1 ) $(this).val(data['discount']);
				if( name.indexOf('uci') > -1 ) $(this).val(data['uci']);
			});
		 } else if( data['gbn'] == '4' ){
			$('#'+grpId).children().find('span:first').each(function(){
				$(this).html(data['title']);
			});

			$('#'+grpId).children().find('input').each(function(){
				name = $(this).attr("name");
			
				if( name.indexOf('title') > -1 ) $(this).val(data['title']);
				if( name.indexOf('url') > -1 ) $(this).val(data['url']);
				if( name.indexOf('image_name') > -1 ) $(this).val(data['image']);
				if( name.indexOf('image_name2') > -1 ) $(this).val('');
				if( name.indexOf('period') > -1 ) $(this).val(data['period']);
				if( name.indexOf('place') > -1 ) $(this).val(data['location']);
//				if( name.indexOf('discount') > -1 ) $(this).val(data['discount']);
				if( name.indexOf('discount') > -1 ) $(this).val('할인');
				if( name.indexOf('uci') > -1 ) $(this).val(data['uci']);
			});
		 }else{
			$('#'+grpId).children().find('span:first').each(function(){
				$(this).html(data['title']);
			});
			
			$('#'+grpId).children().find('input').each(function(){
				name = $(this).attr("name");
				if( name.indexOf('title') > -1 ) $(this).val(data['title']);
				if( name.indexOf('url') > -1 ){
					if( data['gbn'] == '1' ){ $(this).val('/perform/performView.do?uci=' + data['uci'].replace('+','%2b')); }
					else if( data['gbn'] == '2' ){ $(this).val('/perform/exhibitionView.do?uci=' + data['uci'].replace('+','%2b')); }
					else if( data['gbn'] == '6' ){ $(this).val('/festival/festivalView.do?uci=' + data['uci'].replace('+','%2b')); }
					else if( data['gbn'] == '5' ){ $(this).val('/festival/eventsView.do?uci=' + data['uci'].replace('+','%2b')); }
					else{ $(this).val(data['url']); }
				}
			
				//이미지 URL인지 내부이미지인지에 따라
				if(data['reference_identifier']){
					if( name.indexOf('image_name') > -1 ) $(this).val(data['reference_identifier']);
				}else{
					if( name.indexOf('image_name') > -1 ) $(this).val('/upload/rdf/'+data['reference_identifier_org']);
				}
				if( name.indexOf('image_name2') > -1 ) $(this).val('');
				if( name.indexOf('period') > -1 ) $(this).val(data['period']);
				if( name.indexOf('place') > -1 ) $(this).val(data['venue']);
				if( name.indexOf('rights') > -1 ) $(this).val(data['rights']);
				if( name.indexOf('uci') > -1 ) $(this).val(data['uci']);
			});
		 }
	 } else {
		$('#'+grpId).children().find('span:first').each(function(){
			$(this).html(data['title']);
		});
		$('#'+grpId).children().find('input').each(function(){
			name = $(this).attr("name");
		
			if( name.indexOf('title') > -1 ) $(this).val(data['title']);
			if( name.indexOf('url') > -1 ) $(this).val(data['url']);
			if( name.indexOf('image_name') > -1 ) $(this).val(data['image']);
			if( name.indexOf('image_name2') > -1 ) $(this).val('');
			if( name.indexOf('summary') > -1 ) $(this).val(data['summary']);
		});
	 }
}

var grpId = "";

function goPop(gbn,obj){
	grpId = $(obj).parent().parent().parent().attr("id");
	
	window.open('/popup/cultureExp.do?type='+gbn+'&subType=0', 'culturePopup', 'scrollbars=yes,width=600,height=630');
}

function setForm(obj, grpNum){
	var typeCnt = new Array();
	typeCnt['A'] = 6;
	typeCnt['B'] = 12;
	typeCnt['C'] = 9;
	var tmpName = "";
	var rowCnt = Number(typeCnt[$(obj).val()])+1;
	
	//모든 입력폼을 비워준다.
	$('.trInputFrm'+grpNum).each(function(){
		$(this).remove();
	});
	
	//입력폼의 name을 바꿔준다.
	$('#trInputFrm,#trInputFrm2,#trInputFrm3').find('input,textarea').each(function() {
		tmpName = $(this).attr("name");
		$(this).attr("name", tmpName.substring( 0, Number(tmpName.length) -1 ) + grpNum );
		
		//그룹넘버 셋팅
		if( tmpName.indexOf("group_num_grp") > -1 ){
			$(this).attr("value",grpNum);
		}
		
		//그룹넘버 타입
		if( tmpName.indexOf("group_type_grp") > -1 ){
			$(this).attr("value",$(obj).val());
		}
	});
	
	//입력폼을 담는다.
	var inputHtml = $('#trInputFrm').html();		//문화체험 입력폼
	var inputHtml2 = $('#trInputFrm2').html();		//문화영상 입력폼
	var inputHtml3 = $('#trInputFrm3').html();		//텍스터 입력란 폼
	
	//A타입은 textarea 항목, C타입은 영상항목 추가
	if( $(obj).val() == 'A' ){
		$(obj).parent().parent().after("<tr colspan='3' id='"+grpNum+"_"+Number(typeCnt[$(obj).val()]+1)+"' class='trInputFrm"+grpNum+"'>"+inputHtml3+"</tr>");
		rowCnt++;
	}else if( $(obj).val() == 'C' ){
		$(obj).parent().parent().after("<tr colspan='3' id='"+grpNum+"_"+Number(typeCnt[$(obj).val()]+1)+"' class='trInputFrm"+grpNum+"'>"+inputHtml2+"</tr>");
		rowCnt++;
	}
	
	//입력폼을 넣어준다.
	for( var i=typeCnt[$(obj).val()]; i>0; i-- ){
		$(obj).parent().parent().after("<tr colspan='3' id='"+grpNum+"_"+i+"' class='trInputFrm"+grpNum+"'>"+inputHtml+"</tr>");
	}
	
	//rowspan값을 설정한다.
	$(obj).parent().parent().find('th').attr('rowspan',rowCnt);
	
}

function insert(){
	if (!confirm('등록하시겠습니까?')) {
		return false;
	}
	
	//입력할 데이터를 배열로 담는다.
	setData();
	if(!doValidation()){
		return;
	}
	
	action = "insert";
	$('form[name=frm]').attr('action' ,'/main/content/insertMain.do');
	$('form[name=frm]').submit();
}

function goList(){
	action = "list";
	$('form[name=frm]').attr('action' ,'/main/content/list.do');
	$('form[name=frm]').submit();
}

function update(){
	if (!confirm('수정하시겠습니까?')) {
		return false;
	}
	
	//입력할 데이터를 배열로 담는다.
	setData();
	if(!doValidation()){
		return;
	}
	
	action = "update";
	$('form[name=frm]').attr('action' ,'/main/content/updateMain.do');
	$('form[name=frm]').submit();
}

function deleteMain(){
	if (!confirm('삭제 하시겠습니까?')) {
		return false;
	}
	action = "delete";
	$('form[name=frm]').attr('action' ,'/main/content/delete.do');
	$('form[name=frm]').submit();
}

//각 그룹 별 rowcount를 입력해준다.
function setData(){
	var tmpIdx = 0;
	
	for( var i=1; i<5; i++ ){
		$('.trInputFrm'+i).find('input').each(function(){
			//각 그룹 별 row수를 넣어준다.
			if( $(this).attr('name').indexOf('code_grp') > -1 ){
				$(this).val(++tmpIdx);
			}
		});
		tmpIdx = 0;
	}
}


function doValidation(){
	var rtnFlg = true;
	var textareaFlg = false;
	var groupType = "";
	
	if( $('input[name=mainTitle]').val() == '' ){
		alert("제목을 입력하세요.");
		return false;
	}
	
	if( $('input[name=mainWriter]').val() == '' ){
		alert("작성자를 입력하세요.");
		return false;
	}

	for( var i=1; i<5; i++ ){
		if( $('input[name=title_top_grp'+i+']').val() == '상단 타이틀 입력란'+i ){
			$('input[name=title_top_grp'+i+']').val('');
		}
	}
	/* 
	for( var i=1; i<2; i++ ){
		if( $('input[name=title_top_grp'+i+']').val() == '' ){
			alert("상단 타이틀을 입력하세요.");
			rtnFlg = false;
			break;
		}
		
		groupType = $( '#group_type_grp'+i ).val();
		$('.trInputFrm'+i).each(function(){
			if( groupType == 'A' ){
				if( $(this).find("textarea[name=main_text_grp"+i+"]").val() == "" ){
					textareaFlg = true;
				}
			}
		});
		
		if(textareaFlg){
			alert("텍스트를 입력해주세요.");
			rtnFlg = false;
			break;
		}

		$('.trInputFrm'+i).each(function(){
			if( $(this).find("input[name=title_grp"+i+"]").val() == "" ){
				if( $(this).find("textarea[name=main_text_grp"+i+"]").size() < 1 ){
					rtnFlg = false;
				}
			}
		});
		
		if(!rtnFlg){
			alert("문화체험/문화영상을 선택해주세요.");
			break;
		}
	} */
	
	return rtnFlg;
}

</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/main/code/insertMain.do" enctype="multipart/form-data">
			<input type="hidden" name="searchApproval" value="${paramMap.searchApproval}"/>
						
			<c:if test='${not empty view.seq }'>
				<input type="hidden" name="pseq" value="${view.seq }"/>
			</c:if>
			<input type="hidden" name="menu_type" value="${paramMap.menu_type }"/>
			<ul class="tab">
				<c:forEach items="${tabList }" var="tabList" varStatus="status">
					<li>
						<a href="/main/content/list.do?menu_type=${tabList.code}" <c:if test="${ paramMap.menu_type eq tabList.code }"> class="focus"</c:if>>
							${tabList.name}
						</a>
					</li>
				</c:forEach>
			</ul>
			
			<!-- 함께즐겨요 view div -->
			<div id="703">
				<table summary="함께즐겨요 작성">
					<caption>함께즐겨요 작성</caption>
					<colgroup>
						<col style="width:12%" />
						<col style="width:13%" />
						<col style="*" />
						<col style="width:10%" />
						<col style="width:20%" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">제목</th>
							<td colspan="2">
								<input type="text" title="메인콘텐츠 제목" name="mainTitle" style="width:100%;" value="${view.title}"/>
							</td>
							<th scope="row">등록자</th>
							<td>
								<input type="text" title="등록자" name="mainWriter" style="width:100%;" value="${view.writer}"/>
							</td>
						</tr>
						
						
						<!-- 그룹1 -->
						<c:choose>
							<c:when test="${ empty subGrpList}">
								<tr>
									<th scope="row" colspan="2">
										<input type="text" title="상단 타이틀" name="title_top_grp1" placeholder="상단 타이틀 입력란1"/><br/><br/>
										<span>타입 : </span>
										<select id="group_type_grp1" onchange="javascript:setForm(this,1);return;" style="width:100px; margin-left: 15px;">
											<option value="A">A</option>
											<option value="B">B</option>
											<option value="C">C</option>
										</select>
									</th>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="li" items="${subGrpList}">
									<c:if test="${li.group_num eq 1}">
										<tr>
											<th scope="row" colspan="2" rowspan="${li.cnt+1}">
												<input type="text" title="상단 타이틀" name="title_top_grp1" value="${li.top_title }"/><br/><br/>
												<span>타입 : </span>
												<select id="group_type_grp1" onchange="javascript:setForm(this,1);return;" style="width:100px; margin-left: 15px;">
													<option value="A" ${li.group_type eq 'A' ? 'selected="selected"':''}>A</option>
													<option value="B" ${li.group_type eq 'B' ? 'selected="selected"':''}>B</option>
													<option value="C" ${li.group_type eq 'C' ? 'selected="selected"':''}>C</option>
												</select>
											</th>
										</tr>
										<c:forEach var="li2" items="${subList}" varStatus="i">
											<c:if test="${li.group_num eq li2.group_num and li2.code ne li.cnt}">
												<tr class="trInputFrm${li2.group_num }" id="${li2.group_num }_${li2.code }">
													<td colspan="3">
														<span>${li2.title}</span>
														<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('exp',this);return;" style="width:140px;">문화체험 선택</a></span>
														<input type="hidden" value="${li2.title}" name="title_grp${li2.group_num }">
														<input type="hidden" value="${li2.image_name }" name="image_name_grp${li2.group_num }">
														<input type="hidden" value="${li2.image_name2 }" name="image_name2_grp${li2.group_num }">
														<input type="hidden" value="${li2.url }" name="url_grp${li2.group_num }">
														<input type="hidden" value="${li2.uci }" name="uci_grp${li2.group_num }">
														<input type="hidden" value="${li2.code }" name="category_grp${li2.group_num }">
														<input type="hidden" value="${li2.place }" name="place_grp${li2.group_num }">
														<input type="hidden" value="${li2.discount }" name="discount_grp${li2.group_num }">
														<input type="hidden" value="${li2.period }" name="period_grp${li2.group_num }">
														<input type="hidden" value="${li2.summary }" name="summary_grp${li2.group_num }">
														<input type="hidden" value="${li2.cont_date }" name="cont_date_grp${li2.group_num }">
														<input type="hidden" value="${li2.rights }" name="rights_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_num }" name="group_num_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_type }" name="group_type_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_text }" name="main_text_grp${li2.group_num }">
														<input type="hidden" value="${li2.code }" name="code_grp${li2.group_num }">
														<input type="hidden" value="${li2.type }" name="sub_type_grp${li2.group_num }">
													</td>
												</tr>
											</c:if>
											<c:if test="${li.group_num eq li2.group_num and li2.code eq li.cnt}">
												<tr class="trInputFrm${li2.group_num }" id="${li2.group_num }_${li2.code }">
													<td colspan="3">
														<c:if test="${li.group_type eq 'A'}">
															<textarea name="main_text_grp${li2.group_num }" title="텍스트" style="width:100%;margin-bottom:10px;height: 60px;">${li2.group_text }</textarea>
															<span>텍스트 URL&nbsp;:&nbsp;&nbsp;</span><input type="text" value="${li2.url }" name="url_grp${li2.group_num }" style="width:82%;'">
														</c:if>
														<c:if test="${li.group_type eq 'B'}">
															<span>${li2.title}</span>
															<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('exp',this);return;" style="width:140px;">문화체험 선택</a></span>
															<input type="hidden" value="${li2.group_text }" name="main_text_grp${li2.group_num }">
														</c:if>
														<c:if test="${li.group_type eq 'C'}">
															<span>${li2.title}</span>
															<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('ucc',this);return;" style="width:140px;">영상 영역 문화체험 선택</a></span>
															<input type="hidden" value="${li2.group_text }" name="main_text_grp${li2.group_num }">
														</c:if>
														<input type="hidden" value="${li2.title}" name="title_grp${li2.group_num }">
														<input type="hidden" value="${li2.image_name }" name="image_name_grp${li2.group_num }">
														<input type="hidden" value="${li2.image_name2 }" name="image_name2_grp${li2.group_num }">
														<input type="hidden" value="${li2.url }" name="url_grp${li2.group_num }">
														<input type="hidden" value="${li2.uci }" name="uci_grp${li2.group_num }">
														<input type="hidden" value="${li2.code }" name="category_grp${li2.group_num }">
														<input type="hidden" value="${li2.place }" name="place_grp${li2.group_num }">
														<input type="hidden" value="${li2.discount }" name="discount_grp${li2.group_num }">
														<input type="hidden" value="${li2.period }" name="period_grp${li2.group_num }">
														<input type="hidden" value="${li2.summary }" name="summary_grp${li2.group_num }">
														<input type="hidden" value="${li2.cont_date }" name="cont_date_grp${li2.group_num }">
														<input type="hidden" value="${li2.rights }" name="rights_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_num }" name="group_num_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_type }" name="group_type_grp${li2.group_num }">
														<input type="hidden" value="${li2.code }" name="code_grp${li2.group_num }">
														<input type="hidden" value="${li2.type }" name="sub_type_grp${li2.group_num }">
													</td>
												</tr>
											</c:if>
										</c:forEach>
									</c:if>
								</c:forEach>
							</c:otherwise>
						</c:choose>
						<!-- 그룹1 -->
						
						
						<!-- 그룹2 -->
						<c:choose>
							<c:when test="${ empty subGrpList}">
								<tr>
									<th scope="row" colspan="2">
										<input type="text" title="상단 타이틀" name="title_top_grp2" placeholder="상단 타이틀 입력란2"/><br/><br/>
										<span>타입 : </span>
										<select id="group_type_grp2" onchange="javascript:setForm(this,2);return;" style="width:100px; margin-left: 15px;">
											<option value="A">A</option>
											<option value="B">B</option>
											<option value="C">C</option>
										</select>
									</th>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="li" items="${subGrpList}">
									<c:if test="${li.group_num eq 2}">
										<tr>
											<th scope="row" colspan="2" rowspan="${li.cnt+1}">
												<input type="text" title="상단 타이틀" name="title_top_grp2" value="${li.top_title }"/><br/><br/>
												<span>타입 : </span>
												<select id="group_type_grp2" onchange="javascript:setForm(this,2);return;" style="width:100px; margin-left: 15px;">
													<option value="A" ${li.group_type eq 'A' ? 'selected="selected"':''}>A</option>
													<option value="B" ${li.group_type eq 'B' ? 'selected="selected"':''}>B</option>
													<option value="C" ${li.group_type eq 'C' ? 'selected="selected"':''}>C</option>
												</select>
											</th>
										</tr>
										<c:forEach var="li2" items="${subList}" varStatus="i">
											<c:if test="${li.group_num eq li2.group_num and li2.code ne li.cnt}">
												<tr class="trInputFrm${li2.group_num }" id="${li2.group_num }_${li2.code }">
													<td colspan="3">
														<span>${li2.title}</span>
														<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('exp',this);return;" style="width:140px;">문화체험 선택</a></span>
														<input type="hidden" value="${li2.title}" name="title_grp${li2.group_num }">
														<input type="hidden" value="${li2.image_name }" name="image_name_grp${li2.group_num }">
														<input type="hidden" value="${li2.image_name2 }" name="image_name2_grp${li2.group_num }">
														<input type="hidden" value="${li2.url }" name="url_grp${li2.group_num }">
														<input type="hidden" value="${li2.uci }" name="uci_grp${li2.group_num }">
														<input type="hidden" value="${li2.code }" name="category_grp${li2.group_num }">
														<input type="hidden" value="${li2.place }" name="place_grp${li2.group_num }">
														<input type="hidden" value="${li2.discount }" name="discount_grp${li2.group_num }">
														<input type="hidden" value="${li2.period }" name="period_grp${li2.group_num }">
														<input type="hidden" value="${li2.summary }" name="summary_grp${li2.group_num }">
														<input type="hidden" value="${li2.cont_date }" name="cont_date_grp${li2.group_num }">
														<input type="hidden" value="${li2.rights }" name="rights_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_num }" name="group_num_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_type }" name="group_type_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_text }" name="main_text_grp${li2.group_num }">
														<input type="hidden" value="${li2.code }" name="code_grp${li2.group_num }">
														<input type="hidden" value="${li2.type }" name="sub_type_grp${li2.group_num }">
													</td>
												</tr>
											</c:if>
											<c:if test="${li.group_num eq li2.group_num and li2.code eq li.cnt}">
												<tr class="trInputFrm${li2.group_num }" id="${li2.group_num }_${li2.code }">
													<td colspan="3">
														<c:if test="${li.group_type eq 'A'}">
															<textarea name="main_text_grp${li2.group_num }" title="텍스트" style="width:100%;margin-bottom:10px;height: 60px;">${li2.group_text }</textarea>
															<span>텍스트 URL&nbsp;:&nbsp;&nbsp;</span><input type="text" value="${li2.url }" name="url_grp${li2.group_num }" style="width:82%;'">
														</c:if>
														<c:if test="${li.group_type eq 'B'}">
															<span>${li2.title}</span>
															<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('exp',this);return;" style="width:140px;">문화체험 선택</a></span>
															<input type="hidden" value="${li2.group_text }" name="main_text_grp${li2.group_num }">
														</c:if>
														<c:if test="${li.group_type eq 'C'}">
															<span>${li2.title}</span>
															<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('ucc',this);return;" style="width:140px;">영상 영역 문화체험 선택</a></span>
															<input type="hidden" value="${li2.group_text }" name="main_text_grp${li2.group_num }">
														</c:if>
														<input type="hidden" value="${li2.title}" name="title_grp${li2.group_num }">
														<input type="hidden" value="${li2.image_name }" name="image_name_grp${li2.group_num }">
														<input type="hidden" value="${li2.image_name2 }" name="image_name2_grp${li2.group_num }">
														<input type="hidden" value="${li2.url }" name="url_grp${li2.group_num }">
														<input type="hidden" value="${li2.uci }" name="uci_grp${li2.group_num }">
														<input type="hidden" value="${li2.code }" name="category_grp${li2.group_num }">
														<input type="hidden" value="${li2.place }" name="place_grp${li2.group_num }">
														<input type="hidden" value="${li2.discount }" name="discount_grp${li2.group_num }">
														<input type="hidden" value="${li2.period }" name="period_grp${li2.group_num }">
														<input type="hidden" value="${li2.summary }" name="summary_grp${li2.group_num }">
														<input type="hidden" value="${li2.cont_date }" name="cont_date_grp${li2.group_num }">
														<input type="hidden" value="${li2.rights }" name="rights_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_num }" name="group_num_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_type }" name="group_type_grp${li2.group_num }">
														<input type="hidden" value="${li2.code }" name="code_grp${li2.group_num }">
														<input type="hidden" value="${li2.type }" name="sub_type_grp${li2.group_num }">
													</td>
												</tr>
											</c:if>
										</c:forEach>
									</c:if>
								</c:forEach>
							</c:otherwise>
						</c:choose>
						<!-- 그룹2 -->
						
						
						<!-- 그룹3 -->
						<c:choose>
							<c:when test="${ empty subGrpList}">
								<tr>
									<th scope="row" colspan="2">
										<input type="text" title="상단 타이틀" name="title_top_grp3" placeholder="상단 타이틀 입력란3"/><br/><br/>
										<span>타입 : </span>
										<select id="group_type_grp3" onchange="javascript:setForm(this,3);return;" style="width:100px; margin-left: 15px;">
											<option value="A">A</option>
											<option value="B">B</option>
											<option value="C">C</option>
										</select>
									</th>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="li" items="${subGrpList}">
									<c:if test="${li.group_num eq 3}">
										<tr>
											<th scope="row" colspan="2" rowspan="${li.cnt+1}">
												<input type="text" title="상단 타이틀" name="title_top_grp3" value="${li.top_title }"/><br/><br/>
												<span>타입 : </span>
												<select id="group_type_grp3" onchange="javascript:setForm(this,3);return;" style="width:100px; margin-left: 15px;">
													<option value="A" ${li.group_type eq 'A' ? 'selected="selected"':''}>A</option>
													<option value="B" ${li.group_type eq 'B' ? 'selected="selected"':''}>B</option>
													<option value="C" ${li.group_type eq 'C' ? 'selected="selected"':''}>C</option>
												</select>
											</th>
										</tr>
										<c:forEach var="li2" items="${subList}" varStatus="i">
											<c:if test="${li.group_num eq li2.group_num and li2.code ne li.cnt}">
												<tr class="trInputFrm${li2.group_num }" id="${li2.group_num }_${li2.code }">
													<td colspan="3">
														<span>${li2.title}</span>
														<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('exp',this);return;" style="width:140px;">문화체험 선택</a></span>
														<input type="hidden" value="${li2.title}" name="title_grp${li2.group_num }">
														<input type="hidden" value="${li2.image_name }" name="image_name_grp${li2.group_num }">
														<input type="hidden" value="${li2.image_name2 }" name="image_name2_grp${li2.group_num }">
														<input type="hidden" value="${li2.url }" name="url_grp${li2.group_num }">
														<input type="hidden" value="${li2.uci }" name="uci_grp${li2.group_num }">
														<input type="hidden" value="${li2.code }" name="category_grp${li2.group_num }">
														<input type="hidden" value="${li2.place }" name="place_grp${li2.group_num }">
														<input type="hidden" value="${li2.discount }" name="discount_grp${li2.group_num }">
														<input type="hidden" value="${li2.period }" name="period_grp${li2.group_num }">
														<input type="hidden" value="${li2.summary }" name="summary_grp${li2.group_num }">
														<input type="hidden" value="${li2.cont_date }" name="cont_date_grp${li2.group_num }">
														<input type="hidden" value="${li2.rights }" name="rights_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_num }" name="group_num_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_type }" name="group_type_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_text }" name="main_text_grp${li2.group_num }">
														<input type="hidden" value="${li2.code }" name="code_grp${li2.group_num }">
														<input type="hidden" value="${li2.type }" name="sub_type_grp${li2.group_num }">
													</td>
												</tr>
											</c:if>
											<c:if test="${li.group_num eq li2.group_num and li2.code eq li.cnt}">
												<tr class="trInputFrm${li2.group_num }" id="${li2.group_num }_${li2.code }">
													<td colspan="3">
														<c:if test="${li.group_type eq 'A'}">
															<textarea name="main_text_grp${li2.group_num }" title="텍스트" style="width:100%;margin-bottom:10px;height: 60px;">${li2.group_text }</textarea>
															<span>텍스트 URL&nbsp;:&nbsp;&nbsp;</span><input type="text" value="${li2.url }" name="url_grp${li2.group_num }" style="width:82%;'">
														</c:if>
														<c:if test="${li.group_type eq 'B'}">
															<span>${li2.title}</span>
															<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('exp',this);return;" style="width:140px;">문화체험 선택</a></span>
															<input type="hidden" value="${li2.group_text }" name="main_text_grp${li2.group_num }">
														</c:if>
														<c:if test="${li.group_type eq 'C'}">
															<span>${li2.title}</span>
															<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('ucc',this);return;" style="width:140px;">영상 영역 문화체험 선택</a></span>
															<input type="hidden" value="${li2.group_text }" name="main_text_grp${li2.group_num }">
														</c:if>
														<input type="hidden" value="${li2.title}" name="title_grp${li2.group_num }">
														<input type="hidden" value="${li2.image_name }" name="image_name_grp${li2.group_num }">
														<input type="hidden" value="${li2.image_name2 }" name="image_name2_grp${li2.group_num }">
														<input type="hidden" value="${li2.url }" name="url_grp${li2.group_num }">
														<input type="hidden" value="${li2.uci }" name="uci_grp${li2.group_num }">
														<input type="hidden" value="${li2.code }" name="category_grp${li2.group_num }">
														<input type="hidden" value="${li2.place }" name="place_grp${li2.group_num }">
														<input type="hidden" value="${li2.discount }" name="discount_grp${li2.group_num }">
														<input type="hidden" value="${li2.period }" name="period_grp${li2.group_num }">
														<input type="hidden" value="${li2.summary }" name="summary_grp${li2.group_num }">
														<input type="hidden" value="${li2.cont_date }" name="cont_date_grp${li2.group_num }">
														<input type="hidden" value="${li2.rights }" name="rights_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_num }" name="group_num_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_type }" name="group_type_grp${li2.group_num }">
														<input type="hidden" value="${li2.code }" name="code_grp${li2.group_num }">
														<input type="hidden" value="${li2.type }" name="sub_type_grp${li2.group_num }">
													</td>
												</tr>
											</c:if>
										</c:forEach>
									</c:if>
								</c:forEach>
							</c:otherwise>
						</c:choose>
						<!-- 그룹3 -->
						
						
						<!-- 그룹4 -->
						<c:choose>
							<c:when test="${ empty subGrpList}">
								<tr>
									<th scope="row" colspan="2">
										<input type="text" title="상단 타이틀" name="title_top_grp4" placeholder="상단 타이틀 입력란4"/><br/><br/>
										<span>타입 : </span>
										<select id="group_type_grp4" onchange="javascript:setForm(this,4);return;" style="width:100px; margin-left: 15px;">
											<option value="A">A</option>
											<option value="B">B</option>
											<option value="C">C</option>
										</select>
									</th>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="li" items="${subGrpList}">
									<c:if test="${li.group_num eq 4}">
										<tr>
											<th scope="row" colspan="2" rowspan="${li.cnt+1}">
												<input type="text" title="상단 타이틀" name="title_top_grp4" value="${li.top_title }"/><br/><br/>
												<span>타입 : </span>
												<select id="group_type_grp4" onchange="javascript:setForm(this,4);return;" style="width:100px; margin-left: 15px;">
													<option value="A" ${li.group_type eq 'A' ? 'selected="selected"':''}>A</option>
													<option value="B" ${li.group_type eq 'B' ? 'selected="selected"':''}>B</option>
													<option value="C" ${li.group_type eq 'C' ? 'selected="selected"':''}>C</option>
												</select>
											</th>
										</tr>
										<c:forEach var="li2" items="${subList}" varStatus="i">
											<c:if test="${li.group_num eq li2.group_num and li2.code ne li.cnt}">
												<tr class="trInputFrm${li2.group_num }" id="${li2.group_num }_${li2.code }">
													<td colspan="3">
														<span>${li2.title}</span>
														<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('exp',this);return;" style="width:140px;">문화체험 선택</a></span>
														<input type="hidden" value="${li2.title}" name="title_grp${li2.group_num }">
														<input type="hidden" value="${li2.image_name }" name="image_name_grp${li2.group_num }">
														<input type="hidden" value="${li2.image_name2 }" name="image_name2_grp${li2.group_num }">
														<input type="hidden" value="${li2.url }" name="url_grp${li2.group_num }">
														<input type="hidden" value="${li2.uci }" name="uci_grp${li2.group_num }">
														<input type="hidden" value="${li2.code }" name="category_grp${li2.group_num }">
														<input type="hidden" value="${li2.place }" name="place_grp${li2.group_num }">
														<input type="hidden" value="${li2.discount }" name="discount_grp${li2.group_num }">
														<input type="hidden" value="${li2.period }" name="period_grp${li2.group_num }">
														<input type="hidden" value="${li2.summary }" name="summary_grp${li2.group_num }">
														<input type="hidden" value="${li2.cont_date }" name="cont_date_grp${li2.group_num }">
														<input type="hidden" value="${li2.rights }" name="rights_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_num }" name="group_num_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_type }" name="group_type_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_text }" name="main_text_grp${li2.group_num }">
														<input type="hidden" value="${li2.code }" name="code_grp${li2.group_num }">
														<input type="hidden" value="${li2.type }" name="sub_type_grp${li2.group_num }">
													</td>
												</tr>
											</c:if>
											<c:if test="${li.group_num eq li2.group_num and li2.code eq li.cnt}">
												<tr class="trInputFrm${li2.group_num }" id="${li2.group_num }_${li2.code }">
													<td colspan="3">
														<c:if test="${li.group_type eq 'A'}">
															<textarea name="main_text_grp${li2.group_num }" title="텍스트" style="width:100%;margin-bottom:10px;height: 60px;">${li2.group_text }</textarea>
															<span>텍스트 URL&nbsp;:&nbsp;&nbsp;</span><input type="text" value="${li2.url }" name="url_grp${li2.group_num }" style="width:82%;'">
														</c:if>
														<c:if test="${li.group_type eq 'B'}">
															<span>${li2.title}</span>
															<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('exp',this);return;" style="width:140px;">문화체험 선택</a></span>
															<input type="hidden" value="${li2.group_text }" name="main_text_grp${li2.group_num }">
														</c:if>
														<c:if test="${li.group_type eq 'C'}">
															<span>${li2.title}</span>
															<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('ucc',this);return;" style="width:140px;">영상 영역 문화체험 선택</a></span>
															<input type="hidden" value="${li2.group_text }" name="main_text_grp${li2.group_num }">
														</c:if>
														<input type="hidden" value="${li2.title}" name="title_grp${li2.group_num }">
														<input type="hidden" value="${li2.image_name }" name="image_name_grp${li2.group_num }">
														<input type="hidden" value="${li2.image_name2 }" name="image_name2_grp${li2.group_num }">
														<input type="hidden" value="${li2.url }" name="url_grp${li2.group_num }">
														<input type="hidden" value="${li2.uci }" name="uci_grp${li2.group_num }">
														<input type="hidden" value="${li2.code }" name="category_grp${li2.group_num }">
														<input type="hidden" value="${li2.place }" name="place_grp${li2.group_num }">
														<input type="hidden" value="${li2.discount }" name="discount_grp${li2.group_num }">
														<input type="hidden" value="${li2.period }" name="period_grp${li2.group_num }">
														<input type="hidden" value="${li2.summary }" name="summary_grp${li2.group_num }">
														<input type="hidden" value="${li2.cont_date }" name="cont_date_grp${li2.group_num }">
														<input type="hidden" value="${li2.rights }" name="rights_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_num }" name="group_num_grp${li2.group_num }">
														<input type="hidden" value="${li2.group_type }" name="group_type_grp${li2.group_num }">
														<input type="hidden" value="${li2.code }" name="code_grp${li2.group_num }">
														<input type="hidden" value="${li2.type }" name="sub_type_grp${li2.group_num }">
													</td>
												</tr>
											</c:if>
										</c:forEach>
									</c:if>
								</c:forEach>
							</c:otherwise>
						</c:choose>
						<!-- 그룹4 -->
						
						
						<tr>
							<th scope="row">승인여부</th>
							<td colspan="4">
								<div class="inputBox">
									<label><input type="radio" name="approval" value="Y" ${view.approval eq 'Y' ? 'checked="checked"':''}/> 승인</label>
									<label><input type="radio" name="approval" value="N" ${view.approval eq 'N' or empty view.approval ? 'checked="checked"':''}/> 미승인</label>
								</div>
							</td>
						</tr>
						<!-- 그룹4 -->
						
						
					</tbody>
				</table>
			</div>
			<!-- 함께즐겨요 view div -->
			
			
		</form>
	</div>
	<div class="btnBox textRight">
		<c:if test='${not empty view}'>
			<span class="btn white"><button type="button" onclick="javascript:update();return;">수정</button></span>
			<span class="btn white"><button type="button" onclick="javascript:deleteMain();return;">삭제</button></span>
		</c:if>
		<c:if test='${empty view }'>
			<span class="btn white"><button type="button" onclick="javascript:insert();return;">등록</button></span>
		</c:if>
		<span class="btn gray"><button type="button" onclick="javascript:goList();return;">목록</button></span>
	</div>
	
<table style="display:none;">
<!-- 문화체험용 입력폼 -->
	<tr id="trInputFrm">
		<td colspan="3">
			<span></span>
			<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('exp',this);return;" style="width:140px;">문화체험 선택</a></span>
			<input type="hidden" title="문화체험" value="" name="title_grp0">
			<input type="hidden" value="" name="image_name_grp0">
			<input type="hidden" value="" name="image_name2_grp0">
			<input type="hidden" value="" name="url_grp0">
			<input type="hidden" value="" name="uci_grp0">
			<input type="hidden" value="" name="seq_grp0">
			<input type="hidden" value="" name="category_grp0">
			<input type="hidden" value="" name="place_grp0">
			<input type="hidden" value="" name="discount_grp0">
			<input type="hidden" value="" name="period_grp0">
			<input type="hidden" value="" name="summary_grp0">
			<input type="hidden" value="" name="cont_date_grp0">
			<input type="hidden" value="" name="rights_grp0">
			<input type="hidden" value="" name="group_num_grp0">
			<input type="hidden" value="" name="group_type_grp0">
			<input type="hidden" value="" name="main_text_grp0">
			<!-- 기존엔 common_code에서 코드를 가져와 입력해주었으나 현재는 의미가 없어짐
				 걍 그룹 내 row를 구분하는 데이터로 활용하기로 함 -->
			<input type="hidden" value="" name="code_grp0">
			<input type="hidden" value="" name="sub_type_grp0">
		</td>
	</tr>
	
<!-- 문화영상용 입력폼 -->
	<tr id="trInputFrm2">
		<td colspan="3">
			<span></span>
			<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('ucc',this);return;" style="width:140px;">영상 영역 문화체험 선택</a></span>
			<input type="hidden" title="문화영상" name="title_grp0">
			<input type="hidden" name="image_name_grp0">
			<input type="hidden" name="image_name2_grp0">
			<input type="hidden" name="url_grp0">
			<input type="hidden" name="uci_grp0">
			<input type="hidden" name="seq_grp0">
			<input type="hidden" name="category_grp0">
			<input type="hidden" name="place_grp0">
			<input type="hidden" name="discount_grp0">
			<input type="hidden" name="period_grp0">
			<input type="hidden" name="summary_grp0">
			<input type="hidden" name="cont_date_grp0">
			<input type="hidden" name="rights_grp0">
			<input type="hidden" value="" name="group_num_grp0">
			<input type="hidden" value="" name="group_type_grp0">
			<input type="hidden" value="" name="main_text_grp0">
			<input type="hidden" value="" name="code_grp0">
			<input type="hidden" value="" name="sub_type_grp0">
		</td>
	</tr>
	
<!-- textarea용 입력폼 -->
	<tr id="trInputFrm3">
		<td colspan="3">
			<input type="hidden" title="textarea" name="seq_grp0">
			<input type="hidden" name="uci_grp0">
			<input type="hidden" name="title_grp0">
			<input type="hidden" name="period_grp0">
			<input type="hidden" name="image_name_grp0">
			<input type="hidden" name="image_name2_grp0">
			<input type="hidden" name="category_grp0">
			<input type="hidden" name="place_grp0">
			<input type="hidden" name="discount_grp0">
			<input type="hidden" name="summary_grp0">
			<input type="hidden" name="cont_date_grp0">
			<input type="hidden" name="rights_grp0">
			<input type="hidden" value="" name="group_num_grp0">
			<input type="hidden" value="" name="group_type_grp0">
			<input type="hidden" value="" name="code_grp0">
			<input type="hidden" value="" name="sub_type_grp0">
			<textarea name="main_text_grp0" title="텍스트" style="width:100%;margin-bottom:10px;height: 60px;"></textarea>
			<span>텍스트 URL&nbsp;:&nbsp;&nbsp;</span><input type="text" name="url_grp0" style="width:82%;'">
		</td>
	</tr>
</table>
</body>
</html>