<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<style type="text/css">
	.views {margin-top:30px;}
	.views .sub_title {padding:0 0 5px; font-size:1.2em; font-weight:bold;}
	.views td.subject {padding-left:10px;}
</style>
<script type="text/javascript">

var target1 = null;
var target2 = null;

var callback = {
	fileUpload : function (res) {
		// res.full_file_path
		// res.file_path
		target1.val(res.file_path);
		target2.html('<a href="/upload/arc_tmp/' + res.file_path + '" target="_blank">' + res.file_path + '</a>');
	}
};

var getCodeList = function () {
	var arc_thm_id		=	$('select[name=arc_thm_id]');
	var arc_period_type	=	'${view.arc_period_type }';
	var arc_zone_type	=	'${view.arc_zone_type }';
	var arc_event_type	=	'${view.arc_event_type }';

	$.get('/addservice/archive/categoryListinc.do', {
		arc_thm_id			:	arc_thm_id.val()
		,arc_period_type	:	arc_period_type
		,arc_zone_type		:	arc_zone_type
		,arc_event_type		:	arc_event_type
	}, function (data) {

		var item = null;
		var html = '';

		html += '<select name="arc_period_type">';
		html += '<option value="">1차분류</option>';
		
		for (var i in data.list1) {
			item = data.list1[i];
			html += '<option value="' + item.dtl_code + '"' + (item.dtl_code == arc_period_type ? ' selected="selected"' : '') + '>';
			html += item.dtl_cde_title;
			html += '</option>';
		}

		html += '</select>';

		
		html += ' <select name="arc_zone_type">';
		html += '<option value="">2차분류</option>';
		
		for (var i in data.list2) {
			item = data.list2[i];
			html += '<option value="' + item.dtl_code + '"' + (item.dtl_code == arc_zone_type ? ' selected="selected"' : '') + '>';
			html += item.dtl_cde_title;
			html += '</option>';
		}

		html += '</select>';
		
		
		html += ' <select name="arc_event_type">';
		html += '<option value="">3차분류</option>';
		
		for (var i in data.list2) {
			item = data.list2[i];
			html += '<option value="' + item.dtl_code + '"' + (item.dtl_code == arc_event_type ? ' selected="selected"' : '') + '>';
			html += item.dtl_cde_title;
			html += '</option>';
		}

		html += '</select>';

		$('#category').html(html);
		
	}, 'json').fail(function() {
		alert('카테고리 조회에 실패했습니다.');
	});
};

