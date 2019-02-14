<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">

/*
	/2016.09.01 리뉴얼에 의한 메뉴 변경/
	750	함께 즐겨요
	751	지식이 더해집니다
	752	교육/지원사업/문화소식/채용
	753	문화사업
	707	문화산업URL	: AS-IS
	703	우측영역		: 구 함께 즐겨요
*/

$(function () {
	$('body').keydown(function(event) {
		if(event.keyCode == '13'){
			return false;
		}
	});
});

var grpId="";
function setVal(data){
	var name = "";
	$('#'+grpId).children().find('span:first').each(function(){
		$(this).html(data['title']);
	});
	$('#'+grpId).children().find('input').each(function(){
		name = $(this).attr("name");

		if( name.indexOf('title') > -1 ) $(this).val(data['title']);
		if( name.indexOf('url') > -1 ) $(this).val(data['url']);
		if( name.indexOf('uci') > -1 ) $(this).val(data['uci']);
		if( name.indexOf('cont_date') > -1 ) $(this).val(data['cont_date']);
		if( name.indexOf('rights') > -1 ) $(this).val(data['rights']);
		if( name.indexOf('image_name') > -1 ) $(this).val(data['image']);
	});
}

function goList(){
	action = "list";
	$('form[name=frm]').attr('action' ,'/main/content/list.do');
	$('form[name=frm]').submit();
}

function insert(){
	if (!confirm('등록하시겠습니까?')) {
		return false;
	}
	
	if( !doValidation() ){
		return;
	}	
	
	action = "insert";
	$('form[name=frm]').attr('action' ,'/main/content/insert.do');
	$('form[name=frm]').submit();
}

