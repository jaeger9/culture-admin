<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">

var callback = {
		patterncode : function (res) {
		/*
			JSON.stringify(res) = {
				"cateType"	:	"F"
				,"orgCode"	:	"NLKF02"
				,"orgId"	:	86
				,"category"	:	"도서"
				,"name"		:	"국립중앙도서관"
			}
		*/
		
		console.log(JSON.stringify(res) );
		if (res == null) {
			alert('Response Data null');
			return false;
		}
		
		$('input[name=usec_title]').val(res.xtitle);
		$('input[name=usec_upid]').val(res.did);
	}
};

$(function () {

	var frm = $('form[name=frm]');

	var title		= frm.find('input[name=title]');
	var usec_title		= frm.find('input[name=usec_title]');
	
	//layout
	
	//radio check
	if('${view.status}')$('input:radio[name="status"][value="${view.status}"]').prop('checked', 'checked');
	
	
	//select selected
	if('${view.category}')$("select").val('${view.category}').attr("selected", "selected");
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		
		if(title.val() ==''){
			alert('제품명 입력하세요');
			title.focus();
			return false;
		}
		
		if(usec_title.val() ==''){
			alert('활용문양 선택하세요');
			usec_title.focus();
			return false;
		}
		
		if($('textarea[name=content]').val() ==''){
			alert('비고 입력하세요');
			$('textarea[name=content]').focus();
			return false;
		}

		if(!$('input[name=status]:checked').is(':checked')){
			alert('사용여부 선택하세요');
			$('input[name=status]').focus();
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
        		frm.attr('action' ,'/pattern/apply/design/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}

        		frm.attr('action' ,'/pattern/apply/design/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/pattern/apply/design/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/pattern/apply/design/list.do';
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
	  	} else if($(this).html() == '선택') {
	  		window.open('/popup/patterncode.do', 'placePopup', 'scrollbars=yes,width=400,height=300');
	  	} 	
	});


	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/pattern/apply/design/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<table summary="전통문양 활용 작성">
				<caption>전통문양 활용  작성</caption>
				<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">제품명</th>
						<td colspan="3">
							<input type="text" name="title" style="width:670px" value="${view.title}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">구분</th>
						<td>
							<select title="공연/전시일 선택하세요" name="category">
								<c:forEach items="${categoryList }" var="categoryList" varStatus="status">
									<option value="${categoryList.code}">${categoryList.name}</option>
								</c:forEach>
							</select>
						</td>
						<th scope="row">등록일</th>
						<td>
							${view.reg_date}
							<c:if test="${not empty view.upd_date }">
								(최종수정일 ${view.upd_date}) 
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">활용문양</th>
						<td colspan="3">
							<input type="text" name="usec_title" style="width:600px" value="${view.upct_title}"/>
							<input type="hidden" name="usec_upid" value="${view.usec_upid}"/>
							<span class="btn whiteS"><a herf="#url">선택</a></span>
						</td>
					</tr>


					<tr>
						<th scope="row">썸네일이미지</th>
						<td colspan="3">
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
							<c:if test='${not empty view.thumbnail_name}'>
								<div class="inputBox">
									${view.thumbnail_name}
								</div>
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">크게보기 이미지</th>
						<td colspan="3">
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
							<c:if test='${not empty view.image_name}'>
								<div class="inputBox">
									${view.image_name }
								</div>
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">비고</th>
						<td colspan="3">
							<textarea name="content" style="width:100%;height:100px;"><c:out value="${view.content}" escapeXml="true" /></textarea>
						</td>	
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="status" value="W"/>대기</label>
								<label><input type="radio" name="status" value="Y"/>승인</label>
								<label><input type="radio" name="status" value="N" checked/>미승인</label>
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