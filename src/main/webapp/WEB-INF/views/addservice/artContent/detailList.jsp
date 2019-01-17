<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

	var vvm_seq = $('input[name=vvm_seq]');

	new Checkbox('input[name=vvi_seqsAll]', 'input[name=vvi_seqs]');

	// 삭제
	$('.delete_btn').click(function () {

		var vvi_seqs = $('input[name=vvi_seqs]:checked');

		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		if (vvi_seqs.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}

		var param = {};

		if (vvi_seqs.size() > 0) {
			param.vvi_seqs = [];
			
			$('input[name=vvi_seqs]:checked').each(function () {
				param.vvi_seqs.push( $(this).val() );
			});
		}

		$.ajax({
			url			:	'/addservice/artContent/detailDelete.do'
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

<input type="hidden" name="vvm_seq" value="${view.vvm_seq }" />

<ul class="tab">
	<li><a href="/addservice/artContent/form.do?vvm_seq=${view.vvm_seq }">기본 정보</a></li>
	<li><a href="/addservice/artContent/detailList.do?vvm_seq=${view.vvm_seq }" class="focus">상세 정보</a></li>
</ul>

<c:set var="detailCount" value="${fn:length(listByDetailAll) }" />

<div class="topBehavior" style="margin-top:15px;">
	<p class="totalCnt">총 <span><fmt:formatNumber value="${detailCount }" pattern="###,###" /></span>건</p>
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
			<col />
			<col style="width:12%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="vvi_seqsAll" /></th>
				<th scope="col">번호</th>
				<th scope="col">항목</th>
				<th scope="col">첨부파일</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${empty listByDetailAll }">
			<tr>
				<td colspan="4">검색된 결과가 없습니다.</td>
			</tr>
			</c:if>

			<c:forEach items="${listByDetailAll }" var="item" varStatus="status">
			<tr>
				<td>
					<input type="checkbox" name="vvi_seqs" value="${item.vvi_seq }" />
				</td>
				<td>
					<%--
					<fmt:formatNumber value="${detailCount - status.index }" pattern="###,###" />
					--%>
					<fmt:formatNumber value="${status.count }" pattern="###,###" />
				</td>
				<td class="subject">
					<a href="/addservice/artContent/detailForm.do?vvm_seq=${item.vvm_seq }&vvi_seq=${item.vvi_seq }">
						<c:out value="${item.vvi_title }" default="(제목없음)" />
					</a>
				</td>
				<td>
					<c:if test="${not empty item.vvi_ole_file_name }">
						첨부
					</c:if>
					<c:if test="${empty item.vvi_ole_file_name }">
						-
					</c:if>
				</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<div class="btnBox">
	<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
	<span class="btn gray fr"><a href="/addservice/artContent/list.do" class="list_btn">전체 목록</a></span>
	<span class="btn dark fr" style="margin-right:4px;"><a href="/addservice/artContent/detailForm.do?vvm_seq=${view.vvm_seq }">등록</a></span>
</div>

</form>

</body>
</html>