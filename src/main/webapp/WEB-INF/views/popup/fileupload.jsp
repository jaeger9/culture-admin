<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:choose>
	<c:when test="${valid eq '0' }">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

	alert( '요청값이 올바르지 않습니다.' );
	window.close();

</script>
</head>
<body>
</body>
</html>	

	</c:when>
	<c:when test="${valid eq '2' }">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

	var data = {
		full_file_path	:	'${full_file_path }'
		,file_path		:	'${file_path }'
	};

	if (window.opener && window.opener.callback && window.opener.callback.fileUpload) {
		window.opener.callback.fileUpload( data );
	}

	window.close();

</script>
</head>
<body>
</body>
</html>	

	</c:when>
	<c:otherwise>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

	var frm			=	$('form[name=frm]');
	var menu_type	=	frm.find('input[name=menu_type]');
	var file		=	frm.find('input[name=file]');
	var insert_btn	=	frm.find('.insert_btn');
	var close_btn	=	frm.find('.close_btn');
	
	frm.submit(function () {
		if (file.val() == '') {
			file.focus();
			alert('파일을 선택해 주세요.');
			return false;
		} 
		return true;
	});

	insert_btn.click(function () {
		frm.submit();		
	});

	close_btn.click(function () {
		window.close();
		return false;
	});

});
</script>
</head>
<body>

<form name="frm" method="POST" action="/popup/fileupload.do" enctype="multipart/form-data" style="padding:20px;">
<fieldset class="searchBox">
	<legend>검색</legend>

	<input type="hidden" name="menu_type" value="${menu_type }" />

	<div class="tableWrite">
		<table summary="게시판 글 검색">
			<caption>게시판 글 검색</caption>
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">첨부파일</th>
					<td>
						<input type="file" name="file" />
						<span class="btn whiteS"><a href="#" class="insert_btn">등록</a></span>
						<c:if test="${file_type eq 'thumb'}">
							<p><span style="color:red;">※ 썸네일 이미지의 파일 용량은 2MB 이하로 등록해 주세요.</span></p>
						</c:if>
					</td>
				</tr> 
			</tbody>
		</table>
	</div>
</fieldset>

<div class="btnBox">
	<span class="btn dark fr"><a href="#" class="close_btn">닫기</a></span>
</div>
</form>

<script>

	$('[name=file]').on({
		'change': function() {
			if('${file_type}' == 'thumb') {
				if(this.files[0].size > 2*1024*1024) {
					alert('썸네일 이미지의 파일 용량이 너무 큽니다. 2MB 이하로 등록해 주세요.');
					$(this).val('');
					return false;
				}
			}
		}
	});

</script>

</body>
</html>
	
	</c:otherwise>
</c:choose>