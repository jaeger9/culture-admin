<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

var getCodeList = function () {
	var arc_thm_id		=	$('select[name=arc_thm_id]');
	var arc_period_type	=	'${paramMap.arc_period_type }';
	var arc_zone_type	=	'${paramMap.arc_zone_type }';
	var arc_event_type	=	'${paramMap.arc_event_type }';

	$.get('/addservice/archive/categoryListinc.do', {
		arc_thm_id			:	arc_thm_id.val()
		,arc_period_type	:	arc_period_type
		,arc_zone_type		:	arc_zone_type
		,arc_event_type		:	arc_event_type
	}, function (data) {

		var item = null;
		var html = '';

		html += '<select name="arc_period_type">';
		html += '<option value="">1차분류</option>';
		
		for (var i in data.list1) {
			item = data.list1[i];
			html += '<option value="' + item.dtl_code + '"' + (item.dtl_code == arc_period_type ? ' selected="selected"' : '') + '>';
			html += item.dtl_cde_title;
			html += '</option>';
		}

		html += '</select>';

		
		html += ' <select name="arc_zone_type">';
		html += '<option value="">2차분류</option>';
		
		for (var i in data.list2) {
			item = data.list2[i];
			html += '<option value="' + item.dtl_code + '"' + (item.dtl_code == arc_zone_type ? ' selected="selected"' : '') + '>';
			html += item.dtl_cde_title;
			html += '</option>';
		}

		html += '</select>';
		
		
		html += ' <select name="arc_event_type">';
		html += '<option value="">3차분류</option>';
		
		for (var i in data.list2) {
			item = data.list2[i];
			html += '<option value="' + item.dtl_code + '"' + (item.dtl_code == arc_event_type ? ' selected="selected"' : '') + '>';
			html += item.dtl_cde_title;
			html += '</option>';
		}

		html += '</select>';

		$('#category').html(html);
		
	}, 'json').fail(function() {
		alert('카테고리 조회에 실패했습니다.');
	});
};

$(function () {

	var frm				=	$('form[name=frm]');
	var page_no			=	frm.find('input[name=page_no]');
	var search_type		=	frm.find('select[name=search_type]');
	var search_word		=	frm.find('input[name=search_word]');
	var search_btn		=	frm.find('button[name=search_btn]');
	
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

	new Checkbox('input[name=acm_cls_cdsAll]', 'input[name=acm_cls_cds]');
	
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

	// 승인 여부
	var ajaxApproval = function (arc_status) {
		arc_status = arc_status == '0' ? '0' : '1';
		var arc_statusText = arc_status == '0' ? '승인' : '미승인';
		
		var acm_cls_cds = $('input[name=acm_cls_cds]:checked');

		if (!confirm(arc_statusText + ' 처리 하시겠습니까?')) {
			return false;
		}
		if (acm_cls_cds.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}

		var param = {
			arc_status : arc_status
		};

		if (acm_cls_cds.size() > 0) {
			param.acm_cls_cds = [];
			
			$('input[name=acm_cls_cds]:checked').each(function () {
				param.acm_cls_cds.push( $(this).val() );
			});
		}

		$.ajax({
			url			:	'/addservice/archive/approval.do'
			,type		:	'post'
			,data		:	$.param(param, true)
			,dataType	:	'json'
			,success : function( res ) {

				if (res.success) {
					alert(arc_statusText + " 처리가 완료 되었습니다.");
					location.reload();
				} else {
					alert(arc_statusText + " 처리가 실패 되었습니다.");
				}
			}
			,error : function(data, status, err) {
				alert(arc_statusText + " 처리가 실패 되었습니다.");
			}
		});

	};

	$('.approval_y_btn').click(function () {
		ajaxApproval('0');
		return false;
	});

	$('.approval_n_btn').click(function () {
		ajaxApproval('1');
		return false;
	});
	
	// 삭제
	$('.delete_btn').click(function () {

		var acm_cls_cds = $('input[name=acm_cls_cds]:checked');

		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		if (acm_cls_cds.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}

		var param = {};

		if (acm_cls_cds.size() > 0) {
			param.acm_cls_cds = [];
			
			$('input[name=acm_cls_cds]:checked').each(function () {
				param.acm_cls_cds.push( $(this).val() );
			});
		}

		$.ajax({
			url			:	'/addservice/archive/delete.do'
			,type		:	'post'
			,data		:	$.param(param, true)
			,dataType	:	'json'
			,success	:	function (res) {
				if (res.success) {
					alert("삭제가 완료 되었습니다.");
					location.reload();
				} else {
					alert("삭제 실패 되었습니다.");
				}
			}
			,error : function(data, status, err) {
				alert("삭제 실패 되었습니다.");
			}
		});

		return false;
	});

	// select box
	var arc_thm_id = $('select[name=arc_thm_id]');
	arc_thm_id.change(function () {
		getCodeList();
	});
	
	if (arc_thm_id.val() != '') {
		getCodeList();
	}
});

