<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
var cultureRecomIndex = 0;	
var menu_type = 1;

setResponseData = function(res){
	
};
var callback = {
		culturerecom : function(res) { 
			var due = true;
			if (res == null) {
				alert('CallBack Res Null');
				return false;
			};
			if(due == true){
				var frm = $('form[name="representForm"]');
				//console.log(res.idx + ' ' + res.title);
				
				$('form[name="representForm"] input[name="seq"]').val(res.idx);
				$('form[name="representForm"] input[name="represent_yn"]').val('Y');

				if(!confirm('선택하신 영상을 대표영상으로 등록하시겠습니까?')){
					return false;
				}else{					
					frm.submit();
				}
			};
		
	}
}

	$(function() {
		
		var frm = $('form[name=searchfrm]');
		var page_no = frm.find('input[name=page_no]');

		//paging
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

		
		//검색
		$('button[name=searchButton]').click(function(){
			$('form[name=searchfrm]').attr('action', '/addservice/2016Olympic/vodList.do');
			$('form[name=searchfrm] input[name=page_no]').val('1');
			$('form[name=searchfrm]').submit();
		});
		
		search = function() {
			frm.submit();
		}

		
		new Checkbox('input[name=seqsAll]', 'input[name=seqs]');

		

		// 승인 여부
		var ajaxApproval = function (approval) {
			approval = approval == 'Y' ? 'Y' : 'N';
			var approvalText = approval == 'Y' ? '선택된 영상을 올림픽영상으로 적용하시겠습니까?' : '선택된 영상을 올림픽영상에서 제외하시겠습니까?';

			var seqs = $('input[name=seqs]:checked');

			if (!confirm(approvalText)) {
				return false;
			}
			if (seqs.size() == 0) {
				alert('영상을 선택해 주세요.');
				return false;
			}

			var param = {
				approval : approval
			};

			if (seqs.size() > 0) {
				param.seqs = [];
				param.data_yn = [];
				
				$('input[name=seqs]:checked').each(function () {
					param.seqs.push( $(this).val() );
					param.data_yn.push( $(this).attr('data-yn') );
				});
			}

			$.ajax({
				url			:	'/addservice/2016Olympic/approval.do'
				,type		:	'post'
				,data		:	$.param(param, true)
				,dataType	:	'json'
				,success : function( res ) {

					if (res.success) {
						alert("적용되었습니다.");
						location.reload();
					} else {
						alert("처리가 실패 되었습니다.");
					}
				}
				,error : function(data, status, err) {
					alert("처리가 실패 되었습니다.");
				}
			});

		};

		$('.approval_y_btn').click(function () {
			ajaxApproval('Y');
			return false;
		});

		$('.approval_n_btn').click(function () {
			ajaxApproval('N');
			return false;
		});
		
	});

	function excelDown() {
		$('form[name=frm]').attr('action', 'offerExcelDown.do').submit();
	}
		
	function vodPopup(){
		window.open('/addservice/2016Olympic/olympicPopup.do', 'placePopup', 'scrollbars=yes,width=600,height=630');
	}
</script>
</head>
<body>
<form name="representForm" method="get" action="/addservice/2016Olympic/representVodUpdate.do">
<input type="hidden" name="seq"/>
<input type="hidden" name="represent_yn"/>
<div class="tableList" style="margin-bottom: 30px;">
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:20%" />
			<col style="width:80%" />
		</colgroup>
		<tbody>
			<tr>
				<th>대표영상</th>
				<td class="subject">
					<span id="representative_vod">
					<c:choose>
						<c:when test="${ empty representVod }">선택하신 대표영상이 없습니다.</c:when>
						<c:when test="${ not empty representVod }">${ representVod.title }</c:when>
					</c:choose>
					</span>
					<span class="btn whiteS"><a href="#url" onclick="javascript:vodPopup();">문화 영상 선택</a></span>
				</td>
			</tr>
		</tbody>
	</table>
</div>
</form>

<form name="searchfrm" method="get" action="/addservice/2016Olympic/vodList.do">
	<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
	<fieldset class="searchBox">
		<legend>검색</legend>
		<div class="tableWrite">
			<table summary="게시판 글 검색">
				<caption>게시판 글 검색</caption>
				<colgroup>
					<col style="width:20%" />
					<col />
				<tbody>
					<tr>
						<th scope="row">검색어</th>
						<td>
							<select name="searchGubun">
								<option value="" <c:if test="${empty paramMap.searchGubun }">selected</c:if>>전체</option>
								<option value="title" <c:if test="${paramMap.searchGubun eq 'title'}">selected</c:if>>제목</option>
								<option value="name" <c:if test="${paramMap.searchGubun eq 'name'}">selected</c:if>>작성자</option>
							</select>
							<input type="text" name="keyword" title="검색어 입력" value="${paramMap.keyword}"/>
							<span class="btn darkS">
								<button name="searchButton" type="button">검색</button>
							</span>
						</td>
						
					</tr>
				</tbody>
			</table>
		</div>
	</fieldset>
</form>

<!-- 건수  -->
<div class="topBehavior">
	<p class="totalCnt">올림픽영상 : 총 <span>${olympicVodCount}</span>건</p>
</div>

<form name="frm" method="get" action="/addservice/2016Olympic/vodList.do">
<input type="hidden" name="page_no" value="${paramMap.page_no }" />

<!-- table list -->
<div class="tableList">
	<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:8%" />
			<col style="width:8%" />
			<col />
			<col style="width:12%" />
			<col style="width:10%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="seqsAll" /></th>
				<th scope="col">번호</th>
				<th scope="col">제목</th>
				<th scope="col">작성자</th>
				<th scope="col">올림픽<br />영상</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${list }" var="item" varStatus="status">
			<tr>
				<td>
					<input type="checkbox" name="seqs" value="${item.idx }" data-yn="<c:if test="${empty item.representative_yn}">N</c:if><c:if test="${not empty item.representative_yn}">Y</c:if>"/>
				</td>
				<td>
					<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index }"/>
					${num }
				</td>
				<td class="subject">
						${item.title }
				</td>
				<td>
					${item.user_name }
				</td>
				<td>
					<c:if test="${item.representative_yn eq 'Y' or item.representative_yn eq 'N' }">○</c:if>
				</td>
			</tr>
			</c:forEach>

			<c:if test="${empty list }">
			<tr>
				<td colspan="5">검색된 결과가 없습니다.</td>
			</tr>
			</c:if>
		</tbody>
	</table>
</div>

<div id="pagination"></div>

<div class="btnBox">
	<span class="btn white"><a href="#" class="approval_y_btn">선택</a></span>
	<span class="btn white"><a href="#" class="approval_n_btn">미선택</a></span>
</div>
</form>
	
	
</body>
</html>
