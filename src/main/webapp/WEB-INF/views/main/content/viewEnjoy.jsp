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
	window.open('/popup/cultureExp.do?type='+type+'&subType='+subType+'&gbn='+tab, 'culturePopup', 'scrollbars=yes,width=600,height=630');
}


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


function insert(){

	if(!doValidation()){
		return;
	}
	
	if (!confirm('등록하시겠습니까?')) {
		return false;
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
	
	for( var i=1; i<4; i++){
		var cnt = 0;
		$('input[name=title_grp'+i+']').each(function(){
			if( $(this).val() == "" ){
				cnt++;
			}
		});

		if($('input[name=title_grp'+i+']').attr("title") == "문화릴레이티켓" && cnt == 3){
			alert("문화릴레이티켓을 선택해주세요.");
			rtnFlg = false;
		}
		if($('input[name=title_grp'+i+']').attr("title") == "할인이벤트" && cnt == 1){
			alert("할인이벤트를 선택해주세요.");
			rtnFlg = false;
		}
		if($('input[name=title_grp'+i+']').attr("title") == "국내외 문화영상" && cnt == 9){
			alert("국내외 문화영상을 선택해주세요.");
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
			<input type="hidden" name="groupSize" value="3"/>
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
				<table summary="함께즐겨요 작성">
					<caption>함께즐겨요 작성</caption>
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
						
						<!-- 문화릴레이티켓 START-->
						
						<tr>
							<th scope="row" rowspan="4">문화릴레이티켓</th>
						</tr>
									
						<c:choose>
							<c:when test="${empty subGrpList }">
								<c:forEach begin="0" end="2" varStatus="i">
								<tr id="1_${i.index + 1}" class="trInputFrm1">
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('exp',this, '3');return;" style="width:140px;">문화체험 선택</a></span>
										<input type="hidden" name="title_top_grp1" value="문화릴레이티켓"/>
										<input type="hidden" title="문화릴레이티켓" value="" name="title_grp1">
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
										<input type="hidden" value="1" name="group_num_grp1">
										<input type="hidden" value="1" name="group_type_grp1">
										<input type="hidden" value="" name="main_text_grp1">
										<input type="hidden" value="${i.index + 1}" name="code_grp1">
										<input type="hidden" value="" name="sub_type_grp1">
									</td>
								</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<c:forEach var="li" items="${subGrpList}">
								<c:if test="${li.group_num eq 1}">	
									<c:forEach var="li2" items="${subList}" varStatus="i">
										<c:if test="${li.group_num eq li2.group_num and li2.group_num eq 1}">
											<tr id="${li2.group_num }_${li2.code }" class="trInputFrm1">
												<td colspan="3">
													<span>${li2.title}</span>
													<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('exp',this, '3');return;" style="width:140px;">문화체험 선택</a></span>
													<input type="hidden" value="${li2.title}" name="title_grp1">
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
													<input type="hidden" value="1" name="group_num_grp1">
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
						<!-- 문화릴레이티켓 END-->
						
						
						
						
						<!-- 할인이벤트 START-->
						<tr>
							<th scope="row" rowspan="2">할인이벤트</th>
						</tr>
						<c:choose>
							<c:when test="${empty subGrpList }">
								<tr id="2_1" class="trInputFrm2">
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('exp',this, '4');return;" style="width:140px;">문화체험 선택</a></span>
										<input type="hidden" name="title_top_grp2" value="할인이벤트"/>
										<input type="hidden" title="할인이벤트" value="" name="title_grp2">
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
										<input type="hidden" value="2" name="group_num_grp2">
										<input type="hidden" value="2" name="group_type_grp2">
										<input type="hidden" value="" name="main_text_grp2">
										<input type="hidden" value="1" name="code_grp2">
										<input type="hidden" value="" name="sub_type_grp2">
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="li" items="${subGrpList}">
								<c:if test="${li.group_num eq 2}">
									<c:forEach var="li2" items="${subList}" varStatus="i">
									<c:if test="${li.group_num eq li2.group_num and li2.group_num eq 2}">
									<tr id="${li2.group_num }_${li2.code }" class="trInputFrm2">
										<td colspan="3">
											<span>${li2.title}</span>
											<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('exp',this, '4');return;" style="width:140px;">문화체험 선택</a></span>
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
											<input type="hidden" value="2" name="group_num_grp2">
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
						<!-- 할인이벤트 END-->
						
						<!-- 국내외 문화영상 START-->
						<tr>
							<th scope="row" rowspan="10">국내외 문화영상</th>
						</tr>
						<c:choose>
							<c:when test="${empty subGrpList }">
								<c:forEach begin="0" end="8" varStatus="i">
								<tr id="3_${i.index + 1}" class="trInputFrm3">
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('con',this, '5');return;" style="width:140px;">문화포털 콘텐츠 선택</a></span>
										<input type="hidden" name="title_top_grp3" value="국내외 문화영상"/>
										<input type="hidden" title="국내외 문화영상" value="" name="title_grp3">
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
										<input type="hidden" value="3" name="group_num_grp3">
										<input type="hidden" value="3" name="group_type_grp3">
										<input type="hidden" value="" name="main_text_grp3">
										<input type="hidden" value="${i.index + 1}" name="code_grp3">
										<input type="hidden" value="" name="sub_type_grp3">
									</td>			
								</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<c:forEach var="li" items="${subGrpList}">
								<c:if test="${li.group_num eq 3}">
									<c:forEach var="li2" items="${subList}" varStatus="i">
										<c:if test="${li.group_num eq li2.group_num and li2.group_num eq 3}">
											<tr id="${li2.group_num }_${li2.code }" class="trInputFrm3">
												<td colspan="3">
													<span>${li2.title}</span>
													<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('con',this, '5');return;" style="width:140px;">문화포털 콘텐츠 선택</a></span>
													<input type="hidden" value="${li2.title}" name="title_grp3">
													<input type="hidden" value="${li2.image_name }" name="image_name_grp3">
													<input type="hidden" value="${li2.image_name2 }" name="image_name2_grp3">
													<input type="hidden" value="${li2.url }" name="url_grp3">
													<input type="hidden" value="${li2.uci }" name="uci_grp3">
													<input type="hidden" value="${li2.code }" name="category_grp3">
													<input type="hidden" value="${li2.place }" name="place_grp3">
													<input type="hidden" value="${li2.discount }" name="discount_grp3">
													<input type="hidden" value="${li2.period }" name="period_grp3">
													<%-- <input type="hidden" value="${li2.summary }" name="summary_grp3"> --%>
													<input type="hidden" value="" name="summary_grp3">
													<input type="hidden" value="${li2.cont_date }" name="cont_date_grp3">
													<input type="hidden" value="${li2.rights }" name="rights_grp3">
													<input type="hidden" value="3" name="group_num_grp3">
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
						<!-- 국내외 문화영상 END-->
						
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