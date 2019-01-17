<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- <script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script> -->
<script type="text/javascript">

var callback = {
	fileUpload : function (res) {
		console.log( res.full_file_path);
		console.log( res.file_path);
		target.val(res.file_path);
		//targetView.html('<img src="/upload/recom/recom/' + res.file_path + '" width="100" height="100" alt="" />');
	}
};

$(function () {
	
	var frm			=	$('form[name=frm]');
	
	var seq		=	$('input[name="seq"]');
	var title		=	$('input[name="title"]');
	var url		=	$('input[name="url"]');
	var approval		=	$('input[name="approval"]');
	
	frm.submit(function () {

		if (title.val() == '') {
			title.focus();
			alert('공지글을 입력해 주세요.');
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
		

		if(seq.val() != ''){
			if(!confirm('수정하시겠습니까?')){
				return false;
			}
		}else{
			if(!confirm('등록하시겠습니까?')){
				return false;
			}
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
				url			:	'/addservice/pollEvent/noticeDelete.do'
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

<form name="frm" method="POST" action="/addservice/pollEvent/noticeForm.do">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="seq" value="${view.seq }" />

	<div class="tableWrite">
		<table summary="게시판 글 등록">
			<caption>게시판 글 등록</caption>
			<colgroup>
				<col style="width:25%" />
				<col style="width:75%" />
			</colgroup>
			<tbody>
				<tr>
					<th>* 공지글</th>
					<td>
						<input type="text" name="title" value="${view.title}" style="width:500px" maxlength="200"/>
					</td>
				</tr>
				<tr>
					<th rowspan="2">* 연결URL</th>
					<td>포털
						<input type="text" name="portal_url" value="${view.portal_url}" style="width:500px" maxlength="100"/>
					</td>
				</tr>
				<tr>
					<td>모바일
						<input type="text" name="mobile_url" value="${view.mobile_url}" style="width:500px" maxlength="100"/>
					</td>
				</tr>
				<tr>
					<th scope="row">승인여부</th>
					<td colspan="4">
						<label><input type="radio" name="approval" value="S" ${view.approval eq 'S' ? 'checked="checked"' : '' } /> 대기</label>
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

		<span class="btn gray"><a href="/addservice/pollEvent/noticeList.do" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>