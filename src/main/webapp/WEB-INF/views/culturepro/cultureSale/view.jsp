<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />


<script type="text/javascript" src="<c:url value="/js/culturepro/view/common.js"/>"></script>
<!-- <script type="text/javascript" src="/crosseditor/js/namo_scripteditor.js"></script> -->
<script type="text/javascript">
var target = null;
var targetView = null;
var callback = {
		fileUpload : function (res) {
			target.val(res.file_path);
			targetView.html('<img src="/upload/cultureNews/' + res.file_path + '" width="150" height="150" alt="" />');
		}
	};


$(function() {
	var frm = $('form[name=frm]');
	var title = frm.find('input[name=title]');
	var strt_dt = frm.find('input[name=strt_dt]');
	var end_dt = frm.find('input[name=end_dt]');
	
	new Datepicker(strt_dt, end_dt);
	
	// 승인 여부  radio check
	if ('${view.app_approval}') {
		$('input:radio[name="app_approval"][value="${view.app_approval}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="app_approval"][value="W"]').prop('checked', 'checked');
	}
	
	$('.upload_pop_btn').click(function () {
		if($('input:radio[name="u_type"]:checked').val() != "D"){
			alert("썸네일 타입을 '직접 등록'으로 선택해주세요.");
			return;
		}
		var p		=	$(this).parents('tr:eq(0)');
		target		=	p.find("input[name='file_name']");
		targetView	=	p.find('.upload_pop_img');

		Popup.fileUpload('cultureVideo');
		return false;
	});
	
	//썸네일 타입 선택 시 초기화 
	$('input:radio[name="u_type"]').change(function(){
		$("input[name=file_name]").val("");
		$(".upload_pop_img").html("");
		$("#u_url").val("");
	});
	

	$('#u_url').on("keyup",function(){
		$('input:radio[name="u_type"][value="S"]').prop('checked', 'checked');
		var url = $("#u_url").val();
		var youtube_id = youtube_parser(url);
		if(youtube_id == false){
			alert("올바르지 않은 유튜브 URL입니다.");
			return;
		}
		var thumnail_url = "http://img.youtube.com/vi/"+youtube_id+"/hqdefault.jpg";
		$("input[name=file_name]").val(thumnail_url);
		$(".upload_pop_img").html('<img src="'+ thumnail_url + '" width="480" height="360" alt="" />');
	});
	
	//위치 찾기
	$('.find_location').click(function(){
		var index = $(this).index();
		Popup.findLocation(index+1);
	});
	
	setCoordinate = function (cul_gps_x , cul_gps_y, num){
		$('#gps_x'+num).val(cul_gps_x);
		$('#gps_y'+num).val(cul_gps_y);
	}
	
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
				frm.attr('action', '/culturepro/cultureSale/update.do');
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = '/culturepro/cultureSale/list.do';
			}
		});
	});
});
</script>
</head>
<body>
	<div class="tableWrite">
		<form name="frm" method="post" enctype="multipart/form-data">
			<c:if test='${not empty view}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
				<input type="hidden" name="type" value="${view.type}"/>
			</c:if>
			<div class="tableWrite">
				<table summary="관리자 HOT 할인정보 등록 페이지입니다.">
					<caption>관리자 HOT 할인정보 컨텐츠</caption>
					<colgroup>
						<col width="20%"/>
						<col width="*"/>
					</colgroup>
					<tbody>
					 <c:if test='${not empty view}'>
						<tr>
							<th scope="row">등록일</th>
							<td><span><c:out value='${view.reg_dt }'/></span></td>
						</tr>
						<tr>
							<th scope="row">조회수</th>
							<td><span><c:out value='${view.view_cnt }'/></span></td>
						</tr>
					</c:if>
						<tr>
							<th scope="row">기간</th>
							<td><span><c:out value='${view.start_dt }'/> ~ <c:out value='${view.end_dt }'/> </span>
						</tr>
						<tr>
							<th scope="row">제목</th>
							<td>
								<span>
									<c:out value='${view.title }'/>
								</span>
							</td>
						</tr>
						<tr>
						<th scope="row"> 내용</th> 
							<td >
							<span><c:out value="${view.contents}"  /></span>
							
							</td>
						</tr>
						</tr>
						<!-- tr>
							<th scope="row">썸네일</th>
							<td>
								<label>
									<input type="radio" name="u_type" value="S" ${view.u_type eq 'S' ? 'checked="checked"' : '' } /> 등록된썸네일(기본썸네일)사용
								</label> 
								<label>
									<input type="radio" name="u_type" value="D" ${view.u_type eq 'D' ? 'checked="checked"' : '' } /> 직접 등록
								</label> 
								<input type="hidden" name="file_name" value="${view.u_url_img}" /> 
								<span class="btn whiteS">
									<a href="#" class="upload_pop_btn">찾아보기</a>
								</span>
								<br/>
						 		<span class="upload_pop_img"> 
							    <c:if test="${not empty view.u_url_img && (view.u_type == 'S')}">
									<img src="${view.u_url_img}" width="480" height="360" alt="" />
								</c:if>
								<c:if test="${not empty view.u_url_img && (view.u_type == 'D')}">
									<img src="/upload/cultureVideo/${view.u_url_img}" width="480" height="360" alt="" />
								</c:if>
								</span>
								
								<input type="hidden" name="old_file_type" value="${view.u_type}" />
								<input type="hidden" name="old_file_name" value="${view.u_url_img}" />
							</td>
						</tr -->
					</tbody>
				</table>
			</div>
			<br />
			
			<!-- 승인여부 -->
			<div class="tableWrite">
				<table summary="문화/제안 등록 여부">
					<caption>승인여부</caption>
					<colgroup>
						<col style="width: 15%" />
						<col style="width: %" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">승인여부</th>
							<td><label><input type="radio" name="app_approval"
									value="W"
									${view.app_approval eq 'W' ? 'checked="checked"' : '' } /> 대기</label> <label><input
									type="radio" name="app_approval" value="Y"
									${view.app_approval eq 'Y' ? 'checked="checked"' : '' } /> 승인</label> <label><input
									type="radio" name="app_approval" value="N"
									${view.app_approval eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

		</form>
	</div>
	<div class="btnBox textRight">
	<c:if test='${not empty view}'>
		<span class="btn gray"><button id="register" type="button">수정</button></span>
	</c:if>
		<span class="btn gray"><button id="list" type="button">목록</button></span>
	</div>
</body>
</html>