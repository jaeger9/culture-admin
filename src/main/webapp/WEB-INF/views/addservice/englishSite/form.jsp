<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

$(function () {
	var frm			=	$('form[name=frm]');
	var seq			=	frm.find('input[name=seq]');

	var org_name	=	frm.find('input[name=org_name]');
	var org_eng_name	=	frm.find('input[name=org_eng_name]');
	var url			=	frm.find('input[name=url]');
	var approval	=	frm.find('input[name=approval]');
	
	frm.submit(function () {
		if (seq.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}

		if ($('select[name="category"] option:selected').val() == '') {
			$('select[name="category"]').focus();
			alert('구분을 선택해 주세요.');
			return false;
		}
		if (org_name.val() == '') {
			org_name.focus();
			alert('기관명을 입력해 주세요.');
			return false;
		}
		if (org_eng_name.val() == '') {
			org_eng_name.focus();
			alert('영문 풀네임을 입력해 주세요.');
			return false;
		}
		if (url.val() == '') {
			url.focus();
			alert('연결 URL을 입력해 주세요.');
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
				url			:	'/addservice/englishSite/delete.do'
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

<form name="frm" method="POST" action="/addservice/englishSite/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>
	
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
				<tr>
					<th scope="row">작성자</th>
					<td>
						${view.user_id }
					</td>
					<th scope="row">등록일</th>
					<td>
						${view.reg_date }
					</td>
				</tr>
				<tr>
					<th scope="row">구분</th>
					<td colspan="3">
						<select name="category">
							<option value="" ${empty view.category ? 'selected="selected"' : '' }>선택</option>
							<option value="관광" ${view.category eq '관광' ? 'selected="selected"' : '' }>관광</option>
							<option value="도서" ${view.category eq '도서' ? 'selected="selected"' : '' }>도서</option>
							<option value="문화산업" ${view.category eq '문화산업' ? 'selected="selected"' : '' }>문화산업</option>
							<option value="문화예술" ${view.category eq '문화예술' ? 'selected="selected"' : '' }>문화예술</option>
							<option value="문화유산" ${view.category eq '문화유산' ? 'selected="selected"' : '' }>문화유산</option>
							<option value="정책" ${view.category eq '정책' ? 'selected="selected"' : '' }>정책</option>
							<option value="체육"	${view.category eq '체육'	? 'selected="selected"' : '' }>체육</option>
							<option value="홍보" ${view.category eq '홍보' ? 'selected="selected"' : '' }>홍보</option>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">기관명</th>
					<td colspan="3">
						<input type="text" name="org_name" value="${view.org_name }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">영문 풀네임</th>
					<td colspan="3">
						<input type="text" name="org_eng_name" value="${view.org_eng_name }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">연결 URL</th>
					<td colspan="3">
						<input type="text" name="url" value="${view.url }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td colspan="3">
						<label><input type="radio" name="approval" value="S" ${view.approval eq 'S' or empty view.approval ? 'checked="checked"' : '' } /> 대기</label>
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

		<span class="btn gray"><a href="/addservice/englishSite/list.do" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>