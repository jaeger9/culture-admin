<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- 
	20151006 : 이용환 : 에디터 변경을 위해 수정 
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
 -->
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="/crosseditor/js/namo_scripteditor.js"></script>

<script type="text/javascript">

$(function () {

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
//	nhn.husky.EZCreator.createInIFrame( oEditorsOption );

	var frm			=	$('form[name=frm]');
	var seq			=	frm.find('input[name=seq]');
	var reply		=	frm.find('textarea[name=reply]');
	var status		=	frm.find('input[name=status]');

	frm.submit(function () {
		// frm.serialize()
//		oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
		document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");

		if (seq.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		if (status.filter(':checked').size() == 0) {
			status.eq(0).focus();
			alert('승인여부를 선택해 주세요.');
			return false;
		}
		return true;
	});

	// 등록/수정
	$('.insert_btn').click(function () {
		frm.submit();
		return false;
	});
	
	// 삭제
	if ($('.delete_btn').size() > 0) {
		$('.delete_btn').click(function () {
			// 삭제
			if (!confirm('삭제하시겠습니까?')) {
				return false;
			}
			if (seq.val() == '') {
				alert('seq가 존재하지 않습니다.');
				return false;
			}

			var param = {
				seqs : [ seq.val() ]
			};

			$.ajax({
				url			:	'/customer/mou/delete.do'
				,type		:	'post'
				,data		:	$.param(param, true)
				,dataType	:	'json'
				,success	:	function (res) {
					if (res.success) {
						alert("삭제가 완료 되었습니다.");
						location.href = $('.list_btn').attr('href');

					} else {
						alert("삭제 실패 되었습니다.");
					}
				}
				,error : function(data, status, err) {
					alert("삭제 실패 되었습니다.");
				}
			});

			return false;
		});		
	}

});
</script>
</head>
<body>

<form name="frm" method="POST" action="/customer/mou/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="seq" value="${view.seq }" />

	<div class="tableWrite">
		<table summary="게시판 글 등록">
			<caption>게시판 글 등록</caption>
			<colgroup>
				<col style="width:15%" />
				<col style="width:35%" />
				<col style="width:15%" />
				<col style="width:35%" />
			</colgroup>
			<tbody>
<c:if test="${not empty view.seq }">
				<tr>
					<th scope="row">고유번호</th>
					<td colspan="3">
						${view.seq }
					</td>
				</tr>
				<tr>
					<th scope="row">등록자</th>
					<td>
						<c:out value="${view.user_id }" default="-" />
					</td>
					<th scope="row">등록일</th>
					<td>
						<c:out value="${view.reg_date }" default="-" />
					</td>
				</tr>
</c:if>
				<tr>
					<th scope="row">구분</th>
					<td colspan="3">
						<c:if test="${view.category eq '0'}">소식</c:if>
						<c:if test="${view.category eq '1'}">행사/교육</c:if>
						<c:if test="${view.category eq '2'}">공연/전시</c:if>
						<c:if test="${view.category eq '3'}">문화동영상</c:if>
						<c:if test="${view.category eq '4'}">문화추천</c:if>
						<c:if test="${view.category eq '5'}">전통디자인</c:if>
						<c:if test="${view.category eq '6'}">이벤트</c:if>
						<c:if test="${view.category eq '7'}">오픈 API</c:if>
						<c:if test="${view.category eq '8'}">기타</c:if>
					</td>
				</tr>
				<tr>
					<th scope="row">제목</th>
					<td colspan="3">
						${view.title }
					</td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td colspan="3">
						${view.email }
					</td>
				</tr>
				<tr>
					<th scope="row">연락처</th>
					<td colspan="3">
						${view.phone }
					</td>
				</tr>
				<tr>
					<th scope="row">소속</th>
					<td colspan="3">
						${view.company }
					</td>
				</tr>
				<tr>
					<th scope="row">홈페이지</th>
					<td colspan="3">
						${view.homepage }
					</td>
				</tr>
				<tr>
					<th scope="row">내용</th>
					<td colspan="3">
						<c:out value="${view.content }" escapeXml="false" />
					</td>
				</tr>
				<tr>
					<th scope="row">답변</th>
					<td colspan="3">
	        			<!-- 20151006 : 이용환 : 에디터 변경을 위해 수정 
						<textarea id="contents" name="reply" style="width:100%;height:400px;"><c:out value="${view.reply }" escapeXml="true" /></textarea>
						-->
						<script type="text/javascript" language="javascript">
							var CrossEditor = new NamoSE('contents');
							CrossEditor.params.Width = "100%";
							CrossEditor.params.Height = "400px";
							CrossEditor.params.UserLang = "auto";
							CrossEditor.params.UploadFileSizeLimit = "image:10485760";
							CrossEditor.params.Font = {"NanumGothic":"나눔고딕","Dotum":"돋움", "Gulim":"굴림", "Batang":"바탕", "Gungsuh":"궁서", "맑은 고딕":"맑은 고딕"  ,"David":"David", "MS Pgothic":"MS Pgothic","Simplified Arabic":"Simplified Arabic","SimSun":"SimSun","Arial":"Arial","Courier New":"Courier New", "Tahoma":"Tahoma", "Times New Roman":"Times New Roman", "verdana":"Verdana"};
							CrossEditor.EditorStart();
							function OnInitCompleted(e){
								e.editorTarget.SetBodyValue(document.getElementById("contents").value);
							}
						</script>
						<textarea id="contents" name="reply" style="width:100%;height:400px;display:none;"><c:out value="${view.reply }" escapeXml="true" /></textarea>
					
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td colspan="3">
						<label><input type="radio" name="status" value="W" ${view.status eq 'W' or empty view.status ? 'checked="checked"' : '' } /> 대기</label>
						<label><input type="radio" name="status" value="Y" ${view.status eq 'Y' ? 'checked="checked"' : '' } /> 승인</label>
						<label><input type="radio" name="status" value="N" ${view.status eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.seq ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view.seq }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/customer/mou/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>