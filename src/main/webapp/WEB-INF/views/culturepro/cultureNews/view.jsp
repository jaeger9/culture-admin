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
		targetView.html('<img src="/upload/cardnews/' + res.file_path + '" width="150" height="150" alt="" />');
	}
};
function setCoordinate(cul_gps_x , cul_gps_y, num){
	$("input[name='gps_x"+num+"']").val(cul_gps_x);
	$("input[name='gps_y"+num+"']").val(cul_gps_y);
}

$(function() {
	var frm = $('form[name=frm]');
	var source = frm.find('input[name=source]');
	var title = frm.find('input[name=title]');
	//var months = frm.find('select[name=month]');
	
	//년도 지정
	var date = new Date();
	var year = date.getFullYear();
	
	//월 options 박스 생성
	/**
	for(var i = 1 ; i < 13 ; i++){
		$('#group_month').append($('<option>',{
			value : year+'-'+i+'',
			text :  year+'년 '+i+' 월',
		}));
		
		if ('${view.approval_yn}' == i){
			$('#group_month').val(year+'년 '+i+' 월').attr("selected", "selected");
		}
	}
	*/
	// 파일업로드
	$('.upload_pop_btn').click(function () {
		var p		=	$(this).parents('tr:eq(0)');
		target		=	p.find("input[name='file_name']");
		targetView	=	p.find('.upload_pop_img');

		Popup.fileUpload('cardnews');
		return false;
	});
	
	//위치 찾기
	$('.find_location').click(function(){
		var index = $('.find_location').index(this);
		console.log(index);
		Popup.findLocation(index+1);
	});
	
	

	// 승인 여부  radio check
	if ('${view.approval_yn}') {
		$('input:radio[name="approval_yn"][value="${view.approval_yn}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="approval_yn"][value="W"]').prop('checked', 'checked');
	}
	
	// 앱 게시 여부 radio check
	if ('${view.app_approval_yn}') {
		$('input:radio[name="app_approval_yn"][value="${view.app_approval_yn}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="app_approval_yn"][value="W"]').prop('checked', 'checked');
	}
	
	$("input:checkbox[name='file_delete']").change(function() {
		var file_name = $(this).parent().parent().parent().find('input[name=file_name]');
		if($(this).is(":checked")) {
			if(file_name.val() == $(this).val()){
				file_name.val("");	
			}
		}else{
			file_name.val($(this).val());
		}
	});
	
	frm.submit(function() {
		
//		if(months.val() == ''){
//			alert("월을 선택해주세요.");
//			months.focus();
//			return false;
//		}
		
		if (source.val() == '') {
			alert('출처를 입력해 주세요');
			source.focus();
			return false;
		}
		if (title.val() == '') {
			alert("제목 입력해 주세요");
			title.focus();
			return false;
		}
// 		if ($('textarea[name=contents]').val() == '') {
// 			alert("내용을 입력해 주세요");
// 			$('textarea[name=contents]').focus();
// 			return false;
// 		}
		oEditors.getById["contents"].exec("UPDATE_CONTENTS_FIELD", []);
		
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
		
		var file_chk = false;
		$("input[name='file_name']").each(function(){
		    if($(this).val()){
		    	file_chk = true;
		    }
		});
		if(!file_chk){
			alert("이미지를 선택해 주세요");
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
				frm.attr('action', '/culturepro/cultureNews/update.do');
				frm.submit();
			} else if ($(this).html() == '삭제') {
				if (!confirm('삭제 하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/cultureNews/delete.do');
				frm.submit();
			} else if ($(this).html() == '등록') {
				if (!confirm('등록하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/cultureNews/insert.do');
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = '/culturepro/cultureNews/list.do';
			}
		});
	});
});
</script>
</head>
<body>

	<div class="tableWrite">
		<form name="frm" method="post" 
			enctype="multipart/form-data">
			<c:if test='${not empty view}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<div class="tableWrite">
				<table summary="관리자 문화소식관리 등록 페이지입니다.">
					<caption>관리자 문화소식관리 컨텐츠</caption>
					<tbody>
					 <c:if test='${not empty view}'>
						<tr>
							<th scope="row">앱 게시일</th>
							<td><span><c:out value='${view.app_release_date }'/></span></td>
						</tr>
						<tr>
							<th scope="row">앱 조회수</th>
							<td><span><c:out value='${view.app_view_cnt }'/></span></td>
						</tr>
					</c:if>
						<!-- tr>
							<th scope="row"><span style="color: red">*</span> 월 선택</th>
							<td><select id="group_month" name="group_month">
							</select></td>
						</tr -->
						<tr>
							<th scope="row"><span style="color: red">*</span> 출처</th>
							<td><span><input type="text" id="source" name="source" value="<c:out value='${view.source }'/>"
									class="inputText width80" /></span></td>
						</tr>
						<tr>
							<th scope="row"><span style="color: red">*</span> 제목</th>
							<td><span><input type="text" id="title" name="title" value="<c:out value='${view.title }'/>"
									class="inputText width80" /></span></td>
						</tr>
						<tr>
