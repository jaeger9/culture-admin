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
	var search_btn	=	frm.find('button[name=search_btn]');
	var close_btn	=	frm.find('.close_btn');
	
	var search = function () {
		frm.submit();
	};
	
	role_id.keypress(function(event) {
		if (event.which == 13) {
			event.preventDefault();
			search();
		}
	});

	search_btn.click(function () {
		search();
		return false;
	});
	
	close_btn.click(function () {
		window.close();
		return false;
	});

	$('.role_id_btn').click(function () {
		var data = {
			role_id : '${role_id }'
		};

		if (window.opener && window.opener.callback && window.opener.callback.roleId) {
			window.opener.callback.roleId( data );
		}
		
		window.close();
		return false;
	});

});
</script>
</head>
<body>

<form name="frm" method="get" action="/popup/roleId.do" style="padding:20px;">
<fieldset class="searchBox">
	<legend>검색</legend>
	
	<div class="tableWrite">
		<table summary="게시판 글 검색">
			<caption>게시판 글 검색</caption>
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">아이디</th>
					<td>
						<input type="text" name="role_id" value="${role_id }" />

						<span class="btn darkS">
							<button type="button" name="search_btn">검색</button>
						</span>
					</td>
				</tr> 
			</tbody>
		</table>
	</div>
</fieldset>

<div style="border:1px solid red;">
	<c:if test="${role_id_count > 0 }">
		${empty role_id ? '아이디를 입력해 주세요.' : '존재하는 아이디입니다.' }
	</c:if>
	<c:if test="${role_id_count eq 0 }">
		<a href="#" class="role_id_btn">
			'${role_id }' 사용하시겠습니까?
		</a>
	</c:if>
</div>

<div class="btnBox">
	<span class="btn dark fr"><a href="#" class="close_btn">닫기</a></span>
</div>
</form>

</body>
</html>