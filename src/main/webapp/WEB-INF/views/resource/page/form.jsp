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
	//파일 선택 시 파일명 표시되도록
	$('input[name=uploadFile]').each(function(i) {
		$(this).change(function() {
			$(this).parent().find('.inputText').val(getFileName($(this).val()));
		});
	});

    
    $(document).on("click","#page_type_a,#page_type_b,#page_type_c",function(e){
        $("body").append("<p style='cursor:pointer' id='preview'><img src='"+ $(this).attr("src") +"' width='650px' style='margin:3px;'/></p>"); //보여줄 이미지를 선언                       
        $("#preview")
            .css("top","30%")
            .css("left","40%")
            .fadeIn("fast"); //미리보기 화면 설정 셋팅
        pageTypeover = false;
    });
    $(document).on("mouseout","#preview",function(e){
   		$("#preview").remove();
    });
});


//파일명 가져오기
function getFileName(fullPath) {
	var pathHeader, pathEnd = 0;
	var fileName = "";
	
	if ( fullPath != "" ) {
		pathHeader = fullPath.lastIndexOf("\\");
		pathEnd = fullPath.length;
		fileName = fullPath.substring(Number(pathHeader)+1, pathEnd);
	}
	
	return fileName;
}

//메뉴 트리구조 불러오기
function goPop(){
	window.open('/popup/menuTree.do', 'menuTreePopup', 'scrollbars=yes,width=400,height=630');
}

//팝업에서 넘어온 값 셋팅
function setVal(data){
	$('#menu_id').val(data['menu_id']);
	$('#menu_name').html(data['menu_name']);
}

//insert
function insert(){
	if (!confirm('등록하시겠습니까?')) {
		return false;
	}
	if(!doValidation()){
		return;
	}
	
	$('form[name=frm]').attr('action' , "/resource/page/insert.do");
	$('form[name=frm]').submit();
}

//update
function update(){
	if (!confirm('수정하시겠습니까?')) {
		return false;
	}
	if('${view.page_type}' != $('input[name=page_type]:checked').val()){
		//기 작성된 메뉴의 존재 여부를 체크한다.
		if(!isMenu()){
			return false;
		}
	}
	if(!doValidation()){
		return;
	}
	$('form[name=frm]').attr('action' , "/resource/page/update.do");
	$('form[name=frm]').submit();
}

//delete
function onDelete(){
	$('form[name=frm]').attr('action' , "/resource/page/delete.do'");
	$('form[name=frm]').submit();
}

function isMenu(){
	var isFlg = false;
	$.ajax({
		url			:	'/resource/page/isMenuYn.do'
		,type		:	'post'
		,data		:	"pseq="+$('input[name=seq]').val()
		,dataType	:	'text'
		,async: false
		,success	:	function (res) {
			if(res == 'Y'){
				alert('해당 페이지에 작성된 메뉴가 존재합니다.\n 해당 메뉴를 삭제한 후 다시 시도해 주세요.');
				isFlg = false;
			}else{
				isFlg = true;
			}
		}
		,error : function(data, status, err) {
		}
	});
	return isFlg;
}

//목록으로 이동
function goList(){
	$('input[name=form_type]').prop('checked',false);
	$('input[name=page_type]').prop('checked',false);
	$('form[name=frm]').attr('action' , "/resource/page/list.do");
	$('form[name=frm]').submit();
}

//validation
function doValidation(){
	if($('#title').val() == ""){
		alert("문화정보자원명을 입력해주세요.");
		$('#title').val().focus();
		return false;
	}

	if($('#menu_name').html() == ''){
		alert('메뉴를 선택해주세요.');
		$('#menu_name').focus();
		return false;
	}
	
	if($('#sub_title').val() == ''){
		alert('서브주제명을 입력해주세요.');
		$('#sub_title').focus();
		return false;
	}
		
	return true;
}

