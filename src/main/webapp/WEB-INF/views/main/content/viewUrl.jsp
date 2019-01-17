<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
$(function () {
	$('body').keydown(function(event) {
		if(event.keyCode == '13'){
			return false;
		}
	});

	$('input[name=title]').each(function(i) {
		$(this).focusin(function() {
			if( $(this).val() == '메뉴명을 입력하세요.' ){
				$(this).val('');
			}
		});
		$(this).focusout(function() {
			if( $(this).val() == '' ){
				$(this).val('메뉴명을 입력하세요.');
			}
		});
		
		if( $(this).val() == '' ){
			$(this).val('메뉴명을 입력하세요.');
		}
	});

	$('input[name=url]').each(function(i) {
		$(this).focusin(function() {
			if( $(this).val() == 'URL을 입력하세요.' ){
				$(this).val('');
			}
		});
		$(this).focusout(function() {
			if( $(this).val() == '' ){
				$(this).val('URL을 입력하세요.');
			}
		});
		
		if( $(this).val() == '' ){
			$(this).val('URL을 입력하세요.');
		}
	});
});

function goList(){
	action = "list";
	$('form[name=frm]').attr('action' ,'/main/content/list.do');
	$('form[name=frm]').submit();
}

function insert(){
	if (!confirm('등록하시겠습니까?')) {
		return false;
	}
	
	if( !doValidation() ){
		return;
	}
	
	if($('input[name=new_win_chk]').is(":checked")){
		$('input[name=new_win_yn]').val('Y');
	}else{
		$('input[name=new_win_yn]').val('N');
	}
	
	action = "insert";
	$('form[name=frm]').attr('action' ,'/main/content/insert.do');
	$('form[name=frm]').submit();
}

function update(){
	if (!confirm('수정하시겠습니까?')) {
		return false;
	}

	if( !doValidation() ){
		return;
	}	

	if($('input[name=new_win_chk]').is(":checked")){
		$('input[name=new_win_yn]').val('Y');
	}else{
		$('input[name=new_win_yn]').val('N');
	}
	
	action = "update";
	$('form[name=frm]').attr('action' ,'/main/content/update.do');
	$('form[name=frm]').submit();
}

function deleteMain(){
	if (!confirm('삭제 하시겠습니까?')) {
		return false;
	}
	action = "delete";
	$('form[name=frm]').attr('action' ,'/main/content/delete.do');
	$('form[name=frm]').submit();
}

function doValidation(){
	if( $('input[name=mainTitle]').val() == '' ){
		alert("제목을 입력하세요.");
		$('input[name=mainTitle]').focus();
		return false;
	}
	if( $('input[name=mainWriter]').val() == '' ){
		alert("등록자를 입력하세요.");
		$('input[name=mainWriter]').focus();
		return false;
	}
	if( $('input[name=title]').val() == '' ){
		alert("문화산업 메뉴명을 입력하세요.");
		$('input[name=title]').focus();
		return false;
	}
	if( $('input[name=url]').val() == '' ){
		alert("URL을 입력하세요.");
		$('input[name=url]').focus();
		return false;
	}
	return true;
}
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" enctype="multipart/form-data">
			<input type="hidden" name="searchApproval" value="${paramMap.searchApproval}"/>
			<input type="hidden" name="new_win_yn" value=""/>
			<c:if test='${not empty view.seq }'>
				<input type="hidden" name="pseq" value="${view.seq }"/>
			</c:if>
			<input type="hidden" name="menu_type" value="${paramMap.menu_type }"/>
			<input type="hidden" name="code" value="${paramMap.menu_type }"/>
			<ul class="tab">
				<c:forEach items="${tabList }" var="tabList" varStatus="status">
					<li>
						<a href="/main/content/list.do?menu_type=${tabList.code}" <c:if test="${ paramMap.menu_type eq tabList.code }"> class="focus"</c:if>>
							${tabList.name}
						</a>
					</li>
				</c:forEach>
			</ul>
			
			<!-- 지식이 더해집니다. view div -->
			<div id="notiDiv">
				<table summary="소식/교육/채용 작성">
					<caption>소식/교육/채용 작성</caption>
					<colgroup>
						<col style="width:15%" />
						<col style="*" />
						<col style="width:15%" />
						<col style="width:10%" />
						<col style="width:20%" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">제목</th>
							<td colspan="2">
								<input type="text" title="메인콘텐츠 제목" name="mainTitle" style="width:100%;" value="${view.title}"/>
							</td>
							<th scope="row">등록자</th>
							<td>
								<input type="text" title="등록자" name="mainWriter" style="width:100%;" value="${view.writer}"/>
							</td>
						</tr>
						
						<c:if test="${empty subList }">
							<tr>
								<th scope="row">문화산업</th>
								<td colspan="4">
									<input type="text" title="메뉴명" name="title" style="width:50%;"/>
								</td>
							</tr>
							<tr>
								<th scope="row">URL</th>
								<td colspan="4">
									<input type="text" title="URL" name="url" style="width:70%;"/>&nbsp;&nbsp;
									<input type="checkbox" title="새창열림여부" name="new_win_chk"/>&nbsp;새창
								</td>
							</tr>
							<input type="hidden" name="seq" value=""/>
						</c:if>
						
						<c:if test="${not empty subList }">
							<c:forEach var="li" items="${subList }">
								<tr>
									<th scope="row">문화산업</th>
									<td colspan="4">
										<input type="text" title="메뉴명" name="title" style="width:50%;" value="${li.title}"/>
									</td>
								</tr>
								<tr>
									<th scope="row">URL</th>
									<td colspan="4">
										<input type="text" title="URL" name="url" style="width:70%;" value="${li.url}"/>&nbsp;&nbsp;
										<input type="checkbox" ${li.new_win_yn eq 'Y' ? 'checked="checked"':''} title="새창열림여부" name="new_win_chk"/>&nbsp;새창
									</td>
								</tr>
								<input type="hidden" name="seq" value="${li.seq }"/>
							</c:forEach>
						</c:if>
						<tr>
							<th scope="row">승인여부</th>
							<td colspan="4">
								<div class="inputBox">
									<label><input type="radio" name="approval" value="Y" ${view.approval eq 'Y' ? 'checked="checked"':''}/> 승인</label>
									<label><input type="radio" name="approval" value="N" ${view.approval eq 'N' or empty view.approval ? 'checked="checked"':''}/> 미승인</label>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 함께즐겨요 view div -->
			
			
		</form>
	</div>
	<div class="btnBox textRight">
		<c:if test='${not empty view}'>
			<span class="btn white"><button type="button" onclick="javascript:update();return;">수정</button></span>
			<span class="btn white"><button type="button" onclick="javascript:deleteMain();return;">삭제</button></span>
		</c:if>
		<c:if test='${empty view }'>
			<span class="btn white"><button type="button" onclick="javascript:insert();return;">등록</button></span>
		</c:if>
		<span class="btn gray"><button type="button" onclick="javascript:goList();return;">목록</button></span>
	</div>
</body>
</html>