<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<style>
	.close-div {position:absolute;overflow:hidden;background:#444;top:610px;width:500px;height:20px;}
	.close-div span {float:right;}
	.close-div span a {color:#fff;font-weight:bold;font-size:14px;}
	.close-div span a:hover {text-decoration:none;}
</style>
<script type="text/javascript">
	$(function () {
	
		var frm = $('form[name=frm]');
		var page_no = frm.find('input[name=page_no]');
		var search_btn = frm.find('button[name=search_btn]');
		var search_word = frm.find('input[name=search_word]');
		
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
		
		$('div.close-div span a').click(function () {
			window.close();
			return false;
		});
		
		$('#cate-span').on({
			'click': function() {
				var cateRadio = $('[name=cate-radio]:checked');
				if(cateRadio.val() == null || cateRadio.val() == '') {
					alert('주제를 선택해 주세요');
				} else {
					window.opener.callback.category(cateRadio.data());
					window.close();
				}
			}
		})
		
	});
</script>
</head>
<body>
<%--<div style="over-flow:hidden; padding:5px 20px;">
	<span style="float:right;"><a href="#" class="close_btn">닫기</a></span>
</div> --%>

<form name="frm" method="get" action="categoryList.do" style="padding:20px;">
<fieldset class="searchBox">
	<legend>검색</legend>
	
	<input type="hidden" name="page_no" value="${paramMap.page_no }" />
	
	<div class="tableWrite">
		<table summary="게시판 글 검색">
			<caption>공연장 검색</caption>
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">주제</th>
					<td>
						<input type="text" name="search_word" style="width:290px;" value="${paramMap.search_word }" />
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
	<table summary="문화 이슈 카테고리 목록">
		<caption>문화 이슈 카테고리 목록</caption>
		<colgroup>
			<col width="10%" />
			<col />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">선택</th>
				<th scope="col">주제</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
				<tr>
					<td colspan="2">검색된 게시물이 없습니다.</td>
				</tr>
			</c:if>
			<c:forEach var="item" items="${list }">
				<tr>
					<td><input type="radio" name="cate-radio" value="${item.seq }" data-seq="${item.seq }" data-nm="${item.category_nm }"/></td>
					<td><a href="categoryView.do?seq=${item.seq }"><c:out value="${item.category_nm }"/></a></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<div id="pagination"></div>

<div class="btnBox">
	<span class="btn white" id="cate-span"><a href="#">선택</a></span>
	<span class="btn dark fr"><a href="categoryView.do">등록</a></span>
</div>
</form>

<div class="close-div"><span><a href="#">닫기</a></span></div>

</body>
</html>