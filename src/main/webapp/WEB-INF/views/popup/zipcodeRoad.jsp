<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

	var frm				=	$('form[name=frm]');
	var page_no			=	frm.find('input[name=page_no]');
	var dong			=	frm.find('input[name=dong]');
	var search_btn		=	frm.find('button[name=search_btn]');
	var close_btn		=	frm.find('.close_btn');

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

	dong.keypress(function(event) {
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
		var parent = $(this).parent().parent();
		var data = parent.data();
		var addr = parent.find('td:eq(2)').text();
			addr = addr.replace(/\t/g, ' ');
			addr = addr.replace(/\s\s/g, ' ');
			addr = addr.replace(/\s\s/g, ' ');
			addr = addr.replace(/\s\s/g, ' ');
			addr = addr.replace(/\s\s/g, ' ');
			addr = addr.replace(/\s\s/g, ' ');
			addr = addr.replace(/\s\s/g, ' ');
			addr = $.trim(addr);

		data.addr = addr;

		if (window.opener && window.opener.callback && window.opener.callback.zipcode) {
			window.opener.callback.zipcode( data );
		}
		
		window.close();
		return false;
	});

});
</script>
</head>
<body>

<form name="frm" method="get" action="/popup/zipcodeRoad.do" style="padding:20px;">
<fieldset class="searchBox">
	<legend>검색</legend>
	
	<input type="hidden" name="page_no" value="${paramMap.page_no }" />
	
	<div class="tableWrite">
		<table summary="게시판 글 검색">
			<caption>게시판 글 검색</caption>
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">검색</th>
					<td>
						<input type="text" name="road_name" value="${paramMap.road_name }" />

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
			<col style="width:10%" />
			<col style="width:45%" />
			<col />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">번호</th>
				<th scope="col">구주소</th>
				<th scope="col">신주소</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
			<tr>
				<td colspan="3">검색된 결과가 없습니다.</td>
			</tr>
			</c:if>
			<c:forEach items="${list }" var="item" varStatus="status">
			<tr
				data-zipcode="${item.zip_code }"
				data-addr=""
				>

				<td>
					<a href="#">
						${item.zip_code }
					</a>
				</td>
				<td class="subject">
					<a href="#">
						${item.sido_name }
						${item.gu_name }
						${item.dong_name1 }
						
						<c:choose>
							<c:when test="${not empty item.gi_num1 && not empty item.gi_num2 }">
								${item.gi_num1 } - ${item.gi_num2 }
							</c:when>
							<c:otherwise>
								${item.gi_num1 }
							</c:otherwise>
						</c:choose>	
					</a>
				</td>
				<td class="subject">
					<a href="#">
						${item.sido_name }
						${item.gu_name }
						${item.road_name }
						${item.buil_num1 }
						
						<c:if test="${not empty item.buil_num2 }">
							- ${item.buil_num2 }
						</c:if>
													
						<c:choose>
							<c:when test="${not empty item.dong_name1 && not empty item.buil_name }">
								(${item.dong_name1 }, ${item.buil_name })
							</c:when>
							<c:otherwise>
								(${item.dong_name1 })
							</c:otherwise>
						</c:choose>	
					</a>
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