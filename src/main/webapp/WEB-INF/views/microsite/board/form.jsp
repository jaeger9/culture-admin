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

var callback = {
	fileUpload : function (res) {
		// res.full_file_path
		// res.file_path
		$('input[name=thumbnail]').val(res.full_file_path);
		$('.upload_pop_img').html('<img src="' + res.full_file_path + '" width="174" height="114" alt="" />');
	}
};

$(function () {

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
//	nhn.husky.EZCreator.createInIFrame( oEditorsOption );

	var frm				=	$('form[name=frm]')
	var seq				=	frm.find('input[name=seq]');
	var site_id			=	frm.find('select[name=site_id]');
	var menu_id			=	frm.find('select[name=menu_id]');
	var title			=	frm.find('input[name=title]');
	var thumbnail		=	frm.find('input[name=thumbnail]');
	var contents		=	frm.find('textarea[name=contents]');
	var approval		=	frm.find('input[name=approval]');
	var notice			=	frm.find('input[name=notice]');
	var spare1			=	frm.find('input[name=spare1]');
	var spare2			=	frm.find('input[name=spare2]');
	var spare3			=	frm.find('input[name=spare3]');
	var spare4			=	frm.find('input[name=spare4]');
	var spare5			=	frm.find('input[name=spare5]');
	
	frm.submit(function () {
		// frm.serialize()
//		oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
       	document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");

		if (seq.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		if (site_id.val() == '') {
			site_id.focus();
			alert('사이트 아이디를 선택해 주세요.');
			return false;
		}
		if (menu_id.val() == '') {
			menu_id.focus();
			alert('메뉴 아이디를 선택해 주세요.');
			return false;
		}
		if (title.val() == '') {
			title.focus();
			alert('제목을 입력해 주세요.');
			return false;
		}
		// thumbnail
		if (contents.val() == '' || contents.val().toLowerCase() == '<br>') {
			alert('내용을 입력해 주세요.');
			return false;
		}
		if (approval.filter(':checked').size() == 0) {
			approval.eq(0).focus();
			alert('승인 여부를 선택해 주세요.');
			return false;
		}
		return true;
	});

	// 파일업로드
	$('.upload_pop_btn').click(function () {
		Popup.fileUpload('microsite_board');
		return false;
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
				url			:	'/microsite/board/delete.do'
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

	site_id.change(function () {
		var _this = this;
		menu_id.html('<option value="">사이트 아이디를 선택해 주세요.</option>');
		
		if ($(this).val() != '') {
			$.get('/microsite/menu/menuidjson.do', {site_id : $(this).val()}, function (data) {
				var list = data.menuList;
				var mid = menu_id.data().menuId;
				menu_id.data({menuId : ''});

				if (list != null && list.length > 0) {
					menu_id.empty();
					
					for (var i in list) {
						menu_id.append('<option value="' + list[i].menu_id + '"' + (list[i].menu_id == mid ? ' selected="selected"' : '') + '  >  ' + list[i].menu_names + '</option>');
					}
				} else {
					menu_id.html('<option value="">등록된 메뉴가 없습니다.</option>');
				}
			});
		}
	}).change();
	
});
</script>
</head>
<body>

<form name="frm" method="POST" action="/microsite/board/form.do" enctype="multipart/form-data">
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
					<td>
						${view.seq }
					</td>
					<th scope="row">조회수</th>
					<td>
						<fmt:formatNumber value="${view.view }" pattern="###,###"/>
						${empty view.view ? '0' : '' }
					</td>
				</tr>
				<tr>
					<th scope="row">등록자</th>
					<td>
						<c:out value="${view.writer }" default="-" />
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
						<select name="site_id">
							<c:forEach items="${siteList }" var="item">
								<option value="${item.site_id }" ${item.site_id eq view.site_id ? ' selected="selected" ' : '' } >${item.site_name }</option>
							</c:forEach>
						</select>
						<select name="menu_id" data-menu-id="${view.menu_id }">
							<option value="">사이트 아이디를 선택해 주세요.</option>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">제목</th>
					<td colspan="3">
						<input type="text" name="title" value="${view.title }" style="width:580px" />
						<label><input type="checkbox" name="notice" value="Y" ${view.notice eq 'Y' ? 'checked="checked"' : '' } /> 상단노출</label>
					</td>
				</tr>
				<tr>
					<th scope="row">썸네일 이미지</th>
					<td colspan="3">
						<input type="text" name="thumbnail" value="${view.thumbnail }" style="width:580px" />
						<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
						<div class="upload_pop_msg">(외부 이미지 URL 또는 174px * 114px 크기의 이미지를 선택해 주세요.)</div>
						<div class="upload_pop_img">
							<c:if test="${not empty view.thumbnail }">
								<img src="${view.thumbnail }" width="174" height="114" alt="" />
							</c:if>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">내용</th>
					<td colspan="3">
	        			<!-- 20151006 : 이용환 : 에디터 변경을 위해 수정 
						<textarea id="contents" name="contents" style="width:100%;height:400px;"><c:out value="${view.contents }" escapeXml="true" /></textarea>
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
						<textarea id="contents" name="contents" style="width:100%;height:400px;display:none;"><c:out value="${view.contents }" escapeXml="true" /></textarea>
							
					</td>
				</tr>
				<tr>
					<th scope="row">여분1</th>
					<td colspan="3">
						<input type="text" name="spare1" value="${view.spare1 }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">여분2</th>
					<td colspan="3">
						<input type="text" name="spare2" value="${view.spare2 }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">여분3</th>
					<td colspan="3">
						<input type="text" name="spare3" value="${view.spare3 }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">여분4</th>
					<td colspan="3">
						<input type="text" name="spare4" value="${view.spare4 }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">여분5</th>
					<td colspan="3">
						<input type="text" name="spare5" value="${view.spare5 }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td colspan="3">
						<label><input type="radio" name="approval" value="Y" ${view.approval eq 'Y' or empty view.approval ? 'checked="checked"' : '' } /> 승인</label>
						<label><input type="radio" name="approval" value="N" ${view.approval eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
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

		<span class="btn gray"><a href="/microsite/board/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>