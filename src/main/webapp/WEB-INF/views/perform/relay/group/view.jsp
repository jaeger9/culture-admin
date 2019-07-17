<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
var action = "";

var callback = {
		postalcode :function(res) {
			//{"buil_num2":"","buil_num1":"","road_name":"","zip_code":152090,"gi_num2":"","gi_num1":"","dong_name1":"개봉동","gu_name":"구로구","sido_name":"서울"}
			
			if (res == null) {
				alert('callback data null');
				return false;
			}
			var zip_code = res.zip_code.toString();
			
			$('input[name=zip_code]').val(zip_code.substring(0,3)+"-"+zip_code.substring(3,6));
			$('input[name=addr1]').val(res.sido_name + ' ' + res.gu_name + ' ' + res.dong_name1);
		}
}

$(function () {

	var frm = $('form[name=frm]');
	
	var name		= frm.find('input[name=name]');
	var homepage		= frm.find('input[name=homepage]');
	var tel		= frm.find('input[name=tel]');
	var zip_code		= frm.find('input[name=zip_code]');
	var addr1		= frm.find('input[name=addr1]');
	var addr2		= frm.find('input[name=addr2]');
	
	//layout
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	if('${view.zip_yn}')$('input:radio[name="zip_yn"][value="${view.zip_yn}"]').prop('checked', 'checked');
	
	//URL 미리보기
	goLink = function() { 
		alert("homepage");
		window.open($('input[name=homepage]').val(),'homepage' , 'width=570, height=420, scrollbars=yes, resizable=yes');
	}
	
	//공연상 선택
	$('span.btn.whiteS a').each(function(){
	  	$(this).click(function(){
	    	if( $(this).html() == '선택'){
	      		window.open('/popup/place.do', 'placePopup', 'scrollbars=yes,width=400,height=300');
	    	} else if( $(this).html() == '우편번호찾기'){
	    		//window.open('/popup/postalcode.do?zip_yn=' + $('input[name=zip_yn]:checked').val(),'postalcodePopup' , 'scrollbars=yes,width=500,height=420');
	    		window.open('/popup/jusoPopup.do','postalcodePopup' , 'width=570, height=420, scrollbars=yes, resizable=yes');
	    	} else if( $(this).html() == '유효성검사'){
	    		goLink();
	    	}
	  	});
	});
	
	//upload file 변경시 fake file div text 변경
	$('input[name=uploadFile]').each(function(){
		$(this).change(function(){
			$(this).next().find('input.inputText').val($(this).val());
		});
	});
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		if(action == 'delete'){
			return true;
		}
		
		if(name.val() ==''){
			alert('기관/단체명 입력하세요');
			name.focus();
			return false;
		}

		if(homepage.val() ==''){
			alert('홈페이지 입력하세요');
			homepage.focus();
			return false;
		}

		if(tel.val() ==''){
			alert('전화번호 입력하세요');
			tel.focus();
			return false;
		}
		
		if(zip_code.val() ==''){
			alert('우편번호 선택하세요');
			zip_code.focus();
			return false;
		}

		if(addr1.val() ==''){
			alert('주소 선택하세요');
			addr1.focus();
			return false;
		}

		if(addr2.val() ==''){
			alert('상세주소 입력하세요');
			addr2.focus();
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
        		frm.attr('action' ,'/perform/relay/group/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		action = "delete";
        		frm.attr('action' ,'/perform/relay/group/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/perform/relay/group/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/perform/relay/group/list.do';
        	}   		
    	});
	});
	
});

//도로명주소 Open Api
function jusoCallBack(sido, gugun, addr, addr2, zipNo){	
	$('input[name=zip_code]').val(zipNo);	//우편번호
	$('input[name=addr1]').val(addr);		//기본주소
	$('input[name=addr2]').val(addr2);		//상세주소
}
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/perform/relay/group/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<table summary="공연 참여 단체 작성">
				<caption>공연 참여 단체 글쓰기</caption>
				<colgroup>
					<col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">기관/단체명</th>
						<td colspan="3">
							<input type="text" name="name" id="name" style="width:670px"  value="${view.name }">
						</td>
					</tr>
					<tr>
						<th scope="row">홈페이지</th>
						<td colspan="3">
							<input type="text" name="homepage" id="homepage" style="width:570px"  value="${view.homepage }">
							<span class="btn whiteS"><button>유효성검사</button></span>
						</td>
					</tr>
					<tr>
						<th scope="row">전화번호</th>
						<td colspan="3">
							<input type="text" name="tel" id="tel" style="width:200px"  value="${view.tel }">
						</td>
					</tr>
					<tr>
						<th scope="row">썸네일 이미지</th>
						<td colspan="3">
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
							<c:if test="${not empty view.thumb_url}">
								<div class="inputBox">
									<input type="hidden" name="file_delete" value="${view.thumb_url}" />
									<label><input type="checkbox" name="imagedelete" value="Y" /> <strong>삭제</strong>  ${view.thumb_url}</label>
									<input type="hidden" name="thumb_url" value="${view.thumb_url }"/>
								</div>
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">상세주소</th>
						<td colspan="3">
							<div class="inputBox">
								<span class="btn whiteS"><a href="#url">우편번호찾기</a></span>
								<div style="display:none">
									<label><input type="radio" value="63" name="zip_yn" checked/>지번주소</label>
									<label><input type="radio" value="64" name="zip_yn"/>도로명주소</label>
								</div>
							</div>
							<div class="inputBox">
								<input type="text" name="zip_code" style="width:150px" value="${view.zip_code }" />
								<input type="text" name="addr1" style="width:400px" value="${view.addr1 }" />
							</div>
							<div>
								<input type="text" name="addr2" style="width:400px" value="${view.addr2 }" />
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">순번</th>
						<td colspan="3">
							<select name='order_seq' id='order_seq' class="inputSelectStyle">
								<c:forEach var="item" varStatus="i" begin="1" end="50" step="1">
									<option value="${item}" <c:if test="${item == view.order_seq}">selected="selected"</c:if>><c:out value="${item}" /></option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval" value="W" checked/> 대기</label>
								<label><input type="radio" name="approval" value="Y"/> 승인</label>
								<label><input type="radio" name="approval" value="N"/> 미승인</label>
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