<!-- 							<th scope="row"><span style="color: red">*</span> 내용</th> -->
							<td colspan="2">
							<textarea id="contents" name="contents"style="width:100%;height:100px;" maxlength="2000"><c:out value="${view.contents}" escapeXml="true" /></textarea>
							
							</td>
						</tr>
						<tr>
							<th scope="row">위치지정</th>
							<td>
								<table>
									<tr>
										<td>
											X <input type="text" name="gps_x1" class="inputText" value="${view.gps_x1 }"/> 
											Y <input type="text" name="gps_y1" class="inputText" value="${view.gps_y1 }"/> 
											<span class="btn white">
												<button name="find_loc" type="button" class="find_location">찾기</button>
											</span>
										</td>
									</tr>
									<tr>
										<td>
											X <input type="text" name="gps_x2" class="inputText" value="${view.gps_x2 }"/> 
											Y <input type="text" name="gps_y2" class="inputText" value="${view.gps_y2 }"/> 
											<span class="btn white">
												<button name="find_loc" type="button" class="find_location">찾기</button>
											</span>
										</td>
									</tr>
									<tr>
										<td>
											X <input type="text" name="gps_x3" class="inputText" value="${view.gps_x3 }"/> 
											Y <input type="text" name="gps_y3" class="inputText" value="${view.gps_y3 }"/>
											<span class="btn white">
												<button name="find_loc" type="button" class="find_location">찾기</button>
											</span>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						</tr>
					</tbody>
				</table>
			</div>
			<br />
			<div class="tableWrite">
				<table summary="카드 뉴스 컨텐츠 작성">
					<caption>카드 뉴스 컨텐츠 글쓰기</caption>
					<colgroup>
						<col style="width: 7%" />
						<col style="width: 50%" />
						<col style="width: %" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">순번</th>
							<th scope="row"><span style="color: red">*</span> 이미지<br />
								<span style="color: rgba(126, 137, 155, 1);">540 * 540
									px에 맞추어 등록해주시기 바랍니다.</span></th>
							<th scope="row">이미지 설명<br /> <span
								style="color: rgba(126, 137, 155, 1);">※ 웹 접근성 준수사항으로 반드시
									작성해야 합니다.<br /> (작성 방법: 이미지에 있는 텍스트 동일하게 기입. / 한 줄로 작성. / 내용은
									‘| ‘로 구분 )
							</span>
							</th>
						</tr>
						<c:forEach var="i" begin="1" end="30">
							<tr>
								<td>${i}</td>
								<td>
									<table>
										<tr>
											<td><span class="upload_pop_img"> <c:if
														test="${not empty listFile[i-1].file_name }">
														<img src="/upload/cardnews/${listFile[i-1].file_name }"
															width="150" height="150" alt="" />
													</c:if>
											</span></td>
											<td><input type="hidden" name="file_name"
												value="${listFile[i-1].file_name }" /> <span
												class="btn whiteS"><a href="#" class="upload_pop_btn">찾아보기</a></span>
												<c:if test="${not empty listFile[i-1].file_name }">
													<span class="inputBox"> <label><input
															type="checkbox" name="file_delete"
															value="${listFile[i-1].file_name }" /> <strong>삭제</strong>
															${listFile[i-1].file_name }</label>
													</span>
												</c:if></td>
										</tr>
									</table>
								</td>
								<td><textarea name="description"
										style="width: 100%; height: 150px;" maxlength="2000"><c:out
											value="${listFile[i-1].description }" escapeXml="true" /></textarea></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<br />
			<!-- 승인여부 -->
			<!-- div class="tableWrite">
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
			</div  -->

			<!-- 앱게시 여부 -->
			<div class="tableWrite">
				<table summary="문화융성앱 컨텐츠 등록 앱 게시여부">
					<caption>앱 게시</caption>
					<colgroup>
						<col style="width: 15%" />
						<col style="width: %" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">앱 게시</th>
							<td><label><input type="radio" name="app_approval_yn"
									value="W" ${view.app_approval_yn eq 'W' ? 'checked="checked"' : '' } />
									대기</label> <label><input type="radio" name="app_approval_yn"
									value="Y" ${view.app_approval_yn eq 'Y' ? 'checked="checked"' : '' } />
									게시</label> <label><input type="radio" name="app_approval_yn"
									value="N" ${view.app_approval_yn eq 'N' ? 'checked="checked"' : '' } />
									미게시</label></td>
						</tr>
					</tbody>
				</table>
			</div>
		</form>
	</div>
	<div class="btnBox textRight">
	<c:if test='${not empty view}'>
		<span class="btn white"><button type="button">수정</button></span>
		<span class="btn white"><button type="button">삭제</button></span>
	</c:if>
	<c:if test='${empty view}'>
		<span class="btn white"><button id="register" type="button">등록</button></span>
	</c:if>
		<span class="btn gray"><button id="list" type="button">목록</button></span>
	</div>
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
</body>
</html>