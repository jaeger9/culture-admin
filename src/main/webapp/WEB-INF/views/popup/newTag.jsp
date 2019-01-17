<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {
	//paging
	var pageCnt = Number('${count}')/(Number('${paramMap.list_unit }')/10);
	new Pagination({
		view		:	'#pagination',
		page_count	:	pageCnt,
		page_no		:	'${paramMap.page_no }',
		callback	:	function(pageIndex, e) {
			$('#page_no').val(pageIndex + 1);
			search('pagging');
			return false;
		}
	});
	
	$('input[name=nameAll]').click(function () {
		$('input[name=chkTag]:checkbox').prop('checked',$('input[name=nameAll]:checkbox').prop("checked"));
	});
});

function search(type){
	if(typeof(type)=='undefined'){
		$('#page_no').val(1);
	}
	$('#frm').submit();
}

function select(){
	//validation
	if($('input[name=chkTag]:checked').length < 1){
		alert("등록할 태그를 하나이상 선택해주세요.");
		return;
	}
	if($('input[name=chkTag]:checked').length > 9){
		alert("태그는 10개까지 등록 가능합니다.");
		return;
	}
	
	var seqs = new Array();
	var names = new Array();

	//선택학 태그의 seq와 태그명을 배열로 저장한다.
	$('input[name=chkTag]:checked').each(function(){
		seqs.push($(this).val());
		names.push($(this).parent().parent().find('label').html());
	});
	
	//부모창에 선택정보를 넘겨준다.
	$('input[name=tags]', opener.document).val(names);
	$('input[name=tagSeqs]', opener.document).val(seqs);
	
	window.close();
	return false;
}

</script>
</head>
<body>

<form name="frm" id="frm" method="post" action="/popup/newTag.do">
	<input type="hidden" name="page_no" id="page_no" value="${paramMap.page_no}"/>
	<input type="hidden" name="type" id="type" value="${paramMap.type}"/>
	
	<fieldset class="searchBox">
		<legend>검색</legend>
		
		<div class="tableWrite">
			<table summary="태그 검색">
				<caption>태그 검색</caption>
				<colgroup>
					<col style="width:17%" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">태그명</th>
						<td>
							<input type="text" name="keyword" title="검색어 입력" value="${paramMap.keyword}"/>
							<span class="btn darkS">
								<button name="search_btn" type="button" onclick="javascript:search();return;">검색</button>
							</span>
						</td>
					</tr> 
				</tbody>
			</table>
		</div>
	</fieldset>

	<div class="topBehavior">
		<p class="totalCnt">총 <span><fmt:formatNumber value="${count }" pattern="###,###" /></span>건</p>
		<p class="sortingList">노출수
			<select name="list_unit" onchange="javascript:search();return;">
				<c:forEach begin="10" end="100" step="10" varStatus="i">
					<option value="${i.index}" ${i.index eq paramMap.list_unit ? ' selected="selected"':''}>${i.index}</option>
				</c:forEach>
			</select>
		</p>
	</div>
	
	<!-- table list -->
	<div class="tableList">
		<table summary="태그 목록">
			<caption>태그 목록</caption>
			<colgroup>
				<col style="width:30%" />
				<col style="width:70%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col"><input type="checkbox" name="nameAll" title="리스트 전체 선택" /></th>
					<th scope="col">태그명</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${empty list }">
					<tr>
						<td colspan="2">검색된 게시물이 없습니다.</td>
					</tr>
				</c:if>
				<c:forEach items="${list }" var="item" varStatus="status">
					<tr>
						<td><input type="checkbox" name="chkTag" id="chk${status.index }" value="${item.seq}"/></td>
						<td>
							<label for="chk${status.index }"><c:out value="${item.name}"/></label>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<div id="pagination">
	</div>
	
	
	<div class="btnBox">
		<span class="btn white"><a href="#" class="select_btn" onclick="javascript:select();return;">선택</a></span>
		<span class="btn dark fr"><a href="#" class="close_btn" onclick="javascript:window.close();return;">닫기</a></span>
	</div>
</form>

</body>
</html>