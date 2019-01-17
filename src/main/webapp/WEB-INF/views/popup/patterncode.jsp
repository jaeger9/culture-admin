<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

	var frm = $('form[name=frm]');
	var page_no = frm.find('input[name=page_no]');
	var search_btn = frm.find('button[name=search_btn]');
	var search_word = frm.find('input[name=name]');
	var close_btn = frm.find('.close_btn');
	
	var search = function () {
		frm.submit();
	};
	
	new Pagination({
		view		:	'#pagination',
		page_count	:	'${count }',
		page_no		:	'${paramMap.page_no }',
		callback	:	function(pageIndex, e) {
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});

	search_word.keypress(function(event) {
		if (event.which == 13) {
			event.preventDefault();
			page_no.val(1);
			search();
		}
	});

	search_btn.click(function () {
		page_no.val(1);
		search();
		return false;
	});
	
	close_btn.click(function () {
		window.close();
		return false;
	});

	$('.tableList a').click(function () {
		var data = $(this).parent().parent().data();

		if (window.opener && window.opener.callback && window.opener.callback.patterncode) {
			window.opener.callback.patterncode( data );
		} else 
			alert('callback function undefined');
		
		window.close();
		return false;
	});
});
</script>
</head>
<body>

<form name="frm" method="get" action="/popup/patterncode.do" style="padding:20px;">
<fieldset class="searchBox">
	<legend>검색</legend>
	
	<input type="hidden" name="page_no" value="${paramMap.page_no }" />
	
	<div class="tableWrite">
		<table summary="게시판 글 검색">
			<caption>검색</caption>
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">검색</th>
					<td>
						<select name="searchGubun">
							<option value="title" ${paramMap.searchGubun eq 'title' ? 'selected="selected"':''}>문양명</option>
							<option value="did" ${paramMap.searchGubun eq 'did' ? 'selected="selected"':''}>문양코드번호</option>
						</select>
						<input type="text" name="keyword" value="${paramMap.keyword }" />
						<span class="btn darkS">
							<button type="button" name="search_btn">검색</button>
						</span>
					</td>
				</tr> 
			</tbody>
		</table>
	</div>
</fieldset>

<div class="topBehavior">
	<p class="totalCnt">총 <span><fmt:formatNumber value="${count }" pattern="###,###" /></span>건</p>
</div>

<!-- table list -->
<div class="tableList">
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:12%" />
			<col style="width:25%" />
			<col style="width:%" />
			<col style="width:%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">번호</th>
				<th scope="col">이미지</th>
				<th scope="col">문양명</th>
				<th scope="col">문양코드번호</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
				<tr>
					<td colspan="4">검색된 게시물이 없습니다.</td>
				</tr>
			</c:if>
			<%--
				실제 사용되는 항목
				res.xtitle
				res.image
				res.url
				res.xabstract
				res.place
				res.did
			--%>
			<c:forEach items="${list }" var="item" varStatus="status">
				<c:choose>
					<c:when test='${item.depth1 eq "pattern" or empty item.depth1}'><c:set var="imagePath" value="2d/250/" /></c:when>
					<c:when test='${item.depth1 eq "2,3도패턴"}'><c:set var="imagePath" value="2d/250/" /></c:when>
					<c:when test='${item.depth1 eq "4도패턴"}'><c:set var="imagePath" value="2d/250/" /></c:when>
					
					<c:when test='${item.depth1 eq "템플릿"}'><c:set var="imagePath" value="2d/templete/250/" /></c:when>
					<c:when test='${item.depth1 eq "템플릿소스"}'><c:set var="imagePath" value="2d/templete_source/250/" /></c:when>
					<c:when test='${item.depth1 eq "템플릿조합"}'><c:set var="imagePath" value="2d/templete_mix/250/" /></c:when>
					
					<c:when test='${item.depth1 eq "MOBILE 배경화면"}'><c:set var="imagePath" value="2d/mobile/250/" /></c:when>
						
					<c:when test='${item.depth1 eq "부피형"}'><c:set var="imagePath" value="3d/250/" /></c:when>
					<c:when test='${item.depth1 eq "확산형"}'><c:set var="imagePath" value="3d/250/" /></c:when>
					<c:when test='${item.depth1 eq "기둥형"}'><c:set var="imagePath" value="3d/250/" /></c:when>
					<c:when test='${item.depth1 eq "응용형"}'><c:set var="imagePath" value="3d/250/" /></c:when>
					<c:otherwise><c:set var="imagePath" value="2d/250/" /></c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${item.gbn eq 'PG03'}">
						<c:set var="imgUrl" value="http://www.culture.go.kr/pattern/service_design/images/design/${item.xfile}.jpg"/>
					</c:when>
					<c:when test="${item.gbn eq 'PG04'}">
						<c:set var="imgUrl" value="http://www.culture.go.kr/pattern/service_design/images/mch/2014/${imagePath }${item.xfile}.jpg"/>
					</c:when>
					<c:when test="${item.gbn eq 'PG05'}">
						<c:set var="imgUrl" value="http://www.culture.go.kr/pattern/service_design/images/mch/2016/3d/${item.xfile}.JPG"/>
					</c:when>
					<c:otherwise>
						<c:set var="imgUrl" value="http://www.culture.go.kr/pattern/service_design/images/thumb/80/${item.xfile}.GIF"/>
					</c:otherwise>
				</c:choose>
				
				<tr data-did="${item.did}" data-xtitle="${item.xtitle}" data-gbn="${item.gbn}"
					data-xtaxonomy="${item.xtaxonomy}"
					data-xabstract="<c:out value='${item.xabstract}'/>"
					data-xdimension="${item.xdimension}"
					data-xtype="${item.xtype}"
					data-image="<c:out value='${imgUrl}'/>"
					data-url="<c:out value='${item.url}'/>"
					data-place="<c:out value='${item.place}'/>"
				>
					<td>
						<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
					</td>
					<td>
						<c:choose>
							<c:when test="${item.gbn eq 'PG03'}">
								<img src="http://www.culture.go.kr/pattern/service_design/images/design/${item.xfile}.jpg" width=80 height=60>
							</c:when>
							<c:when test="${item.gbn eq 'PG04'}">
								<img src="http://www.culture.go.kr/pattern/service_design/images/mch/2014/${imagePath }${item.xfile}.jpg" width=80 height=60>
							</c:when>
							<c:when test="${item.gbn eq 'PG05'}">
								<img src="http://www.culture.go.kr/pattern/service_design/images/mch/2016/3d/${item.xfile}.JPG" width=80 height=60>
							</c:when>
							<c:otherwise>
								<img src="http://www.culture.go.kr/pattern/service_design/images/thumb/80/<c:out value='${item.xfile}' />.GIF" width=80 height=60>
							</c:otherwise>
						</c:choose>
					</td>
					<td>
						<a href="#" name="${item.xtitle}" location="${item.xtitle}">
							<c:out value="${item.xtitle}" default="-" />
						</a>
					</td>
					<td>
						${item.did}
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<div id="pagination"></div>

<div class="btnBox">
	<span class="btn dark fr"><a href="#" class="close_btn">닫기</a></span>
</div>
</form>

</body>
</html>