<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- 
	20151006 : 이용환 : 에디터 변경을 위해 수정 
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
 -->
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="/crosseditor/js/namo_scripteditor.js"></script>

<script type="text/javascript">

var tableAppendDeleteOption ={
	"text" : {
		"minsize": 3 ,
		"maxSize" : 10 , 
		"lumpSize" : 3 , 
		"tableName" : "recomTextTable"
	} ,
	"img" : {
		"minsize": 3 ,
		"maxSize" : 9 , 
		"lumpSize" : 4 , 
		"tableName" : "recomImgTable"
	}
};

var target = null;
var targetView = null;

var callback = {
	/*
		JSON.stringify(res) ={
			"type":"문화포털 기자단",
			"name":"김혜연",
			"seq":19
		}
	*/
	author : function (res) {
		if (res == null) {
			alert('callback data null');
			return false;
		};

		$('input[name=editor]').val(res.name + '(' + res.type + ')');
		$('input[name=editor_name]').val(res.name);
		$('input[name=author_seq]').val(res.seq);
	} , 
	code : function (res) {
		if(res == null) { 
			alert('callback data null');
			return false;
		}
		
		console.log(JSON.stringify(res));
	} , 
	tag : function(res) { 
		if(res == null) { 
			alert('callback data null');
			return false;
		}
		
		console.log(JSON.stringify(res));
		
		$('input[name=tags]').val(res.names);
	},
	fileUpload : function (res) {
		// res.full_file_path
		// res.file_path
		target.val(res.file_path);
		targetView.html('<img src="/upload/recom/recom/' + res.file_path + '" width="100" height="100" alt="" />');
	}
};

