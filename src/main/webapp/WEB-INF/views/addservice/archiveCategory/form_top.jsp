<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

$(function () {
	
	var frm				=	$('form[name=frm]')
	,arc_thm_id			=	frm.find('input[name=arc_thm_id]')
	,arc_thm_title		=	frm.find('input[name=arc_thm_title]')
	,thm_dsp_seq		=	frm.find('input[name=thm_dsp_seq]')
	,thm_period_type	=	frm.find('input[name=thm_period_type]')
	,thm_zone_type		=	frm.find('input[name=thm_zone_type]')
	,thm_event_type		=	frm.find('input[name=thm_event_type]')
	,thm_source_type	=	frm.find('input[name=thm_source_type]')
	,thm_ccm_path		=	frm.find('input[name=thm_ccm_path]')
	,thm_ccm_lev1		=	frm.find('input[name=thm_ccm_lev1]')
	,thm_ccm_lev2		=	frm.find('input[name=thm_ccm_lev2]')
	,thm_ccm_lev3		=	frm.find('input[name=thm_ccm_lev3]')
	,thm_ccm_lev4		=	frm.find('input[name=thm_ccm_lev4]')
	,tmp_thm_ccm_lev	=	frm.find('select[name=tmp_thm_ccm_lev]')
	;

	frm.submit(function () {
		if (arc_thm_id.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		if (arc_thm_title.val() == '') {
			arc_thm_title.focus();
			alert('분류명을 입력해 주세요.');
			return false;
		}
		if (thm_dsp_seq.val() == '') {
			thm_dsp_seq.focus();
			alert('순번을 입력해 주세요.');
			return false;
		}
		var number = /^[0-9]*$/;
		if (!number.test(thm_dsp_seq.val())) {
			thm_dsp_seq.focus();
			thm_dsp_seq.val('');
			alert('순번을 입력해 주세요. (숫자만 입력 가능합니다.)');
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
			if (arc_thm_id.val() == '') {
				alert('arc_thm_id가 존재하지 않습니다.');
				return false;
			}

			var param = {
				arc_thm_ids : [ arc_thm_id.val() ]
			};

			$.ajax({
				url			:	'/addservice/archiveCategory/delete.do'
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

	tmp_thm_ccm_lev.change(function () {
		var values = $(this).val().split('>');

		thm_ccm_lev1.val(values[0]);
		thm_ccm_lev2.val(values[1]);
		thm_ccm_path.val($.trim($(this).find('option:selected').text().replace('>', ' > ')));
	});
	
	if (thm_ccm_lev1.val() != null && thm_ccm_lev2.val() != null) {
		tmp_thm_ccm_lev.find('option[value="' + thm_ccm_lev1.val() + '>' + thm_ccm_lev2.val() + '"]').attr('selected', true);
	}

	tmp_thm_ccm_lev.change();

});
</script>
</head>
<body>

<form name="frm" method="POST" action="/addservice/archiveCategory/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="sKey" value="${paramMap.sKey }" />

	<input type="hidden" name="arc_thm_id" value="${view.arc_thm_id }" />
	<input type="hidden" name="thm_ccm_lev3" value="${view.thm_ccm_lev3 }" />
	<input type="hidden" name="thm_ccm_lev4" value="${view.thm_ccm_lev4 }" />
	<input type="hidden" name="thm_period_type" value="${view.thm_period_type }" maxlength="5" />
	<input type="hidden" name="thm_zone_type" value="${view.thm_zone_type }" maxlength="5" />
	<input type="hidden" name="thm_event_type" value="${view.thm_event_type }" maxlength="5" />
	<input type="hidden" name="thm_source_type" value="${view.thm_source_type }" maxlength="5" />

	<div class="tableWrite">
		<table summary="게시판 글 등록">
		<caption>게시판 글 등록</caption>
		<colgroup>
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
<c:if test="${not empty view.arc_thm_id }">
		<tr>
			<th scope="row">고유번호</th>
			<td>
				${view.arc_thm_id }
			</td>
		</tr>
</c:if>
		<tr>
			<th scope="row">분류명</th>
			<td>
				<input type="text" name="arc_thm_title" value="${view.arc_thm_title }" maxlength="25" style="width:670px" />
			</td>
		</tr>
		<tr>
			<th scope="row">순번</th>
			<td>
				<input type="text" name="thm_dsp_seq" value="${view.thm_dsp_seq }" />
			</td>
		</tr>
		<tr>
			<th scope="row">코드</th>
			<td>
				<input type="hidden" name="thm_ccm_lev1" value="${view.thm_ccm_lev1 }" />
				<input type="hidden" name="thm_ccm_lev2" value="${view.thm_ccm_lev2 }" />
				<input type="hidden" name="thm_ccm_path" value="${view.thm_ccm_path }" />

				<select name="tmp_thm_ccm_lev">
					<c:forEach items="${codeList }" var="item">
						<c:if test="${item.ccm_depth eq 2 }">
							<option value="${item.ccm_codes }">
								${item.ccm_titles }
							</option>
						</c:if>
					</c:forEach>
				</select>
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

		<span class="btn gray"><a href="/addservice/archiveCategory/list.do" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>