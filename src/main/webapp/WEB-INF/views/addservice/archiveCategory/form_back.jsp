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
	,mst_class			=	frm.find('input[name=mst_class]')
	,dtl_code			=	frm.find('input[name=dtl_code]')
	,dtl_cde_title		=	frm.find('input[name=dtl_cde_title]')
	,dtl_value_txt		=	frm.find('input[name=dtl_value_txt]')
	,dtl_value_num		=	frm.find('input[name=dtl_value_num]')
	,dtl_dsp_seq		=	frm.find('input[name=dtl_dsp_seq]')
	;

	frm.submit(function () {
		if (dtl_code.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		if (dtl_cde_title.val() == '') {
			dtl_cde_title.focus();
			alert('분류명을 입력해 주세요.');
			return false;
		}
		if (dtl_dsp_seq.val() == '') {
			dtl_dsp_seq.focus();
			alert('순번을 입력해 주세요.');
			return false;
		}
		var number = /^[0-9]*$/;
		if (!number.test(dtl_dsp_seq.val())) {
			dtl_dsp_seq.focus();
			dtl_dsp_seq.val('');
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
			if (dtl_code.val() == '') {
				alert('dtl_code가 존재하지 않습니다.');
				return false;
			}
			
			var param = {
				arc_thm_ids : [ arc_thm_id.val() + '_' + mst_class.val() + '_' + dtl_code.val() ]
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

});
</script>
</head>
<body>

<form name="frm" method="POST" action="/addservice/archiveCategory/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="sKey" value="${paramMap.sKey }" />
	<input type="hidden" name="arc_thm_id" value="${paramMap.arc_thm_id }" />
	<input type="hidden" name="mst_class" value="${paramMap.mst_class }" />
	<input type="hidden" name="dtl_code" value="${view.dtl_code }" />
	<input type="hidden" name="dtl_value_txt" value="${view.dtl_value_txt }" />
	<input type="hidden" name="dtl_value_num" value="${view.dtl_value_num }" />

	<div class="tableWrite">
		<table summary="게시판 글 등록">
		<caption>게시판 글 등록</caption>
		<colgroup>
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
<c:if test="${not empty view.dtl_code }">
		<tr>
			<th scope="row">고유번호</th>
			<td>
				${paramMap.arc_thm_id } > ${paramMap.mst_class } > ${view.dtl_code }
			</td>
		</tr>
</c:if>
		<tr>
			<th scope="row">분류명</th>
			<td>
				<input type="text" name="dtl_cde_title" value="${view.dtl_cde_title }" maxlength="25" style="width:670px" />
			</td>
		</tr>
		<tr>
			<th scope="row">순번</th>
			<td>
				<input type="text" name="dtl_dsp_seq" value="${view.dtl_dsp_seq }" />
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

		<span class="btn gray"><a href="/addservice/archiveCategory/list.do?sKey=back&arc_thm_id=${paramMap.arc_thm_id }&mst_class=${paramMap.mst_class }" class="list_btn">목록</a></span>
		<span class="btn gray"><a href="/addservice/archiveCategory/list.do?sKey=mid&arc_thm_id=${paramMap.arc_thm_id }" class="list_btn">중분류</a></span>
		<span class="btn gray"><a href="/addservice/archiveCategory/list.do" class="list_btn">대분류</a></span>
	</div>

</fieldset>
</form>

</body>
</html>