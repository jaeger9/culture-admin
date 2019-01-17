<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">

var markSelectedIndex = 0;

var askMarkInfo = {
	markMaxSize : 20,
	markMinSize : 1,
	size : 1
};

var callback = {
	patterncode : function(res) {
		//JSON.stringify(res)
		if (res == null) {
			alert('Response Data null');
			return false;
		}

		$('#pattern_code' + markSelectedIndex).val(res.xtitle);
		$('#did' + markSelectedIndex).val(res.did);
		$("select[name=pattern_gubun]").eq(markSelectedIndex-1).val(res.gbn).attr("selected", "selected");
	}
};

$(function() {

	var frm = $('form[name=frm]');
	var patternCodeDiv = $('#patternCodeDiv');
	var seq = frm.find('input[name=seq]');
	var name = frm.find('input[name=name]');
	var mail1 = frm.find('input[name=mail1]');
	var mail2 = frm.find('input[name=mail2]');
	var phone2 = frm.find('input[name=phone2]');
	var phone3 = frm.find('input[name=phone3]');
	var tel2 = frm.find('input[name=tel2]');
	var tel3 = frm.find('input[name=tel3]');
	var company = frm.find('input[name=company]');
	var pattern_code = frm.find('input[name=pattern_code]');
	var did = frm.find('input[name=did]');

	//3
	var status = frm.find('input[name=status]');

	//layout

	//radio check
	if ('${view.status}')
		$('input:radio[name="status"][value="${view.status}"]').prop('checked', 'checked');

	//checkbox check
	if ('${view.mime_type}') {
		mime_types = '${view.mime_type}'.split(",");

		for (index in mime_types) {
			$("input[name=mime_type][value=" + mime_types[index] + "]").prop("checked", true);
		}
	}

	//email
	if ('${view.email}') {
		//EMAIL

		email = '${view.email}'.split('@');

		$('input[name=mail1]').val(email[0]);
		$('input[name=mail2]').val(email[1]);
		$("select[name=mail3]").val(email[1]).attr("selected", "selected");
	}

	//phone
	if ('${view.phone}') {
		phone = '${view.phone}'.split('-');

		$("select[name=phone1]").val(phone[0]).attr("selected", "selected");
		$('input[name=phone2]').val(phone[1]);
		$('input[name=phone3]').val(phone[2]);
	}

	//tell
	if ('${view.tel}') {
		tel = '${view.tel}'.split('-');

		$("select[name=tel1]").val(tel[0]).attr("selected", "selected");
		$('input[name=tel2]').val(tel[1]);
		$('input[name=tel3]').val(tel[2]);
	}
	
	//if('${view.phone}')$("select").val('${view.phone1}').attr("selected", "selected");
	//if('${view.tel}')$("select").val('${view.tel1}').attr("selected", "selected");
	
	if ('${view.use_year}')
		$("select[name=use_year]").val('${view.use_year}').attr("selected", "selected");

	//mailAddress change
	$('select[name=mail3]').change(function() {
		$('input[name=mail2]').val($(this).prop('option', 'selected').val());
	});

	frm.submit(function() {
		//DB NOT NULL 기준 체크
		
		var gubunCheck = true;
		var gubun;
		$.each($('[name=pattern_code]'), function(i) {
			gubun = $('[name=pattern_gubun]:eq('+i+')');
			if(($(this).val() != null && $(this).val() != '') && (gubun.val() == null || gubun.val() == '')) {
				alert('문양 구분을 선택해주세요');
				gubunCheck = false;
				return false;
			}
		});
		if(!gubunCheck) {
			return false;
		}
		
		if (pattern_code.val() == '') {
			alert('신청 문양 코드 선택하세요');
			pattern_code.focus();
			return false;
		}

		if ($('textarea[name=use_reason]').val() == '') {
			alert('콘텐츠 사용용도 입력하세요');
			$('textarea[name=use_reason]').focus();
			return false;
		}

		if ($('input[name=mime_type]:checked').length < 1) {
			alert('콘텐츠 제공유형 선택하세요');
			$('input[name=mime_type]:checked').focus();
			return false;
		}

		if ($('textarea[name=etc]').val() == '') {
			alert('기대효과 및 기타의견 선택하세요');
			$('textarea[name=etc]').focus();
			return false;
		}

		for(var i=1; i<=3 ; i++){
			if($("input:checkbox[name='contents"+i+"']").is(":checked")){
				$("input:checkbox[name='contents"+i+"']").val(i);
			}else{
				$("input:checkbox[name='contents"+i+"']").val('');
			}
		}

		/* if($('textarea[name=admin_reply]').val() ==''){
			alert('관리자 답변  선택하세요');
			$('textarea[name=admin_reply]').focus();
			return false;
		} */

		return true;
	});

	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
		$(this).click(function() {
			if ($(this).html() == '수정') {
				if (!confirm('수정하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/pattern/ask/update.do');
				frm.submit();
			} else if ($(this).html() == '삭제') {
				if (!confirm('삭제 하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/pattern/ask/delete.do');
				frm.submit();
			} else if ($(this).html() == '등록') {
				if (!confirm('등록하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/pattern/ask/insert.do');
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = '/pattern/ask/list.do?${paramMap.qr_dec }';
			} else {
				return false;
			}
		});
	});

	//중복체크
	$(document).on('click', 'span.btn a', function() {
		try {
			if ($(this).html() == '문양코드 검색') {
				markSelectedIndex = $(this).attr('index');
				window.open('/popup/patterncode.do', 'placePopup', 'scrollbars=yes,width=600,height=630');

			} else if ($(this).html() == '추가') {
				askMarkInfo.size = $('input[name=pattern_code]').size();
				addMarkInputForm();

			} else if ($(this).html() == '삭제') {
				askMarkInfo.size = $('input[name=pattern_code]').size(); 
				deleteMarkInputForm();
			}
		} catch (err) {
			alert(err);
			return false;
		}
	});

	addMarkInputForm = function() {	
		if (askMarkInfo.size < askMarkInfo.markMaxSize) {			
			
			patternCodeHtml = '';
			patternCodeHtml += '<select title="문양 구분" name="pattern_gubun" style="width:100px;">';
				$.each($('#patternCodeDiv select:last option'), function(i) {
					patternCodeHtml += '<option value='+$(this).val()+'>'+$(this).text()+'</option>';
				});
			patternCodeHtml += '</select>';
			patternCodeHtml += ' <input type="text" id="#patternInputCode#" name="pattern_code" style="width:370px" value="" />';
			patternCodeHtml += ' <input type="text" id="#patternID#" name="did" style="width:80px" value="" />';
			patternCodeHtml += ' <span class="btn whiteS"><a href="#url" index="#index#">문양코드 검색</a></span>';
			
			html = patternCodeHtml.replace("#patternInputCode#", "pattern_code" + (askMarkInfo.size + 1));
			html = html.replace("#patternID#", "did" + (askMarkInfo.size + 1));
			html = html.replace("#index#", (askMarkInfo.size + 1));
			
			$('#patternCodeDiv').append(html);
			$("#pattern_code" + (askMarkInfo.size + 1)).next().find('a').click(function() {
				markSelectedIndex = $(this).attr('index');
				window.open('/popup/patterncode.do', 'placePopup', 'scrollbars=yes,width=400,height=300');
			});
			askMarkInfo.size = askMarkInfo.size + 1;
		} else {
			throw "최대 20개까지만 등록 가능합니다.";
		}
	};

	deleteMarkInputForm = function() {
		if (askMarkInfo.size > askMarkInfo.markMinSize) {

			removeTarketInputForm = $('#pattern_code' + askMarkInfo.size);
			removeTarketInputForm.prev().remove();
			removeTarketInputForm.next().remove();
			removeTarketInputForm.next().remove();
			removeTarketInputForm.remove();

			askMarkInfo.size = askMarkInfo.size - 1;
		} else {
			throw "최소 1 개입니다.";
		}
	};
});

</script>
</head>
<body>
<!-- 검색 필드 -->
<div class="tableWrite">
	<form name="frm" method="post" action="/pattern/ask/insert.do">
		<c:if test='${not empty view.seq}'>
			<input type="hidden" name="seq" value="${view.seq}"/>
		</c:if>
		
		<c:if test='${not empty useMarkList}'>
			<div class="sTitBar">
				<h4>신청 문양 정보</h4>
			</div>
			<table summary="신청 문양 정보">
			<caption>신청 문양 정보</caption>
			<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
			<tbody>
				<c:forEach items="${useMarkList }" var="useMarkList" varStatus="status" end="0">
					<tr>
						<th scope="row">신청문양</th>
						<td colspan="3">
							${useMarkList.xtitle }
								<c:if test='${(useMarkList.pattern_cnt)-1 > 0 }' >외 <c:out value='${useMarkList.pattern_cnt-1 }건' /></c:if>(${useMarkList.pattern_code })
						</td>
					</tr>
					<tr>
						<th scope="row">신청일</th>
						<td>
							${useMarkList.reg_date }
						</td>
						<th scope="row">승인일</th>
						<td>
							<c:if test="${view.status eq 'D'}">
								${useMarkList.confirm_date }
							</c:if>
							<c:if test="${view.status eq 'Y'}">
								${useMarkList.confirm_date }
							</c:if>
							
							
						</td>
					</tr>
				</c:forEach>
			</tbody>
			</table>
		</c:if>
		
		<div class="sTitBar">
			<h4>신청자 정보</h4>
		</div>
		
		<table summary="전통문양 활용 작성">
		<caption>전통문양 활용  작성</caption>
		<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
		<tbody>
		<tr>
			<th scope="row">이름</th>
			<td>
				<input type="text" name="name" style="width:275px" value="${view.name}"/>
			</td>
			<th scope="row">아이디</th>
			<td>
				${view.user_id}
			</td>
		</tr>
		<tr>
			<th scope="row">이메일</th>
			<td colspan="3">
				<input type="text" name="mail1" style="width:100px" value="${view.mail1}"/> @
				<input type="text" name="mail2" style="width:150px" value="${view.mail2}"/>
				<select title="Email 선택하세요" name="mail3">
					<option value="">직접입력</option>
					<c:forEach items="${emailList }" var="emailList" varStatus="status">
						<option value="${emailList.value}">${emailList.name}</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th scope="row">휴대폰</th>
			<td	colspan="3">
				<select title="휴대폰 선택하세요" name="phone1" style="width:70px">
					<c:forEach items="${phoneList }" var="phoneList" varStatus="status">
						<option value="${phoneList.value}">${phoneList.name}</option>
					</c:forEach>
				</select>
				-
				<input type="text" maxlength="4" name="phone2" style="width:100px" value="${view.phone2}"/>
				-
				<input type="text" maxlength="4" name="phone3" style="width:100px" value="${view.phone3}"/>
			</td>
		</tr>
		<tr>
			<th scope="row">연락처</th>
			<td	colspan="3">
				<select title="지역번호 선택하세요" name="tel1" style="width:70px">
					<c:forEach items="${areaTelNumList }" var="areaTelNumList" varStatus="status">
						<option value="${areaTelNumList.value}">${areaTelNumList.name}</option>
					</c:forEach>
				</select>
				-
				<input type="text" maxlength="4" name="tel2" style="width:100px" value="${view.tel2}"/>
				-
				<input type="text" maxlength="4" name="tel3" style="width:100px" value="${view.tel3}"/>
			</td>
		</tr>
		<tr>
			<th scope="row">사용용도</th>
			<td	colspan="3">
				<input type="checkbox" name="contents1" value="1" title="개인 선택" <c:if test="${view.contents1 eq '1'}">checked</c:if> />개인 &nbsp;
				<input type="checkbox" name="contents2" value="2" title="개인 선택" <c:if test="${view.contents2 eq '2'}">checked</c:if> />민간 &nbsp;
				<input type="checkbox" name="contents3" value="3" title="개인 선택" <c:if test="${view.contents3 eq '3'}">checked</c:if> />공공
			</td>
		</tr>
		<tr>
			<th scope="row">소속/직위</th>
			<td colspan="3">
				<input type="text" name="company" style="width:670px" value="${view.company}"/>
			</td>	
		</tr>
		</tbody>
		</table>
		
		<div class="sTitBar">
			<h4>신청 콘텐츠 정보</h4>
		</div>
		
		<table summary="신청 콘텐츠 작성">
		<caption>신청 콘텐츠 작성</caption>
		<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
		<tbody>
		<tr>
			<th scope="row">신청 문양 코드</th>
			<td colspan="3">
				<div id="patternCodeDiv">
					<c:if test="${empty useMarkList }">
						<select title="문양 구분" name="pattern_gubun" style="width:100px">
							<option value="">구분 선택</option>
							<c:forEach var="pg" items="${patternGubunList }" varStatus="pgStatus">
								<option value="<c:out value="${pg.value }" />"><c:out value="${pg.name }"/></option>
							</c:forEach>
						</select>					
						<input type="text" id="pattern_code1" name="pattern_code" style="width:370px" value=""/>
						<input type="text" id="did1"          name="did"          style="width:80px" value=""/>
						<span class="btn whiteS"><a href="#url" index="1">문양코드 검색</a></span>
					</c:if>
					<c:if test="${not empty useMarkList }">
						<c:forEach items="${useMarkList }" var="useMarkList" varStatus="status">
							<select title="문양 구분" name="pattern_gubun" style="width:100px">
								<option value="">구분 선택</option>
								<c:forEach var="pg" items="${patternGubunList }" varStatus="pgStatus">
									<option value="<c:out value="${pg.value }" />" <c:if test="${pg.value == useMarkList.pattern_gubun }">selected="selected"</c:if>><c:out value="${pg.name }"/></option>
								</c:forEach>
							</select>
							<input type="text" id="pattern_code${status.count}" name="pattern_code" style="width:370px" value="${useMarkList.pattern_code}(${useMarkList.xfile})${useMarkList.xtitle}"/>
							<input type="text" id="did${status.count}"          name="did"          style="width:80px" value="${useMarkList.pattern_code}"/>
							<span class="btn whiteS"><a href="#url" index="${status.count}">문양코드 검색</a></span>
						</c:forEach>														
					</c:if>
				</div>
				<div  style="margin-top: 2px;">
					<span class="btn whiteS"><a href="#url">추가</a></span>
					<span class="btn whiteS"><a href="#url">삭제</a></span>
				</div>
			</td>
		</tr>
		<tr>
			<th scope="row">콘텐츠 사용기간</th>
			<td colspan="3">
				<c:if test="${view.status eq 'D'}">
					${view.confirm_date } ~ ${view.confirm_end_date } 
				</c:if>
				<c:if test="${view.status eq 'Y'}">
					${view.confirm_date } ~ ${view.confirm_end_date } 
				</c:if>
				<select title="콘텐츠 사용기간" name="use_year" style="width:50px">
					<option value="1">1</option>
					<option value="2">2</option>
				</select> 년
			</td>
		</tr>
		<tr>
			<th scope="row">콘텐츠 사용용도</th>
			<td colspan="3">
				<textarea name="use_reason" style="width:100%;height:100px;"><c:out value="${view.use_reason}" escapeXml="true" /></textarea>
			</td>	
		</tr>
		<tr>
			<th scope="row">콘텐츠 제공유형</th>
			<td colspan="3">
<%-- 				<lable><input type="checkbox" value="JPG" name="mime_type"/> JPG</lable>
				<c:if test="${view.status eq 'D'}">
					<lable><input type="checkbox" value="AI" name="mime_type" checked/> AI</lable>
				</c:if>
				<c:if test="${view.status ne 'D'}">
					<lable><input type="checkbox" value="AI" name="mime_type"/> AI</lable>
				</c:if>
				<lable><input type="checkbox" value="3D" name="mime_type"/> 3D</lable>
				<lable><input type="checkbox" value="CAD" name="mime_type"/> CAD</lable> --%>
				<lable><input type="checkbox" value="org" name="mime_type" checked="checked"/> 원본</lable>
			</td>	
		</tr>
		<tr>
			<th scope="row">기대효과 및 기타의견</th>
			<td colspan="3">
				<textarea name="etc" style="width:100%;height:100px;"><c:out value="${view.etc}" escapeXml="true" /></textarea>
			</td>	
		</tr>
		<tr>
			<th scope="row">관리자 답변 </th>
			<td colspan="3">
				<textarea name="admin_reply" style="width:100%;height:100px;"><c:out value="${view.admin_reply}" escapeXml="true" /></textarea>
			</td>	
		</tr>
		<tr>
			<th scope="row">승인여부</th>
			<td colspan="3">
				<div class="inputBox">
					<label><input type="radio" name="status" value="W" checked/>대기</label>
					<c:if test="${view.status eq 'D'}">
						<label><input type="radio" name="status" value="Y" checked/>승인</label>
					</c:if>
					<c:if test="${view.status ne 'D'}">
						<label><input type="radio" name="status" value="Y"/>승인</label>
					</c:if>
					<label><input type="radio" name="status" value="N"/>미승인</label>
				</div>
			</td>
		</tr>				
		</tbody>
		</table>
	</form>
</div>
<div class="btnBox textRight">
	<c:if test='${not empty view}'>
		<span class="btn white"><button type="button">수정</button></span>
		<span class="btn white"><button type="button">삭제</button></span>
	</c:if>
	<c:if test='${empty view }'>
		<span class="btn white"><button type="button">등록</button></span>
	</c:if>
	<span class="btn gray"><button type="button">목록</button></span>
</div>
</body>
</html>