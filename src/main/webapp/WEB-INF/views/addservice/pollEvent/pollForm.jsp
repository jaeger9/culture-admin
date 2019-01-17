<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- <script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script> -->
<script type="text/javascript">

var callback = {
	fileUpload : function (res) {
		console.log( res.full_file_path);
		console.log( res.file_path);
		target.val(res.file_path);
		//targetView.html('<img src="/upload/recom/recom/' + res.file_path + '" width="100" height="100" alt="" />');
	}
};

$(function () {
	
	var frm			=	$('form[name=frm]');
	
	var event_seq		=	$('input[name="event_seq"]');
	var event_number		=	$('input[name="event_number"]');
	var poll_start_date		=	$('input[name="poll_start_date"]');
	var poll_end_date		=	$('input[name="poll_end_date"]');
	var poll_winner_date		=	$('input[name="poll_winner_date"]');
	var poll1_title		=	$('input[name="poll1_title"]');
	
	var work1_file_name		=	$('input[name="work1_file_name"]');
	var work1_url		=	$('input[name="work1_url"]');
	var work1_title		=	$('input[name="work1_title"]');
	
	var work2_file_name		=	$('input[name="work2_file_name"]');
	var work2_url		=	$('input[name="work2_url"]');
	var work2_title		=	$('input[name="work2_title"]');
	
	var poll2_title		=	$('input[name="poll2_title"]');
	var work3_file_name		=	$('input[name="work3_file_name"]');
	var work3_url		=	$('input[name="work3_url"]');
	var work3_title		=	$('input[name="work3_title"]');
	
	var work4_file_name		=	$('input[name="work4_file_name"]');
	var work4_url		=	$('input[name="work4_url"]');
	var work4_title		=	$('input[name="work4_title"]');

	var approval		=	$('input[name="approval"]');
	
	
	new Datepicker(poll_start_date, poll_end_date);
	new setDatepicker(poll_winner_date);
	
	
	frm.submit(function () {

		if (event_number.val() == '') {
			event_number.focus();
			alert('회차를 입력해 주세요.');
			return false;
		}else{		
			var number = /^[0-9]*$/;
			if (!number.test(event_number.val())) {
				event_number.focus();
				event_number.val('');
				alert('회차는 숫자만 입력가능합니다.');
				return false;
			}
			
		}
		
		var duplCheck = pollNumberDuplCheck();
		if(!duplCheck){
			alert('이미 있는 회차입니다.');
			event_number.focus();
			return false;
		}
		
		if (poll_start_date.val() == '') {
			poll_start_date.focus();
			alert('투표이벤트 시작일을 선택해 주세요.');
			return false;
		}
		if (poll_end_date.val() == '') {
			poll_end_date.focus();
			alert('투표이벤트 종료일을 선택해 주세요.');
			return false;
		}
		
		var duplCheck2 = pollPeriodDuplCheck();
		if(!duplCheck2){
			alert('투표이벤트 기간이 중복되는 정보가 있습니다.');
			poll_start_date.focus();
			return false;
		}
		
		if (poll_winner_date.val() == '') {
			poll_winner_date.focus();
			alert('투표이벤트 당첨자 발표일을 선택해 주세요.');
			return false;
		}
		if (poll1_title.val() == '') {
			poll1_title.focus();
			alert('투표 타이틀1을 입력해 주세요.');
			return false;
		}
		if (work1_file_name.val() == '') {
			alert('작품 1-1 이미지를 선택해 주세요.');
			return false;
		}
		if (work1_url.val() == '') {
			work1_url.focus();
			alert('작품 1-1 연결 URL을 입력해 주세요.');
			return false;
		}
		if (work1_title.val() == '') {
			work1_title.focus();
			alert('작품 1-1 작품 제목을 입력해 주세요.');
			return false;
		}
		if (work2_file_name.val() == '') {
			alert('작품 1-2 이미지를 선택해 주세요.');
			return false;
		}
		if (work2_url.val() == '') {
			work2_url.focus();
			alert('작품 1-2 연결 URL을 입력해 주세요.');
			return false;
		}
		if (work2_title.val() == '') {
			work2_title.focus();
			alert('작품 1-2 작품 제목을 입력해 주세요.');
			return false;
		}

		if (poll2_title.val() == '') {
			poll2_title.focus();
			alert('투표 타이틀2를 입력해 주세요.');
			return false;
		}
		if (work3_file_name.val() == '') {
			alert('작품 2-1 이미지를 선택해 주세요.');
			return false;
		}
		if (work3_url.val() == '') {
			work3_url.focus();
			alert('작품 2-1 연결 URL을 입력해 주세요.');
			return false;
		}
		if (work3_title.val() == '') {
			work3_title.focus();
			alert('작품 1-1 작품 제목을 입력해 주세요.');
			return false;
		}
		if (work4_file_name.val() == '') {
			alert('작품 2-2 이미지를 선택해 주세요.');
			return false;
		}
		if (work4_url.val() == '') {
			work4_url.focus();
			alert('작품 2-2 연결 URL을 입력해 주세요.');
			return false;
		}
		if (work4_title.val() == '') {
			work4_title.focus();
			alert('작품 2-2 작품 제목을 입력해 주세요.');
			return false;
		}
		
		if (approval.filter(':checked').size() == 0) {
			approval.eq(0).focus();
			alert('승인여부를 선택해 주세요.');
			return false;
		}
		
		
		
		

		if(event_seq.val() != ''){
			if(!confirm('수정하시겠습니까?')){
				return false;
			}
		}else{
			if(!confirm('등록하시겠습니까?')){
				return false;
			}
		}
		return true;
	});
	
	// 찾아보기업로드
	$('.upload_pop_btn').click(function () {
		var p		=	$(this).parents('td:eq(0)');
		target		=	p.find('input[type=text]');
		//targetView	=	p.find('.upload_pop_img');

		Popup.fileUpload('addservice_pollEvent');
		return false;
	});
	
	// 등록/수정
	$('.insert_btn').click(function () {
		frm.submit();
		return false;
	});

	// 삭제
/* 	if ($('.delete_btn').size() > 0) {
		$('.delete_btn').click(function () {
			// 삭제
			if (!confirm('삭제하시겠습니까?')) {
				return false;
			}
			if (event_seq.val() == '') {
				alert('event_seq가 존재하지 않습니다.');
				return false;
			}

			var param = {
					seqs : [ event_seq.val() ]
			};

			$.ajax({
				url			:	'/addservice/pollEvent/pollDelete.do'
				,type		:	'post'
				,data		:	$.param(param, true)
				,dataType	:	'json'
				,success	:	function (res) {
					if (res.success) {
						alert("삭제가 완료 되었습니다.");
						location.href = $('.list_btn').attr('href');

					} else {
						alert("이벤트에 투표자가 있습니다.");
					}
				}
				,error : function(data, status, err) {
					alert("삭제 실패 되었습니다.");
				}
			});

			return false;
		});		
	} */
	
});

