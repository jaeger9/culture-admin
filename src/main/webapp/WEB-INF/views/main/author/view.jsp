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
	var author_id		= frm.find('input[name=author_id]');
	var name			= frm.find('input[name=name]');
	var organize		= frm.find('input[name=organize]');
	var job_name		= frm.find('input[name=job_name]');
	var url				= frm.find('input[name=url]');
	var email			= frm.find('input[name=email]');
	var email_address	= frm.find('input[name=email_address]');
	
	//layout
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	
	//select selected
	if('${view.type}'){
		$("select[name=type]").val('${view.type}').attr("selected", "selected");
		if($("select[name=type]").val()=='1'){
			document.getElementById('div_sub_type_2').style.display = "none";
			document.getElementById('div_sub_type_1').style.display = "block";
			$("select[name=sub_type]").val('${view.sub_type}').attr("selected", "selected");
		}
	}
	
	
	
	//mailAddress change
	$('select[name=mailAddressList]').change(function(){  
		$('input[name=email_address]').val( $(this).prop('option' , 'selected').val() );
	})
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		
		if(action == 'list'){
			return true;
		}
		

		if($('select[name=type] > option:selected').val() == '') {
			alert('필진유형 선택하세요');
			$('select[name=type]').focus();
			return false;
		}
		
		if(author_id.val() ==''){
			alert('필진 아이디 입력하세요');
			author_id.focus();
			return false;
		}
		
		if(name.val() ==''){
			alert('이름 입력하세요');
			name.focus();
			return false;
		}

		if(organize.val() ==''){
			alert('조직 입력하세요');
			organize.focus();
			return false;
		}

		if(job_name.val() ==''){
			alert('직업 입력하세요');
			job_name.focus();
			return false;
		}

/* 		if(url.val() ==''){
			alert('링크주소 입력하세요');
			url.focus();
			return false;
		} */

		if(email.val() ==''){
			alert('이메일 입력하세요');
			email.focus();
			return false;
		}

		if(email_address.val() ==''){
			alert('이메일 주소 입력하세요');
			email_address.focus();
			return false;
		}
		
		return true;
	});
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		if (!confirm('수정하시겠습니까?')) {
    				return false;
    			}
        		frm.attr('action' ,'/main/author/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
    				return false;
    			}
        		frm.attr('action' ,'/main/author/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
    				return false;
    			}
        		frm.attr('action' ,'/main/author/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		action = "list";
        		frm.attr('action' ,'/main/author/list.do');
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

function change_field(){
	
	if($("select[name=type]").val()!='1'){
		if($("select[name=type]").val()=='2'){
			$('input[name=organize]').val("아시아문화중심도시 대학생 기자단");
			$('input[name=url]').val("http://blog.naver.com/cultureasia");
		}
		if($("select[name=type]").val()=='3'){
			$('input[name=organize]').val("문화체육관광부 대학생 기자단");
			$('input[name=url]').val("http://culturenori.tistory.com");
		}
		if($("select[name=type]").val()=='4'){
			$('input[name=organize]').val("");
			$('input[name=url]').val("");
		}
		if($("select[name=type]").val()=='5'){
			$('input[name=organize]').val("문화체육관광부 위클리공감");
			$('input[name=url]').val("http://www.korea.kr/gonggam/");
		}
		if($("select[name=type]").val()=='6'){
			$('input[name=organize]').val("");
			$('input[name=url]').val("");
		}
		
		document.getElementById('div_sub_type_1').style.display = "none";
		document.getElementById('div_sub_type_2').style.display = "block";
	}else{
		
		$('input[name=organize]').val("문화포털 기자단");
		$('input[name=url]').val("http://www.culture.go.kr");
		document.getElementById('div_sub_type_2').style.display = "none";
		document.getElementById('div_sub_type_1').style.display = "block";
	}
}
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/main/code/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.seq }'>
				<input type="hidden" name="seq" value="${view.seq }"/>
			</c:if>
			<table summary="공통 코드 작성">
				<caption>공통 코드  작성</caption>
				<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">필진유형</th>
						<td colspan="3">
							<select title="출처 선택" name="type" onchange="javascript:change_field();">
								<option value="">전체</option>
								<c:forEach items="${sourceList}" var="list" varStatus="status">
									<option value="${list.value}">${list.name}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">상세유형</th>
						<td colspan="3">
						<div id="div_sub_type_1" style="display:none">
							<select title="출처 선택" name="sub_type">
								<option value="">전체</option>
								<c:forEach items="${subSourceList}" var="list" varStatus="status">
									<option value="${list.value}">${list.name}</option>
								</c:forEach>
							</select>
						</div>
						<div id="div_sub_type_2" style="display:block">
							<select title="출처 선택" name="sub_type">
								<option value="">전체</option>
							</select>
						</div>
						</td>
					</tr>
					<tr>
						<th scope="row">필진 아이디</th>
						<td colspan="3">
							<input type="text" name="author_id" style="width:100px" value="${view.author_id}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">이름</th>
						<td colspan="3">
							<input type="text" name="name" style="width:100px" value="${view.name}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">조직</th>
						<td colspan="3">
							<input type="text" name="organize" style="width:150px" value="${view.organize}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">직업</th>
						<td colspan="3">
							<input type="text" name="job_name" style="width:100px" value="${view.job_name}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">링크주소</th>
						<td colspan="3">
							<input type="text" name="url" style="width:670px" value="${view.url}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">프로필사진</th>
						<td colspan="3">
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
							<c:if test='${not empty view.photo}'>
								<div class="inputBox">
									<label><input type="checkbox" name="imagedelete" value="Y" /> <strong>삭제</strong>  ${view.photo }</label>
								</div>
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">이메일</th>
						<td colspan="3">
							<input type="text" name="email" style="width:100px" value="${view.email}"/> @
							<input type="text" name="email_address" style="width:150px" value="${view.email_address}"/>
							
							<select name="mailAddressList" title="검색어 선택">
								<option value="">직접입력</option>	
								<c:forEach items="${mailAddressList }" var="list" varStatus="status">
									<option value="${list.value}">${list.name }</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">소개</th>
						<td colspan="3">
							<textarea name="intro" style="width:670px;height:100px;text-align:left" rows=5>${view.intro}</textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval" value="Y"/> 승인</label>
								<label><input type="radio" name="approval" value="N" checked/> 미승인</label>
							</div>
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
<script type="text/javascript">

</script>

