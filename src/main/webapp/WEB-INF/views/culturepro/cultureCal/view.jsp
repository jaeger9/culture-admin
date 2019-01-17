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
<script type="text/javascript" src="/js/smartEdit/js/HuskyEZCreator.js"></script>
<!-- <script type="text/javascript" src="/crosseditor/js/namo_scripteditor.js"></script> -->
<script type="text/javascript">

function setCoordinate(cul_gps_x , cul_gps_y, num){
	$("input[name='gps_x"+num+"']").val(cul_gps_x);
	$("input[name='gps_y"+num+"']").val(cul_gps_y);
}

$(function() {
	var frm = $('form[name=frm]');
	var title = frm.find('input[name=title]');
	var strt_dt = frm.find('input[name=strt_dt]');
	var end_dt = frm.find('input[name=end_dt]');
	
	new Datepicker(strt_dt, end_dt);
	
	// 승인 여부  radio check
	if ('${view.approval_yn}') {
		$('input:radio[name="approval_yn"][value="${view.approval_yn}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="approval_yn"][value="W"]').prop('checked', 'checked');
	}
	
	
	
	// 상세 페이지
	if ('${view.outlink_kind}') {
		$('input:radio[name="outlink_kind"][value="${view.outlink_kind}"]').prop('checked', 'checked');
	}
	
	
	
	//위치 찾기
	$('.find_location').click(function(){
		var index = $(this).index();
		Popup.findLocation(index+1);
	});
	
	frm.submit(function() {
		
		if (title.val() == '') {
			alert("제목 입력해 주세요");
			title.focus();
			return false;
		}
		oEditors.getById["contents"].exec("UPDATE_CONTENTS_FIELD", []);
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
				if($("#notice_yn").is(":checked")){
					$("#notice_yn").val("Y");
				}else{
					$("#notice_yn").val("N");
				}
				frm.attr('action', '/culturepro/cultureCal/update.do');
				frm.submit();
			}  else if ($(this).html() == '등록') {
				if (!confirm('등록하시겠습니까?')) {
					return false;
				}
				if($("#notice_yn").is(":checked")){
					$("#notice_yn").val("Y");
				}else{
					$("#notice_yn").val("N");
				}
				frm.attr('action', '/culturepro/cultureCal/insert.do');
				frm.submit();
			}  else if ($(this).html() == '삭제') {
				if (!confirm('등록하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/culturepro/cultureCal/delete.do');
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = '/culturepro/cultureCal/list.do';
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
				<table summary="관리자 팝업 등록 페이지입니다.">
					<caption>관리자 팝업 컨텐츠</caption>
					<colgroup>
						<col width="20%"/>
						<col width="*"/>
					</colgroup>
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
							<th scope="row">기간</th>
							<td>
								<input type="text" name="strt_dt" class="datepicker" value="${view.strt_dt }" />
								<span>~</span>
								<input type="text" name="end_dt" class="datepicker" value="${view.end_dt }" />
								
								<input type="checkbox" name="notice_yn" id="notice_yn" /> 공지성 (기간과 무관하게 목록 최상단에 노출)
							</td>
						</tr>
						<tr>
							<th scope="row">제목</th>
							<td>
								<span>
									<input type="text" id="title" name="title" value="<c:out value='${view.title }'/>" class="inputText width80" />
									<input type="hidden" id="contents_yn" name="contents_yn" value="Y" />
								</span>
							</td>
						</tr>
						<!-- <tr>
							<th scope="row">상세페이지 여부</th>
							<td>
								<span>
									<label><input type="radio" name="contents_yn" value="Y"/> 있음</label>
									<label><input type="radio" name="contents_yn" value="N"/> 없음</label>
								</span>
							</td>
						</tr> -->
						<tr>
							<th scope="row">상세페이지(url)
							</th>
							<td>
								<span>
									<label><input type="radio" name="outlink_kind" value="in"/> 내부링크</label>
									<label><input type="radio" name="outlink_kind" value="ex"/> 외부링크</label>
								</span>
								<input type="text" id="outlink" name="outlink" value="${view.outlink }" style="width:100%;" />
							</td>
						</tr>
						<tr>
<!-- 							<th scope="row">내용</th> -->
							<td colspan="2">
								<textarea id="contents" name="contents" style="width:100%;height:100px;" maxlength="2000"><c:out value="${view.contents}" escapeXml="true" /></textarea>
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
										<td>
											X <input type="text" name="gps_x01" class="inputText" /> 
											Y <input type="text" name="gps_y01" class="inputText" /> 
											<span class="btn white">
												<button name="find_loc" type="button" class="find_location">찾기</button>
											</span>
										</td>
									</tr>
									<tr>
										<td>
											X <input type="text" name="gps_x02" class="inputText" /> 
											Y <input type="text" name="gps_y02" class="inputText" /> 
											<span class="btn white">
												<button name="find_loc" type="button" class="find_location">찾기</button>
											</span>
										</td>
									</tr>
									<tr>
										<td>
											X <input type="text" name="gps_x03" class="inputText" /> 
											Y <input type="text" name="gps_y03" class="inputText" /> 
											<span class="btn white">
												<button name="find_loc" type="button" class="find_location">찾기</button>
											</span>
										</td>
									</tr>
								</table>
							</td>
						</tr>
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
		<span class="btn gray"><button id="register" type="button">삭제</button></span>
		<span class="btn gray"><button id="register" type="button">수정</button></span>
	</c:if>
	<c:if test='${empty view}'>
		<span class="btn gray"><button id="register" type="button">등록</button></span>
	</c:if>
		<span class="btn gray"><button id="list" type="button">목록</button></span>
	</div>
</body>
</html>