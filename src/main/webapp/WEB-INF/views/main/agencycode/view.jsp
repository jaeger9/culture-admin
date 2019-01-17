<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
var action = "";

$(function () {

	var frm = $('form[name=frm]');
	var orgIdCheckYN		= frm.find('input[name=orgIdCheckYN]');
	var agent				= frm.find('input[name=agent]');
	var name				= frm.find('input[name=name]');
	var org_code			= frm.find('input[name=org_code]');
	var url					= frm.find('input[name=url]');
	var email				= frm.find('input[name=email]');
	var phone_no			= frm.find('input[name=phone_no]');
	var fax_no				= frm.find('input[name=fax_no]');
	var charge				= frm.find('input[name=charge]');
		
	//layout
	
	//radio check
	if('${view.agent}')$('input:radio[name="agent"][value="${view.agent}"]').prop('checked', 'checked');
	if('${view}')$('input:radio[name="use_status"][value="${view.use_status}"]').prop('checked', 'checked');
	
	//select selected
	if('${view.cate_type}')$("select").val('${view.cate_type}').attr("selected", "selected");
	
	frm.submit(function(){
		if(action == 'list'){
			return true;
		}
		//DB NOT NULL 기준 체크
		if(name.val() ==''){
			alert('기관명 입력하세요');
			name.focus();
			return false;
		}

		if(org_code.val() ==''){
			alert('기관코드 입력하세요');
			org_code.focus();
			return false;
		}
		
		if(orgIdCheckYN.val() !='Y' ){
			alert('기관코드 중복 체크하세요');
			orgIdCheckYN.focus();
			return false;
		}
		
		if(!$('select[name=cate_type] > option:selected').val()) {
			alert('분류 선택하세요');
			$('select[name=cate_type]').focus();
			return false;
		}

		if(url.val() ==''){
			alert('URL 입력하세요');
			url.focus();
			return false;
		}
		
		/* 
		if(email.val() ==''){
			alert('구분(*) 입력하세요');
			email.focus();
			return false;
		}

		if(phone_no.val() ==''){
			alert('구분(*) 입력하세요');
			phone_no.focus();
			return false;
		}

		if(fax_no.val() ==''){
			alert('구분(*) 입력하세요');
			fax_no.focus();
			return false;
		}

		if(charge.val() ==''){
			alert('구분(*) 입력하세요');
			charge.focus();
			return false;
		}
		 */
		
		return true;
	});
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		if (!confirm('수정하시겠습니까?')) {
    				return false;
    			}
        		frm.attr('action' ,'/main/agencycode/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
    				return false;
    			}
        		frm.attr('action' ,'/main/agencycode/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
    				return false;
    			}
        		frm.attr('action' ,'/main/agencycode/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		action = "list";
        		frm.attr('action' ,'/main/agencycode/list.do');
        		frm.submit();
        	}   		
    	});
	});
	
	//중복체크
	$('span.btn a').click(function(){
		if($(this).html() == '중복체크') {
		    code = $('input[name=org_code]').val();
	
		    var request = $.ajax({
		      url: "/main/agencycode/codeOverlapCheck.do",
		      type: "POST",
		      data: { org_code : code}
		    });
	
		    request.done(function( msg ) {
		    	if(msg.codeCnt < 1) {
		        	alert('사용 가능합니다.');
		          	$('input[name=orgIdCheckYN]').val('Y');
		      	} else { 
		          	alert('이미 등록된 코드 입니다.');
		          	$('input[name=orgIdCheckYN]').val('N');
		        	$('input[name=orgIdCheckYN]').focus();
		      	}
		    });
		    
		    request.fail(function( jqXHR, textStatus ) {
		      	alert( "Request failed: " + textStatus );
			});
	  	}
	});


	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/main/code/insert.do" enctype="multipart/form-data">
			<input type="hidden" name="orgIdCheckYN" value="<c:if test='${not empty view.org_id }'>Y</c:if>"></input>
			<c:if test='${not empty view.org_id }'>
				<input type="hidden" name="org_id" value="${view.org_id }"/>
			</c:if>
			<table summary="공통 코드 작성">
				<caption>공통 코드  작성</caption>
				<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">구분(*)</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="agent" value="L" checked/> 연계기관</label>
								<label><input type="radio" name="agent" value="R"/> 등록기관</label>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">기관명(*)</th>
						<td colspan="3">
							<input type="text" name="name" style="width:670px" value="${view.name}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">기관코드(*)</th>
						<td colspan="3">
							<input type="text" name="org_code" style="width:100px" value="${view.org_code}"/>
							<span class="btn whiteS"><a href="#url">중복체크</a></span>
						</td>
					</tr>
					<tr>
						<th scope="row">분류(*)</th>
						<td colspan="3">
							<select name="cate_type" title="검색어 선택">
								<option value="">선택</option>	
								<c:forEach items="${categoryList }" var="list" varStatus="status">
									<option value="${list.value}">${list.name }</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">URL(*)</th>
						<td colspan="3">
							<input type="text" name="url" style="width:500px" value="${view.url}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">이메일</th>
						<td colspan="3">
							<input type="text" name="email" style="width:500px" value="${view.email}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">대표전화</th>
						<td colspan="3">
							<input type="text" name="phone_no" style="width:500px" value="${view.phone_no}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">팩스</th>
						<td colspan="3">
							<input type="text" name="fax_no" style="width:500px" value="${view.fax_no}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">담당자</th>
						<td colspan="3">
							<input type="text" name="charge" style="width:500px" value="${view.charge}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">이미지</th>
						<td colspan="3">
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
							<c:if test='${not empty view.file_sysname}'>
								<div class="inputBox">
									<label><input type="checkbox" name="imagedelete" value="Y" /> <strong>삭제</strong>  ${view.file_sysname }</label>
								</div>
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="use_status" value="USED"/> 승인</label>
								<label><input type="radio" name="use_status" value=""/> 미승인</label>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">기관소개</th>
						<td colspan="3">
							<textarea name="etc" style="width:670px;height:100px;text-align:left" rows=5 >${view.etc}</textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">공공문화정보 주요내용</th>
						<td colspan="3">
							<textarea name="content" style="width:670px;height:100px;text-align:left" rows=5>${view.content}</textarea>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div class="btnBox textRight">
		<c:if test='${not empty view}'>
			<span class="btn white"><button type="button">수정</button></span>
			<span class="btn white"><button type="button">삭제</button></span>
		</c:if>
		<c:if test='${empty view }'>
			<span class="btn white"><button type="button">등록</button></span>
		</c:if>
		<span class="btn gray"><button type="button">목록</button></span>
	</div>
</body>
</html>