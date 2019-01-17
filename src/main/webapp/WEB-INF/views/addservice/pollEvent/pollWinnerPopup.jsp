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
		var event_number = $('select[name=event_number]');
		var poll_seq = $('select[name=poll_seq]');
		var work_seq = $('select[name=work_seq]');
		var lottery_number = $('input[name=lottery_number]');
		
		event_number.change(function (){
			location.href="/addservice/pollEvent/pollWinnerPopup.do?event_number="+$(this).val();
			
		});
		poll_seq.change(function (){
			location.href="/addservice/pollEvent/pollWinnerPopup.do?event_number="+event_number.val()+"&poll_seq="+$(this).val();
			
		});
		work_seq.change(function (){
			location.href="/addservice/pollEvent/pollWinnerPopup.do?event_number="+event_number.val()+"&poll_seq="+poll_seq.val()+"&work_seq="+$(this).val();
			
		});
		// 추첨하기, 닫기 
		$('div.btnBox > span > button').each(function() {
			$(this).click(function() {
				if ($(this).html() == '추첨하기') {
					
					if(event_number.val() == ''){
						alert('회차를 선택해주세요.');
						event_number.focus();
						return false;
					}
					
					if(poll_seq.val() == ''){
						alert('투표구분을 선택해주세요.');
						poll_seq.focus();
						return false;
					}
					
					if(work_seq.val() == ''){
						alert('투표작품을 선택해주세요.');
						work_seq.focus();
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
					
					$('form[name=frm]').attr('action', '/addservice/pollEvent/pollWinnerPopup.do').submit();
					
				} else if($(this).html() == '삭제') {
					if (!confirm('당첨자를 삭제 하시겠습니까?')) {
						return false;
					}
					deleteWinner();
				} else if ($(this).html() == '닫기') {
					self.close();
					return false;
				} else if ($(this).html() == '엑셀다운로드') {
					$('form[name=frm]').attr('action', '/addservice/pollEvent/pollWinnerExcelDown.do').submit();
				}
			});
		});
		
		//삭제
		deleteWinner = function () {
			if(getCheckBoxCheckCnt() == 0) {
				alert('삭제할 당첨자를 선택하세요');
				return false;
			}		
			formSubmit('pollWinnerDelete.do');
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

<form name="frm" method="post" action="/addservice/pollEvent/pollWinnerPopup.do" style="padding:20px;">
<fieldset>
	<legend>당첨자 추첨</legend>
	<div class="tableWrite">
		<table summary="당첨자 추첨">
			<caption>당첨자 추첨</caption>
			<colgroup>
				<col style="width:20%"/>
				<col style="width:80%"/>
			</colgroup>
			<tbody>
				<tr>
					<th colspan="2">당첨자 추첨</th>
				</tr>
				<tr>
					<th>회차</th>
					<td>
						<select name="event_number" style="background-color: white; width: 100px;">
							<option value="" <c:if test="${empty paramMap.event_number }">selected</c:if>>전체</option>
							<c:forEach items="${eventNumberList }" var="list" varStatus="status">
								<option value="${list.event_number }" <c:if test="${list.event_number eq paramMap.event_number }">selected</c:if>>${list.event_number }</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>투표구분</th>
					<td>
						<select name="poll_seq" style="background-color: white; width: 300px;">
							<option value="" <c:if test="${empty paramMap.poll_seq }">selected</c:if>>전체</option>
							<c:forEach items="${pollTitleList }" var="list" varStatus="status">
								<option value="${list.poll_seq }" <c:if test="${list.poll_seq eq paramMap.poll_seq }">selected</c:if>>${list.poll_title }</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>투표작품</th>
					<td>
						<select name="work_seq" style="background-color: white; width: 300px;">
							<option value="" <c:if test="${empty paramMap.work_seq }">selected</c:if>>전체</option>
							<c:forEach items="${workTitleList }" var="list" varStatus="status">
								<option value="${list.work_seq }" <c:if test="${list.work_seq eq paramMap.work_seq }">selected</c:if>>${list.title }</option>
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
			<col style="width:20%" />
			<col style="width:30%" />
			<col style="width:20%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="chkboxAll" title="당첨자 전체 선택" /></th>
				<th scope="col">회차</th>
				<th scope="col">성명</th>
				<th scope="col">휴대폰번호</th>
				<th scope="col">투표일</th>
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
				<td><input type="checkbox" name="chkbox_id" value="${item.winner_seq }" /></td>
				<td><c:out value="${item.event_number }"/></td>
				<td><c:out value="${item.name }"/></td>
				<td><c:out value="${item.hp_no }"/></td>
				<td><c:out value="${item.poll_date }"/></td>
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
	<span class="btn white fr" style="margin-right:4px;"><button type="button">엑셀다운로드</button></span>
</div>
</form>
</body>
</html>