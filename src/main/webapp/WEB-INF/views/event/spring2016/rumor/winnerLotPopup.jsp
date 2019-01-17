<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
	$(function () {
	
		//checkbox
		new Checkbox('input[name=chkboxAll]', 'input[name=chkbox_id]');
		
		var frm = $('form[name=frm]');
		
		// 추첨하기, 닫기 
		$('div.btnBox > span > button').each(function() {
			$(this).click(function() {
				if ($(this).html() == '추첨하기') {
					$('[name=frm]').submit();
				} else if($(this).html() == '삭제') {
					if (!confirm('당첨자를 삭제 하시겠습니까?')) {
						return false;
					}
					deleteWinner();
				} else if ($(this).html() == '닫기') {
					self.close();
					return false;
				}
			});
		});
		
		//삭제
		deleteWinner = function () {
			if(getCheckBoxCheckCnt() == 0) {
				alert('삭제할 당첨자를 선택하세요');
				return false;
			}		
			formSubmit('winnerDelete.do');
		}
		
		//체크 박스 count 수 
		getCheckBoxCheckCnt = function() { 
			return $('input[name=chkbox_id]:checked').length;
		};

		//submit
		formSubmit = function (url) { 
			frm.attr('action' , url);
			frm.submit();		
		};
		
	});
	
</script>
</head>
<body>
<fieldset class="searchBox">
	<legend>댓글 참여자 당첨자 추첨</legend>
	<div class="tableWrite">
		<table summary="댓글 참여자 당첨자 추첨">
			<caption>당첨자 추첨</caption>
			<colgroup>
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">댓글 참여자 당첨자 추첨</th>
				</tr>
			</tbody>
		</table>
	</div>
</fieldset>
<form name="frm" method="post" action="winnerLotPopup.do" style="padding:20px;">
<input type="hidden" name="wtype" value="${param.wtype }"/>
<!-- table list -->
<div class="tableList">
	<table summary="첨자">
		<caption>당첨자</caption>
		<colgroup>
			<col style="width:8%" />
			<col style="width:20%" />
			<col style="width:*%" />
			<col style="width:20%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="chkboxAll" title="당첨자 전체 선택" /></th>
				<th scope="col">이름</th>
				<th scope="col">공유 URL</th>
				<th scope="col">휴대폰번호</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${empty winnerList }">
			<tr>
				<td colspan="4">당첨자를 추첨해주세요.</td>
			</tr>
		</c:if>
		<c:forEach var="item" items="${winnerList }">
			<tr>
				<td><input type="checkbox" name="chkbox_id" value="${item.seq }" /></td>
				<td><c:out value="${item.user_nm }"/></td>
				<td><c:out value="${item.url }"/></td>
				<td><c:out value="${item.hp_no }"/></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</div>

<%--<div id="pagination"></div> --%>

<div class="btnBox">
	<span class="btn white"><button type="button">추첨하기</button></span>
	<span class="btn white"><button type="button">삭제</button></span>
	<span class="btn dark fr"><button type="button">닫기</button></span>
</div>
</form>
</body>
</html>