<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- <script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script> -->
<script type="text/javascript">

var target = null;
var targetView = null;

var callback = {
	fileUpload : function (res) {
		// res.full_file_path
		// res.file_path
		target.val(res.file_path);
		targetView.html('<img src="/upload/vvm_tmp/' + res.file_path + '" alt="" />');
	}
};

$(function () {

	// 에디터 HTML 적용
	// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
	// nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	
	var frm				=	$('form[name=frm]');
	var vvm_seq			=	frm.find('input[name=vvm_seq]');
	var vvm_title		=	frm.find('input[name=vvm_title]');
	var vvm_sub_title	=	frm.find('input[name=vvm_sub_title]');
	var vvm_cre_name	=	frm.find('input[name=vvm_cre_name]');
	var vvm_kwd			=	frm.find('input[name=vvm_kwd]');
	var tmp_depth		=	frm.find('input[name=tmp_depth]');

	frm.submit(function () {
		// frm.serialize()
		// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);

		if (vvm_seq.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}

		if (vvm_title.val() == '') {
			vvm_title.focus();
			alert('작품/자료명을 입력해 주세요.');
			return false;
		}
		if (vvm_sub_title.val() == '') {
			vvm_sub_title.focus();
			alert('부제목을 입력해 주세요.');
			return false;
		}
		if (vvm_cre_name.val() == '') {
			vvm_cre_name.focus();
			alert('작가/기능보유자를 입력해 주세요.');
			return false;
		}
		if (vvm_kwd.val() == '') {
			vvm_kwd.focus();
			alert('검색키워드를 입력해 주세요.');
			return false;
		}

		return true;
	});

	$('select[name=ccm_code]').change(function () {
		var data = $(this).find('option:selected').data();
		tmp_depth.val( data.depth );
	}).change();
	
	// 파일업로드
	$('.upload_pop_btn').click(function () {
		var p		=	$(this).parents('td:eq(0)');
		target		=	p.find('input[type=text]');
		targetView	=	p.find('.upload_pop_img');

		Popup.fileUpload('knowledge_artContent');
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
			if (vvm_seq.val() == '') {
				alert('vvm_seq가 존재하지 않습니다.');
				return false;
			}

			var param = {
				vvm_seqs : [ vvm_seq.val() ]
			};

			$.ajax({
				url			:	'/addservice/artContent/delete.do'
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

	// tab click
	$('.tmpSub').click(function () {
		if (vvm_seq.val() == '') {
			alert('[기본 정보] 탭을 제외한 [상세 및 추가 정보]는\r\n[기본 정보]를 등록 완료하신 후 사용 가능합니다.');
			return false;
		}
		return true;
	});
});
</script>
</head>
<body>

<ul class="tab">
	<li><a href="/addservice/artContent/form.do?vvm_seq=${view.vvm_seq }" class="focus">기본 정보</a></li>
	<li><a href="/addservice/artContent/detailList.do?vvm_seq=${view.vvm_seq }" class="tmpSub">상세 정보</a></li>
</ul>

<form name="frm" method="POST" action="/addservice/artContent/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="vvm_seq" value="${view.vvm_seq }" />

	<div class="tableWrite">
		<table summary="게시판 글 등록">
		<caption>게시판 글 등록</caption>
		<colgroup>
			<col style="width:15%" />
			<col style="width:33%" />
			<col style="width:17%" />
			<col style="width:35%" />
		</colgroup>
		<tbody>
<c:if test="${not empty view.vvm_seq }">
		<tr>
			<th scope="row">고유번호</th>
			<td>
				${view.vvm_seq }
			</td>
			<th scope="row">등록일</th>
			<td>
				<c:out value="${view.vvm_reg_date }" default="-" />

				<c:if test="${not empty view.vvm_upd_date }">
					(<c:out value="${view.vvm_upd_date }" default="-" />)
				</c:if>
			</td>
		</tr>
</c:if>
		<tr>
			<th scope="row">작품/자료명</th>
			<td colspan="3">
				<input type="text" name="vvm_title" value="${view.vvm_title }" style="width:670px" />
			</td>
		</tr>
		<tr>
			<th scope="row">부제목</th>
			<td colspan="3">
				<input type="text" name="vvm_sub_title" value="${view.vvm_sub_title }" style="width:670px" />
			</td>
		</tr>
		<tr>
			<th scope="row">장르</th>
			<td colspan="3">
				<input type="hidden" name="tmp_depth" value="" /><!-- vvm_type -->

				<select name="ccm_code">
					<c:forEach items="${codeList }" var="item">
						<c:if test="${item.ccm_depth eq 4 or item.ccm_depth eq 1 }">
							<option value="${item.ccm_code }" data-depth="${item.ccm_depth }" ${view.ccm_code eq item.ccm_code ? ' selected="selected" ' : '' }>${item.ccm_titles }</option>
						</c:if>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th scope="row">작가/기능보유자</th>
			<td>
				<input type="text" name="vvm_cre_name" value="${view.vvm_cre_name }" style="width:200px" />
			</td>
			<th scope="row">검색 키워드</th>
			<td>
				<input type="text" name="vvm_kwd" value="${view.vvm_kwd }" style="width:200px" />
			</td>
		</tr>
		<tr>
			<th scope="row">제작/기획</th>
			<td>
				<input type="text" name="vvm_pub_name" value="${view.vvm_pub_name }" style="width:200px" />
			</td>
			<th scope="row">상영시간/주기</th>
			<td>
				<input type="text" name="vvm_duration" value="${view.vvm_duration }" style="width:200px" />
			</td>
		</tr>
		<tr>
			<th scope="row">발행처</th>
			<td>
				<input type="text" name="vvm_issuer" value="${view.vvm_issuer }" style="width:200px" />
			</td>
			<th scope="row">출연자</th>
			<td>
				<input type="text" name="vvm_staff" value="${view.vvm_staff }" style="width:200px" />
			</td>
		</tr>
		<tr>
			<th scope="row">제작년도</th>
			<td>
				<input type="text" name="vvm_cre_date" value="${view.vvm_cre_date }" style="width:200px" />
			</td>
			<th scope="row">초연년도</th>
			<td>
				<input type="text" name="vvm_fpl_date" value="${view.vvm_fpl_date }" style="width:200px" />
			</td>
		</tr>
		<tr>
			<th scope="row">소유자/소유기관</th>
			<td>
				<input type="text" name="vvm_own_name" value="${view.vvm_own_name }" style="width:200px" />
			</td>
			<th scope="row">전문분야</th>
			<td>
				<input type="text" name="vvm_exp" value="${view.vvm_exp }" style="width:200px" />
			</td>
		</tr>
		<tr>
			<th scope="row">상태</th>
			<td>
				<select name="vvm_status">
					<option value="0" ${view.vvm_status eq '0' ? 'selected="selected"' : '' }>승인</option>
					<option value="1" ${view.vvm_status eq '1' ? 'selected="selected"' : '' }>미승인</option>
				</select>
			</td>
			<th scope="row">저작권 이용 동의서</th>
			<td>
				<select name="vvm_copyright">
					<option value="Y" ${view.vvm_copyright eq 'Y' or empty view.vvm_copyright ? 'selected="selected"' : '' }>확보</option>
					<option value="N" ${view.vvm_copyright eq 'N' ? 'selected="selected"' : '' }>저작권 대상 없음</option>
					<option value="D" ${view.vvm_copyright eq 'D' ? 'selected="selected"' : '' }>소멸</option>
					<option value="O" ${view.vvm_copyright eq 'O' ? 'selected="selected"' : '' }>공문대체</option>
					<option value="S" ${view.vvm_copyright eq 'S' ? 'selected="selected"' : '' }>자체제작</option>
					<option value="P" ${view.vvm_copyright eq 'P' ? 'selected="selected"' : '' }>공개자료</option>
				</select>
			</td>
		</tr>
		<tr>
			<th scope="row">원본 이미지</th>
			<td colspan="3">
				<input type="text" name="vvm_file_name" value="${view.vvm_file_name }" style="width:580px" />
				<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
				<div class="upload_pop_msg">(원본 이미지를 선택해 주세요.)</div>
				<div class="upload_pop_img">
					<c:if test="${not empty view.vvm_file_name }">
						<img src="/upload/vvm_tmp/${view.vvm_file_name }" alt="" />
					</c:if>
				</div>
			</td>
		</tr>
		<tr>
			<th scope="row">썸네일 이미지</th>
			<td colspan="3">
				<input type="text" name="vvm_file_name_sub" value="${view.vvm_file_name_sub }" style="width:580px" />
				<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
				<div class="upload_pop_msg">(썸네일 이미지를 선택해 주세요.)</div>
				<div class="upload_pop_img">
					<c:if test="${not empty view.vvm_file_name_sub }">
						<img src="/upload/vvm_tmp/${view.vvm_file_name_sub }" alt="" />
					</c:if>
				</div>
			</td>
		</tr>
		</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.vvm_seq ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view.vvm_seq }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/addservice/artContent/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</body>
</html>