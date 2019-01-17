<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="/js/culturepro/view/common.js"></script>
<script type="text/javascript">

var callback = {
		//내부 링크페이지 연결
		setInLink : function(value, title){
			$("input[name=in_link]").val(value);
			$("#rtitle").html(title);
		}
};



$(function() {
	var frm = $('form[name=frm]');
	var title = frm.find('input[name=title]');
	var send_date = frm.find('input[name=send_date]');

	new Datepicker(send_date, null);
	

	// 파일찾기
	$('.upload_pop_btn').click(function () {
		if($('input:radio[name="link_type"]:checked').val() != "I"){
			alert("링크페이지 타입을 '앱 내부 페이지'로 선택해주세요.");
			return;
		}

		Popup.linkPath();
		return false;
	});


	// 링크페이지  radio check
	if ('${view.link_type}') {
		$('input:radio[name="link_type"][value="${view.link_type}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="link_type"][value="I"]').prop('checked', 'checked');
		$('input[name=out_link]').attr("disable", true);
	}
	
	// 발송시각 radio check
	if ('${view.send_type}') {
		$('input:radio[name="send_type"][value="${view.send_type}"]').prop('checked', 'checked');
		$('select[name=send_hour]').val('${view.send_hour}');
		$('select[name=send_minute]').val('${view.send_minute}');
	} else {
		$('input:radio[name="send_type"][value="D"]').prop('checked', 'checked');
		$('select[name=send_hour]').attr("disable", true);
		$('select[name=send_minute]').attr("disable", true);
	}
	
	//링크페이지 타입에 따른 처리 
	$('input:radio[name="link_type"]').change(function(){
		var value = $(this).val();
		$('input[name=in_link]').val("");
		$('input[name=out_link]').val("");
		if(value == 'I'){
			$('input[name=out_link]').attr("disable", true);
		}else{
			$('input[name=out_link]').attr("disable", false);
		}
	});
	
	
	//발송시각 타입에 따른 처리 
	$('input:radio[name="send_type"]').change(function(){
		var value = $(this).val();
		if(value == 'D'){
			$('input[name=send_date]').val("");
			$('select[name=send_hour]').val("");
			$('select[name=send_minute]').val("");
			$('input[name=send_date]').attr("disable", true);
			$('select[name=send_hour]').attr("disable", true);
			$('select[name=send_minute]').attr("disable", true);
		}else{
			$('input[name=send_date]').attr("disable", false);
			$('select[name=send_hour]').attr("disable", false);
			$('select[name=send_minute]').attr("disable", false);
		}
	});
	
	frm.submit(function() {
		
		if (title.val() == '') {
			alert("제목 입력해 주세요");
			title.focus();
			return false;
		}
		
		if ($('textarea[name=contents]').val() == '') {
			alert("내용을 입력해 주세요");
			$('textarea[name=contents]').focus();
			return false;
		}else if(!common.chkByteLen("contents", 2000, null)){
			alert("내용은 2000자까지 입력 가능합니다.");
			$('textarea[name=contents]').focus();
			return false;
		}
		

		if($('input:radio[name=link_type]:checked').val() == ''){
			alert("링크페이지 종류를 선택해주세요.");
			return false;
		}else if($('input:radio[name=link_type]:checked').val() == 'I' && 
				$('input[name=in_link]').val() == '' ){
			alert("앱 내부 페이지를 선택해주세요. ");
			return false;
		}else if($('input:radio[name=link_type]:checked').val() == 'O' && 
				$('input[name=out_link]').val() == '' ){
			alert("외부 URL을 입력해주세요. ");
			return false;
		}
		
		if($('input:radio[name=send_type]:checked').val() == ''){
			alert("발송타입을 선택해주세요.");
			return false;
		}else if($('input:radio[name=send_type]:checked').val() == 'R'){
			if(($('select[name=send_hour]').val() == '') && ($('select[name=send_minute]').val() == '')){
				alert("발송 예약 시간을 선택해주세요.");
				return false;
			}
		}
		
		return true;
	});

	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
		$(this).click(function() {
			if ($(this).html() == '수정') {
				if (!confirm('수정하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/culturePush/update.do');
				frm.submit();
			} else if ($(this).html() == '삭제') {
				if (!confirm('삭제 하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/culturePush/delete.do');
				frm.submit();
			} else if ($(this).html() == '등록') {
				if (!confirm('등록하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/culturePush/insert.do');
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = '/culturepro/culturePush/list.do';
			}  else if ($(this).html() == '바로발송') {
				if (!confirm('지금 발송하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/culturePush/send.do');
				frm.submit();
			}
		});
	});
	
	//내용을 쓸때마다 체크함.
	$('textarea[name="contents"]').keyup(function(){
		var result = common.chkByteLen("contents", 2000, "count_char");
		if(!result){
			alert("내용은 2000자까지 입력 가능합니다.");
			return;
		}
	});

	

});
</script>
</head>
<body>

	<div class="tableWrite">
		<form name="frm" method="post" enctype="multipart/form-data">
			<c:if test='${not empty view}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
				<input type="hidden" name="send_yn" value="${view.send_yn}"/>
				<input type="hidden" name="fromUrl" value="view"/>
			</c:if>
			<div class="tableWrite">
				<table summary="PUSH 관리 등록/수정/상세 페이지입니다.">
					<caption>PUSH 관리</caption>
					<tbody>
					 <c:if test='${not empty view}'>
						<tr>
							<th scope="row">등록일</th>
							<td><span><c:out value='${view.reg_date }'/></span></td>
						</tr>
					</c:if>
						<tr>
							<th scope="row"><span style="color: red">*</span> 제목</th>
							<td><span><input type="text" id="title" name="title" value="<c:out value='${view.title }'/>"
									class="inputText width80" /></span></td>
						</tr>
						<tr>
							<th scope="row"><span style="color: red">*</span> PUSH 메시지</th>
							<td>
								<textarea id="contents" name="contents" style="width:100%;height:100px;" maxlength="2000"><c:out value="${view.contents}" escapeXml="true" /></textarea>
								<div style="text-align:right;"><span name="count_char" id="count_char">0</span>/2000byte</div>
							</td>
						</tr>
						<tr>
							<th scope="row"><span style="color: red">*</span> 링크 페이지</th>
							<td>
								<label><input type="radio" name="link_type" value="I"
									${view.link_type eq 'I' ? 'checked="checked"' : '' } />앱 내부 페이지</label> 
									<input type="hidden" name="in_link" value="${view.in_link}" />
									<span class="btn whiteS"><a href="#" class="upload_pop_btn">찾아보기</a></span>
									<span id="rtitle">${view.rtitle}</span>
									<br/>
									<label><input
									type="radio" name="link_type" value="O"
									${view.link_type eq 'O' ? 'checked="checked"' : '' } />외부 URL</label> 
							<span><input type="text" id="out_link" name="out_link" value="<c:out value='${view.out_link}' escapeXml='false' />"
									class="inputText width80" /></span></td>
						</tr>
							<tr>
							<th scope="row"><span style="color: red">*</span> 발송시각</th>
							<td>
							<c:choose>
							   <c:when test="${empty view || (view.send_yn != 'Y')}">
									<label><input
										type="radio" name="send_type" value="D"
										${view.send_type eq 'D' ? 'checked="checked"' : '' } />등록 후 바로발송</label> 
									<label><input
										type="radio" name="send_type" value="R"
										${view.send_type eq 'R' ? 'checked="checked"' : '' } />발송예약</label> 
									<input type="text" name="send_date" value="${view.send_date }" />
									<select name="send_hour">
										<option value="">시간</option>
										<c:forEach var="i" begin="0" end="23">
											<option>${i}</option>
										</c:forEach>
									</select>시 
									<select name="send_minute">
										<option value="">분</option>
										<c:forEach var="i" begin="0" end="59">
											<option><fmt:formatNumber value="${i}" var="min" pattern="00"/>${min}</option>
										</c:forEach>
									</select>분 
								</c:when>
								<c:otherwise>
									[발송완료]${view.send_date} ${view.send_hour}:${view.send_minute}
								</c:otherwise>
							</c:choose>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</form>
	</div>
	<div>
	<p>
	*iOS 기기에서는 제목 부분이 표시되지 않습니다(앱 명칭이 표시됨)<br/>
	*iOS 8 이전 버전 호환을 위해 메시지 내용이 200byte이하로 제한됩니다. (한글 1자당 6byte, 띄어쓰기 및 숫자/특수문자 1byte)
	</p>
	</div>
	<div class="btnBox textLeft">
		<c:if test='${not empty view && view.send_yn != "Y"}'>
			<span class="btn white"><button type="button" ${view.send_yn == 'Y' ? 'disabled=disabled' : ''} >바로발송</button></span>
		</c:if>
	</div>
	<div class="btnBox textRight">
	<c:if test='${not empty view}'>
		<span class="btn gray"><button type="button">수정</button></span>
		<span class="btn gray"><button type="button">삭제</button></span>
	</c:if>
	<c:if test='${empty view}'>
		<span class="btn gray"><button id="register" type="button">등록</button></span>
	</c:if>
		<span class="btn gray"><button id="list" type="button">목록</button></span>
	</div>
</body>
</html>