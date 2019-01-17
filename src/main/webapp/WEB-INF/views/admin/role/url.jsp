<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

	var frm			=	$('form[name=frm]');
	var role_id		=	frm.find('input[name=role_id]');
	var url_ids		=	frm.find('input[name=url_ids]');

	new Checkbox('input[name=url_idsAll]', 'input[name=url_ids]');
	
	$('.insert_btn').click(function () {
		if (!confirm('수정하시겠습니까?')) {
			return false;
		}

		var param = {
			role_id : role_id.val()
			,url_ids : []
		};

		url_ids.filter(':checked').each(function (i) {
			param.url_ids.push( $(this).val() );
		});

		param = $.param(param, true);

		Layer.mask();
		
		$.post('/admin/role/url.do', param, function (data) {
			if (data.success) {
				alert('권한이 수정되었습니다.\r\n설정하신 접근 권한은 서버가 재시작 된 이후 반영됩니다.\r\n관리자 사이트 담당자에게 문의해 주세요.');
			} else {
				alert('잘못된 요청입니다.');
			}
		}).fail(function() {
			alert('권한 수정이 실패되었습니다.');
		}).always(function () {
			Layer.unmask();
		});
		
		return false;
	});

});
</script>
</head>
<body>

<form name="frm" method="POST" action="/admin/role/url.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="role_id" value="${view.role_id }" />

	<div class="tableWrite">
		<table summary="게시판 글 등록">
		<caption>게시판 글 등록</caption>
		<colgroup>
			<col style="width:15%" />
			<col style="width:35%" />
			<col style="width:15%" />
			<col style="width:35%" />
		</colgroup>
		<tbody>
		<tr>
			<th scope="row">아이디</th>
			<td>
				${view.role_id }
			</td>
			<th scope="row">최종 수정일</th>
			<td>
				<c:out value="${view.modify_date }" default="-" />
			</td>
		</tr>
		<tr>
			<th scope="row">이름</th>
			<td colspan="3">
				${view.name }
			</td>
		</tr>
		<tr>
			<th scope="row">설명</th>
			<td colspan="3">
				${view.description }
			</td>
		</tr>
		</tbody>
		</table>
	</div>

	<div style="padding-top:15px;">

		<div class="tableList">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col style="width:4%" />
<%-- 					<col style="width:20%" /> --%>
					<col style="width:48%" />
					<col />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="url_idsAll" /></th>
<!-- 						<th scope="col">URL ID</th> -->
						<th scope="col">URL</th>
						<th scope="col">설명</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty urlList }">
					<tr>
						<td colspan="3">검색된 결과가 없습니다.</td>
					</tr>
					</c:if>
					<c:forEach items="${urlList }" var="item" varStatus="status">
					<tr>
						<td>
							<input type="checkbox" name="url_ids" value="${item.url_id }" ${item.approval eq 'Y' ? 'checked="checked"' : '' } />
						</td>
<%--
						<td style="padding-left:15px;text-align:left;">
							${item.url_id }
						</td>
--%>
						<td style="padding-left:15px;text-align:left;">
							${item.url_string }
						</td>
						<td style="padding-left:15px;text-align:left;">
							${item.description }
						</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">수정</a></span>
		<span class="btn gray"><a href="/admin/role/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>


</body>
</html>