function pollNumberDuplCheck(){
	var result = false;
	var param1 = {
			event_seq : $('input[name="event_seq"]').val() , event_number : $('input[name="event_number"]').val()
		};
	//회차 중복체크
	$.ajax({
		url			:	'/addservice/pollEvent/eventNumberDuplCheck.do'
		,async: false
		,type		:	'post'
		,data		:	$.param(param1, true)
		,dataType	:	'json'
		,success	:	function (res) {
			console.log('res.result > '+res.result);		
			result = res.result;
		}
		,error : function(data, status, err) {
			//alert("삭제 실패 되었습니다.");
			console.log(err);
		}
	});
	
	return result;
}

function pollPeriodDuplCheck(){
	var result = false;
	var param2 = {
			event_seq : $('input[name="event_seq"]').val(), poll_start_date : $('input[name="poll_start_date"]').val(), poll_end_date : $('input[name="poll_end_date"]').val()
		};
	//투표이벤트기간 중복체크
	$.ajax({
		url			:	'/addservice/pollEvent/pollPeriodDuplCheck.do'
		,async: false
		,type		:	'post'
		,data		:	$.param(param2, true)
		,dataType	:	'json'
		,success	:	function (res) {
			result = res.result;
		}
		,error : function(data, status, err) {
			//alert("삭제 실패 되었습니다.");
			console.log(err);
		}
	});
	
	return result;
}

</script>
</head>
<body>