$(function () {

	
	// 에디터 HTML 적용
	//oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
//	nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	
	var frm			=	$('form[name=frm]');
	var reg_date	=	frm.find('input[name=reg_date]');
	var editor_name	=	frm.find('input[name=editor_name]');
	var inumber		=	frm.find('input[name=inumber]');
	var title		=	frm.find('input[name=title]');
	var tags		=	frm.find('input[name=tags]');

	//layout
	new setDatepicker(reg_date);
	
	// 파일업로드
	$('.upload_pop_btn').click(function () {
		var p		=	$(this).parents('td:eq(0)');
		target		=	p.find('input[type=text]');
		targetView	=	p.find('.upload_pop_img');

		Popup.fileUpload('recom');
		return false;
	});
	
	if(!'${view.seq}'){
		var d = new Date();
		$('input[name=reg_date]').val(d.getFullYear() + '-' + (d.getMonth()+1) + '-' + d.getDate());
	}
	
	// upload file 변경시 fake file div text 변경
	/*
	$('input[name=uploadFile]').each(function(){
		$(this).change(function(){
			$(this).next().find('input.inputText').val($(this).val());
		});
	});
	*/
	
	//radio check
	if('${view.approval}')
		$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	
	if('${view.note1}')
		$('input:radio[name="note1"][value="${view.note1}"]').prop('checked', 'checked');
	
	//check box
	if('${view.top_yn}')
		$('input[name=top_yn][value="${view.top_yn}"]').prop('checked' , 'checked');
	
	if('${view.type}')
		$('input[name=type][value="${view.type}"]').prop('checked' , 'checked');
	
	//select selected
	if('${view.genre}')
		$("select[name=genre]").val('${view.genre}').attr("selected", "selected");
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		if(editor_name.val() ==''){
			alert('작가 선택하세요');
			editor_name.focus();
			return false;
		}

		/* if(inumber.val() ==''){
			alert('회차 입력하세요');
			inumber.focus();
			return false;
		} */
		
		if(title.val() == '') {
		    alert("제목 입력하세요");
		    title.focus();
		    return false;
		}
		
		if($('textarea[name=content]').val() == '') {
			alert("테마추천글 입력하세요");
			$('textarea[name=content]').focus();
		    return false;
		}
		
		/*
		if(tags.val() ==''){
			alert('태그 선택하세요');
			tags.focus();
			return false;
		}
		*/
		
		if(reg_date.val() ==''){
			alert('등록일 입력하세요');
			reg_date.focus();
			return false;
		}
		
		if($('input[name=type]:checked').length == 0){
			alert('추천문화(에디터,텍스트형) 선택후 해당 항목 입력후 등록하세요');
			//reg_date.focus();
			return false;
		}
		
		return true;
	});
	
	
	//URL 미리보기
	goLink = function() { 
		window.open($('input[name=url]').val());
	}
	
	//공연상 선택
	$('span.btn.whiteS a').each(function(){
	  	$(this).click(function(){
	    	if( $(this).html() == '작가선택'){
	      		window.open('/popup/author.do', 'placePopup', 'scrollbars=yes,width=400,height=630');
	    	} else if( $(this).html() == '태그선택'){
	    		window.open('/popup/newTag.do', 'placePopup', 'scrollbars=yes,width=400,height=630');
	    	} 
	    	
	    	return false;
	  	});
	});
	
	//table 추가 삭제
	$('span.btn.whiteS a').each(function(){
	  	$(this).click(function(){
	    	if( $(this).html() == '추가'){
	    		appendTr($(this));
	    	} else if( $(this).html() == '삭제'){
	    		deleteTr($(this));
	    	}
	  	});
	});
	
	appendTr = function(dom) {
		try{
			if($(dom).attr("type")) type = $(dom).attr("type");
			else throw "Job Type Undefined";
		
			tableName = tableAppendDeleteOption[type].tableName;
			lumpSize = tableAppendDeleteOption[type].lumpSize;
			maxSize = tableAppendDeleteOption[type].maxSize;
			
			trHtml = '';
			
			if($('table[name=' + tableName + '] tr').size() / lumpSize >= maxSize) {
				throw "최대 " + maxSize + "개만 가능합니다.";
			};
			
			$('table[name=' + tableName  + '] tr').filter(function(index){
				if(index < lumpSize){
					trHtml += '<tr>' + $(this).html() + '</tr>';  
				}
			});
			
		  	$('table[name=' + tableName + '] tbody').append(trHtml);
			  
		} catch (err) { 
			alert(err);
			return false;
		}
	}
	
	deleteTr = function(dom) {
		try{
			if($(dom).attr("type")) type = $(dom).attr("type");
			else throw "Job Type Undefined";
		
			tableName = tableAppendDeleteOption[type].tableName;
			lumpSize = tableAppendDeleteOption[type].lumpSize;
			minsize = tableAppendDeleteOption[type].minsize;
			
			if($('table[name=' + tableName + '] tr').size() / lumpSize <= minsize) {
				throw "최소 " + minsize + " 개는 존재 해야 합니다.";
			};
			
			for(index = 0 ; index < lumpSize ; index++)
				$('table[name=' + tableName + '] tr:last').remove();
			  
		} catch (err) { 
			alert(err);
			return false;
		}
	}
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		if (!confirm('수정하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/magazine/portalcolumn/update.do');
 //       		oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
               	document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/magazine/portalcolumn/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}        		
        		frm.attr('action' ,'/magazine/portalcolumn/insert.do');
//        		oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
               	document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/magazine/portalcolumn/list.do';
        	}   		
    	});
	});

	// 태그선택
	$('input[name=tags]').click(function() {
		window.open('/popup/newTag.do', 'placePopup', 'scrollbars=yes,width=400,height=630');
	});
});

