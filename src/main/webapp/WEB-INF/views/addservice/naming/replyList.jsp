<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

	$(function() {
		
		var frm = $('form[name=frm]');
		var page_no = frm.find('input[name=page_no]');
			
		//paging
		var p = new Pagination({
			view		:	'#pagination',
			page_count	:	'${count }',
			page_no		:	'${paramMap.page_no }',
			/* link		:	'/main/code/list.do?page_no=__id__', */
			callback	:	function(pageIndex, e) {
				//console.log('pageIndex : ' + pageIndex);
				page_no.val(pageIndex + 1);
				search();
				return false;
			}
		});

		
		//검색
		$('button[name=searchButton]').click(function(){
			$('form[name=frm]').attr('action', 'replyList.do');
			$('input[name=page_no]').val('1');
			$('form[name=frm]').submit();
		});
		
		search = function() {
			$('form[name=frm]').attr('action', 'replyList.do');
			frm.submit();
		}
		
		var reg_start	=	frm.find('input[name=reg_start]');
		var reg_end		=	frm.find('input[name=reg_end]');
		new Datepicker(reg_start, reg_end);
		
		
		new Checkbox('input[name=seqsAll]', 'input[name=seqs]');
		
		$('.delete_btn').click(function () {

			var seqs = $('input[name=seqs]:checked');

			if (!confirm('삭제하시겠습니까?')) {
				return false;
			}
			if (seqs.size() == 0) {
				alert('선택된 항목이 없습니다.');
				return false;
			}

			var param = {};

			if (seqs.size() > 0) {
				param.seqs = [];
				
				$('input[name=seqs]:checked').each(function () {
					param.seqs.push( $(this).val() );
				});
			}

			$.ajax({
				url			:	'/addservice/naming/replyDelete.do'
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
		
	});

</script>
</head>
<body>

	<!-- 검색 필드 -->
	<form name="frm" method="get" action="replyList.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/>
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
							<th scope="row">등록일</th>
							<td>
								<input type="text" name="reg_start" value="${paramMap.reg_start }" />
								<span>~</span>
								<input type="text" name="reg_end" value="${paramMap.reg_end }" />
							</td>
						</tr>
						<tr>
							<th scope="row">댓글</th>
							<td>
								<input type="text" name="search_keyword" title="검색어 입력" value="${paramMap.search_keyword}"/>
								<span class="btn darkS">
									<button name="searchButton" type="button">검색</button>
								</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</fieldset>
	
		<!-- 건수  -->
		<div class="topBehavior">
			<p class="totalCnt">총 <span>${count}</span>건</p>
		</div>
		<!-- 리스트 -->
		<div class="tableList">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col style="width:15%" />
					<col style="width:20%" />
					<col />
					<col style="width:20%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="seqsAll" /></th>
						<th scope="col">번호</th>
						<th scope="col">댓글</th>
						<th scope="col">작성일</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="item" items="${list }" varStatus="status">
					<c:set var="num" value="${count-(10*(paramMap.page_no-1))-status.index }"/>
					<tr>
						<td><input type="checkbox" name="seqs" value="${item.seq }" /></td>
						<td>${num }</td>
						<td>${item.summary}</td>
						<td><c:out value="${item.reg_date }"/></td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
	</form>
	<div id="pagination"></div>
	
	<div class="btnBox">
		<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>	
	</div>
	
</body>
</html>
