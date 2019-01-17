<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
var infoTxt = new Array();
infoTxt['url'] = "URL을 입력하세요";
infoTxt['summary'] = "텍스트를 입력하세요";
infoTxt['title'] = "텍스트를 입력하세요(볼드 영역)";

$(function () {
	//파일 선택 시 파일명 표시되도록
	$('input[name=uploadFile]').each(function(i) {
		$(this).change(function() {
			$(this).parent().find('.inputText').val(getFileName($(this).val()));
		});
	});

	//input박스에 포커스 in out시 안내메시지 보여주고 안보여주고하기
	$('#knowDiv').find('textarea, input').each(function(i) {
			$(this).focusin(function() {
				if( $(this).val() == infoTxt[$(this).attr('name')] ){
					$(this).val('');
				}
			});
			$(this).focusout(function() {
				if( $(this).val() == '' ){
					$(this).val(infoTxt[$(this).attr('name')]);
				}
			});
			
			if( $(this).val() == '' ){
				$(this).val(infoTxt[$(this).attr('name')]);
			}
	});
	
	$('body').keydown(function(event) {
		if(event.keyCode == '13'){
			if(event.target.nodeName != "TEXTAREA"){
				return false;
			}
		}
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

function goList(){
	action = "list";
	$('form[name=frm]').attr('action' ,'/main/content/list.do');
	$('form[name=frm]').submit();
}

function insert(){
	if( !doValidation() ){
		return;
	}	
	
	action = "insert";
	$('form[name=frm]').attr('action' ,'/main/content/insertKnow.do');
	$('form[name=frm]').submit();
}

function update(){
	if( !doValidation() ){
		return;
	}	
	
	action = "update";
	$('form[name=frm]').attr('action' ,'/main/content/updateKnow.do');
	$('form[name=frm]').submit();
}

function deleteMain(){
	action = "delete";
	$('form[name=frm]').attr('action' ,'/main/content/delete.do');
	$('form[name=frm]').submit();
}

function doValidation(){
	var valFlg = true;
	if( $('input[name=mainTitle]').val() == '' ){
		alert("제목을 입력해주세요.");
		$('input[name=mainTitle]').focus();
		return false;
	}
	if( $('input[name=mainWriter]').val() == '' ){
		alert("등록자를 입력해주세요.");
		$('input[name=mainWriter]').focus();
		return false;
	}
	/* if( $('input[name=mainMainTitle]').val() == '' ){
		alert("메인 제목을 입력해주세요.");
		$('input[name=mainMainTitle]').focus();
		return false;
	}
	
	$('#knowDiv').find('input').each(function(){
		if( $(this).attr('type') == 'text' ){
			if( $(this).val() == infoTxt[$(this).attr('name')] || $(this).val() == '' ){
				if( $(this).attr('class') == 'inputText' ){
					alert($(this).attr("title") + "을(를) 선택해주세요.");
				}else{
					alert($(this).attr("title") + "을(를) 입력해주세요.");
				}
				$(this).focus();
				valFlg = false;
				return false;
			}
		}
	}); */
	return valFlg;
}

</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" enctype="multipart/form-data">
			<input type="hidden" name="searchApproval" value="${paramMap.searchApproval}"/>
						
			<c:if test='${not empty view.seq }'>
				<input type="hidden" name="pseq" value="${view.seq }"/>
			</c:if>
			<input type="hidden" name="menu_type" value="${paramMap.menu_type }"/>
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
			<div id="knowDiv">
				<table summary="지식이 더해집니다. 작성">
					<caption>지식이 더해집니다. 작성</caption>
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
						<tr>
							<th scope="row">메인 제목 입력</th>
							<td colspan="4">
								<input type="text" title="메인콘텐츠 메인제목" name="mainMainTitle" style="width:100%;" value="${view.main_title}"/>
							</td>
						</tr>
						<!-- 
						689 : 예술지식백과
						690 : 한국문화100
						691 : 통계
						692 : 교육활용자료
						693 : 전통문양
						694 : 도서
						695 : 인문학강연
						696 : 연구보고서
						 -->
						<c:forEach var="li" items="${menuList}">
							<c:forEach var="li2" items="${subList }">
								<c:choose>
									<c:when test="${li.code eq '689' or li.code eq '691' or li.code eq '693' or li.code eq '694' or li.code eq '695'}">
										<c:if test="${li2.code eq li.code}">
											<tr>
												<th scope="row">${li.name}</th>
												<td colspan="4">
													<textarea title="${li.name} 텍스트" name="summary" style="width:600px;height:45px;margin-bottom:7px;">${li2.summary}</textarea><br/>
<%-- 													<input type="text" value="${li2.summary}" title="${li.name} 텍스트" name="summary" style="width:269px; margin-bottom:7px;"/><br/> --%>
													<div class="fileInputs">
														<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
														<div class="fakefile">
															<input type="text" value="${li2.image_name}" title="${li.name} 이미지" name="imgFile" class="inputText" readonly="readonly" />
															<span class="btn whiteS"><button>찾아보기</button></span>
														</div>
													</div>
													<span class="txt">92 * 92 px에 맞추어 등록해주시기 바랍니다.</span><br/>
													<input type="text" value="${li2.url}" title="${li.name} URL" name="url" style="width:269px;"/>
													<input type="hidden" name="title" />
													<input type="hidden" name="code" value="${li.code}"/>
													<input type="hidden" name="seq" value="${li2.seq}"/>
												</td>
											</tr>
										</c:if>
									</c:when>
									<c:when test="${li.code eq '690' or li.code eq '692'}">
										<c:if test="${li2.code eq li.code}">
											<tr>
												<th scope="row">${li.name}</th>
												<td colspan="4">
													<div class="fileInputs">
														<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
														<div class="fakefile">
															<input type="text" value="${li2.image_name}" title="${li.name} 이미지" name="imgFile" class="inputText" readonly="readonly"/>
															<span class="btn whiteS"><button>찾아보기</button></span>
														</div>
													</div>
													<span class="txt">92 * 92 px에 맞추어 등록해주시기 바랍니다.</span><br/>
													<textarea title="${li.name} 텍스트" name="summary" style="width:600px;height:45px;margin-bottom:7px;">${li2.summary}</textarea><br/>
<%-- 													<input type="text" value="${li2.summary}" title="${li.name} 텍스트" name="summary" style="width:269px; margin-bottom:7px;"/><br/>
 --%>													<input type="text" value="${li2.url}" title="${li.name} URL" name="url" style="width:269px;"/>
													<input type="hidden" name="title" />
													<input type="hidden" name="code" value="${li.code}"/>
													<input type="hidden" name="seq" value="${li2.seq}"/>
												</td>
											</tr>
										</c:if>
									</c:when>
									<c:when test="${li.code eq '696'}">
										<c:if test="${li2.code eq li.code}">
											<tr>
												<th scope="row">${li.name}</th>
												<td colspan="4">
													<textarea title="${li.name} 텍스트(볼드 영역)" name="title" style="width:600px;height:45px;margin-bottom:7px;font-weight:bold;">${li2.title}</textarea><br/>
													<textarea title="${li.name} 텍스트" name="summary" style="width:600px;height:45px;margin-bottom:7px;">${li2.summary}</textarea><br/>
<%-- 													<input type="text" value="${li2.title}" title="${li.name} 텍스트(볼드 영역)" name="title" style="font-weight:bold; width:269px; margin-bottom:7px;"/><br/>
													<input type="text" value="${li2.summary}" title="${li.name} 텍스트" name="summary" style="width:269px; margin-bottom:7px;"/><br/> --%>
													<input type="text" value="${li2.url}" title="${li.name} URL" name="url" style="width:269px;"/>
													<input type="hidden" title="${li.name} 이미지" name="imgFile" class="inputText"/>
													<input type="hidden" name="code" value="${li.code}"/>
													<input type="hidden" name="seq" value="${li2.seq}"/>
												</td>
											</tr>
										</c:if>
									</c:when>
								</c:choose>
							</c:forEach>
						</c:forEach>
							
							
						<c:if test="${empty subList}">
							<c:forEach var="li" items="${menuList}">
								<c:choose>
									<c:when test="${li.code eq '689' or li.code eq '691' or li.code eq '693' or li.code eq '694' or li.code eq '695'}">
										<tr>
											<th scope="row">${li.name}</th>
											<td colspan="4">
												<textarea title="${li.name} 텍스트" name="summary" style="width:600px;height:45px;margin-bottom:7px;"></textarea><br/>
												<div class="fileInputs">
													<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
													<div class="fakefile">
														<input type="text" title="${li.name} 이미지" name="imgFile" class="inputText" readonly="readonly" />
														<span class="btn whiteS"><button>찾아보기</button></span>
													</div>
												</div>
												<span class="txt">92 * 92 px에 맞추어 등록해주시기 바랍니다.</span><br/>
												<input type="text" title="${li.name} URL" name="url" style="width:269px;"/>
												<input type="hidden" name="title" />
												<input type="hidden" name="code" value="${li.code}"/>
											</td>
										</tr>
									</c:when>
									<c:when test="${li.code eq '690' or li.code eq '692'}">
										<tr>
											<th scope="row">${li.name}</th>
											<td colspan="4">
												<div class="fileInputs">
													<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
													<div class="fakefile">
														<input type="text" title="${li.name} 이미지" name="imgFile" class="inputText" readonly="readonly"/>
														<span class="btn whiteS"><button>찾아보기</button></span>
													</div>
												</div>
												<span class="txt">92 * 92 px에 맞추어 등록해주시기 바랍니다.</span><br/>
												<textarea title="${li.name} 텍스트" name="summary" style="width:600px;height:45px;margin-bottom:7px;"></textarea><br/>
												<input type="text" title="${li.name} URL" name="url" style="width:269px;"/>
												<input type="hidden" name="title" />
												<input type="hidden" name="code" value="${li.code}"/>
											</td>
										</tr>
									</c:when>
									<c:when test="${li.code eq '696'}">
										<tr>
											<th scope="row">${li.name}</th>
											<td colspan="4">
												<textarea title="${li.name} 텍스트(볼드 영역)" name="title" style="width:600px;height:45px;margin-bottom:7px;font-weight:bold;"></textarea><br/>
												<textarea title="${li.name} 텍스트" name="summary" style="width:600px;height:45px;margin-bottom:7px;"></textarea><br/>
												<input type="text" title="${li.name} URL" name="url" style="width:269px;"/>
												<input type="hidden" title="${li.name} 이미지" name="imgFile" class="inputText"/>
												<input type="hidden" name="code" value="${li.code}"/>
											</td>
										</tr>
									</c:when>
								</c:choose>
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