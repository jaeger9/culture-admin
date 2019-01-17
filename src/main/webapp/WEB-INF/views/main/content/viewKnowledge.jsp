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
		/2016.09.01 리뉴얼에 의한 메뉴 변경/
		750	함께 즐겨요
		751	지식이 더해집니다
		752	교육/지원사업/문화소식/채용
		753	문화사업
		707	문화산업URL	: AS-IS
		703	우측영역		: 구 함께 즐겨요
	 */

});

var grpId="";

function goPop(type,obj,tab){
	grpId = $(obj).parent().parent().parent().attr("id");
	var subType = '3';
	if(tab == '5') subType = '';
	if(type == 'job'){
		window.open('/popup/cultureExp.do?type=con&subType=5', 'culturePopup', 'scrollbars=yes,width=600,height=630');	
	}else{
		window.open('/popup/cultureExp.do?type='+type+'&subType='+subType+'&gbn='+tab, 'culturePopup', 'scrollbars=yes,width=600,height=630');	
	}
}

function setVal(data){
	var name = "";
	if( data['type'] == 'pattern' ){
	 
		$('#'+grpId).children().find('span:first').each(function(){
			$(this).html(data['title']);
		});
		$('#'+grpId).children().find('input').each(function(){
			name = $(this).attr("name");
		
			if( name.indexOf('uci') > -1 ) $(this).val(data['uci']);
			if( name.indexOf('title') > -1 ) $(this).val(data['title']);
			if( name.indexOf('url') > -1 ) $(this).val(data['url']);
			if( name.indexOf('image_name') > -1 ) $(this).val(data['image']);
			if( name.indexOf('image_name2') > -1 ) $(this).val('');
			if( name.indexOf('summary') > -1 ) $(this).val(data['summary']);
			if( name.indexOf('sub_type') > -1 ) $(this).val(data['code']);
			if( name.indexOf('rights') > -1 ) $(this).val(data['rights']);
		});
	
	} else if( data['type'] == 'humanLecture' ){
		$('#'+grpId).children().find('span:first').each(function(){
			$(this).html(data['title']);
		});
		$('#'+grpId).children().find('input').each(function(){
			name = $(this).attr("name");
		
			if( name.indexOf('uci') > -1 ) $(this).val(data['seq']);
			if( name.indexOf('title') > -1 ) $(this).val(data['title']);
			if( name.indexOf('image_name') > -1 ) $(this).val(data['image']);
			if( name.indexOf('image_name2') > -1 ) $(this).val('');
		});
	} else {
		$('#'+grpId).children().find('span:first').each(function(){
			$(this).html(data['title']);
		});
		$('#'+grpId).children().find('input').each(function(){
			name = $(this).attr("name");
		
			if( name.indexOf('uci') > -1 ) $(this).val(data['seq']);
			if( name.indexOf('title') > -1 ) $(this).val(data['title']);
			if( name.indexOf('image_name') > -1 ) $(this).val(data['image']);
			if( name.indexOf('image_name2') > -1 ) $(this).val('');
			if( name.indexOf('sub_type') > -1 ) $(this).val(data['category']);
			if( name.indexOf('url') > -1 ) $(this).val(data['url']);
		});
	}
}