<form name="frm" method="POST" action="/addservice/pollEvent/pollForm.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="event_seq" value="${view.event_seq }" />

	<div class="tableWrite">
		<table summary="게시판 글 등록">
			<caption>게시판 글 등록</caption>
			<colgroup>
				<col style="width:20%" />
				<col style="width:20%" />
				<col style="width:20%" />
				<col style="width:20%" />
				<col style="width:20%" />
			</colgroup>
			<tbody>
				<tr>
					<th>*회차</th>
					<td colspan="4">
						<input type="text" name="event_number" value="${view.event_number }" style="width:100px" maxlength="5"/>
					</td>
				</tr>
				<tr>
					<th>*투표이벤트 기간</th>
					<td colspan="4">
						<input type="text" name="poll_start_date" value="${view.poll_start_date}" readonly="readonly"/>
						<span>~</span>
						<input type="text" name="poll_end_date" value="${view.poll_end_date }" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<th>*투표 당첨자발표</th>
					<td colspan="4">
						<input type="text" name="poll_winner_date" value="${view.poll_winner_date}" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<th>*투표 타이틀1 text</th>
					<td colspan="4"><input type="text" name="poll1_title" value="${view.poll1_title}" style="width:80%" maxlength="500"/></td>
				</tr>
				
				
				<c:if test="${not empty view.poll1_seq }">
					<input type="hidden" name="poll1_seq" value="${view.poll1_seq }"/>
				</c:if>
			<!-- 작품 1-1 start-->
				<c:if test="${not empty view.work1_seq }">
					<input type="hidden" name="work1_seq" value="${view.work1_seq }"/>
				</c:if>
				<tr>
					<th rowspan="4">*작품 1-1</th>
					<td colspan="4">
						이미지 <input type="text" name="work1_file_name" value="${view.work1_file_name }" style="width:460px" readonly="readonly"/>
						<span class="btn whiteS"><a href="#" class="upload_pop_btn">찾아보기</a></span>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						연결 URL <input type="text" name="work1_url" value="${view.work1_url}" style="width:80%" maxlength="150"/>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						작품 제목 <input type="text" name="work1_title" value="${view.work1_title}" style="width:80%" maxlength="200"/>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						투표 경품 <input type="text" name="work1_gift" value="${view.work1_gift}" style="width:80%" maxlength="200"/>
					</td>
				</tr>
				<tr>
					<th rowspan="3">작품 1-1 연관 키워드</th>
					<td colspan="2">
						키워드 <input type="text" name="work1_keyword1" value="${view.work1_keyword1}" style="width:220px" maxlength="50"/>
					</td>
					<td colspan="2">
						연결 URL <input type="text" name="work1_keyword1_url" value="${view.work1_keyword1_url}" style="width:220px" maxlength="150"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						키워드 <input type="text" name="work1_keyword2" value="${view.work1_keyword2}" style="width:220px" maxlength="50"/>
					</td>
					<td colspan="2">
						연결 URL <input type="text" name="work1_keyword2_url" value="${view.work1_keyword2_url}" style="width:220px" maxlength="150"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						키워드 <input type="text" name="work1_keyword3" value="${view.work1_keyword3}" style="width:220px" maxlength="50"/>
					</td>
					<td colspan="2">
						연결 URL <input type="text" name="work1_keyword3_url" value="${view.work1_keyword3_url}" style="width:220px" maxlength="150"/>
					</td>
				</tr>
			<!-- 작품 1-1 end-->
			
			<!-- 작품 1-2 start-->
				<c:if test="${not empty view.work2_seq }">
					<input type="hidden" name="work2_seq" value="${view.work2_seq }"/>
				</c:if>
				<tr>
					<th rowspan="4">*작품 1-2</th>
					<td colspan="4">
						이미지 <input type="text" name="work2_file_name" value="${view.work2_file_name }" style="width:460px" readonly="readonly"/>
						<span class="btn whiteS"><a href="#" class="upload_pop_btn">찾아보기</a></span>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						연결 URL <input type="text" name="work2_url" value="${view.work2_url}" style="width:80%" maxlength="150"/>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						작품 제목 <input type="text" name="work2_title" value="${view.work2_title}" style="width:80%" maxlength="200"/>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						투표 경품 <input type="text" name="work2_gift" value="${view.work2_gift}" style="width:80%" maxlength="200"/>
					</td>
				</tr>
				<tr>
					<th rowspan="3">작품 1-2 연관 키워드</th>
					<td colspan="2">
						키워드 <input type="text" name="work2_keyword1" value="${view.work2_keyword1}" style="width:220px" maxlength="50"/>
					</td>
					<td colspan="2">
						연결 URL <input type="text" name="work2_keyword1_url" value="${view.work2_keyword1_url}" style="width:220px" maxlength="150"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						키워드 <input type="text" name="work2_keyword2" value="${view.work2_keyword2}" style="width:220px" maxlength="50"/>
					</td>
					<td colspan="2">
						연결 URL <input type="text" name="work2_keyword2_url" value="${view.work2_keyword2_url}" style="width:220px" maxlength="150"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						키워드 <input type="text" name="work2_keyword3" value="${view.work2_keyword3}" style="width:220px" maxlength="50"/>
					</td>
					<td colspan="2">
						연결 URL <input type="text" name="work2_keyword3_url" value="${view.work2_keyword3_url}" style="width:220px" maxlength="150"/>
					</td>
				</tr>
			<!-- 작품 1-2 end-->
			
			
			
				<c:if test="${not empty view.poll2_seq }">
					<input type="hidden" name="poll2_seq" value="${view.poll2_seq }"/>
				</c:if>
				<tr>
					<th>*투표 타이틀2 text</th>
					<td colspan="4"><input type="text" name="poll2_title" value="${view.poll2_title}" style="width:80%" maxlength="500"/></td>
				</tr>
				
			<!-- 작품 2-1 start-->
				<c:if test="${not empty view.work3_seq }">
					<input type="hidden" name="work3_seq" value="${view.work3_seq }"/>
				</c:if>
				<tr>
					<th rowspan="4">*작품 2-1</th>
					<td colspan="4">
						이미지 <input type="text" name="work3_file_name" value="${view.work3_file_name }" style="width:460px" readonly="readonly"/>
						<span class="btn whiteS"><a href="#" class="upload_pop_btn">찾아보기</a></span>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						연결 URL <input type="text" name="work3_url" value="${view.work3_url}" style="width:80%" maxlength="150"/>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						작품 제목 <input type="text" name="work3_title" value="${view.work3_title}" style="width:80%" maxlength="200"/>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						투표 경품 <input type="text" name="work3_gift" value="${view.work3_gift}" style="width:80%" maxlength="200"/>
					</td>
				</tr>
				<tr>
					<th rowspan="3">작품 2-1 연관 키워드</th>
					<td colspan="2">
						키워드 <input type="text" name="work3_keyword1" value="${view.work3_keyword1}" style="width:220px" maxlength="50"/>
					</td>
					<td colspan="2">
						연결 URL <input type="text" name="work3_keyword1_url" value="${view.work3_keyword1_url}" style="width:220px" maxlength="150"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						키워드 <input type="text" name="work3_keyword2" value="${view.work3_keyword2}" style="width:220px" maxlength="50"/>
					</td>
					<td colspan="2">
						연결 URL <input type="text" name="work3_keyword2_url" value="${view.work3_keyword2_url}" style="width:220px" maxlength="150"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						키워드 <input type="text" name="work3_keyword3" value="${view.work3_keyword3}" style="width:220px" maxlength="50"/>
					</td>
					<td colspan="2">
						연결 URL <input type="text" name="work3_keyword3_url" value="${view.work3_keyword3_url}" style="width:220px" maxlength="150"/>
					</td>
				</tr>
			<!-- 작품 2-1 end-->
			
			
			<!-- 작품 2-2 start-->
				<c:if test="${not empty view.work4_seq }">
					<input type="hidden" name="work4_seq" value="${view.work4_seq }"/>
				</c:if>
				<tr>
					<th rowspan="4">*작품 2-2</th>
					<td colspan="4">
						이미지 <input type="text" name="work4_file_name" value="${view.work4_file_name }" style="width:460px" readonly="readonly"/>
						<span class="btn whiteS"><a href="#" class="upload_pop_btn">찾아보기</a></span>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						연결 URL <input type="text" name="work4_url" value="${view.work4_url}" style="width:80%" maxlength="150"/>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						작품 제목 <input type="text" name="work4_title" value="${view.work4_title}" style="width:80%" maxlength="200"/>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						투표 경품 <input type="text" name="work4_gift" value="${view.work4_gift}" style="width:80%" maxlength="200"/>
					</td>
				</tr>
				<tr>
					<th rowspan="3">작품 2-2 연관 키워드</th>
					<td colspan="2">
						키워드 <input type="text" name="work4_keyword1" value="${view.work4_keyword1}" style="width:220px" maxlength="50"/>
					</td>
					<td colspan="2">
						연결 URL <input type="text" name="work4_keyword1_url" value="${view.work4_keyword1_url}" style="width:220px" maxlength="150"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						키워드 <input type="text" name="work4_keyword2" value="${view.work4_keyword2}" style="width:220px" maxlength="50"/>
					</td>
					<td colspan="2">
						연결 URL <input type="text" name="work4_keyword2_url" value="${view.work4_keyword2_url}" style="width:220px" maxlength="150"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						키워드 <input type="text" name="work4_keyword3" value="${view.work4_keyword3}" style="width:220px" maxlength="50"/>
					</td>
					<td colspan="2">
						연결 URL <input type="text" name="work4_keyword3_url" value="${view.work4_keyword3_url}" style="width:220px" maxlength="150"/>
					</td>
				</tr>
			<!-- 작품 2-2 end-->

				<tr>
					<th scope="row">승인여부</th>
					<td colspan="4">
						<label><input type="radio" name="approval" value="S" ${view.approval eq 'S' ? 'checked="checked"' : '' } /> 대기</label>
						<label><input type="radio" name="approval" value="Y" ${view.approval eq 'Y' ? 'checked="checked"' : '' } /> 승인</label>
						<label><input type="radio" name="approval" value="N" ${view.approval eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.event_seq ? '등록' : '수정' }</a></span>

<%-- 		<c:if test="${not empty view.event_seq }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>
 --%>
		<span class="btn gray"><a href="/addservice/pollEvent/pollList.do" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>