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
$(function () {
	var frm = $('form[name=frm]');
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');

	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		if (!confirm('수정하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/perform/review/update.do');
               	document.getElementById("contents").value = CrossEditor.GetBodyValue("XHTML");
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/perform/review/delete.do');
        		frm.submit();
        	} else if($(this).html() == '답변등록') {
        		url = "/perform/review/answer/view.do?seq=${view.seq}";
        		location.href = url;
        	} else if($(this).html() == '목록') {
        		console.log('목록');
        		location.href='/perform/review/list.do';
        	}   		
    	});
	});
	
	// 댓글 삭제 이벤트
	$('span.btn.whiteSS a').each(function(){
	  	$(this).click(function() {
	     
	    	var request = $.ajax({
	      		url: "/perform/review/commentdelete.do",
	      		type: "POST",
	      		data: { comment_seq : $(this).attr('comment_seq')}
	    	});

	    	request.done(function( msg ) {
		    	if(msg.success) {
		        	alert('삭제 되었습니다.');
		        	location.reload(true);
		      	} else { 
		            alert('삭제 실패 하였습니다.');
		      	}
	    	});
	    
	    	request.fail(function( jqXHR, textStatus ) {
	      		alert( "삭제 실패 하였습니다.: " + textStatus );
			});
	  	});
	});

	$('span.btn.whiteS a').each(function(){
		$(this).click(function() { 
			if($(this).html() == '공연/전시 선택') {
				window.open('/popup/rdfMetadataNew.do', 'webzinePopup', 'scrollbars=yes,width=400,height=630');
			}
		});
	});
});

var callback = {
	rdfMetadata : function (res) {
		if (res == null) {
			alert('CallBack Res Null');
			return false;
		} 

		$('#preformInfo').html(res.title);
		$('#preform_name').val(res.title);
		$('#uci').val(res.uci.replace('%2b','+'));
		
		return true;
	}
};
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/perform/review/insert.do">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<table summary="공연장 등록/수정">
				<caption>공연장 등록/수정</caption>
				<colgroup>
					<col style="width:17%" /><col style="width:33%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">제목</th>
						<td colspan="3">
							<input type="text" name="title" style="width:670px" value="${view.title}" />
						</td>
					</tr>
					<tr>
						<th scope="row">공연/전시 제목</th>
						<td colspan="3">
							<span id="preformInfo">${view.preform_name}</span>
							<span class="btn whiteS"><a href="#url">공연/전시 선택</a></span>
							<input type="hidden" value="<c:out value='${view.preform_name}'/>" name="preform_name" id="preform_name">
							<input type="hidden" value="${view.uci}" name="uci" id="uci">
						</td>
					</tr>
					<tr>
						<th scope="row">평점</th>
						<td colspan="3">
							${view.score} 점
						</td>
					</tr>
					<tr>
						<th scope="row">작성자</th>
						<td>
							${view.user_id}
						</td>
						<th scope="row">등록일</th>
						<td>
							${view.reg_date}
						</td>
					</tr>
					<tr>
						<th scope="row">내용</th>
						<td colspan="3">
		        			<!-- 20151006 : 이용환 : 에디터 변경을 위해 수정 
							<textarea id="contents" name="content" style="width:100%;height:400px;display:none;"><c:out value="${view.content }" escapeXml="true" /></textarea>
							-->
							<script type="text/javascript" language="javascript">
								var CrossEditor = new NamoSE('contents');
								CrossEditor.params.Width = "100%";
								CrossEditor.params.Height = "400px";
								CrossEditor.params.UserLang = "auto";
								CrossEditor.params.UploadFileSizeLimit = "image:10485760";
								CrossEditor.params.Font = {"NanumGothic":"나눔고딕","Dotum":"돋움", "Gulim":"굴림", "Batang":"바탕", "Gungsuh":"궁서", "맑은 고딕":"맑은 고딕"  ,"David":"David", "MS Pgothic":"MS Pgothic","Simplified Arabic":"Simplified Arabic","SimSun":"SimSun","Arial":"Arial","Courier New":"Courier New", "Tahoma":"Tahoma", "Times New Roman":"Times New Roman", "verdana":"Verdana"};
								CrossEditor.EditorStart();
								function OnInitCompleted(e){
									e.editorTarget.SetBodyValue(document.getElementById("contents").value);
								}
							</script>
							<textarea id="contents" name="content" style="width:100%;height:400px;display:none;"><c:out value="${view.content }" escapeXml="true" /></textarea>
							
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
				</tbody>
			</table>
		</form>
	</div>
	<div class="btnBox textRight">
		<span class="btn white fl"><button type="button">답변등록</button></span>
		<c:if test='${not empty view}'>
			<span class="btn white"><button type="button">수정</button></span>
			<span class="btn white"><button type="button">삭제</button></span>
		</c:if>
		<c:if test='${empty view }'>
			<span class="btn white"><button type="button">등록</button></span>
		</c:if>
		<span class="btn gray"><button type="button">목록</button></span>
	</div>
	<dl class="reple">
	<dt>댓글(${commentListCnt})</dt>
		<dd>
			<c:forEach items="${commentList }" var="list" varStatus="status">
			<c:if test="${ 'N' ne list.approval }">
				<div>
					<em>${list.user_id }</em><span>${list.reg_date} </span>
					<p>
						${list.content}
						<span class="btn whiteSS"><a href="#url" comment_seq="${list.seq}">삭제</a></span>
					</p>
				</div>
			</c:if>
			<c:if test="${ 'N' eq list.approval }">
				<div>
					<em>${list.user_id }</em><span>${list.reg_date} </span>
					<p>게시판의 운영정책에 위배되어 게시물이 삭제되었습니다.</p>
				</div>
			</c:if>
			</c:forEach>
		</dd>
	</dl>
</body>
</html>