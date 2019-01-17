<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">


var viewYN = false;

$(function () {

	var frm = $('form[name=frm]');
	var credt = frm.find('input[name=credt]');
	var upddt = frm.find('input[name=upddt]');
	var issued = frm.find('input[name=issued]');
	var ctype = frm.find('select[name=ctype]');
	var ctypename = frm.find('input[name=ctypename]');
	
	setDatepicker(credt);
	setDatepicker(upddt);
	setDatepicker(issued);

	if("${view.pcn_bno}") viewYN=true;
	//layout
	
	ctype.change(function(){
		ctypename.val(ctype.find('option:selected').text());
	});
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') {
        		if (!confirm('수정하시겠습니까?')) {
        			return false;
        		}
        		credt.val(credt.val().replace(/-/g, ''));
        		upddt.val(upddt.val().replace(/-/g, ''));
        		issued.val(issued.val().replace(/-/g, ''));
        		frm.attr('action' ,'/event/tour/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/event/tour/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		credt.val(credt.val().replace(/-/g, ''));
        		upddt.val(upddt.val().replace(/-/g, ''));
        		issued.val(issued.val().replace(/-/g, ''));
        		frm.attr('action' ,'/event/tour/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/event/tour/list.do';
        	}
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/event/tour/insert.do">
			<c:if test='${not empty view.pcn_bno}'>
				<input type="hidden" name="pcn_bno" value="${view.pcn_bno}"/>
			</c:if>
			<div class="sTitBar">
				<h4>지역관광정보</h4>
			</div>
			<table summary="지역관광정보 등록/수정">
				<caption>지역관광정보 등록/수정</caption>
				<colgroup>
					<col style="width:17%" /><col style="width:33%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">제목</th>
						<td colspan="3">
							<input type="text" name="title" style="width:670px" value="${view.title}" />
						</td>
					</tr>
					<tr>
						<th scope="row">부제</th>
						<td colspan="3">
							<input type="text" name="subtitle" style="width:670px" value="${view.subtitle}" />
						</td>
					</tr>
					<tr>
						<th scope="row">부제2</th>
						<td colspan="3">
							<input type="text" name="title2" style="width:670px" value="${view.title2}" />
						</td>
					</tr>
					<tr>
						<th scope="row">내용</th>
						<td colspan="3">
							<textarea id="contents" name="content" style="width:100%;height:100px;"><c:out value="${view.content }" escapeXml="true" /></textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">서비스URL</th>
						<td colspan="3">
							<input type="text" name="serviceurl" style="width:670px" value="${view.serviceurl}" />
						</td>
					</tr>
					<tr>
						<th scope="row">데이터 생성일</th>
						<td colspan="3">
							<input type="text" name="credt" value="${view.credt}" />
						</td>
					</tr>
					<tr>
						<th scope="row">데이터 수정일</th>
						<td colspan="3">
							<input type="text" name="upddt" value="${view.upddt}" />
						</td>
					</tr>
					<tr>
						<th scope="row">수집 썸네일주소</th>
						<td colspan="3">
							<input type="text" name="imgurl" style="width:670px" value="${view.imgurl}" />
						</td>
					</tr>
					<tr>
						<th scope="row">컨텐츠타입</th>
						<td colspan="3">
							<input type="hidden" name="ctypename" value="${view.ctypename}"/>
							<select name="ctype">
								<c:forEach var="item" items="${typeList}">
									<option value="${item.value}" ${item.value eq view.ctype ? 'selected=selected' : ''}>${item.name}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">관광공사 지역코드</th>
						<td colspan="3">
							<select name="xparea">
								<c:forEach var="item" items="${locList}">
									<option value="${item.value}" ${item.value eq view.xparea ? 'selected=selected' : ''}>${item.name}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">관광공사 지역코드2</th>
						<td colspan="3">
							<input type="text" name="xparea2" style="width:670px" value="${view.xparea2}" />
						</td>
					</tr>
					<tr>
						<th scope="row">주소</th>
						<td colspan="3">
							<input type="text" name="caddr" style="width:670px" value="${view.caddr}" />
						</td>
					</tr>
					<tr>
						<th scope="row">저작권자</th>
						<td colspan="3">
							<input type="text" name="contributor" style="width:670px" value="${view.contributor}" />
						</td>
					</tr>
					<tr>
						<th scope="row">전화번호</th>
						<td colspan="3">
							<input type="text" name="xptel" style="width:670px" value="${view.xptel}" />
						</td>
					</tr>
					<tr>
						<th scope="row">맵X좌표</th>
						<td colspan="3">
							<input type="text" name="xmapx" style="width:670px" value="${view.xmapx}" />
						</td>
					</tr>
					<tr>
						<th scope="row">맵Y좌표</th>
						<td colspan="3">
							<input type="text" name="xmapy" style="width:670px" value="${view.xmapy}" />
						</td>
					</tr>
					<tr>
						<th scope="row">관광공사 카테고리1</th>
						<td colspan="3">
							<input type="text" name="cat1" style="width:670px" value="${view.cat1}" />
						</td>
					</tr>
					<tr>
						<th scope="row">관광공사 카테고리2</th>
						<td colspan="3">
							<input type="text" name="cat2" style="width:670px" value="${view.cat2}" />
						</td>
					</tr>
					<tr>
						<th scope="row">관광공사 카테고리3</th>
						<td colspan="3">
							<input type="text" name="cat3" style="width:670px" value="${view.cat3}" />
						</td>
					</tr>
					<tr>
						<th scope="row">출판사</th>
						<td colspan="3">
							<input type="text" name="rights" style="width:670px" value="${view.rights}" />
						</td>
					</tr>
					<tr>
						<th scope="row">발행일</th>
						<td colspan="3">
							<input type="text" name="issued" value="${fn:length(view.issued) > 2 ? view.issued : '' }" />
						</td>
					</tr>
					<tr>
						<th scope="row">OAI 코드</th>
						<td colspan="3">
							<input type="text" name="code" style="width:670px" value="${view.code}" />
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