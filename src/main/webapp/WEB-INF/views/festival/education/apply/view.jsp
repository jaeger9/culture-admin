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
	education : function (res) {
		/*
			JSON.stringify(res) = {
				"cateType"	:	"F"
				,"orgCode"	:	"NLKF02"
				,"orgId"	:	86
				,"category"	:	"도서"
				,"name"		:	"국립중앙도서관"
			}
		*/
		console.log(JSON.stringify(res));
		if (res == null) {
			alert('callback data null');
			return false;
		}
		
		$('input[name=p_seq]').val(res.seq);
		$('input[name=title]').val(res.title);
	},
	portalmember : function (res) {
		/*
			JSON.stringify(res) = {
				"cateType"	:	"F"
				,"orgCode"	:	"NLKF02"
				,"orgId"	:	86
				,"category"	:	"도서"
				,"name"		:	"국립중앙도서관"
			}
		*/
		console.log(JSON.stringify(res));
		if (res == null) {
			alert('callback data null');
			return false;
		}
		
		$('#userNameArea').empty();
		$('#userNameArea').append(res.name);
		$('input[name=user_id]').val(res.userId);
	}
};

$(function () {

	var frm = $('form[name=frm]');
	
	//layout
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	
	//select selected
	if('${view.email2}')$("select[name=email3]").val('${view.email2}').attr("selected", "selected");
	
	$('select[name=email3]').change(function(){  
		$('input[name=email2]').val( $(this).prop('option' , 'selected').val() );
	})
	
	//교육 선택
	$('span.btn.whiteS a').each(function(){
	  	$(this).click(function(){
	    	if( $(this).html() == '교육검색'){
	      		window.open('/popup/education.do', 'placePopup', 'scrollbars=yes,width=400,height=300');
	    	}  else if( $(this).html() == '유저검색'){
	    		window.open('/popup/portalmember.do', 'placePopup', 'scrollbars=yes,width=400,height=300');
	    	}
	  	});
	});
	





	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		if (!confirm('수정하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/festival/education/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/festival/education/apply/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/festival/education/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/festival/education/apply/list.do?seq=${view.p_seq}';
        	}   		
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/festival/education/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<table summary="교육 신청 작성">
				<caption>교육 신청 작성ㄴ</caption>
				<colgroup>
					<col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">교육명</th>
						<td colspan="3">
							<input type="text" name="title" id="title" style="width:300px"  value="${view.title}" readonly/>
							<span class="btn whiteS"><a href="#url" index="1">교육검색</a></span>
							</br><input type="hidden" name="p_seq" id="title" style="width:300px"  value="${view.p_seq}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">신청자</th>
						<td colspan="3">
							<span id="userNameArea">${view.user_name}</span>
							
							<c:if test="${ empty view.user_name}">
								<span class="btn whiteS"><a href="#url" index="1">유저검색</a></span>
							</c:if>
							<input type="text" name="user_id" id="title" style="width:50px"  value="${view.user_id}">
						</td>
					</tr>
					<tr>
						<th scope="row">신청자 연락처</th>
						<td colspan="3">
							<input type="text" name="tel" style="width:200px"  value="${view.tel}" />
						</td>
					</tr>
					<tr>
						<th scope="row">신청인원</th>
						<td>
							<input type="text" name="person" style="width:50px"  value="${view.person}" /> 명
						</td>
					</tr>
					<tr>
						<th scope="row">신청자 이메일</th>
						<td colspan="3">
							<input type="text" name="email1" style="width:100px" value="${view.email1}" /> @
							<input type="text" name="email2" style="width:150px" value="${view.email2}" />
							<select title="Email 선택하세요" name="email3">
								<option value="">직접입력</option>
								<c:forEach items="${emailList }" var="emailList" varStatus="status">
									<option value="${emailList.value}">${emailList.name}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval" value="W"/> 대기</label>
								<label><input type="radio" name="approval" value="Y"/> 사용</label>
								<label><input type="radio" name="approval" value="N"/> 미사용</label>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div class="btnBox textRight">
		<c:if test='${not empty view}'>
			<!-- <span class="btn white"><button type="button">수정</button></span> -->
			<!-- <span class="btn white"><button type="button">삭제</button></span> -->
		</c:if>
		<%-- <c:if test='${empty view }'>
			<span class="btn white"><button type="button">등록</button></span>
		</c:if> --%>
		<span class="btn gray"><button type="button">목록</button></span>
	</div>
</body>
</html>