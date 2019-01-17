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

$(function() {
	var frm = $('form[name=frm]');
	var event_seq = frm.find('select[name=event_seq]');
	var title = frm.find('input[name=title]');

	// radio check
	if ('${view.category}') {
		$('input:radio[name="category"][value="${view.category}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="category"][value="1"]').prop('checked', 'checked');
	}
	
	if ('${view.approval}') {
		$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="approval"][value="W"]').prop('checked', 'checked');
	}

	// select
	if('${view.event_seq}')$("select[name=event_seq]").val('${view.event_seq}').attr("selected", "selected");
	
//	nhn.husky.EZCreator.createInIFrame(oEditorsOption);

	frm.submit(function() {
		if (event_seq.val() == '') {
			alert('구분을 선택해 주세요');
			event_seq.focus();
			return false;
		}
		if (title.val() == '') {
			alert("제목을 입력해 주세요");
			title.focus();
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
				frm.attr('action', '/campaign/news/update.do');
				//oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
				document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
				frm.submit();
			} else if ($(this).html() == '삭제') {
				if (!confirm('삭제 하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/campaign/news/delete.do');
				frm.submit();
			} else if ($(this).html() == '등록') {
				if (!confirm('등록하시겠습니까?')) {
					return false;
				}
				frm.attr('action', '/campaign/news/insert.do');
				//oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
				document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = '/campaign/news/list.do';
			}
		});
	});

});

</script>
</head>
<body>
<!-- 검색 필드 -->
<div class="tableWrite">
	<form name="frm" method="post" action="/campaign/news/insert.do">
		<c:if test='${not empty view.seq}'>
			<input type="hidden" name="seq" value="${view.seq}"/>
		</c:if>
		<div class="sTitBar">
			<h4>캠페인 소식 컨텐츠</h4>
		</div>
		<div class="tableWrite">	
			<table summary="캠페인 소식 컨텐츠 작성">
				<caption>캠페인 소식 컨텐츠 글쓰기</caption>
				<colgroup>
					<col style="width:15%" />
					<col style="width:35%" />
					<col style="width:15%" />
					<col style="width:35%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">구분</th>
						<td colspan="3">
							<select title="구분 선택" name="event_seq">
								<option value="">선택</option>
								<c:forEach var="item" items="${eventList }">
									<option value="${item.seq }">${item.title }</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">분류</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="category" value="1" checked="checked"/> 일반공지</label>
								<label><input type="radio" name="category" value="2"/> 캠페인소식</label>
								<label><input type="radio" name="category" value="3"/> 당첨자발표</label>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval" value="W" checked="checked"/> 대기</label>
								<label><input type="radio" name="approval" value="Y"/> 승인</label>
								<label><input type="radio" name="approval" value="N"/> 미승인</label>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">제목</th>
						<td colspan="3">
							<input type="text" name="title" style="width:500px" value="<c:out value='${view.title }'/>"/>
						</td>
					</tr>
					<tr>
						<th scope="row">URL</th>
						<td colspan="3">
							<input type="text" name="url" style="width:500px" value="<c:out value='${view.url }'/>"/>
						</td>	
					</tr>
					<c:if test='${not empty view.seq}'>
						<tr>
							<th>등록일</th>
							<td>${view.reg_date } (${view.reg_id })</td>
							<th>수정일</th>
							<td>
								<c:if test="${not empty view.upd_id }">
									${view.upd_date } (${view.upd_id })
								</c:if>
							</td>
						</tr>					
					</c:if>
				</tbody>
			</table>
		</div>		
		<div class="sTitBar">
			<h4>
				<label>내용</label>
			</h4>
		</div>		
		<div class="tableWrite">	
			<table summary="캠페인 소식 컨텐츠 작성">
			<caption>캠페인 소식 컨텐츠 글쓰기</caption>
			<colgroup>
				<col />
			</colgroup>
			<tbody>
				<tr>
					<td style="padding-left:40px;">
	        			<!-- 20151006 : 이용환 : 에디터 변경을 위해 수정 
						<textarea id="contents" name="contents" style="width:725px;height:650px;"><c:out value="${view.contents }" escapeXml="true" /></textarea>
						-->
						<script type="text/javascript" language="javascript">
							var CrossEditor = new NamoSE('contents');
							CrossEditor.params.Width = "725px";
							CrossEditor.params.Height = "650px";
							CrossEditor.params.UserLang = "auto";
							CrossEditor.params.UploadFileSizeLimit = "image:10485760";
							CrossEditor.params.Font = {"NanumGothic":"나눔고딕","Dotum":"돋움", "Gulim":"굴림", "Batang":"바탕", "Gungsuh":"궁서", "맑은 고딕":"맑은 고딕"  ,"David":"David", "MS Pgothic":"MS Pgothic","Simplified Arabic":"Simplified Arabic","SimSun":"SimSun","Arial":"Arial","Courier New":"Courier New", "Tahoma":"Tahoma", "Times New Roman":"Times New Roman", "verdana":"Verdana"};
							CrossEditor.EditorStart();
							function OnInitCompleted(e){
								e.editorTarget.SetBodyValue(document.getElementById("contents").value);
							}
						</script>
						<textarea id="contents" name="contents" style="width:725px;height:650px;display:none;"><c:out value="${view.contents }" escapeXml="true" /></textarea>
					</td>	
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
	<c:if test='${empty view }'>
		<span class="btn white"><button type="button">등록</button></span>
	</c:if>
	<span class="btn gray"><button type="button">목록</button></span>
</div>
</body>
</html>