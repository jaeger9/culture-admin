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
	
	var frm				=	$('form[name=frm]');
	var id				=	frm.find('input[name=id]');
	var tad_name		=	frm.find('input[name=tad_name]');
	var chinese			=	frm.find('input[name=chinese]');
	var english			=	frm.find('input[name=english]');
	var sub_name1		=	frm.find('input[name=sub_name1]');
	var sub_name2		=	frm.find('input[name=sub_name2]');
	var abstract		=	frm.find('input[name=abstract]');
	var detail_txt		=	frm.find('input[name=detail_txt]');
	var publication		=	frm.find('input[name=publication]');
	var report			=	frm.find('input[name=report]');
	var person			=	frm.find('input[name=person]');
	var organ			=	frm.find('input[name=organ]');
	var genre1			=	frm.find('input[name=genre1]');
	var genre2			=	frm.find('input[name=genre2]');
	var genre3			=	frm.find('input[name=genre3]');
	var contents		=	frm.find('textarea[name=contents]');

	frm.submit(function () {
		// frm.serialize()
		// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);

		if (id.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		if (tad_name.val() == '') {
			tad_name.focus();
			alert('용어명을 입력해 주세요.');
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
			if (id.val() == '') {
				alert('id가 존재하지 않습니다.');
				return false;
			}

			var param = {
				ids : [ id.val() ]
			};

			$.ajax({
				url			:	'/addservice/artDictionary/delete.do'
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

<form name="frm" method="POST" action="/addservice/artDictionary/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="id" value="${view.id }" />

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
<c:if test="${not empty view.id }">
				<tr>
					<th scope="row">고유번호</th>
					<td>
						${view.id }
					</td>
					<th scope="row">조회수</th>
					<td>
						${view.view_cnt }
					</td>
				</tr>
</c:if>
				<tr>
					<th scope="row">용어명</th>
					<td colspan="3">
						<input type="text" name="tad_name" value="${view.tad_name }" />
					</td>
				</tr>
				<tr>
					<th scope="row">용어명(한자)</th>
					<td>
						<input type="text" name="chinese" value="${view.chinese }" />
					</td>
					<th scope="row">용어명(영어)</th>
					<td>
						<input type="text" name="english" value="${view.english }" />
					</td>
				</tr>
				<tr>
					<th scope="row">부용어명</th>
					<td>
						<input type="text" name="sub_name1" value="${view.sub_name1 }" />
					</td>
					<th scope="row">부용어명2</th>
					<td>
						<input type="text" name="sub_name2" value="${view.sub_name2 }" />
					</td>
				</tr>
				<tr>
					<th scope="row">대분류</th>
					<td>
						<input type="text" name="genre1" value="${view.genre1 }" />
					</td>
					<th scope="row">중분류</th>
					<td>
						<input type="text" name="genre2" value="${view.genre2 }" />
					</td>
				</tr>
				<tr>
					<th scope="row">소분류</th>
					<td colspan="3">
						<input type="text" name="genre3" value="${view.genre3 }" />
					</td>
				</tr>
				<tr>
					<th scope="row">관련서적</th>
					<td colspan="3">
						<input type="text" name="publication" value="${view.publication }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">관련논문</th>
					<td colspan="3">
						<input type="text" name="report" value="${view.report }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">관련인물</th>
					<td colspan="3">
						<input type="text" name="person" value="${view.person }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">관련단체</th>
					<td colspan="3">
						<input type="text" name="organ" value="${view.organ }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">요약설명</th>
					<td colspan="3">
						<input type="text" name="abstract" value="${view.abstract }" style="width:670px" />
					</td>
				</tr>
				<tr>
					<th scope="row">상세설명</th>
					<td colspan="3">
						<textarea id="detail_txt" name="detail_txt" style="width:100%;height:200px;"><c:out value="${view.detail_txt }" escapeXml="true" /></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">콘텐츠</th>
					<td colspan="3">
						<textarea id="contents" name="contents" style="width:100%;height:200px;"><c:out value="${view.contents }" escapeXml="true" /></textarea>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.id ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view.id }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/addservice/artDictionary/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>