function tagInit(){
	$('input[name=tagSeqs]').val('');
	$('input[name=tags]').val('');
}
</script>
</head>
<body>
<!-- 검색 필드 -->
<div class="tableWrite">
	<form name="frm" method="post" action=/magazine/portalcolumn/insert.do" enctype="multipart/form-data">
		<c:if test='${not empty view.seq}'>
			<input type="hidden" name="seq" value="${view.seq}"/>
		</c:if>
		<input type="hidden" name="cont_type" value="C"/>
		<input type="hidden" name="inumber" id="title" style="width:300px"  value="${view.inumber }">
		<div class="sTitBar">
			<h4>문화공감</h4>
		</div>
		<div class="tableWrite">	
			<table summary="문화공감 작성">
			<caption>문화공감 글쓰기</caption>
			<colgroup>
				<col style="width:15%" />
				<col style="width:35%" />
				<col style="width:15%" />
				<col style="width:35%" />
			</colgroup>
			<tbody>
			<tr>
				<th scope="row">작가</th>
				<td colspan="3">
					<input type="text" name="editor" id="title" style="width:200px"  value="${view.editor_name }">
					<input type="hidden" name="editor_name" id="title" style="width:200px"  value="${view.editor_name }">
					<input type="hidden" name="author_seq" value="${view.author_seq}"/>
					<span class="btn whiteS"><a href="#">작가선택</a></span>
				</td>
			</tr>
			<tr>
				<th scope="row">승인여부</th>
				<td colspan="3">
					<div class="inputBox">
						<label><input type="radio" name="approval" value="W"/> 대기</label>
						<label><input type="radio" name="approval" value="Y"/> 승인</label>
						<label><input type="radio" name="approval" value="N"/> 미승인</label>
					</div>
				</td>
			</tr>
			<%-- <tr>
				<th scope="row">회차</th>
				<td colspan="3">
					<input type="text" name="inumber" id="title" style="width:300px"  value="${view.inumber }">
					<input type="checkbox" value="Y" name="top_yn"/> 테마문화추천 베스트 
				</td>
			</tr> --%>
			<tr>
				<th scope="row">제목</th>
				<td colspan="3">
					<input type="text" name="title" id="title" style="width:300px"  value="${view.title }">
				</td>
			</tr>
			<tr>
				<th scope="row">테마추천글</th>
				<td colspan="3">
					<textarea name="content" style="width:100%;height:100px;"><c:out value="${view.content}" escapeXml="true" /></textarea>
				</td>	
			</tr>
			<tr style="display:none;">
				<th scope="row">관련태그</th>
				<td colspan="3">
					<input type="text" name="tags" id="title" style="width:400px"  value="${tagName }" readonly="readonly"/>
					<input type="hidden" name="tagSeqs" id="tagSeqs"/>
					<!-- 태그맵 테이블에 등록될 문화공감 메뉴 코드/시퀀스 -->
					<input type="hidden" name="menuType" id="menuType" value="${paramMap.menuType}"/>
					<input type="hidden" name="boardSeq" id="boardSeq" value="${view.seq}"/>
					<span class="btn whiteS"><a href="#">태그선택</a></span>
					<span class="btn darkS"><a href="#" onclick="javascript:tagInit();return;">초기화</a></span>
				</td>
			</tr>
			<tr>
				<th scope="row">메인 이미지</th>
				<td colspan="3">
					<%--
					<div class="fileInputs">
						<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
						<div class="fakefile">
							<input type="text" title="" class="inputText" />
							<span class="btn whiteS"><button>찾아보기</button></span>
						</div>
					</div>
					<c:if test='${not empty view.img_url}'>
						<div class="inputBox">
							<a href="/upload/recom/recom/${view.img_url}" target="_blank">${view.img_url}</a>
							<input type="hidden" value="${img_url}" name="img_url">
						</div>
					</c:if>
					--%>

					<input type="text" name="img_url" value="${view.img_url }" style="width:580px" />
					<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
					<div class="upload_pop_msg">(메인 이미지를 선택해 주세요.)</div>
					<div class="upload_pop_img">
						<c:if test="${not empty view.img_url }">
							<img src="/upload/recom/recom/${view.img_url }" width="100" height="100" alt="" />
						</c:if>
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row">썸네일 이미지</th>
				<td colspan="3">
					<%--
					<div class="fileInputs">
						<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
						<div class="fakefile">
							<input type="text" title="" class="inputText" />
							<span class="btn whiteS"><button>찾아보기</button></span>
						</div>
					</div>
					<c:if test='${not empty view.thumb_url}'>
						<div class="inputBox">
							<a href="/upload/recom/recom/${view.thumb_url}" target="_blank">${view.thumb_url}</a>
							<input type="hidden" value="${thumb_url}" name="thumb_url">
						</div>
					</c:if>
					--%>

					<input type="text" name="thumb_url" value="${view.thumb_url }" style="width:580px" />
					<span class="btn whiteS"><a href="#" class="upload_pop_btn">파일</a></span>
					<div class="upload_pop_msg">(썸네일 이미지를 선택해 주세요.)</div>
					<div class="upload_pop_img">
						<c:if test="${not empty view.thumb_url }">
							<img src="/upload/recom/recom/${view.thumb_url }" width="100" height="100" alt="" />
						</c:if>
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row">등록일</th>
				<td colspan="3">
					<input type="text" name="reg_date" value="${view.reg_date }" />
				</td>
			</tr>
			</tbody>
			</table>
		</div>
		<!-- <div class="sTitBar">
			<h4><label><input type="checkbox" name="type" value="1"/>추천문화(이미지 형)</label></h4>
			<span class="btn whiteS"><a href="#url" type="img">추가</a></span>
			<span class="btn whiteS"><a href="#url" type="img">삭제</a></span>
		</div> -->
		<%-- <div class="tableWrite">	
			<table name="recomImgTable" summary="문화공감 작성">
				<caption>문화공감 글쓰기</caption>
				<colgroup>
					<col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<c:if test="${ empty imgViewList }">
						<c:forEach begin="0" end="2" varStatus="status">
							<tr>
								<th scope="row">제목</th>
								<td colspan="3">
									<input type="text" name="img_title" style="width:670px" />
								</td>
							</tr>
							<tr>
								<th scope="row">추천글</th>
								<td colspan="3">
									<input type="text" name="img_content" style="width:670px"  />
								</td>
							</tr>
							<tr>
								<th scope="row">URL</th>
								<td colspan="3">
									<input type="text" name="img_url" style="width:670px"  />
								</td>
							</tr>
							<tr>
								<th scope="row">이미지</th>
								<td colspan="3">
									<div class="fileInputs">
										<input type="file" name="recomUploadFile" class="file hidden" title="첨부파일 선택" />
										<div class="fakefile">
											<input type="text" title="" class="inputText" />
											<span class="btn whiteS"><button>찾아보기</button></span>
										</div>
									</div>
									<c:if test="${'Y' eq view.img_url}">
										<div class="inputBox">
											<a href="/upload/${${img_url}}">${img_url}</a>
											<input type="hidden" value="${img_url}" name="img_url">
										</div>
									</c:if>
								</td>
							</tr>
						</c:forEach>
					</c:if>
					<c:if test="${not empty imgViewList }">
						<c:forEach items="${imgViewList}" var="list" varStatus="status">
							<tr>
								<th scope="row">제목</th>
								<td colspan="3">
									<input type="text" name="img_title" style="width:670px" value="${list.title}" />
								</td>
							</tr>
							<tr>
								<th scope="row">추천글</th>
								<td colspan="3">
									<input type="text" name="img_content" style="width:670px" value="${list.content}" />
								</td>
							</tr>
							<tr>
								<th scope="row">URL</th>
								<td colspan="3">
									<input type="text" name="img_url" style="width:670px" value="${list.url}" />
								</td>
							</tr>
							<tr>
								<th scope="row">이미지</th>
								<td colspan="3">
									<div class="fileInputs">
										<input type="file" name="recomUploadFile" class="file hidden" title="첨부파일 선택" />
										<div class="fakefile">
											<input type="text" title="" class="inputText" />
											<span class="btn whiteS"><button>찾아보기</button></span>
										</div>
									</div>
									${list.url}
									<c:if test="${'Y' eq view.img_url}">
										<div class="inputBox">
											<a href="/upload/${${img_url}}">${img_url}</a>
											<input type="hidden" value="${img_url}" name="img_url">
										</div>
									</c:if>
								</td>
							</tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
		</div> --%>
		<div class="sTitBar">
			<h4>
				<label><input type="checkbox" name="type" value="2"/>추천문화(에디터 형)</label>
			</h4>
		</div>
		<div class="tableWrite">	
			<table summary="문화공감 작성">
				<caption>문화공감 글쓰기</caption>
				<colgroup>
					<col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<td colspan="4">
		        			<!-- 20151006 : 이용환 : 에디터 변경을 위해 수정 
							<textarea id="contents" name="recom_content" style="width:100%;height:400px;"><c:out value="${view.recom_content }" escapeXml="true" /></textarea>
							-->
							<script type="text/javascript" language="javascript">
								var CrossEditor = new NamoSE('contents');
								CrossEditor.params.Width = "100%";
								CrossEditor.params.Height = "800px";
								CrossEditor.params.UserLang = "auto";
								CrossEditor.params.UploadFileSizeLimit = "image:10485760";
								CrossEditor.params.Font = {"NanumGothic":"나눔고딕","Dotum":"돋움", "Gulim":"굴림", "Batang":"바탕", "Gungsuh":"궁서", "맑은 고딕":"맑은 고딕"  ,"David":"David", "MS Pgothic":"MS Pgothic","Simplified Arabic":"Simplified Arabic","SimSun":"SimSun","Arial":"Arial","Courier New":"Courier New", "Tahoma":"Tahoma", "Times New Roman":"Times New Roman", "verdana":"Verdana"};
								CrossEditor.EditorStart();
								function OnInitCompleted(e){
									e.editorTarget.SetBodyValue(document.getElementById("contents").value);
								}
							</script>
							<textarea id="contents" name="recom_content" style="width:100%;height:400px;display:none;"><c:out value="${view.recom_content }" escapeXml="true" /></textarea>
						
						</td>	
					</tr>
				</tbody>
			</table>
		</div>
		<div class="sTitBar">
			<h4>
				<label><input type="checkbox" name="type" value="3"/>추천문화(텍스트 형)</label>
			</h4>
			<span class="btn whiteS"><a href="#url" type="text">추가</a></span>
			<span class="btn whiteS"><a href="#url" type="text">삭제</a></span>
		</div>
		<div class="tableWrite">	
			<table name="recomTextTable" summary="추천 문화(텍스트 형)">
				<caption>추천 문화(텍스트 형)</caption>
				<colgroup>
					<col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<c:if test="${ empty textViewList }">
						<c:forEach begin="0" end="2" varStatus="status">
							<tr>
								<th scope="row">제목</th>
								<td colspan="3">
									<input type="text" name="text_title" style="width:500px" />
								</td>
							</tr>
							<tr>
								<th scope="row">추천글</th>
								<td colspan="3">
									<input type="text" name="text_content" style="width:500px" />
								</td>
							</tr>
							<tr>
								<th scope="row">URL</th>
								<td colspan="3">
									<input type="text" name="text_url" style="width:500px"  />
								</td>
							</tr>
						</c:forEach>
					</c:if>
					<c:if test="${not empty textViewList }">
						<c:forEach items="${textViewList}" var="list" varStatus="status">
							<tr>
								<th scope="row">제목</th>
								<td colspan="3">
									<input type="text" name="text_title" style="width:500px" value="${list.title}" />
								</td>
							</tr>
							<tr>
								<th scope="row">추천글</th>
								<td colspan="3">
									<input type="text" name="text_content" style="width:500px" value="${list.content}" />
								</td>
							</tr>
							<tr>
								<th scope="row">URL</th>
								<td colspan="3">
									<input type="text" name="text_url" style="width:500px" value="${list.url}" />
								</td>
							</tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
		</div>
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