function insert(){
	if (!confirm('등록하시겠습니까?')) {
		return false;
	}
	
	if(!doValidation()){
		return;
	}
	
	action = "insert";
	$('form[name=frm]').attr('action' ,'/main/content/insertMainContents.do');
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
	
	if(!doValidation()){
		return;
	}
	
	action = "update";
	$('form[name=frm]').attr('action' ,'/main/content/updateMainContents.do');
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


function doValidation(){
	var rtnFlg = true;
	
	if( $('input[name=mainTitle]').val() == '' ){
		alert("제목을 입력하세요.");
		$('input[name=mainTitle]').focus();
		return false;
	}
	
	if( $('input[name=mainWriter]').val() == '' ){
		alert("등록자를 입력하세요.");
		$('input[name=mainWriter]').focus();
		return false;
	}
	
	for( var i=1; i<=4 ; i++){
		var cnt = 0;
		$('input[name=title_grp'+i+']').each(function(){
			if( $(this).val() == "" ){
				cnt++;
			}
		});

		if($('input[name=title_grp'+i+']').attr("title") == "전통문양활용" && cnt == 4){
			alert("전통문양활용을 선택해주세요.");
			rtnFlg = false;
		}
		if($('input[name=title_grp'+i+']').attr("title") == "문화직업" && cnt == 1){
			alert("문화직업을 선택해주세요.");
			rtnFlg = false;
		}
		if($('input[name=title_grp'+i+']').attr("title") == "인문학강연" && cnt == 1){
			alert("인문학강연을 선택해주세요.");
			rtnFlg = false;
		}
		if($('input[name=title_grp'+i+']').attr("title") == "교육활용자료" && cnt == 1){
			alert("교육활용자료를 선택해주세요.");
			rtnFlg = false;
		}
		if(!rtnFlg){
			break;
		}
	}
	
	return rtnFlg;
}

</script>
</head>
<body>
	<div class="tableWrite">
		<form name="frm" method="post" action="/main/content/insertMainContents.do">
			<input type="hidden" name="groupSize" value="4"/>
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
			
			<div>
				<table summary="지식이더해집니다 작성">
					<caption>지식이더해집니다 작성</caption>
					<colgroup>
						<col style="width:20%" />
						<col style="*" />
						<col style="width:10%" />
						<col style="width:20%" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">제목</th>
							<td>
								<input type="text" title="메인콘텐츠 제목" name="mainTitle" style="width:100%;" value="${view.title}"/>
							</td>
							<th scope="row">등록자</th>
							<td>
								<input type="text" title="등록자" name="mainWriter" style="width:100%;" value="${view.writer}"/>
							</td>
						</tr>
						
						<!-- 전통문양활용 START-->
						<tr>
							<th scope="row" rowspan="5">전통문양활용</th>
						</tr>
									
						<c:choose>
							<c:when test="${empty subGrpList }">
								<c:forEach begin="0" end="3" varStatus="i">
								<tr id="1_${i.index + 1}" class="trInputFrm1">
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('pattern',this, '1');return;" style="width:140px;">전통문양활용 선택</a></span>
										<input type="hidden" name="title_top_grp1" value="전통문양활용"/>
										<input type="hidden" title="전통문양활용" value="" name="title_grp1">
										<input type="hidden" value="" name="seq_grp1">
										<input type="hidden" value="" name="image_name_grp1">
										<input type="hidden" value="" name="image_name2_grp1">
										<input type="hidden" value="" name="url_grp1">
										<input type="hidden" value="" name="uci_grp1">
										<input type="hidden" value="" name="seq_grp1">
										<input type="hidden" value="" name="category_grp1">
										<input type="hidden" value="" name="place_grp1">
										<input type="hidden" value="" name="discount_grp1">
										<input type="hidden" value="" name="period_grp1">
										<input type="hidden" value="" name="summary_grp1">
										<input type="hidden" value="" name="cont_date_grp1">
										<input type="hidden" value="" name="rights_grp1">
										<input type="hidden" value="${i.index + 1}" name="group_num_grp1">
										<input type="hidden" value="1" name="group_type_grp1">
										<input type="hidden" value="" name="main_text_grp1">
										<input type="hidden" value="1" name="code_grp1">
										<input type="hidden" value="" name="sub_type_grp1">
									</td>
								</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<c:forEach var="li" items="${subGrpList}">
								<c:if test="${li.group_type eq 1}">	
									<c:forEach var="li2" items="${subList}" varStatus="i">
										<c:if test="${li.group_type eq li2.group_type and li.group_num eq li2.group_num}">
											<tr id="${li.group_type }_${li2.group_num}" class="trInputFrm1">
												<td colspan="3">
													<span>${li2.title}</span>
													<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('pattern',this, '1');return;" style="width:140px;">전통문양활용 선택</a></span>
													<input type="hidden" value="${li2.title}" name="title_grp1">
													<input type="hidden" value="${li2.seq}" name="seq_grp1">
													<input type="hidden" value="${li2.image_name }" name="image_name_grp1">
													<input type="hidden" value="${li2.image_name2 }" name="image_name2_grp1">
													<input type="hidden" value="${li2.url }" name="url_grp1">
													<input type="hidden" value="${li2.uci }" name="uci_grp1">
													<input type="hidden" value="${li2.code }" name="category_grp1">
													<input type="hidden" value="${li2.place }" name="place_grp1">
													<input type="hidden" value="${li2.discount }" name="discount_grp1">
													<input type="hidden" value="${li2.period }" name="period_grp1">
													<input type="hidden" value="${li2.summary }" name="summary_grp1">
													<input type="hidden" value="${li2.cont_date }" name="cont_date_grp1">
													<input type="hidden" value="${li2.rights }" name="rights_grp1">
													<input type="hidden" value="${li2.group_num}" name="group_num_grp1">
													<input type="hidden" value="${li2.group_type }" name="group_type_grp1">
													<input type="hidden" value="${li2.group_text }" name="main_text_grp1">
													<input type="hidden" value="${li2.code }" name="code_grp1">
													<input type="hidden" value="${li2.type }" name="sub_type_grp1">
												</td>
											</tr>
										</c:if>
										
									</c:forEach>
								</c:if>
								</c:forEach>
							</c:otherwise>
						</c:choose>	
						<!-- 전통문양활용 END-->
						

						<!-- 문화예보 START-->
						<!-- 
						<tr>
							<th scope="row" rowspan="2">문화예보</th>
						</tr>
						<c:choose>
							<c:when test="${empty subGrpList }">
								<tr id="2_1" class="trInputFrm2">
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('forecast',this);return;" style="width:140px;">문화예보 선택</a></span>
										<input type="hidden" name="title_top_grp2" value="문화예보"/>
										<input type="hidden" title="문화예보" value="" name="title_grp2">
										<input type="hidden" value="" name="image_name_grp2">
										<input type="hidden" value="" name="image_name2_grp2">
										<input type="hidden" value="" name="url_grp2">
										<input type="hidden" value="" name="uci_grp2">
										<input type="hidden" value="" name="seq_grp2">
										<input type="hidden" value="" name="category_grp2">
										<input type="hidden" value="" name="place_grp2">
										<input type="hidden" value="" name="discount_grp2">
										<input type="hidden" value="" name="period_grp2">
										<input type="hidden" value="" name="summary_grp2">
										<input type="hidden" value="" name="cont_date_grp2">
										<input type="hidden" value="" name="rights_grp2">
										<input type="hidden" value="1" name="group_num_grp2">
										<input type="hidden" value="2" name="group_type_grp2">
										<input type="hidden" value="" name="main_text_grp2">
										<input type="hidden" value="1" name="code_grp2">
										<input type="hidden" value="" name="sub_type_grp2">
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="li" items="${subGrpList}">
								<c:if test="${li.group_type eq 2}">
									<c:forEach var="li2" items="${subList}" varStatus="i">
									<c:if test="${li.group_type eq li2.group_type }">
									<tr id="${li2.group_type }_${li2.group_num }" class="trInputFrm2">
										<td colspan="3">
											<span>${li2.title}</span>
											<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('forecast',this);return;" style="width:140px;">문화예보 선택</a></span>
											<input type="hidden" value="${li2.title}" name="title_grp2">
											<input type="hidden" value="${li2.image_name }" name="image_name_grp2">
											<input type="hidden" value="${li2.image_name2 }" name="image_name2_grp2">
											<input type="hidden" value="${li2.url }" name="url_grp2">
											<input type="hidden" value="${li2.uci }" name="uci_grp2">
											<input type="hidden" value="${li2.code }" name="category_grp2">
											<input type="hidden" value="${li2.place }" name="place_grp2">
											<input type="hidden" value="${li2.discount }" name="discount_grp2">
											<input type="hidden" value="${li2.period }" name="period_grp2">
											<input type="hidden" value="${li2.summary }" name="summary_grp2">
											<input type="hidden" value="${li2.cont_date }" name="cont_date_grp2">
											<input type="hidden" value="${li2.rights }" name="rights_grp2">
											<input type="hidden" value="${li2.group_num }" name="group_num_grp2">
											<input type="hidden" value="${li2.group_type }" name="group_type_grp2">
											<input type="hidden" value="${li2.group_text }" name="main_text_grp2">
											<input type="hidden" value="${li2.code }" name="code_grp2">
											<input type="hidden" value="${li2.type }" name="sub_type_grp2">
										</td>
									</tr>
									</c:if>
									
									</c:forEach>
								</c:if>
								</c:forEach>
							</c:otherwise>
						</c:choose>
						-->
						<!--문화예보 END-->
						<!--  한국문화100 -->
						<tr>
							<th scope="row" rowspan="2">한국문화100</th>
						</tr>
						<c:choose>
							<c:when test="${empty subGrpList }">
								<tr id="2_1" class="trInputFrm2">
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('culture100',this);return;" style="width:140px;">한국문화100 선택</a></span>
										<input type="hidden" name="title_top_grp2" value="한국문화100"/>
										<input type="hidden" title="한국문화100" value="" name="title_grp2">
										<input type="hidden" value="" name="image_name_grp2">
										<input type="hidden" value="" name="image_name2_grp2">
										<input type="hidden" value="" name="url_grp2">
										<input type="hidden" value="" name="uci_grp2">
										<input type="hidden" value="" name="seq_grp2">
										<input type="hidden" value="" name="category_grp2">
										<input type="hidden" value="" name="place_grp2">
										<input type="hidden" value="" name="discount_grp2">
										<input type="hidden" value="" name="period_grp2">
										<input type="hidden" value="" name="summary_grp2">
										<input type="hidden" value="" name="cont_date_grp2">
										<input type="hidden" value="" name="rights_grp2">
										<input type="hidden" value="1" name="group_num_grp2">
										<input type="hidden" value="2" name="group_type_grp2">
										<input type="hidden" value="" name="main_text_grp2">
										<input type="hidden" value="1" name="code_grp2">
										<input type="hidden" value="" name="sub_type_grp2">
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="li" items="${subGrpList}">
								<c:if test="${li.group_type eq 2}">
									<c:forEach var="li2" items="${subList}" varStatus="i">
									<c:if test="${li.group_type eq li2.group_type }">
									<tr id="${li2.group_type }_${li2.group_num }" class="trInputFrm2">
										<td colspan="3">
											<span>${li2.title}</span>
											<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('culture100',this);return;" style="width:140px;">한국문화100 선택</a></span>
											<input type="hidden" value="${li2.title}" name="title_grp2">
											<input type="hidden" value="${li2.image_name }" name="image_name_grp2">
											<input type="hidden" value="${li2.image_name2 }" name="image_name2_grp2">
											<input type="hidden" value="${li2.url }" name="url_grp2">
											<input type="hidden" value="${li2.uci }" name="uci_grp2">
											<input type="hidden" value="${li2.code }" name="category_grp2">
											<input type="hidden" value="${li2.place }" name="place_grp2">
											<input type="hidden" value="${li2.discount }" name="discount_grp2">
											<input type="hidden" value="${li2.period }" name="period_grp2">
											<input type="hidden" value="${li2.summary }" name="summary_grp2">
											<input type="hidden" value="${li2.cont_date }" name="cont_date_grp2">
											<input type="hidden" value="${li2.rights }" name="rights_grp2">
											<input type="hidden" value="${li2.group_num }" name="group_num_grp2">
											<input type="hidden" value="${li2.group_type }" name="group_type_grp2">
											<input type="hidden" value="${li2.group_text }" name="main_text_grp2">
											<input type="hidden" value="${li2.code }" name="code_grp2">
											<input type="hidden" value="${li2.type }" name="sub_type_grp2">
										</td>
									</tr>
									</c:if>
									</c:forEach>
								</c:if>
								</c:forEach>
							</c:otherwise>
						</c:choose>
						<!--한국문화100 END-->
						
						<!-- 문화직업 START-->
					<%-- 	<tr>
							<th scope="row" rowspan="2">문화직업</th>
						</tr>
						<c:choose>
							<c:when test="${empty subGrpList }">
								<tr id="3_1" class="trInputFrm3">
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('job',this);return;" style="width:140px;">문화직업 선택</a></span>
										<input type="hidden" name="title_top_grp3" value="문화직업"/>
										<input type="hidden" title="문화직업" value="" name="title_grp3">
										<input type="hidden" value="" name="image_name_grp3">
										<input type="hidden" value="" name="image_name2_grp3">
										<input type="hidden" value="" name="url_grp3">
										<input type="hidden" value="" name="uci_grp3">
										<input type="hidden" value="" name="seq_grp3">
										<input type="hidden" value="" name="category_grp3">
										<input type="hidden" value="" name="place_grp3">
										<input type="hidden" value="" name="discount_grp3">
										<input type="hidden" value="" name="period_grp3">
										<input type="hidden" value="" name="summary_grp3">
										<input type="hidden" value="" name="cont_date_grp3">
										<input type="hidden" value="" name="rights_grp3">
										<input type="hidden" value="1" name="group_num_grp3">
										<input type="hidden" value="3" name="group_type_grp3">
										<input type="hidden" value="" name="main_text_grp3">
										<input type="hidden" value="1" name="code_grp3">
										<input type="hidden" value="" name="sub_type_grp3">
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="li" items="${subGrpList}">
								<c:if test="${li.group_type eq 3}">
									<c:forEach var="li2" items="${subList}" varStatus="i">
									<c:if test="${li.group_type eq li2.group_type}">
									<tr id="${li2.group_type }_${li2.group_num }" class="trInputFrm3">
										<td colspan="3">
											<span>${li2.title}</span>
											<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('job',this);return;" style="width:140px;">문화직업 선택</a></span>
											<input type="hidden" value="${li2.title}" name="title_grp3">
											<input type="hidden" value="${li2.image_name }" name="image_name_grp3">
											<input type="hidden" value="${li2.image_name2 }" name="image_name2_grp3">
											<input type="hidden" value="${li2.url }" name="url_grp3">
											<input type="hidden" value="${li2.uci }" name="uci_grp3">
											<input type="hidden" value="${li2.code }" name="category_grp3">
											<input type="hidden" value="${li2.place }" name="place_grp3">
											<input type="hidden" value="${li2.discount }" name="discount_grp3">
											<input type="hidden" value="${li2.period }" name="period_grp3">
											<input type="hidden" value="${li2.summary }" name="summary_grp3">
											<input type="hidden" value="${li2.cont_date }" name="cont_date_grp3">
											<input type="hidden" value="${li2.rights }" name="rights_grp3">
											<input type="hidden" value="${li2.group_num }" name="group_num_grp3">
											<input type="hidden" value="${li2.group_type }" name="group_type_grp3">
											<input type="hidden" value="${li2.group_text }" name="main_text_grp3">
											<input type="hidden" value="${li2.code }" name="code_grp3">
											<input type="hidden" value="${li2.type }" name="sub_type_grp3">
										</td>
									</tr>
									</c:if>
									
									</c:forEach>
								</c:if>
								</c:forEach>
							</c:otherwise>
						</c:choose> --%>
						<!-- 문화직업 END-->
						
						<!-- 기획영상 START-->
						<tr>
							<th scope="row" rowspan="2">기획영상</th>
						</tr>
						<c:choose>
							<c:when test="${empty subGrpList }">
								<tr id="3_1" class="trInputFrm3">
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('job',this);return;" style="width:140px;">기획영상선택</a></span>
										<input type="hidden" name="title_top_grp3" value="기획영상"/>
										<input type="hidden" title="기획영상" value="" name="title_grp3">
										<input type="hidden" value="" name="image_name_grp3">
										<input type="hidden" value="" name="image_name2_grp3">
										<input type="hidden" value="" name="url_grp3">
										<input type="hidden" value="" name="uci_grp3">
										<input type="hidden" value="" name="seq_grp3">
										<input type="hidden" value="" name="category_grp3">
										<input type="hidden" value="" name="place_grp3">
										<input type="hidden" value="" name="discount_grp3">
										<input type="hidden" value="" name="period_grp3">
										<input type="hidden" value="" name="summary_grp3">
										<input type="hidden" value="" name="cont_date_grp3">
										<input type="hidden" value="" name="rights_grp3">
										<input type="hidden" value="1" name="group_num_grp3">
										<input type="hidden" value="3" name="group_type_grp3">
										<input type="hidden" value="" name="main_text_grp3">
										<input type="hidden" value="1" name="code_grp3">
										<input type="hidden" value="" name="sub_type_grp3">
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="li" items="${subGrpList}">
								<c:if test="${li.group_type eq 3}">
									<c:forEach var="li2" items="${subList}" varStatus="i">
									<c:if test="${li.group_type eq li2.group_type}">
									<tr id="${li2.group_type }_${li2.group_num }" class="trInputFrm3">
										<td colspan="3">
											<span>${li2.title}</span>
											<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('job',this);return;" style="width:140px;">기획영상선택</a></span>
											<input type="hidden" value="${li2.title}" name="title_grp3">
											<input type="hidden" value="${li2.image_name }" name="image_name_grp3">
											<input type="hidden" value="${li2.image_name2 }" name="image_name2_grp3">
											<input type="hidden" value="${li2.url }" name="url_grp3">
											<input type="hidden" value="${li2.uci }" name="uci_grp3">
											<input type="hidden" value="${li2.code }" name="category_grp3">
											<input type="hidden" value="${li2.place }" name="place_grp3">
											<input type="hidden" value="${li2.discount }" name="discount_grp3">
											<input type="hidden" value="${li2.period }" name="period_grp3">
											<input type="hidden" value="${li2.summary }" name="summary_grp3">
											<input type="hidden" value="${li2.cont_date }" name="cont_date_grp3">
											<input type="hidden" value="${li2.rights }" name="rights_grp3">
											<input type="hidden" value="${li2.group_num }" name="group_num_grp3">
											<input type="hidden" value="${li2.group_type }" name="group_type_grp3">
											<input type="hidden" value="${li2.group_text }" name="main_text_grp3">
											<input type="hidden" value="${li2.code }" name="code_grp3">
											<input type="hidden" value="${li2.type }" name="sub_type_grp3">
										</td>
									</tr>
									</c:if>
									
									</c:forEach>
								</c:if>
								</c:forEach>
							</c:otherwise>
						</c:choose>
						<!-- 기획영상 END-->
						
						
						<!-- 교육활용자료 START-->
						<tr>
							<th scope="row" rowspan="2">교육활용자료</th>
						</tr>
						<c:choose>
							<c:when test="${empty subGrpList }">
								<tr id="4_1" class="trInputFrm4">
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('ict',this);return;" style="width:140px;">교육활용자료 선택</a></span>
										<input type="hidden" name="title_top_grp4" value="교육활용자료"/>
										<input type="hidden" title="교육활용자료" value="" name="title_grp4">
										<input type="hidden" value="" name="image_name_grp4">
										<input type="hidden" value="" name="image_name2_grp4">
										<input type="hidden" value="" name="url_grp4">
										<input type="hidden" value="" name="uci_grp4">
										<input type="hidden" value="" name="seq_grp4">
										<input type="hidden" value="" name="category_grp4">
										<input type="hidden" value="" name="place_grp4">
										<input type="hidden" value="" name="discount_grp4">
										<input type="hidden" value="" name="period_grp4">
										<input type="hidden" value="" name="summary_grp4">
										<input type="hidden" value="" name="cont_date_grp4">
										<input type="hidden" value="" name="rights_grp4">
										<input type="hidden" value="1" name="group_num_grp4">
										<input type="hidden" value="4" name="group_type_grp4">
										<input type="hidden" value="" name="main_text_grp4">
										<input type="hidden" value="1" name="code_grp4">
										<input type="hidden" value="" name="sub_type_grp4">
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="li" items="${subGrpList}">
								<c:if test="${li.group_type eq 4}">
									<c:forEach var="li2" items="${subList}" varStatus="i">
									<c:if test="${li.group_type eq li2.group_type}">
									<tr id="${li2.group_type }_${li2.group_num }" class="trInputFrm2">
										<td colspan="3">
											<span>${li2.title}</span>
											<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('ict',this);return;" style="width:140px;">교육활용자료 선택</a></span>
											<input type="hidden" value="${li2.title}" name="title_grp4">
											<input type="hidden" value="${li2.image_name }" name="image_name_grp4">
											<input type="hidden" value="${li2.image_name2 }" name="image_name2_grp4">
											<input type="hidden" value="${li2.url }" name="url_grp4">
											<input type="hidden" value="${li2.uci }" name="uci_grp4">
											<input type="hidden" value="${li2.code }" name="category_grp4">
											<input type="hidden" value="${li2.place }" name="place_grp4">
											<input type="hidden" value="${li2.discount }" name="discount_grp4">
											<input type="hidden" value="${li2.period }" name="period_grp4">
											<input type="hidden" value="${li2.summary }" name="summary_grp4">
											<input type="hidden" value="${li2.cont_date }" name="cont_date_grp4">
											<input type="hidden" value="${li2.rights }" name="rights_grp4">
											<input type="hidden" value="${li2.group_num }" name="group_num_grp4">
											<input type="hidden" value="${li2.group_type }" name="group_type_grp4">
											<input type="hidden" value="${li2.group_text }" name="main_text_grp4">
											<input type="hidden" value="${li2.code }" name="code_grp4">
											<input type="hidden" value="${li2.type }" name="sub_type_grp4">
										</td>
									</tr>
									</c:if>
									
									</c:forEach>
								</c:if>
								</c:forEach>
							</c:otherwise>
						</c:choose>
						<!-- 교육활용자료 END-->
						
						<tr>
							<th scope="row">승인여부</th>
							<td colspan="3">
								<div class="inputBox">
									<label><input type="radio" name="approval" value="Y" ${view.approval eq 'Y' ? 'checked="checked"':''}/> 승인</label>
									<label><input type="radio" name="approval" value="N" ${view.approval eq 'N' or empty view.approval ? 'checked="checked"':''}/> 미승인</label>
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
			<span class="btn white"><button type="button" onclick="javascript:update();return;">수정</button></span>
			<span class="btn white"><button type="button" onclick="javascript:deleteMain();return;">삭제</button></span>
		</c:if>
		<c:if test='${empty view }'>
			<span class="btn white"><button type="button" onclick="javascript:insert();return;">등록</button></span>
		</c:if>
		<span class="btn gray"><button type="button" onclick="javascript:goList();return;">목록</button></span>
	</div>
	
</body>
</html>