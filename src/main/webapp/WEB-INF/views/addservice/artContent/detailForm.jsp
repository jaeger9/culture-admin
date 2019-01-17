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

var callback = {
	fileUpload : function (res) {
		// res.full_file_path
		// res.file_path
		$('input[name=vvi_ole_file_name]').val(res.file_path);
		$('input[name=tmp_vvi_ole_file_path]').val(res.full_file_path);

		$('.upload_pop_img').html('<a href="/upload/vmi/' + res.file_path + '" target="_blank">' + res.file_path + '</a>');
	}
};

$(function () {
	var frm					=	$('form[name=frm]');
	var vvm_seq				=	frm.find('input[name=vvm_seq]');
	var vvi_seq				=	frm.find('input[name=vvi_seq]');
	var vvi_title			=	frm.find('input[name=vvi_title]');
	var vac_contents		=	frm.find('textarea[name=vac_contents]');
	var vvi_ole_title		=	frm.find('input[name=vvi_ole_title]');
	var vvi_ole_file_name	=	frm.find('input[name=vvi_ole_file_name]');

	frm.submit(function () {
		if (vvi_seq.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}

		if (vvi_title.val() == '') {
			vvi_title.focus();
			alert('항목명을 입력해 주세요.');
			return false;
		}

		if (vac_contents.val() == '') {
			vac_contents.focus();
			alert('내용을 입력해 주세요.');
			return false;
		}

		if (vvi_ole_title.val() == '') {
			vvi_ole_title.focus();
			alert('다운로드 버튼 제목을 입력해 주세요.');
			return false;
		}

		// vvi_ole_file_name

		return true;
	});

	// 파일업로드
	$('.upload_pop_btn').click(function () {
		Popup.fileUpload('knowledge_artContentDetail');
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
			if (vvi_seq.val() == '') {
				alert('vvi_seq가 존재하지 않습니다.');
				return false;
			}

			var param = {
				vvi_seqs : [ vvi_seq.val() ]
			};

			$.ajax({
				url			:	'/addservice/artContent/detailDelete.do'
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
	
	// file
	var file_delete_btn		=	$('.file_delete_btn');
	var file_insert			=	$('.file_insert');
	new Checkbox('input[name=file_vmi_seqsAll]', 'input[name=file_vmi_seqs]');

	file_delete_btn.click(function () {
		if (isAddInfo) {
			alert('상세 정보를 등록하신 후 파일을 삭제하실 수 있습니다.');
			return false;
		}
		var file_vmi_seqs = $('input[name=file_vmi_seqs]:checked');
		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		if (file_vmi_seqs.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}
		var param = {};
		if (file_vmi_seqs.size() > 0) {
			param.file_vmi_seqs = [];
			
			$('input[name=file_vmi_seqs]:checked').each(function () {
				param.file_vmi_seqs.push( $(this).val() );
			});
		}
		$.post('./detailFileDelete.do', $.param(param, true), function (res) {
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
			alert('상세 정보를 등록하신 후 파일을 등록하실 수 있습니다.');
			return false;
		}
		Popup.artContentFile(vvm_seq.val(), vvi_seq.val());
	});
	
	// mapping
	var map_delete_btn		=	$('.map_delete_btn');
	var map_insert			=	$('.map_insert');
	new Checkbox('input[name=map_vvm_seqsAll]', 'input[name=map_vvm_seqs]');

	map_delete_btn.click(function () {
		if (isAddInfo) {
			alert('상세 정보를 등록하신 후 매핑정보를 삭제하실 수 있습니다.');
			return false;
		}
		var map_vvm_seqs = $('input[name=map_vvm_seqs]:checked');
		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		if (map_vvm_seqs.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}
		var param = {
			vvi_seq_par		:	vvi_seq.val()
			,vvm_seq_par	:	vvm_seq.val()
		};
		if (map_vvm_seqs.size() > 0) {
			param.map_vvm_seqs = [];
			
			$('input[name=map_vvm_seqs]:checked').each(function () {
				param.map_vvm_seqs.push( $(this).val() );
			});
		}
		$.post('./detailMapDelete.do', $.param(param, true), function (res) {
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
			alert('상세 정보를 등록하신 후 매핑정보를 등록하실 수 있습니다.');
			return false;
		}
		Popup.artContentMap(vvm_seq.val(), vvi_seq.val());
	});
	
	// site
	var site_delete_btn		=	$('.site_delete_btn');
	var site_insert			=	$('.site_insert');
	new Checkbox('input[name=site_vru_seqsAll]', 'input[name=site_vru_seqs]');

	site_delete_btn.click(function () {
		if (isAddInfo) {
			alert('상세 정보를 등록하신 후 사이트 정보를 삭제하실 수 있습니다.');
			return false;
		}
		var site_vru_seqs = $('input[name=site_vru_seqs]:checked');
		if (!confirm('삭제하시겠습니까?')) {
			return false;
		}
		if (site_vru_seqs.size() == 0) {
			alert('선택된 항목이 없습니다.');
			return false;
		}
		var param = {};
		if (site_vru_seqs.size() > 0) {
			param.site_vru_seqs = [];
			
			$('input[name=site_vru_seqs]:checked').each(function () {
				param.site_vru_seqs.push( $(this).val() );
			});
		}
		$.post('./detailSiteDelete.do', $.param(param, true), function (res) {
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
	site_insert.click(function () {
		if (isAddInfo) {
			alert('상세 정보를 등록하신 후 사이트 정보를 등록하실 수 있습니다.');
			return false;
		}
		Popup.artContentSite(vvm_seq.val(), vvi_seq.val());
		return false;
	});

});

</script>
</head>
<body>
<ul class="tab">
	<li><a href="/addservice/artContent/form.do?vvm_seq=${view.vvm_seq }">기본 정보</a></li>
	<li><a href="/addservice/artContent/detailList.do?vvm_seq=${view.vvm_seq }" class="focus">상세 정보</a></li>
</ul>

<form name="frm" method="POST" action="/addservice/artContent/detailForm.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="vvm_seq" value="${view.vvm_seq }" />
	<input type="hidden" name="vvi_seq" value="${viewDetail.vvi_seq }" />

	<div class="tableWrite">
		<table summary="게시판 글 등록">
		<caption>게시판 글 등록</caption>
		<colgroup>
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
<c:if test="${not empty viewDetail.vvi_seq }">
		<tr>
			<th scope="row">고유번호</th>
			<td>
				${viewDetail.vvi_seq }
			</td>
		</tr>
</c:if>
		<tr>
			<th scope="row">항목명</th>
			<td>
				<input type="text" name="vvi_title" value="${viewDetail.vvi_title }" style="width:670px" />
			</td>
		</tr>
		<tr>
			<th scope="row">내용</th>
			<td>
				<textarea name="vac_contents" style="width:100%;height:200px;"><c:forEach items="${listByViewDetailContent }" var="item">${item.vac_contents }</c:forEach></textarea>
			</td>
		</tr>
		<tr>
			<th scope="row">다운로드<br />버튼명</th>
			<td>
				<input type="text" name="vvi_ole_title" value="${viewDetail.vvi_ole_title }" style="width:670px" />
			</td>
		</tr>
		<tr>
			<th scope="row">다운로드<br />파일</th>
			<td>
				<input type="hidden" name="tmp_vvi_ole_file_path" value="" />

				<input type="text" name="vvi_ole_file_name" value="${viewDetail.vvi_ole_file_name }" style="width:580px" />
				<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
				<div class="upload_pop_msg">(다운로드 파일을 선택해 주세요.)</div>
				<div class="upload_pop_img">
					<c:if test="${not empty viewDetail.vvi_ole_file_name }">
						<a href="/upload/vmi/${viewDetail.vvi_ole_file_name }" target="_blank">
							${viewDetail.vvi_ole_file_name }
						</a>
					</c:if>
				</div>
			</td>
		</tr>
		</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty viewDetail.vvi_seq ? '등록' : '수정' }</a></span>

		<c:if test="${not empty viewDetail.vvi_seq }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/addservice/artContent/detailList.do?vvm_seq=${view.vvm_seq }" class="list_btn">상세 목록</a></span>
		<span class="btn gray"><a href="/addservice/artContent/list.do" class="list_btn">전체 목록</a></span>
	</div>

</fieldset>
</form>



<div class="views">
	<p class="sub_title">- 첨부파일</p>

	<div class="tableList">
		<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:4%" />
			<col style="width:11%" />
			<col style="width:11%" />
			<col />
			<col style="width:20%" />
			<col style="width:20%" />
			<col style="width:6%" />
			<col style="width:6%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="file_vmi_seqsAll" /></th>
				<th scope="col">파일형식</th>
				<th scope="col">표현방식</th>
				<th scope="col">내용</th>
				<th scope="col">파일1</th>
				<th scope="col">파일2</th>
				<th scope="col">19세</th>
				<th scope="col">신규</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${empty listByViewDetailFile }">
		<tr>
			<td colspan="8">검색된 결과가 없습니다.</td>
		</tr>
		</c:if>
		<c:forEach items="${listByViewDetailFile }" var="item" varStatus="status">
		<tr>
			<td>
				<input type="checkbox" name="file_vmi_seqs" value="${item.vmi_seq }" />
			</td>
			<td>
				${item.vmi_mime_type }
			</td>
			<td>
				<c:choose>
					<c:when test="${item.vmi_prn_pos < 4 }">화면출력</c:when>
					<c:when test="${item.vmi_prn_pos eq 4 }">링크출력</c:when>
					<c:otherwise>-</c:otherwise>
				</c:choose>
			</td>
			<td class="subject">
				${item.vmi_title }
			</td>
			<td>
				<c:if test="${not empty item.vmi_file_name }">
					<a href="/upload/vmi_temp/${item.vmi_file_name }">${item.vmi_file_name }</a>
				</c:if>
				<c:if test="${empty item.vmi_file_name }">-</c:if>
			</td>
			<td>
				<c:if test="${not empty item.vmi_file_name_sub }">
					<a href="/upload/vmi_temp/${item.vmi_file_name_sub }">${item.vmi_file_name_sub }</a>
				</c:if>
				<c:if test="${empty item.vmi_file_name_sub }">-</c:if>
			</td>
			<td>
				${item.vmi_adult_chk eq 'Y' ? '예' : '아니요' }
			</td>
			<td>
				${item.vmi_new_chk eq 'Y' ? '예' : '아니요' }				
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
	<p class="sub_title">- 가치정보매핑</p>

	<div class="tableList">
		<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:4%" />
			<col />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="map_vvm_seqsAll" /></th>
				<th scope="col">작품/자료명</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${empty listByViewDetailMapping }">
		<tr>
			<td colspan="2">검색된 결과가 없습니다.</td>
		</tr>
		</c:if>
		<c:forEach items="${listByViewDetailMapping }" var="item" varStatus="status">
		<tr>
			<td>
				<input type="checkbox" name="map_vvm_seqs" value="${item.vvm_seq }" />
			</td>
			<td class="subject">
				<a href="/addservice/artContent/form.do?vvm_seq=${item.vvm_seq }" target="_blank">
					${item.vvm_title }
				</a>
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
	<p class="sub_title">- 관련 사이트</p>

	<div class="tableList">
		<table summary="게시판 글 목록">
		<caption>게시판 글 목록</caption>
		<colgroup>
			<col style="width:4%" />
			<col style="width:12%" />
			<col />
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="site_vru_seqsAll" /></th>
				<th scope="col">표현방식</th>
				<th scope="col">사이트</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${empty listByViewDetailSite }">
		<tr>
			<td colspan="3">검색된 결과가 없습니다.</td>
		</tr>
		</c:if>
		<c:forEach items="${listByViewDetailSite }" var="item" varStatus="status">
		<tr>
			<td>
				<input type="checkbox" name="site_vru_seqs" value="${item.vru_seq }" />
			</td>
			<td>
				${item.vru_type eq '1' ? '제목 링크' : '주소 출력' }
			</td>
			<td class="subject">
				<a href="${item.vru_url }" target="_blank">${item.vru_title }</a>
			</td>
		</tr>
		</c:forEach>
		</tbody>
		</table>
	</div>
	
	<div class="btnBox">
		<span class="btn white"><a href="#" class="site_delete_btn">삭제</a></span>
		<span class="btn dark fr"><a href="#void" class="site_insert">등록</a></span>
	</div>
</div>

</body>
</html>