<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

var callback = {
	rdfMetadata : function (res) {
		/*
			JSON.stringify(res) = {
				"uci"				:	"..."
				,"perform_title"	:	"..."
			}
		*/
		if (res == null) {
			return false;
		}

		$('input[name=uci]').val(res.uci);
		$('input[name=perform_title]').val(res.title);
	}
};

$(function () {

	var frm				=	$('form[name=frm]');
	var seq				=	frm.find('input[name=seq]');
	var content_type	=	frm.find('input[name=content_type]');
	var title			=	frm.find('input[name=title]');
	var uci				=	frm.find('input[name=uci]');
	var perform_title	=	frm.find('input[name=perform_title]');
	var invitation		=	frm.find('input[name=invitation]');
	var start_dt		=	frm.find('input[name=start_dt]');
	var end_dt			=	frm.find('input[name=end_dt]');
	var win_dt			=	frm.find('input[name=win_dt]');
	var win_url			=	frm.find('input[name=win_url]');
	var rights			=	frm.find('input[name=rights]');
	var references		=	frm.find('input[name=references]');
	var approval		=	frm.find('input[name=approval]');

	new Datepicker(start_dt, end_dt);
	setDatepicker(win_dt);
	
	frm.submit(function () {
		// frm.serialize()

		if (seq.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		if (content_type.filter(':checked').size() == 0) {
			content_type.eq(0).focus();
			alert('구분을 선택해 주세요.');
			return false;
		}
		if (title.val() == '') {
			title.focus();
			alert('이벤트명을 입력해 주세요.');
			return false;
		}
		if (uci.val() == '' || perform_title.val() == '') {
			uci.focus();
			alert('공연을 선택해 주세요.');
			return false;
		}
		if (start_dt.val() == '') {
			start_dt.focus();
			alert('이벤트 시작일을 선택해 주세요.');
			return false;
		}
		if (end_dt.val() == '') {
			end_dt.focus();
			alert('이벤트 종료일을 선택해 주세요.');
			return false;
		}
		if (approval.filter(':checked').size() == 0) {
			approval.eq(0).focus();
			alert('승인여부를 선택해 주세요.');
			return false;
		}
		return true;
	});

	// 출처
	$('.perform_btn').add(perform_title).click(function () {
		Popup.rdfMetadata('공연/전시');
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
				url			:	'/event/invitation/delete.do'
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

<form name="frm" method="POST" action="/event/invitation/form.do" enctype="multipart/form-data">
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
						<fmt:formatNumber value="${view.view_cnt }" pattern="###,###"/>
						${empty view.view_cnt ? '0' : '' }
					</td>
				</tr>
				<tr>
					<th scope="row">등록자</th>
					<td>
						${view.user_id }
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
						<label><input type="radio" name="content_type" value="1" ${view.content_type eq '1' or empty view.content_type ? 'checked="checked"' : '' } /> 문화초대이벤트</label>
						<label><input type="radio" name="content_type" value="2" ${view.content_type eq '2' ? 'checked="checked"' : '' } /> 문화릴레이티켓</label>
					</td>
				</tr>
				<tr>
					<th scope="row">이벤트명</th>
					<td colspan="3">
						<input type="text" name="title" value="${view.title }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">공연</th>
					<td colspan="3">
						<input type="hidden" name="uci" value="${view.uci }" />
						<input type="text" name="perform_title" value="${view.perform_title }" readonly="readonly" style="width:580px" />
						<span class="btn whiteS"><a href="#" class="perform_btn">공연</a></span>
					</td>
				</tr>
				<tr>
					<th scope="row">초대일시</th>
					<td colspan="3">
						<input type="text" name="invitation" value="${view.invitation }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">이벤트기간</th>
					<td colspan="3">
						<input type="text" name="start_dt" value="${view.start_dt }" readonly="readonly" />
						~
						<input type="text" name="end_dt" value="${view.end_dt }" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<th scope="row">당첨자발표</th>
					<td colspan="3">
						<input type="text" name="win_dt" value="${view.win_dt }" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<th scope="row">당첨자URL</th>
					<td colspan="3">
						<input type="text" name="win_url" value="${view.win_url }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">이벤트 안내</th>
					<td colspan="3">
						<input type="text" name="invt_detail" value="${view.invt_detail }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">응모방법</th>
					<td colspan="3">
						<input type="text" name="invt_cmt" value="${view.invt_cmt }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">공연단체명</th>
					<td colspan="3">
						<input type="text" name="rights" value="${view.rights }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">공연단체연락처</th>
					<td colspan="3">
						<input type="text" name="references" value="${view.references }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td colspan="3">
						<label><input type="radio" name="approval" value="W" ${view.approval eq 'W' or empty view.approval ? 'checked="checked"' : '' } /> 대기</label>
						<label><input type="radio" name="approval" value="Y" ${view.approval eq 'Y' ? 'checked="checked"' : '' } /> 승인</label>
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

		<span class="btn gray"><a href="/event/invitation/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>