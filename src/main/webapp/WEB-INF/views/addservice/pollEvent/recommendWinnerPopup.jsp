<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
	$(function () {
		
		if('${msg}' != ''){
			alert('${msg}');
		}
	
		//checkbox
		new Checkbox('input[name=chkboxAll]', 'input[name=chkbox_id]');
		
		var frm = $('form[name=frm]');
		var entry_month = $('select[name=entry_month]');
		var lottery_number = $('input[name=lottery_number]');
		
		entry_month.change(function (){
			location.href="/addservice/pollEvent/recommendWinnerPopup.do?entry_month="+$(this).val();
			
		});
		// 추첨하기, 닫기 
		$('div.btnBox > span > button').each(function() {
			$(this).click(function() {
				if ($(this).html() == '추첨하기') {
					if(entry_month.val() == ''){
						alert('참여월을 선택해주세요.');
						entry_month.focus();
						return false;
					}
					
					if(lottery_number.val() == '' || lottery_number.val() == '0'){
						alert('추첨건수를 1이상 입력해주세요.');
						lottery_number.focus();
						lottery_number.val('');
						return false;
					}
					
					var number = /^[0-9]*$/;
					if (!number.test(lottery_number.val())) {
						lottery_number.focus();
						lottery_number.val('');
						alert('추첨건수는 숫자만 입력가능합니다.');
						return false;
					}
					
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
			formSubmit('recommendWinnerDelete.do');
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

<form name="frm" method="post" action="/addservice/pollEvent/recommendWinnerPopup.do" style="padding:20px;">
<fieldset>
	<legend>당첨자 추첨</legend>
	<div class="tableWrite">
		<table summary="당첨자 추첨">
			<caption>당첨자 추첨</caption>
			<colgroup>
				<col style="width:60%"/>
				<col style="width:15%"/>
				<col style="width:25%"/>
			</colgroup>
			<tbody>
				<tr>
					<th>당첨자 추첨</th>
					<th>참여월</th>
					<td>
						<select name="entry_month" style="background-color: white; width: 100px;">
							<option value="" <c:if test="${empty paramMap.month }">selected</c:if>>선택</option>
							<c:forEach items="${recommendMonthList }" var="list" varStatus="status">
								<option value="${list.month }" <c:if test="${list.month eq paramMap.entry_month }">selected</c:if>>${list.month}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</fieldset>
<!-- table list -->
<div class="tableList">
	<table summary="첨자">
		<caption>당첨자</caption>
		<colgroup>
			<col style="width:10%" />
			<col style="width:10%" />
			<col style="width:15%" />
			<col style="width:15%" />
			<col />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="chkboxAll" title="당첨자 전체 선택" /></th>
				<th scope="col">참여월</th>
				<th scope="col">성명</th>			
				<th scope="col">휴대폰 번호</th>
				<th scope="col">추천 작품명</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${empty winnerList }">
			<tr>
				<td colspan="5">당첨자를 추첨해주세요.</td>
			</tr>
		</c:if>
		<c:forEach var="item" items="${winnerList }">
			<tr>
				<td><input type="checkbox" name="chkbox_id" value="${item.seq }" /></td>
				<td><c:out value="${item.month}"/></td>
				<td><c:out value="${item.user_nm }"/></td>
				<td><c:out value="${item.hp_no}"/></td>
				<td><c:out value="${item.recommend_work}"/></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</div>
<div class="btnBox">
	<span style="margin-left:20px; margin-right:4px;">추첨건수 <input type="text" name="lottery_number" style="padding : 0; width: 50px;"/></span>
	<span class="btn white"><button type="button">추첨하기</button></span>

	<span class="btn dark fr" style="margin-right:4px;"><button type="button">닫기</button></span>
	<span class="btn white fr" style="margin-right:4px;"><button type="button">삭제</button></span>
</div>
</form>
</body>
</html>