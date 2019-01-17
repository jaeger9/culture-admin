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
		var lottery_number = $('input[name=lottery_number]');
		
		// 추첨하기, 닫기 
		$('div.btnBox > span > button').each(function() {
			$(this).click(function() {
				$('form[name=frm]').attr('action', '/addservice/culturecok/winnerPopup.do')
				if ($(this).html() == '추첨하기') {
					
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

	function excelDown() {
		$('form[name=frm]').attr('action', 'winnerExcelDown.do').submit();
	}
	
</script>
</head>
<body>

<form name="frm" method="post" action="/addservice/culturecok/winnerPopup.do" style="padding:20px;">
<input type="hidden" name="gubun" value="${paramMap.gubun }" />
<fieldset>
	<legend>당첨자 추첨</legend>
	<div class="tableWrite">
		<table summary="당첨자 추첨">
			<caption>당첨자 추첨</caption>
			<tbody>
				<tr>
					<c:if test="${paramMap.gubun eq 'A' }">
					<th>당첨자 추첨</th>
					</c:if>
					<c:if test="${paramMap.gubun eq 'S' }">
					<th>당첨자 추첨 (당첨 가능한 사람수 250명)</th>
					</c:if>
					<c:if test="${paramMap.gubun eq 'T' }">
					<th>당첨자 추첨 (당첨 가능한 사람수 70명)</th>
					</c:if>
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
			<col style="width:7%" />
			<col style="width:10%" />
			<col style="width:20%" />
			<col />
			<col style="width:20%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="chkboxAll" title="당첨자 전체 선택" /></th>
				<th scope="col">번호</th>
				<th scope="col">성명</th>
				<th scope="col">휴대폰 번호</th>
				<th scope="col">EMAIL</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${empty winnerList }">
			<tr>
				<td colspan="5">당첨자를 추첨해주세요.</td>
			</tr>
		</c:if>
		<c:forEach var="item" items="${winnerList }" varStatus="stat">
			<c:if test="${paramMap.gubun eq 'T'}">
			<c:choose>
				<c:when test="${stat.count eq 1 }">
					<tr>
						<td colspan="5" style="font-weight: bold; color: blue;">1등 당첨자(10명)</td>
					</tr>
				</c:when>
				<c:when test="${stat.count eq 11 }">
					<tr>
						<td colspan="5" style="font-weight: bold; color: blue;">2등 당첨자(20명)</td>
					</tr>
				</c:when>
				<c:when test="${stat.count eq 31 }">
					<tr>
						<td colspan="5" style="font-weight: bold; color: blue;">3등 당첨자(30명)</td>
					</tr>
				</c:when>
			</c:choose>
			</c:if>
			
			<tr>
				<td><input type="checkbox" name="chkbox_id" value="${item.seq }" /></td>
				<td>${stat.count }</td>
				<td><c:out value="${item.name }"/></td>
				<td><c:out value="${item.hp_no}"/></td>
				<td style="word-break: break-all;"><c:out value="${item.email}"/></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</div>
<div class="btnBox">
	<c:if test="${paramMap.gubun eq 'A' }">
	<span style="margin-left:20px; margin-right:4px;">추첨건수
			<input type="text" name="lottery_number" style="padding : 0; width: 50px;"/>
	</span>
	</c:if>
	<c:if test="${paramMap.gubun eq 'T' }">
	<span style="margin-left:20px; margin-right:4px;">
		<input type="text" name="lottery_number" style="padding : 0; width: 50px; display: none;" value="70"/>
	</span>
	</c:if>
	<c:if test="${paramMap.gubun eq 'S' }">
	<span style="margin-left:20px; margin-right:4px;">
		<input type="text" name="lottery_number" style="padding : 0; width: 50px; display: none;" value="250"/>
	</span>
	</c:if>

	<span class="btn white"><button type="button">추첨하기</button></span>

	<span class="btn dark fr" style="margin-right:4px;"><a href="#url" onclick="excelDown(); return false;">엑셀다운로드</a></span>
	<span class="btn dark fr" style="margin-right:4px;"><button type="button">닫기</button></span>
	<span class="btn white fr" style="margin-right:4px;"><button type="button">삭제</button></span>
</div>
</form>
</body>
</html>