$(function () {
	var frm					=	$('form[name=frm]');
	var acm_cls_cd			=	frm.find('input[name=acm_cls_cd]');
	var arc_thm_id			=	frm.find('select[name=arc_thm_id]');
	var arc_title			=	frm.find('input[name=arc_title]');
	var arc_group_title		=	frm.find('input[name=arc_group_title]');
	var arc_staff			=	frm.find('input[name=arc_staff]');
	var arc_source_desc		=	frm.find('input[name=arc_source_desc]');
	var arc_data_form		=	frm.find('input[name=arc_data_form]');
	var arc_url				=	frm.find('input[name=arc_url]');
	var arc_email			=	frm.find('input[name=arc_email]');
	var arc_copyright_flag	=	frm.find('input[name=arc_copyright_flag]');
	var arc_make_date		=	frm.find('input[name=arc_make_date]');
	var arc_kwd				=	frm.find('input[name=arc_kwd]');
	var arc_file_name		=	frm.find('input[name=arc_file_name]');
	var arc_file_sub_name	=	frm.find('input[name=arc_file_sub_name]');
	var arc_status			=	frm.find('input[name=arc_status]');

	// hidden
	var arc_source_type		=	frm.find('input[name=arc_source_type]');
	var arc_ply_cde			=	frm.find('input[name=arc_ply_cde]');
	var arc_dis_cde			=	frm.find('input[name=arc_dis_cde]');
	var arc_seq				=	frm.find('input[name=arc_seq]');
	
	// var arc_file			=	frm.find('input[name=arc_file]');
	// var arc_file_sub		=	frm.find('input[name=arc_file_sub]');
	// var view_cnt			=	frm.find('input[name=view_cnt]');
	// var arc_create_date	=	frm.find('input[name=arc_create_date]');
	// var arc_update_date	=	frm.find('input[name=arc_update_date]');
	// var arc_create_by	=	frm.find('input[name=arc_create_by]');
	// var arc_update_by	=	frm.find('input[name=arc_update_by]');
	
	// select box
	arc_thm_id.change(function () {
		getCodeList();
	});
	getCodeList();
	
	frm.submit(function () {
		if (acm_cls_cd.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}

		var arc_period_type		=	frm.find('select[name=arc_period_type]');
		var arc_zone_type		=	frm.find('select[name=arc_zone_type]');
		var arc_event_type		=	frm.find('select[name=arc_event_type]');

		if (acm_cls_cd.val() == '') {
			acm_cls_cd.focus();
			alert('고유번호를 입력해 주세요.');
			return false;
		}
		if (arc_thm_id.val() == '') {
			arc_thm_id.focus();
			alert('테마를 선택해 주세요.');
			return false;
		}
		if (arc_period_type.val() == '') {
			arc_period_type.focus();
			alert('1차 분류를 선택해 주세요.');
			return false;
		}
		if (arc_zone_type.val() == '') {
			arc_zone_type.focus();
			alert('2차 분류를 선택해 주세요.');
			return false;
		}
		if (arc_event_type.val() == '') {
			arc_event_type.focus();
			alert('3차 분류를 선택해 주세요.');
			return false;
		}
		if (arc_title.val() == '') {
			arc_title.focus();
			alert('자료명을 입력해 주세요.');
			return false;
		}
		return true;
	});

	// 파일업로드
	$('.upload_pop_btn').click(function () {
		var p = $(this).parents('tr:eq(0)');

		target1 = p.find('input:eq(0)');
		target2 = p.find('.upload_pop_img');;

		Popup.fileUpload('addservice_archive');
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
			if (!confirm('삭제하시겠습니까?')) {
				return false;
			}
			if (acm_cls_cd.val() == '') {
				alert('acm_cls_cd가 존재하지 않습니다.');
				return false;
			}

			var param = {
				acm_cls_cds : [ acm_cls_cd.val() ]
			};

			$.ajax({
				url			:	'/addservice/archive/delete.do'
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
	
	var isAddInfo = true;
	
	if ($('.delete_btn').size() > 0) {
		isAddInfo = false;
	}
	
	
	// 내용
	var content_idsAll		=	$('input[name=content_idsAll]');
	var content_ids			=	$('input[name=content_ids]');
	var content_delete_btn	=	$('.content_delete_btn');
	var content_insert		=	$('.content_insert');
	new Checkbox('input[name=content_idsAll]', 'input[name=content_ids]');

	content_delete_btn.click(function () {
		if (isAddInfo) {
			alert('게시글을 등록하신 후 삭제하실 수 있습니다.');
			return false;
		}
		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		var ids = content_ids.filter(':checked');
		if (ids.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}
		var param = {ids : []};
		ids.each(function () {
			param.ids.push( $(this).val() );
		});
		$.post('./contentDelete.do', $.param(param, true), function (res) {
			if (res.success) {
				alert("삭제가 완료 되었습니다.");
				location.reload();
			} else {
				alert("삭제 실패 되었습니다.");
			}
		}).fail(function () {
			alert("삭제 실패 되었습니다.");
		});
		return false;
	});
	content_insert.click(function () {
		if (isAddInfo) {
			alert('게시글을 등록하신 후 등록하실 수 있습니다.');
			return false;
		}
		Popup.archiveContent(acm_cls_cd.val());
	});
	

	// 파일
	var file_idsAll			=	$('input[name=file_idsAll]');
	var file_ids			=	$('input[name=file_ids]');
	var file_delete_btn		=	$('.file_delete_btn');
	var file_insert			=	$('.file_insert');
	new Checkbox('input[name=file_idsAll]', 'input[name=file_ids]');

	file_delete_btn.click(function () {
		if (isAddInfo) {
			alert('게시글을 등록하신 후 삭제하실 수 있습니다.');
			return false;
		}
		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		var ids = file_ids.filter(':checked');
		if (ids.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}
		var param = {ids : []};
		ids.each(function () {
			param.ids.push( $(this).val() );
		});
		$.post('./fileDelete.do', $.param(param, true), function (res) {
			if (res.success) {
				alert("삭제가 완료 되었습니다.");
				location.reload();
			} else {
				alert("삭제 실패 되었습니다.");
			}
		}).fail(function () {
			alert("삭제 실패 되었습니다.");
		});
		return false;
	});
	file_insert.click(function () {
		if (isAddInfo) {
			alert('게시글을 등록하신 후 등록하실 수 있습니다.');
			return false;
		}
		Popup.archiveFile(acm_cls_cd.val());
	});
	
	
	// 매핑
	var map_idsAll			=	$('input[name=map_idsAll]');
	var map_ids				=	$('input[name=map_ids]');
	var map_delete_btn		=	$('.map_delete_btn');
	var map_insert			=	$('.map_insert');
	new Checkbox('input[name=map_idsAll]', 'input[name=map_ids]');
	
	map_delete_btn.click(function () {
		if (isAddInfo) {
			alert('게시글을 등록하신 후 삭제하실 수 있습니다.');
			return false;
		}
		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		var ids = map_ids.filter(':checked');
		if (ids.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}
		var param = {ids : []};
		ids.each(function () {
			param.ids.push( $(this).val() );
		});
		$.post('./mapDelete.do', $.param(param, true), function (res) {
			if (res.success) {
				alert("삭제가 완료 되었습니다.");
				location.reload();
			} else {
				alert("삭제 실패 되었습니다.");
			}
		}).fail(function () {
			alert("삭제 실패 되었습니다.");
		});
		return false;
	});
	map_insert.click(function () {
		if (isAddInfo) {
			alert('게시글을 등록하신 후 등록하실 수 있습니다.');
			return false;
		}
		Popup.archiveMap(acm_cls_cd.val(), arc_thm_id.val());
	});
	
	
	// 색인
	var index_idsAll		=	$('input[name=index_idsAll]');
	var index_ids			=	$('input[name=index_ids]');
	var index_delete_btn	=	$('.index_delete_btn');
	var index_insert		=	$('.index_insert');
	new Checkbox('input[name=index_idsAll]', 'input[name=index_ids]');

	index_delete_btn.click(function () {
		if (isAddInfo) {
			alert('게시글을 등록하신 후 삭제하실 수 있습니다.');
			return false;
		}
		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		var ids = index_ids.filter(':checked');
		if (ids.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}
		var param = {ids : []};
		ids.each(function () {
			param.ids.push( $(this).val() );
		});
		$.post('./indexDelete.do', $.param(param, true), function (res) {
			if (res.success) {
				alert("삭제가 완료 되었습니다.");
				location.reload();
			} else {
				alert("삭제 실패 되었습니다.");
			}
		}).fail(function () {
			alert("삭제 실패 되었습니다.");
		});
		return false;
	});
	index_insert.click(function () {
		if (isAddInfo) {
			alert('게시글을 등록하신 후 등록하실 수 있습니다.');
			return false;
		}
		Popup.archiveIndex(acm_cls_cd.val());
	});

});

</script>
</head>
<body>

<form name="frm" method="POST" action="/addservice/archive/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="arc_source_type" value="${view.arc_source_type }" />
	<input type="hidden" name="arc_ply_cde" value="${view.arc_ply_cde }" />
	<input type="hidden" name="arc_dis_cde" value="${view.arc_dis_cde }" />
	<input type="hidden" name="arc_seq" value="${view.arc_seq }" />

	<div class="tableWrite">
		<table summary="게시판 글 등록">
		<caption>게시판 글 등록</caption>
		<colgroup>
			<col style="width:15%" />
			<col style="width:35%" />
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
<c:if test="${not empty view }">
		<tr>
			<th scope="row">고유번호</th>
			<td>
				<input type="hidden" name="acm_cls_cd" value="${view.acm_cls_cd }" />
				${view.acm_cls_cd }
			</td>
			<th scope="row">조회수</th>
			<td>
				${view.view_cnt }
			</td>
		</tr>
		<tr>
			<th scope="row">등록일</th>
			<td>
				<c:out value="${view.arc_create_date }" default="-" />
			</td>
			<th scope="row">수정일</th>
			<td>
				<c:out value="${view.arc_update_date }" default="-" />
			</td>
		</tr>
</c:if>
<c:if test="${empty view }">
		<tr>
			<th scope="row">고유번호</th>
			<td colspan="3">
				<input type="text" name="acm_cls_cd" value="" style="width:670px" />
			</td>
		</tr>
</c:if>
		<tr>
			<th scope="row">테마선택</th>
			<td colspan="3">
				<select name="arc_thm_id">
					<c:forEach items="${themeList }" var="item">
						<option value="${item.arc_thm_id }"${view.arc_thm_id eq item.arc_thm_id ? ' selected="selected" ' : '' }>
							${item.arc_thm_title }
						</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th scope="row">분류선택</th>
			<td colspan="3" id="category">
				<select name="arc_period_type">
					<option value="">1차분류</option>
				</select>
				<select name="arc_zone_type">
					<option value="">2차분류</option>
				</select>
				<select name="arc_event_type">
					<option value="">3차분류</option>
				</select>
			</td>
		</tr>
		<tr>
			<th scope="row">자료명</th>
			<td colspan="3">
				<input type="text" name="arc_title" value="${view.arc_title }" style="width:670px" />
			</td>
		</tr>
		<tr>
			<th scope="row">생산자</th>
			<td>
				<input type="text" name="arc_staff" value="${view.arc_staff }" style="width:270px" />
			</td>
			<th scope="row">생성일</th>
			<td>
				<input type="text" name="arc_make_date" value="${view.arc_make_date }" style="width:270px" />
			</td>
		</tr>
		<tr>
			<th scope="row">주제분류</th>
			<td>
				<input type="text" name="arc_group_title" value="${view.arc_group_title }" style="width:270px" />
			</td>
			<th scope="row">자료제공</th>
			<td>
				<input type="text" name="arc_source_desc" value="${view.arc_source_desc }" style="width:270px" />
			</td>
		</tr>
		<tr>
			<th scope="row">자료형태</th>
			<td>
				<input type="text" name="arc_data_form" value="${view.arc_data_form }" style="width:270px" />
			</td>
			<th scope="row">핵심어</th>
			<td>
				<input type="text" name="arc_kwd" value="${view.arc_kwd }" style="width:270px" />
			</td>
		</tr>
		<tr>
			<th scope="row">설명</th>
			<td colspan="3">
				<textarea name="acd_contents" style="width:100%;height:200px;"><c:forEach items="${contentList }" var="item">${item.acd_contents }</c:forEach></textarea>
			</td>
		</tr>
		<tr>
			<th scope="row">대표이미지</th>
			<td colspan="3">
				<input type="text" name="arc_file_name" value="${view.arc_file_name }" style="width:580px" />
				<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
				<div class="upload_pop_msg">(다운로드 파일을 선택해 주세요.)</div>
				<div class="upload_pop_img">
					<c:if test="${not empty view.arc_file_name }">
						<a href="/upload/arc_tmp/${view.arc_file_name }" target="_blank">
							${view.arc_file_name }
						</a>
					</c:if>
				</div>
			</td>
		</tr>
		<tr>
			<th scope="row">대표이미지</th>
			<td colspan="3">
				<input type="text" name="arc_file_sub_name" value="${view.arc_file_sub_name }" style="width:580px" />
				<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
				<div class="upload_pop_msg">(다운로드 파일을 선택해 주세요.)</div>
				<div class="upload_pop_img">
					<c:if test="${not empty view.arc_file_sub_name }">
						<a href="/upload/arc_tmp/${view.arc_file_sub_name }" target="_blank">
							${view.arc_file_sub_name }
						</a>
					</c:if>
				</div>
			</td>
		</tr>
		<tr>
			<th scope="row">저작권 이용<br />동의서</th>
			<td colspan="3">
				<label><input type="radio" name="arc_copyright_flag" value="Y" <c:if test="${view.arc_copyright_flag eq 'Y' or empty view }">checked</c:if> /> 확보</label>
				<label><input type="radio" name="arc_copyright_flag" value="N" <c:if test="${view.arc_copyright_flag eq 'N' }">checked</c:if>/> 저작권 대상 없음</label>
				<label><input type="radio" name="arc_copyright_flag" value="D" <c:if test="${view.arc_copyright_flag eq 'D' }">checked</c:if>/> 소멸</label>
				<label><input type="radio" name="arc_copyright_flag" value="O" <c:if test="${view.arc_copyright_flag eq 'O' }">checked</c:if>/> 공문대체</label>
				<label><input type="radio" name="arc_copyright_flag" value="S" <c:if test="${view.arc_copyright_flag eq 'S' }">checked</c:if>/> 자체제작</label>
				<label><input type="radio" name="arc_copyright_flag" value="P" <c:if test="${view.arc_copyright_flag eq 'P' }">checked</c:if>/> 공개자료</label>
			</td>
		</tr>
		<tr>
			<th scope="row">URL</th>
			<td colspan="3">
				<input type="text" name="arc_url" value="${view.arc_url }" style="width:670px" />
			</td>
		</tr>
		<tr>
			<th scope="row">E-MAIL</th>
			<td colspan="3">
				<input type="text" name="arc_email" value="${view.arc_email }" style="width:670px" />
			</td>
		</tr>
		<tr>
			<th scope="row">승인여부</th>
			<td colspan="3">
				<label><input type="radio" name="arc_status" value="0" <c:if test="${view.arc_status eq '0' or empty view }">checked</c:if> /> 승인</label>
				<label><input type="radio" name="arc_status" value="1" <c:if test="${view.arc_status eq '1' }">checked</c:if>/> 미승인</label>
			</td>
		</tr>
		</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/addservice/archive/list.do" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>



<div class="views">
	<p class="sub_title">- 내용</p>

	<div class="tableList">
		<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:4%" />
			<col />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="content_idsAll" /></th>
				<th scope="col">내용</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${empty addContentList }">
		<tr>
			<td colspan="2">검색된 결과가 없습니다.</td>
		</tr>
		</c:if>
		<c:forEach items="${addContentList }" var="item" varStatus="status">
		<tr>
			<td>
				<input type="checkbox" name="content_ids" value="${item.acm_cls_cd }_${item.act_content_cd }" />
			</td>
			<td class="subject">
				${item.act_title }
			</td>
		</tr>
		</c:forEach>
		</tbody>
		</table>
	</div>

	<div class="btnBox">
		<span class="btn white"><a href="#" class="content_delete_btn">삭제</a></span>
		<span class="btn dark fr"><a href="#void" class="content_insert">등록</a></span>
	</div>
</div>



<div class="views">
	<p class="sub_title">- 첨부파일</p>

	<div class="tableList">
		<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:4%" />
			<col style="width:11%" />
			<col />
			<col style="width:20%" />
			<col style="width:20%" />
			<col style="width:6%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="file_idsAll" /></th>
				<th scope="col">파일형식</th>
				<th scope="col">내용</th>
				<th scope="col">파일1</th>
				<th scope="col">파일2</th>
				<th scope="col">19세</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${empty fileList }">
		<tr>
			<td colspan="6">검색된 결과가 없습니다.</td>
		</tr>
		</c:if>
		<c:forEach items="${fileList }" var="item" varStatus="status">
		<tr>
			<td>
				<input type="checkbox" name="file_ids" value="${item.acm_cls_cd }_${item.amd_med_cd }" />
			</td>
			<td>
				${item.amd_mime_type }
			</td>
			<td class="subject">
				${item.amd_title }
			</td>
			<td>
				<c:if test="${not empty item.amd_file_name }">
					<a href="/upload/arc_tmp/${item.amd_file_name }">${item.amd_file_name }</a>
				</c:if>
				<c:if test="${empty item.amd_file_name }">-</c:if>
			</td>
			<td>
				<c:if test="${not empty item.amd_file_name_sub }">
					<a href="/upload/arc_tmp/${item.amd_file_name_sub }">${item.amd_file_name_sub }</a>
				</c:if>
				<c:if test="${empty item.amd_file_name_sub }">-</c:if>
			</td>
			<td>
				${item.amd_adult_chk eq 'Y' ? '예' : '아니요' }
			</td>
		</tr>
		</c:forEach>
		</tbody>
		</table>
	</div>
	
	<div class="btnBox">
		<span class="btn white"><a href="#" class="file_delete_btn">삭제</a></span>
		<span class="btn dark fr"><a href="#void" class="file_insert">등록</a></span>
	</div>
</div>



<div class="views">
	<p class="sub_title">- 연계정보</p>

	<div class="tableList">
		<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:4%" />
			<col style="width:15%" />
			<col />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="map_idsAll" /></th>
				<th scope="col">분류</th>
				<th scope="col">내용</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${empty mapList }">
		<tr>
			<td colspan="3">검색된 결과가 없습니다.</td>
		</tr>
		</c:if>
		<c:forEach items="${mapList }" var="item" varStatus="status">
		<tr>
			<td>
				<!-- ${item.map_m_table_key_1 }_${item.map_m_table_key_2 }_${item.map_seq } -->
				<input type="checkbox" name="map_ids" value="${item.map_seq }" />
			</td>
			<td>
				${item.map_s_system_name }
			</td>
			<td class="subject">
				${item.map_s_title }
			</td>
		</tr>
		</c:forEach>
		</tbody>
		</table>
	</div>

	<div class="btnBox">
		<span class="btn white"><a href="#" class="map_delete_btn">삭제</a></span>
		<span class="btn dark fr"><a href="#void" class="map_insert">등록</a></span>
	</div>
</div>



<div class="views">
	<p class="sub_title">- 색인정보</p>

	<div class="tableList">
		<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:4%" />
			<col />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="index_idsAll" /></th>
				<th scope="col">내용</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${empty indexList }">
		<tr>
			<td colspan="2">검색된 결과가 없습니다.</td>
		</tr>
		</c:if>
		<c:forEach items="${indexList }" var="item" varStatus="status">
		<tr>
			<td>
				<input type="checkbox" name="index_ids" value="${view.acm_cls_cd }_${item.idx_dtl_seq }_${item.idx_map_seq }" />
			</td>
			<td class="subject">
				${item.arc_idx_title }
				>
				${item.idx_dtl_title }
			</td>
		</tr>
		</c:forEach>
		</tbody>
		</table>
	</div>

	<div class="btnBox">
		<span class="btn white"><a href="#" class="index_delete_btn">삭제</a></span>
		<span class="btn dark fr"><a href="#void" class="index_insert">등록</a></span>
	</div>
</div>

</body>
</html>