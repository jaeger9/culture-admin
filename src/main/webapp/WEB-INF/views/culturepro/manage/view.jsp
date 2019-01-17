<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="/crosseditor/js/namo_scripteditor.js"></script>

<script type="text/javascript">
$(function() {
	var frm = $('form[name=frm]');

	frm.submit(function() {
		return true;
	});

	//삭제 , 목록 
	$('span > button').each(function() {
		$(this).click(function() {
			if ($(this).html() == '수정') {
				if (!confirm('수정 하시겠습니까?')) {
					return false;
				}
				
				$('input[name=updateStatus]').val($('input:radio[name="approval_yn"]:checked').val());
				frm.attr('action', '/culturepro/manage/statusUpdate.do');
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = '/culturepro/manage/list.do';
			}
		});
	});
});
</script>
</head>
<body>
<!-- 검색 필드 -->
<div class="tableWrite">
	<form name="frm" method="post" action="/culturepro/manage/form.do" enctype="multipart/form-data">
		<input type="hidden" name="seq" value="${paramMap.g_seq}"/>
		<input type="hidden" name="g_seq" value="${paramMap.g_seq}"/>
		<input type="hidden" name="updateStatus" value=""/>
		<input type="hidden" name="targetView" value="Y"/>
		
		<div class="tableWrite">	
			<table summary="문화융성앱 게시시설관리 컨텐츠">
				<caption>문화융성앱 게시시설관리 Mapping 컨텐츠</caption>
				<colgroup>
					<col style="width:15%" />
					<col style="width:%" />
					<col style="width:15%" />
					<col style="width:%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">고유번호</th>
						<td>
							${paramMap.g_seq }
						</td>
						<th scope="row">대표시설명</th>
						<td>
							${viewlist[0].facility_name }
						</td>
					</tr>
				</tbody>
			</table>	
		</div>
		<br/>
		
		<!-- 연결정보  -->
		<div>
			<table summary="문화융성앱 게시시설관리 컨텐츠">
				<caption>문화융성앱 게시시설관리 Mapping 컨텐츠</caption>
				<colgroup>
					<col style="width:%" />
				</colgroup>
				<tbody>
					<tr>
						<td><h3 class="subtitle01">혜택정보</h3></td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<!-- 리스트 -->
		<div class="tableList">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col style="width:6%" />
					<col style="width:15%" />
					<col style="width:25%" />
					<col style="width:18%" />
					<col style="width:%" />
				</colgroup>
				<thead>
				<tr>
					<th scope="col">번호</th>
					<th scope="col">구분</th>
					<th scope="col">제목</th>
					<th scope="col">할인/이벤트 기간</th>
					<th scope="col">할인/혜택/초대일시 상세보기</th>
				</tr>
				</thead>
				<tbody>
					<c:forEach items="${viewlist }" var="item" varStatus="status">
						<tr>
							<td>${status.index + 1 }</td>
							<td>[<c:out value="${item.type_code_nm}"/>]</td>
							<td class="subject"><c:out value="${item.title}"/></td>
							<td>${item.date}</td>
							<td class="subject"><c:out value="${item.desc}"/></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div><br/>
		
		<!-- 승인여부 -->
		<div class="tableWrite">	
			<table summary="문화융성앱 게시시설관리 컨텐츠">
				<caption>승인여부</caption>
				<colgroup>
					<col style="width:15%" />
					<col style="width:%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">승인여부</th>
						<td>
							<label><input type="radio" name="approval_yn" value="W" ${view.approval_yn eq 'W' ? 'checked="checked"' : '' } /> 대기</label>
							<label><input type="radio" name="approval_yn" value="Y" ${view.approval_yn eq 'Y' ? 'checked="checked"' : '' } /> 승인</label>
							<label><input type="radio" name="approval_yn" value="N" ${view.approval_yn eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>	
						</td>
					</tr>
				</tbody>
			</table>	
		</div>
	</form>
</div>
<div class="btnBox textRight">
	<span class="btn white"><button type="button">수정</button></span>
	<span class="btn gray"><button type="button">목록</button></span>
</div>
</body>
</html>