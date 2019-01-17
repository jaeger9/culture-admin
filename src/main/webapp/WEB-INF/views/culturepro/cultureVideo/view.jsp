<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="/js/smartEdit/js/HuskyEZCreator.js"></script>
<script type="text/javascript" src="/js/culturepro/view/common.js"></script>
<script type="text/javascript">
var target = null;
var targetView = null;

var callback = {
	fileUpload : function (res) {
		target.val(res.file_path);
		targetView.html('<img src="/upload/cultureVideo/' + res.file_path + '" width="480" height="360" alt="" />');
	}
};

function setCoordinate(cul_gps_x , cul_gps_y, num){
	$("input[name='gps_x"+num+"']").val(cul_gps_x);
	$("input[name='gps_y"+num+"']").val(cul_gps_y);
}

$(function() {
	var frm = $('form[name=frm]');
	var title = frm.find('input[name=title]');
	var category = frm.find('select[name=category]');

	// 파일업로드
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
	
	// 상세 페이지
	if ('${view.outlink_kind}') {
		$('input:radio[name="outlink_kind"][value="${view.outlink_kind}"]').prop('checked', 'checked');
	}
	
	$('#u_url').on("blur",function(){
		
		var url = $("#u_url").val();
		var youtube_id = youtube_parser(url);
		if(youtube_id == false){
			alert("올바르지 않은 유튜브 URL입니다.");
			$("#u_url").val("");
			return false;
		}
		$('input:radio[name="u_type"][value="S"]').prop('checked', 'checked');
		var thumnail_url = "http://img.youtube.com/vi/"+youtube_id+"/hqdefault.jpg";
		$("input[name=file_name]").val(thumnail_url);
		$(".upload_pop_img").html('<img src="'+ thumnail_url + '" width="480" height="360" alt="" />');
	});
	
	function youtube_parser(url){
	    var regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/;
	    var match = url.match(regExp);
	    return (match&&match[7].length==11)? match[7] : false;
	}
	
	
	//위치 찾기
	$('.find_location').click(function(){
		var index = $('.find_location').index(this);
		Popup.findLocation(index+1);
	});
	

	//분류
	if('${view.category}')$("select[name=category]").val('${view.category}').attr("selected", "selected");
	
	
	// 승인 여부  radio check
	if ('${view.approval_yn}') {
		$('input:radio[name="approval_yn"][value="${view.approval_yn}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="approval_yn"][value="W"]').prop('checked', 'checked');
	}
	
	//썸네일 타입 선택 시 초기화 
	$('input:radio[name="u_type"]').change(function(){
		$("input[name=file_name]").val("");
		$(".upload_pop_img").html("");
		$("#u_url").val("");
	});
	
	
	frm.submit(function() {
		
		if (category.val() == '') {
			alert('분류를 선택해주세요.');
			source.focus();
			return false;
		}
		if (title.val() == '') {
			alert("제목 입력해 주세요");
			title.focus();
			return false;
		}
		
		if($('input:radio[name="u_type"]:checked').val() == "S"){
			if($("#u_url").val() == ''){
				alert("유튜브 URL을 입력해주세요.");
				return false;
			}
			
			if($("input[name=file_name]").val() == ""){
				alert("유튜브 썸네일이 올바르지 않습니다.");
				return false;
			}
		}else if($('input:radio[name="u_type"]:checked').val() == "D"){
			if($("input[name=file_name]").val() == ""){
				alert("파일을 첨부해주세요. ");
				return false;
			}
		}else{
			alert("썸네일 타입을 선택해주세요. ");
			return false;
		}
		oEditors.getById["contents"].exec("UPDATE_CONTENTS_FIELD", []);
		if ($('textarea[name=contents]').val() == '') {
			alert("내용을 입력해 주세요");
			$('textarea[name=contents]').focus();
			return false;
		}
		
		var location_chk = false;
		$( "input[name^='gps']" ).each(function(){
			if($(this).val()){
				location_chk = true;
		    }
		});
		
		
		/* 
		if(($("input[name='gps_x1']").val() != '' && $("input[name='gps_y1']").val() == '') ||
				($("input[name='gps_x1']").val() == '' && $("input[name='gps_y1']").val() != '')){
			alert("올바른 위치를 입력해주세요.");
			return false;
		}
		
		if(($("input[name='gps_x2']").val() != '' && $("input[name='gps_y2']").val() == '') ||
				($("input[name='gps_x2']").val() == '' && $("input[name='gps_y2']").val() != '')){
			alert("올바른 위치를 입력해주세요.");
			return false;
		}
		
		if(($("input[name='gps_x3']").val() != '' && $("input[name='gps_y3']").val() == '') ||
				($("input[name='gps_x3']").val() == '' && $("input[name='gps_y3']").val() != '')){
			alert("올바른 위치를 입력해주세요.");
			return false;
		} 
		
		if(!location_chk){
			alert("위치를 입력해주세요.");
			return false;
		}
		*/

		return true;
	});

	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
		$(this).click(function() {
			if ($(this).html() == '수정') {
				if (!confirm('수정하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/cultureVideo/update.do');
				frm.submit();
			} else if ($(this).html() == '삭제') {
				if (!confirm('삭제 하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/cultureVideo/delete.do');
				frm.submit();
			} else if ($(this).html() == '등록') {
				if (!confirm('등록하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/cultureVideo/insert.do');
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = '/culturepro/cultureVideo/list.do';
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
			</c:if>
			<div class="tableWrite">
				<table summary="관리자 문화영상관리 등록 페이지입니다.">
					<caption>관리자 문화영상관리 컨텐츠</caption>
					<tbody>
					 <c:if test='${not empty view}'>
						<tr>
							<th scope="row">등록일</th>
							<td><span><c:out value='${view.reg_date }'/></span></td>
						</tr>
						<tr>
							<th scope="row">조회수</th>
							<td><span><c:out value='${view.view_cnt }'/></span></td>
						</tr>
					</c:if>
						<tr>
							<th scope="row"><span style="color: red">*</span> 분류</th>
							<td>
								<select name="category" style="width: 100px;">
									<option value="">전체</option>
									<option value="culturetv">문화TV</option>
									<option value="cultureroad">길 위의 인문학</option>
									<option value="culture100">한국문화100</option>
									<option value="job30">문화직업30</option>
									<option value="cultureCast">문화예보</option>
									<option value="culturepd">문화PD</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row"><span style="color: red">*</span> 제목</th>
							<td><span><input type="text" id="title" name="title" value="<c:out value='${view.title }'/>"
									class="inputText width80" /></span></td>
						</tr>
						<tr>
							<th scope="row"> 상세페이지(url)</th>
							<td>
								<span>
									<label><input type="radio" name="outlink_kind" value="in"/> 내부링크</label>
									<label><input type="radio" name="outlink_kind" value="ex"/> 외부링크</label>
								</span>
								<input type="text" id="outlink" name="outlink" value="${view.outlink }" style="width:100%;" />
							</td>
						</tr>
						<tr>
							<th scope="row"><span style="color: red">*</span> 유튜브URL</th>
							<td><span><input type="text" id="u_url" name="u_url" value="<c:out value='${view.u_url }'/>"
									class="inputText width80" /></span></td>
						</tr>
							<tr>
							<th scope="row"><span style="color: red">*</span> 썸네일</th>
							<td>
								<table>
									<tr>
									<td>
										<label><input type="radio" name="u_type"
									value="S"
									${view.u_type eq 'S' ? 'checked="checked"' : '' } /> 유튜브 썸네일 사용</label> <label><input
									type="radio" name="u_type" value="D"
									${view.u_type eq 'D' ? 'checked="checked"' : '' } /> 직접 등록</label> 
									</td></tr>
									<tr>
										<td>
										<input type="hidden" name="file_name"
												value="${view.u_url_img}" /> <span
												class="btn whiteS"><a href="#" class="upload_pop_btn">찾아보기</a></span><br/>
										 <span class="upload_pop_img"> 
										   <c:if test="${not empty view.u_url_img && (view.u_type == 'S')}">
											<img src="${view.u_url_img}"
															width="480" height="360" alt="" />
											</c:if>
											<c:if test="${not empty view.u_url_img && (view.u_type == 'D')}">
												<img src="/upload/cultureVideo/${view.u_url_img}"
															width="480" height="360" alt="" />
											</c:if>
										</span>
										<!-- 이전 파일 삭제를 위한 정보 -->
										<input type="hidden" name="old_file_type"
												value="${view.u_type}" />
										<input type="hidden" name="old_file_name"
												value="${view.u_url_img}" />
									</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
<!-- 							<th scope="row"><span style="color: red">*</span> 내용</th> -->
							<td colspan="2">
<%-- 							<textarea id="contents" name="contents"style="width:100%;height:100px;" maxlength="2000"><c:out value="${view.contents}" escapeXml="true" /></textarea> --%>
							<textarea id="contents" name="contents"style="width:100%;height:100px;" maxlength="2000"><c:out value="${view.contents}" escapeXml="true" /></textarea>
							<!-- 스크립트 -->
							<script type="text/javascript">
								var oEditors = [];
								nhn.husky.EZCreator.createInIFrame({
									oAppRef: oEditors,
									elPlaceHolder: "contents",
									sSkinURI: "/js/smartEdit/SmartEditor2Skin.html",
									fCreator: "createSEditor2",
									htParams: {
										fOnBeforeUnload:function(){
											return;
										}
									}
								});
							</script>
							</td>
						</tr>
						<tr>
							<th scope="row">위치지정</th>
							<td>
								<table>
									<tr>
										<td>X <input type="text" name="gps_x1" value="${view.gps_x1 }"
											class="inputText" /> Y <input type="text" name="gps_y1"
											class="inputText" value="${view.gps_y1 }"/> <span class="btn white"><button
													name="find_loc" type="button" class="find_location">찾기</button></span></td>
									</tr>
									<tr>
										<td>X <input type="text" name="gps_x2" value="${view.gps_x2 }"
											class="inputText" /> Y <input type="text" name="gps_y2" value="${view.gps_y2}"
											class="inputText" /> <span class="btn white"><button
													name="find_loc" type="button" class="find_location">찾기</button></span></td>
									</tr>
									<tr>
										<td>X <input type="text" name="gps_x3" value="${view.gps_x3 }"
											class="inputText" /> Y <input type="text" name="gps_y3" value="${view.gps_y3 }"
											class="inputText" /> <span class="btn white"><button
													name="find_loc" type="button" class="find_location">찾기</button></span></td>
									</tr>
								</table>
							</td>
						</tr>
						</tr>
					</tbody>
				</table>
			</div>
			<br />
			
			<!-- 승인여부 -->
			<div class="tableWrite">
				<table summary="문화융성앱 컨텐츠 등록 승인 여부">
					<caption>승인여부</caption>
					<colgroup>
						<col style="width: 15%" />
						<col style="width: %" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">승인여부</th>
							<td><label><input type="radio" name="approval_yn"
									value="W"
									${view.approval_yn eq 'W' ? 'checked="checked"' : '' } /> 대기</label> <label><input
									type="radio" name="approval_yn" value="Y"
									${view.approval_yn eq 'Y' ? 'checked="checked"' : '' } /> 승인</label> <label><input
									type="radio" name="approval_yn" value="N"
									${view.approval_yn eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

		</form>
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