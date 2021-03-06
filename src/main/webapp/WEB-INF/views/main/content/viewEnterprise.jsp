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
function setVal(data){
	var name = "";
	$('#'+grpId).children().find('span:first').each(function(){
		$(this).html(data['title']);
	});
	$('#'+grpId).children().find('input').each(function(){
		name = $(this).attr("name");
		if( name.indexOf('title') > -1 ) $(this).val(data['title']);
		if( name.indexOf('url') > -1 ) $(this).val(data['url']);
		if( name.indexOf('image_name') > -1 ) $(this).val(data['image']);
		if( name.indexOf('uci') > -1 ) $(this).val(data['seq']);
		if( name.indexOf('new_win_yn') > -1 ) $(this).val(data['new_win_yn']);
	});
}

function goPop(gbn,obj){
	grpId = $(obj).parent().parent().parent().attr("id");
	
	window.open('/popup/cultureExp.do?type='+gbn+'&subType=3', 'culturePopup', 'scrollbars=yes,width=600,height=630');
}

function insert(){
	if (!confirm('등록하시겠습니까?')) {
		return false;
	}
	
	if(!doValidation()){
		return;
	}
	
	action = "insert";
	$('form[name=frm]').attr('action' ,'/main/content/insert.do');
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
	
	for( var i=0; i<8; i++){
		$('#tr'+i).each(function(){
			if( $(this).find("input[name=title]").val() == "" ){
				alert("문화사업을 선택해주세요.");
				$(this).find('.btn').focus();
				rtnFlg = false;
			}
		});
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
		<form name="frm" method="post" action="/main/content/insert.do">
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
				<table summary="문화사업 작성">
					<caption>문화사업 작성</caption>
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
								<input type="text" title="메인콘텐츠 제목" maxlength="500" name="mainTitle" style="width:100%;" value="${view.title}"/>
							</td>
							<th scope="row">등록자</th>
							<td>
								<input type="text" title="등록자" maxlength="10" name="mainWriter" style="width:100%;" value="${view.writer}"/>
							</td>
						</tr>
						<tr>
							<th scope="row" rowspan="2">대표 문화사업<br/>(이미지+제목 노출)</th>
						</tr>
						<c:if test="${empty subList }">
							<tr id="tr1">
								<td colspan="3">
									<span></span>
									<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('enterprise',this);return;" style="width:140px;">문화사업 선택</a></span>
									<input type="hidden" value="" name="title">
									<input type="hidden" value="" name="image_name">
									<input type="hidden" value="" name="url">
									<input type="hidden" value="" name="uci">
									<input type="hidden" value="" name="new_win_yn">
									<!-- 코드에 의미가 없어 순번으로 대체 -->
									<input type="hidden" name="code" value="1"/>
								</td>
							</tr>
						</c:if>
						<c:if test="${not empty subList }">
							<c:forEach var="li" items="${subList}" varStatus="i">
								<tr id="tr${i.index}">
									<td colspan="3">
										<span>${li.title }</span>
										<span class="btn whiteS"><a href="#url" onclick="javascript:goPop('enterprise',this);return;" style="width:140px;">문화사업 선택</a></span>
										<input type="hidden" value="<c:out value='${li.title }'/>" name="title">
										<input type="hidden" value="${li.image_name }" name="image_name">
										<input type="hidden" value="${li.url }" name="url">
										<input type="hidden" value="${li.uci }" name="uci">
										<input type="hidden" value="${li.new_win_yn }" name="new_win_yn">
										<!-- 코드에 의미가 없어 순번으로 대체 -->
										<input type="hidden" name="code" value="${i.index + 1}"/>
										<input type="hidden" name="seq" value="${li.seq}"/>
									</td>
								</tr>
							</c:forEach>
						</c:if>
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