</script>
<style type="text/css">
 .tableWrite .reqStar {color:#D20B1E; margin-right:3px;}
/* 미리보기 스타일 셋팅 */
#preview{
    z-index: 9999;
    position:absolute;
    border:0px solid #ccc;
    background:#333;
    padding:1px;
    display:none;
    color:#fff;
}
</style>
</head>
<body>
<div class="tableWrite">
	<form name="frm" method="post" action="/resource/page/list.do" enctype="multipart/form-data">
		<input type="hidden" name="seq" value="${view.seq}"/>
		<input type="hidden" name="search_type" value="${paramMap.search_type}"/>
		<input type="hidden" name="search_keyword" value="${paramMap.search_keyword}"/>
		<input type="hidden" name="srch_approval" value="${paramMap.srch_approval}"/>
		<div class="sTitBar">
			<h4>문화정보자원통합</h4>
		</div>
		<div class="tableWrite">	
			<table summary="문화정보자원통합 작성">
				<caption>문화정보자원통합 작성</caption>
				<colgroup>
					<col style="width:16%" />
					<col style="width:28%" />
					<col style="width:28%" />
					<col style="width:28%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><span class="reqStar">*</span>문화정보자원명</th>
						<td colspan="3">
							<input type="text" name="title" id="title" value="${view.title}" style="width:500px" maxlength="30" />
						</td>
					</tr>
					<tr>
						<th scope="row"><span class="reqStar">*</span>메뉴 선택</th>
						<td colspan="3">
							<span id="menu_name">${view.menu_name}</span>
							<input type="hidden" name="menu_id" id="menu_id" value="${view.menu_id}"></input>
							<span class="btn whiteS"><a href="#url" onclick="javascript:goPop();return;" style="width:80px;">메뉴 선택</a></span>
						</td>
					</tr>
					<tr>
						<th scope="row"><span class="reqStar">*</span>서브주제명</th>
						<td colspan="3">
							<input type="text" name="sub_title" id="sub_title" style="width:500px" maxlength="30" value="${view.sub_title }"/>
							<span>한글 30자까지 입력</span> 
						</td>
					</tr>
					<tr></tr>
					<tr>
						<th scope="row">상단이미지</th>
						<td colspan="3">
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
							<c:if test="${not empty view.image}">
								<div class="inputBox">
									<label><input type="checkbox" name="imagedelete" value="Y" /> <strong>삭제</strong>  ${view.image}</label>
								</div>
							</c:if>
							<div>
								<c:if test='${not empty view.image }'>
									<img width="100%" alt="" src="/upload/resource/page/${view.image}">
								</c:if>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row"><span class="reqStar">*</span>타입선택</th>
						<td style="cursor:pointer;">
							<label><input type="radio" name="page_type" value="A" <c:if test="${view.page_type eq 'A' or empty view }">checked</c:if> /> A타입(3단, 1페이지구성)</label>
							<img src="/images/resource/pageA.jpg" alt="A타입 페이지" width="180px" height="100px" id="page_type_a"/>
						</td>
						<td style="cursor:pointer;">
							<label><input type="radio" name="page_type" value="B" <c:if test="${view.page_type eq 'B'}">checked</c:if> /> B타입(3단, 메뉴구성)</label>
							<img src="/images/resource/pageB.jpg" alt="B타입 페이지" width="180px" height="100px" id="page_type_b"/>
						</td>
						<td style="cursor:pointer;">
							<label><input type="radio" name="page_type" value="C" <c:if test="${view.page_type eq 'C'}">checked</c:if> /> C타입(2단, 메뉴구성)</label>
							<img src="/images/resource/pageC.jpg" alt="C타입 페이지" width="180px" height="100px" id="page_type_c"/>
						</td>
					</tr>
					<tr>
						<th scope="row"><span class="reqStar">*</span>3단 구성 선택</th>
						<td>
							<label><input type="radio" name="form_type" value="1" <c:if test="${view.form_type eq '1' or empty view }">checked</c:if> /> 문화포털 제공 형태(자동생성)</label>
						</td>
						<td colspan="2">
							<label><input type="radio" name="form_type" value="2" <c:if test="${view.form_type eq '2'}">checked</c:if> /> 배너형태(수동입력)</label>
						</td>
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval" value="W" <c:if test="${view.approval eq 'W' or empty view.approval}">checked</c:if> /> 대기</label>
								<label><input type="radio" name="approval" value="Y" <c:if test="${view.approval eq 'Y'}">checked</c:if> /> 승인</label>
								<label><input type="radio" name="approval" value="N" <c:if test="${view.approval eq 'N'}">checked</c:if> /> 미승인</label>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>
</div>
<div class="btnBox textRight">
	<c:if test='${not empty view}'>
		<span class="btn white"><button type="button" onclick="javascript:update();return;">수정</button></span>
		<span class="btn white"><button type="button" onclick="javascript:onDelete();return;">삭제</button></span>
	</c:if>
	<c:if test='${empty view }'>
		<span class="btn white"><button type="button" onclick="javascript:insert();return;">등록</button></span>
	</c:if>
	<span class="btn gray"><button type="button" onclick="javascript:goList();return;">목록</button></span>
</div>
</body>
</html>