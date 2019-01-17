<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- <script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script> -->
<script type="text/javascript">

$(function () {

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
	// nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	
	var frm			=	$('form[name=frm]');
	var seq			=	frm.find('input[name=seq]');
	var agent		=	frm.find('input[name=agent]');
	var cate_type	=	frm.find('select[name=cate_type]');
	var category	=	frm.find('input[name=category]');
	var sitename	=	frm.find('input[name=sitename]');
	var service		=	frm.find('input[name=service]');
	var url			=	frm.find('input[name=url]');
	var info		=	frm.find('textarea[name=info]');
	var approval	=	frm.find('input[name=approval]');
	
	frm.submit(function () {
		// frm.serialize()
		// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);

		if (seq.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}

		category.val( $.trim(cate_type.find('option').filter(':selected').text()) );

		if (agent.val() == '') {
			agent.focus();
			alert('기관명을 입력해 주세요.');
			return false;
		}
		if (sitename.val() == '') {
			sitename.focus();
			alert('사이트명을 입력해 주세요.');
			return false;
		}
		if (service.val() == '') {
			service.focus();
			alert('서비스명을 입력해 주세요.');
			return false;
		}
		if (url.val() == '') {
			url.focus();
			alert('URL을 입력해 주세요.');
			return false;
		}
		if (info.val() == '') {
			info.focus();
			alert('서비스 소개를 입력해 주세요.');
			return false;
		}
		if (approval.filter(':checked').size() == 0) {
			approval.eq(0).focus();
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
				url			:	'/addservice/contestAgent/delete.do'
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

<form name="frm" method="POST" action="/addservice/contestAgent/form.do" enctype="multipart/form-data">
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
					<th scope="row">등록/수정일</th>
					<td>
						<c:out value="${view.reg_date }" default="-" />
						/
						<c:out value="${view.upd_date }" default="-" />
					</td>
				</tr>
</c:if>
				<tr>
					<th scope="row">구분</th>
					<td colspan="3">
						<input type="hidden" name="category" value="${view.category }" />
						<select name="cate_type">
							<option value="A" ${view.cate_type eq 'A' ? 'selected="selected"' : '' }>문화예술</option>
							<option value="B" ${view.cate_type eq 'B' ? 'selected="selected"' : '' }>문화유산</option>
							<option value="C" ${view.cate_type eq 'C' ? 'selected="selected"' : '' }>문화산업</option>
							<option value="D" ${view.cate_type eq 'D' ? 'selected="selected"' : '' }>체육</option>
							<option value="E" ${view.cate_type eq 'E' ? 'selected="selected"' : '' }>관광</option>
							<option value="F" ${view.cate_type eq 'F' ? 'selected="selected"' : '' }>도서</option>
							<option value="G" ${view.cate_type eq 'G' ? 'selected="selected"' : '' }>정책/홍보</option>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">기관명</th>
					<td colspan="3">
						<input type="text" name="agent" value="${view.agent }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">사이트명</th>
					<td colspan="3">
						<input type="text" name="sitename" value="${view.sitename }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">서비스명</th>
					<td colspan="3">
						<input type="text" name="service" value="${view.service }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">URL</th>
					<td colspan="3">
						<input type="text" name="url" value="${view.url }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">서비스 소개</th>
					<td colspan="3">
						<textarea name="info" style="width:100%;height:400px;"><c:out value="${view.info }" escapeXml="false" /></textarea>
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

		<span class="btn gray"><a href="/addservice/contestAgent/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>