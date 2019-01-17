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

	// 부모 변수
	var frm			=	$('form[name=frm]');
	var seq			=	frm.find('input[name=seq]');
	var category1	=	frm.find('select[name=category1]');
	var category2	=	frm.find('select[name=category2]');
	var name		=	frm.find('input[name=name]');

	// 자식 변수
	var template		=	$('#template');
	var operation		=	$('#operation');
	var empty			=	$('#empty');
	var sub_delete_seqs	=	frm.find('input[name=sub_delete_seqs]');
	var add_btn			=	$('.add_btn');
	
	
	
	frm.submit(function () {
		// frm.serialize()
		// oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);

		// 부모
		if (seq.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		if (category1.val() == '') {
			category1.focus();
			alert('구분을 선택해 주세요.');
			return false;
		}
		if (category2.val() == '') {
			category2.focus();
			alert('상세분류를 선택해 주세요.');
			return false;
		}
		if (name.val() == '') {
			name.focus();
			alert('기관명을 입력해 주세요.');
			return false;
		}

		// 자식
		var valid = true;
		operation.find('> div').each(function () {
			var sub_site_name	=	$(this).find('input[name=sub_site_name]');
			var sub_site_url	=	$(this).find('input[name=sub_site_url]');
			if (sub_site_name.val() == '') {
				sub_site_name.focus();
				valid = false;
				alert('사이트명을 입력해 주세요.');
				return false;
			}
			if (sub_site_url.val() == '') {
				sub_site_url.focus();
				valid = false;
				alert('URL을 입력해 주세요.');
				return false;
			}
		});
		return valid;
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
				url			:	'/customer/site/delete.do'
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

	var oCategory = [];
	category2.find('option').each(function () {
		var t = $(this);
		var d = $(this).data();

		oCategory.push({
			name : $.trim(t.html())
			,value : t.val()
			,pcode : d.pcode
			,select : $(this).is(':selected')
		});
	});

	category1.change(function () {
		var pcode = $(this).val();
		var html = '';
		for (var i in oCategory) {
			if (pcode == oCategory[i].pcode) {
				html += '<option value="' + oCategory[i].value + '"' + (oCategory[i].select ? ' selected="selected"' : '') + '>' + oCategory[i].name + '</option>';
			}
		}
		category2.html(html);
	}).change();
	
	
	// 자식 삭제
	$(document).on('click', '.item_delete', function () {
		var p = $(this).parents('div.ids:eq(0)');
		var sub_seq = p.find('input[name=sub_seq]').val();

		if (sub_seq != '') {
			if (sub_delete_seqs.val() == '') {
				sub_delete_seqs.val( sub_seq );				
			} else {
				sub_delete_seqs.val( sub_delete_seqs.val() + ',' + sub_seq );
			}
		}

		p.remove();

		if (operation.find('div.ids').size() == 0) {
			empty.show();
		} else {
			empty.hide();
		}

		return false;
	});

	// 자식 추가
	add_btn.click(function () {
		operation.append( template.html() );
		operation.find('> div:last-child').find('span.index').text( operation.find('> div').size() );

		if (operation.find('div.ids').size() == 0) {
			empty.show();
		} else {
			empty.hide();
		}

		return false;
	});

	// 자식 초기 미등록 시
	if (operation.find('div.ids').size() == 0) {
		empty.show();
	} else {
		empty.hide();
	}
	
});
</script>
</head>
<body>

<form name="frm" method="POST" action="/customer/site/form.do" enctype="multipart/form-data">
<fieldset class="searchBox">
	<legend>상세 보기</legend>

	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="seq" value="${view.seq }" />

<!-- 부모 등록 -->
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
					<th scope="row">등록일</th>
					<td>
						<c:out value="${view.reg_date }" default="-" />
					</td>
				</tr>
</c:if>
				<tr>
					<th scope="row">구분</th>
					<td colspan="3">
						<select name="category1">
							<option value="1" ${view.category1 eq '1' ? 'selected="selected"' : '' }>분야별</option>
							<option value="2" ${view.category1 eq '2' ? 'selected="selected"' : '' }>소속별</option>
						</select>

						<select name="category2">
<c:forEach items="${categoryList }" var="j">
							<option value="${j.code }" data-pcode="${j.pcode }" ${view.category2 eq j.code ? 'selected="selected"' : '' }>${j.name }</option>
</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">기관명</th>
					<td colspan="3">
						<input type="text" name="name" value="${view.name }" style="width:670px" />
					</td>
				</tr>
			</tbody>
		</table>
	</div>
<!-- // 부모 등록 -->
<!-- 자식 등록 -->
	<input type="hidden" name="sub_delete_seqs" value="" />	
	<div id="empty" style="display:none;">
		등록된 사이트가 없습니다.
	</div>
	<div id="operation">
		<c:forEach items="${siteList }" var="item" varStatus="status">
		<div class="ids">
			<input type="hidden" name="sub_seq" value="${item.seq }" />
			<p>
				<span class="name">번호</span>
				<span class="index">${status.count } (${item.seq })</span>
			</p>
			<p>
				<span class="name">사이트명</span>
				<input type="text" name="sub_site_name" value="${item.site_name }" />
			</p>
			<p>
				<span class="name">URL</span>
				<input type="text" name="sub_site_url" value="${item.site_url }" />
			</p>
			<div class="btns">
				<a href="#" class="item_delete">삭제</a>
			</div>
		</div>
		</c:forEach>	
	</div>
<!-- // 자식 등록 -->

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="add_btn">사이트 추가</a></span>

		<span class="btn white"><a href="#" class="insert_btn">${empty view.seq ? '등록' : '수정' }</a></span>

		<c:if test="${not empty view.seq }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>

		<span class="btn gray"><a href="/customer/site/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

	<div id="template" style="display:none;">
		<div class="ids">
			<input type="hidden" name="sub_seq" value="" />
			<p>
				<span class="name">번호</span>
				<span class="index">0</span>
			</p>
			<p>
				<span class="name">사이트명</span>
				<input type="text" name="sub_site_name" value="" />
			</p>
			<p>
				<span class="name">URL</span>
				<input type="text" name="sub_site_url" value="" />
			</p>
			<div class="btns">
				<a href="#" class="item_delete">삭제</a>
			</div>
		</div>
	</div>

</body>
</html>