function update(){
	if (!confirm('수정하시겠습니까?')) {
		return false;
	}
	
	if( !doValidation() ){
		return;
	}	
	
	action = "update";
	$('form[name=frm]').attr('action' ,'/main/content/update.do');
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

var infoTxt = new Array();
infoTxt['698'] = "문화소식";
infoTxt['699'] = "교육";
infoTxt['700'] = "채용";
infoTxt['816'] = "지원사업";

function doValidation(){
	var valFlg = true;
	var name = "";
	
	if( $('input[name=mainTitle]').val() == '' ){
		alert("제목을 입력해주세요.");
		$('input[name=mainTitle]').focus();
		return false;
	}
	
	if( $('input[name=mainWriter]').val() == '' ){
		alert("등록자를 입력해주세요.");
		$('input[name=mainWriter]').focus();
		return false;
	}

	var cnt = 0;
 	$('#notiDiv').find('input').each(function(){
		name = $(this).attr('name');
		if( name == 'code' ){
			type = $(this).val();
		}
		if(name == 'title'){
			if(type == '816'){ //지원사업의 경우 1개이상이면 등록가능
				if($(this).val() == "") cnt++;
				if(cnt ==  5){
					alert(infoTxt[type]+"을 선택해주세요.");
					valFlg = false;
					return false;
				}
			}else{
				if( $(this).val() == "" ){
					alert(infoTxt[type]+"을 선택해주세요.");
					valFlg = false;
					return false;
				}
			}
		}
	});

	return valFlg;
}

var grpId = "";
function goPop(gbn,obj,subType){
	grpId = $(obj).parent().parent().parent().attr("id");
	
	window.open('/popup/cultureExp.do?type=etc&type2='+gbn+'&subType='+subType, 'culturePopup', 'scrollbars=yes,width=600,height=630');
}
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" enctype="multipart/form-data">
			<input type="hidden" name="searchApproval" value="${paramMap.searchApproval}"/>
						
			<c:if test='${not empty view.seq }'>
				<input type="hidden" name="pseq" value="${view.seq }"/>
			</c:if>
			<input type="hidden" name="menu_type" value="${paramMap.menu_type }"/>
			<ul class="tab">
				<c:forEach items="${tabList }" var="tabList" varStatus="status">
					<%-- <li>
						<a href="/main/content/list.do?menu_type=${tabList.code}" <c:if test="${ paramMap.menu_type eq tabList.code }"> class="focus"</c:if>>
							${tabList.name}
						</a>
					</li> --%>
					 <c:if test="${tabList.code ne 750 and  tabList.code ne 751 and tabList.code ne 752
			     and tabList.code ne 753  and tabList.code ne 707  and tabList.code ne 703}">
					<li>
						<a href="/main/content/list.do?menu_type=${tabList.code}" <c:if test="${ paramMap.menu_type eq tabList.code }"> class="focus"</c:if>>
							${tabList.name}
						</a>
					</li>
				</c:if>
				</c:forEach>
			</ul>
			
			<!-- 지식이 더해집니다. view div -->
			<div id="notiDiv">
				<table summary="소식/교육/채용 작성">
					<caption>소식/교육/채용 작성</caption>
					<colgroup>
						<col style="width:15%" />
						<col style="*" />
						<col style="width:15%" />
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
						<!-- 
						698 : 소식(문화소식)
						699 : 교육
						700 : 채용
						
						697 : 지원사업
						 -->
						<c:if test="${empty subList}">
							<c:forEach var="li" items="${menuList}">
							<!-- 소식, 교육 안보이게끔 하드코딩 -->
							  <c:if test="${li.code ne 698 and li.code ne 699 }">
								<tr>
									<th scope="row" rowspan="6">${li.name}</th>
								</tr>							
								<c:forEach begin="1" end="5" varStatus="i">
									<tr id="tr${li.code}${i.index}">
										<td colspan="4">
											<span></span>
											<c:choose>
											 	<c:when test="${li.code eq '698' }">
													<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('noti',this,0);return;" style="width:140px;">${li.name} 선택</a></span>
												</c:when>
												<c:when test="${li.code eq '699' }">
													<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('noti',this,1);return;" style="width:140px;">${li.name} 선택</a></span>
												</c:when> 
												<c:when test="${li.code eq '700' }">
													<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('noti',this,2);return;" style="width:140px;">${li.name} 선택</a></span>
												</c:when>
												<c:otherwise>
													<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('noti',this,3);return;" style="width:140px;">${li.name} 선택</a></span>
												</c:otherwise>
											</c:choose>
											<input type="hidden" name="code" value="${li.code}"/>
											<input type="hidden" name="title"/>
											<input type="hidden" name="url"/>
											<input type="hidden" name="uci"/>
											<input type="hidden" name="cont_date"/>
											<input type="hidden" name="rights"/>
											<input type="hidden" name="image_name"/>
										</td>
									</tr>
								</c:forEach>
							  </c:if>
							</c:forEach>
						</c:if>
						<c:if test="${not empty subList}">
							<c:forEach var="li" items="${menuList}">
							<!-- 소식, 교육 안보이게끔 하드코딩 -->
							  <c:if test="${li.code ne 698 and li.code ne 699 }">
								<tr>
									<th scope="row" rowspan="6">${li.name}</th>
								</tr>							
								<c:forEach var="li2" items="${subList}" varStatus="i">
								  <c:if test="${li2.code ne 698 and li2.code ne 699 }">
									<c:if test="${li2.code eq li.code }">
										<tr id="tr${li.code}${i.index}">
											<td colspan="4">
												<span>${li2.title}</span>
												<c:choose>
													<c:when test="${li.code eq '698' }">
														<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('noti',this,0);return;" style="width:140px;">${li.name} 선택</a></span>
													</c:when>
													<c:when test="${li.code eq '699' }">
														<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('noti',this,1);return;" style="width:140px;">${li.name} 선택</a></span>
													</c:when>
													<c:when test="${li.code eq '700' }">
														<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('noti',this,2);return;" style="width:140px;">${li.name} 선택</a></span>
													</c:when>
													<c:otherwise>
														<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('noti',this,3);return;" style="width:140px;">${li.name} 선택</a></span>
													</c:otherwise>
												</c:choose>
												<input type="hidden" name="code" value="${li.code}"/>
												<input type="hidden" value="${fn:replace(li2.title,'"','&quot;') }" name="title"/>
												<input type="hidden" value="${li2.url }" name="url"/>
												<input type="hidden" value="${li2.uci }" name="uci"/>
												<input type="hidden" value="${li2.cont_date }" name="cont_date"/>
												<input type="hidden" value="${li2.rights }" name="rights"/>
												<input type="hidden" value="${li2.image_name }" name="image_name"/>
												<input type="hidden" value="${li2.seq }" name="seq"/>
											</td>
										</tr>
									</c:if>
								  </c:if>
								</c:forEach>
							  </c:if>
							</c:forEach>
						</c:if>
						
						<tr>
							<th scope="row">승인여부</th>
							<td colspan="4">
								<div class="inputBox">
									<label><input type="radio" name="approval" value="Y" ${view.approval eq 'Y' ? 'checked="checked"':''}/> 승인</label>
									<label><input type="radio" name="approval" value="N" ${view.approval eq 'N' or empty view.approval ? 'checked="checked"':''}/> 미승인</label>
								</div>
							</td>
						</tr>
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
</body>
</html>