</script>
</head>
<body>

<form name="frm" method="get" action="/addservice/archive/list.do">
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
			<th scope="row">테마선택</th>
			<td>
				<select name="arc_thm_id">
					<option value="">전체</option>
					<c:forEach items="${themeList }" var="item">
						<option value="${item.arc_thm_id }"${paramMap.arc_thm_id eq item.arc_thm_id ? ' selected="selected" ' : '' }>
							${item.arc_thm_title }
						</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th scope="row">분류선택</th>
			<td id="category">
				<select name="arc_period_type">
					<option value="">1차분류</option>
				</select>
				<select name="arc_zone_type">
					<option value="">2차분류</option>
				</select>
				<select name="arc_event_type">
					<option value="">3차분류</option>
				</select>
			</td>
		</tr>
		<tr>
			<th scope="row">검색어</th>
			<td>
				<select name="search_type">
					<option value="all">전체</option>
					<option value="title"		${paramMap.search_type eq 'title'	? 'selected="selected"' : '' }>제목</option>
				</select>

				<input type="text" name="search_word" value="${paramMap.search_word }" style="width:470px;" />

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
<!--
	<ul class="sortingList">
		<li class="on"><a href="#url">최신순</a></li>
		<li><a href="#url">조회순</a></li>
	</ul>
-->
</div>

<!-- table list -->
<div class="tableList">
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:4%" />
			<col style="width:8%" />
			<col style="width:24%" />
			<col />
			<col style="width:12%" />
			<col style="width:6%" />
			<col style="width:6%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="acm_cls_cdsAll" /></th>
				<th scope="col">번호</th>
				<th scope="col">구분</th>
				<th scope="col">작품명</th>
				<th scope="col">등록일</th>
				<th scope="col">조회수</th>
				<th scope="col">승인<br />여부</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty list }">
			<tr>
				<td colspan="7">검색된 결과가 없습니다.</td>
			</tr>
			</c:if>

			<c:forEach items="${list }" var="item" varStatus="status">
			<tr>
				<td>
					<input type="checkbox" name="acm_cls_cds" value="${item.acm_cls_cd }" />
				</td>
				<td>
					<fmt:formatNumber value="${count - (paramMap.page_no - 1) * paramMap.list_unit - status.index  }" pattern="###,###" />
				</td>
				<td>
					${item.arc_group_title }
				</td>
				<td class="subject">
					<a href="/addservice/archive/form.do?acm_cls_cd=${item.acm_cls_cd }&qs=${paramMap.qs }">
						${item.arc_title }
					</a>
				</td>
				<td>
					${item.arc_create_date }
				</td>
				<td>
					${item.view_cnt }
				</td>
				<td>
					${item.arc_status eq '0' ? '승인' : '미승인' }
				</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<div id="pagination"></div>

<div class="btnBox">
	<span class="btn white"><a href="#" class="approval_y_btn">승인</a></span>
	<span class="btn white"><a href="#" class="approval_n_btn">미승인</a></span>
	<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
	<span class="btn dark fr"><a href="/addservice/archive/form.do?qs=${paramMap.qs }">등록</a></span>
</div>

</form>

</body>
</html>