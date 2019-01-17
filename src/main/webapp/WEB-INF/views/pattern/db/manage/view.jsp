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

	var frm = $('form[name=frm]');
	
	//layout
	
	
	//select selected
	if('${view.ecim_ecgb}')$("select[name=ecim_ecgb]").val('${view.ecim_ecgb}').attr("selected", "selected");
		
	$('span.btn.whiteS a').each(function(){
	  	$(this).click(function(){
	    	if( $(this).html() == '우편번호찾기'){
	    		//               /pattern/db/category/list.do
	    	} 
	  	});
	});
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		frm.attr('action' ,'/pattern/db/manage/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		frm.attr('action' ,'/pattern/db/manage/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		frm.attr('action' ,'/pattern/db/manage/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/pattern/db/manage/list.do';
        	}   		
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/pattern/db/manage/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.ecim_ecid}'>
				<input type="hidden" name="ecim_ecid" value="${view.ecim_ecid}"/>
			</c:if>
			<table summary="분류체계  작성">
				<caption>분류체계 글쓰기</caption>
				<colgroup>
					<col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row" >문양코드</th>
						<td><c:out value='${view.did}' /></td>
						<th scope="row" >컨텐츠 구분</th>
						<td>
							<select name="xtype">
				    			<option value="">전체</option>
				    			<option value="원시문양">원시문양</option>
				    			<option value="개별문양">개별문양</option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" >문양명</th>
						<td><input type="text" name="xtitle" id="artsubject" class="fullsize" value="<c:out value='${view.xtitle}' />" maxlength="25" title="문양명" /></td>
						<th scope="row" >문양명(한자명)</th>
						<td><input type="text" name="xalternative" id="artcsubject" class="fullsize" value="<c:out value='${view.xalternative}' />" maxlength="25" title="문양명(한자명)" /></td>
					</tr>
					<tr>
						<th scope="row" >저작자</th>
						<td  colspan="3"><input type="text" id="writer" name="xcreator" class="fullsize" value="<c:out value='${view.xcreator}' />" maxlength="50" title="저작자" /></td>
					</tr>
					<tr>
						<th scope="row">컨텐츠 파일</th>
						<td colspan="3">
							<%-- <div class="inputBox">
								이전파일: ${view.ecim_file}
							</div> --%>
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row" >다운로드 파일</th>
						<td colspan="3">
							<%-- <div class="inputBox">
								이전파일: ${view.ecim_file}
							</div> --%>
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row" >썸네일 파일(80)</th>
						<td colspan="3">
							<%-- <div class="inputBox">
								이전파일: ${view.ecim_file}
							</div> --%>
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row" >썸네일 파일(250)</th>
						<td colspan="3">
							<%-- <div class="inputBox">
								이전파일: ${view.ecim_file}
							</div> --%>
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" />
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
						</td>
					</tr>
					<tr >
						<th scope="row" >문양분류체계</th>
						<td  colspan="3">
							<input type="text" id="xtaxonomy" name="xtaxonomy" value="<c:out value='${view.xtaxonomy}' />" readonly style='width:80%;' title="문양분류체계" />
							<!-- <a href="lform('/pattern/admin/cms/category_list.jsp?target=popup&pcodefield=xcollectionid&pnamefield=xtaxonomy','350','315');" class="btnn"> -->
							<span class="btn whiteS"><a href="#url">분류체계관리</a></span>
						</td>
					</tr>
					<tr>
						<th scope="row" >문양구분</th>
						<td>
							<select name="xdimension">
							    <option value="2d">2d</option>
							    <option value="3d">3d</option>
							</select>
						</td>
						<th scope="row" >cad사용여부</th>
						<td><input type="checkbox" name="xcad" id="ixcad" value="y" <c:if test='${view.xcad eq "y"}'> checked="checked"</c:if> title="cad사용여부" /></td>
					</tr>
					<tr>
						<th scope="row" >설명자료</th>
						<td colspan="3"><textarea rows="8" style="width:100%;" id="ixabstract" name="xabstract" title="설명자료"><c:out value='${view.xabstract}' /></textarea></td>
					</tr>
					<tr>
						<th scope="row" >원천유물명</th>
						<td><input type="text" name="xmain" class="fullsize"  id="ixmain" title="원천유물명" value="<c:out value='${view.xmain}' />" maxlength="25" /></td>
						<th scope="row" >원천유물재질</th>
						<td><input type="text" name="xmat" class="fullsize" id="ixmat" title="원천유물재질" value="<c:out value='${view.xmat}' />" maxlength="25" /></td>
					</tr>
					<tr>
						<th scope="row" >원천유물용도</td>
						<td><input type="text" name="xuse" id="ixuse" class="fullsize" title="원천유물용도" value="<c:out value='${view.xuse}' />" maxlength="25" /></td>
						<th scope="row" >국적/시대</td>
						<td><input type="text" name="xage" id="xage" class="fullsize" title="국적/시대" value="<c:out value='${view.xage}' />" maxlength="25" /></td>
					</tr>
					<tr>
						<th scope="row" >발행처</td>
						<td  colspan="3"><input type="text" id="xpublisher" name="xpublisher" title="발행처" class="fullsize" value="<c:out value='${view.xpublisher}' />" maxlength="25" /></td>
					</tr>
					<tr>
						<th scope="row" >작업자</td>
						<td><input type="text" name="xname" id="ixname" class="fullsize" value="<c:out value='${view.xname}' />" maxlength="25" title="작업자" /></td>
						<th scope="row" >작업기관</td>
						<td><input type="text" name="xcorporate" id="ixcorporate" class="fullsize" value="<c:out value='${view.xcorporate}' />" maxlength="25" title="작업기관" /></td>
					</tr>
					<tr>
						<th scope="row" >자료유형</td>
						<td><input type="text" name="xcategory" id="ixcategory" class="fullsize" value="<c:out value='${view.xcategory}' />" maxlength="25" title="자료유형" /></td>
						<th scope="row" >개발내역</td>
						<td><input type="text" name="xdevelopment" id="ixdevelopment" class="fullsize" value="<c:out value='${view.xdevelopment}' />" maxlength="25" title="개발내역" /></td>
					</tr>
					<tr>
						<th scope="row" >제작일</td>
						<td><input type="text" name="xcreated" id="ixcreated" size="10" value="<c:out value='${view.xcreated}' />"  readonly /></td>
						<th scope="row" >수정일</td>
						<td><input type="text" name="xmodified" id="ixmodified" size="10" value="<c:out value='${view.xmodified}' />" maxlength="10" readonly/></td>
					</tr>
					<tr>
						<th scope="row" >자료형태</td>
						<td><input type="text" name="xformat" id="ixformat" class="fullsize" value="<c:out value='${view.xformat}' />" maxlength="10" title="자료형태" /></td>
						<th scope="row" >서비스용자료형태</td>
						<td><input type="text" name="xview" id="xview" class="fullsize" value="<c:out value='${view.xview}' />" maxlength="10" title="서비스용자료형태" /></td>
					</tr>
					<tr>
						<th scope="row" >파일명</td>
						<td><input type="text" name="xfile" id="ixview" class="fullsize" value="<c:out value='${view.xfile}' />" maxlength="25" title="파일명" /></td>
						<th scope="row" >식별자</td>
						<td><input type="text" name="xprimary" id="ixprimary" class="fullsize" value="<c:out value='${view.xprimary}' />" maxlength="25" title="식별자" /></td>
					</tr>
					<tr>
						<th scope="row" >원천유물</td>
						<td  colspan="3"><input type="text" name="xwork" id="xwork" class="fullsize" value="<c:out value='${view.xwork}' />" maxlength="100" title="원천유물" /></td>
					</tr>
					<tr>
						<th scope="row" >원천유물명</td>
						<td  colspan="3"><input type="text" name="xoriginal" id="ixoriginal" class="fullsize" value="<c:out value='${view.xoriginal}' />" maxlength="25" title="원천유물명" /></td>
					</tr>
					<tr>
						<th scope="row" >언어</td>
						<td><input type="text" name="xword" id="ixword" class="fullsize" value="<c:out value='${view.xword}' />" maxlength="25" title="언어" /></td>
						<th scope="row" >소장기관</td>
						<td><input type="text" name="xlocation" id="ixlocation" class="fullsize" value="<c:out value='${view.xlocation}' />" maxlength="25" title="소장기관" /></td>
					</tr>
					<tr>
						<th scope="row" >저작권정보</td>
						<td><input type="text" name="xright" id="ixright" class="fullsize" value="<c:out value='${view.xright}' />" maxlength="25" title="저작권정보" /></td>
						<th scope="row" >소유권자</td>
						<td><input type="text" name="xproperty" id="xproperty" class="fullsize" value="<c:out value='${view.xproperty}' />" maxlength="25" title="소유권자" /></td>
					</tr>
					<tr>
						<th scope="row" >소유기관</td>
						<td  colspan="3"><input type="text" name="xplace" id="ixplace" class="fullsize" value="<c:out value='${view.xplace}' />" maxlength="25" title="소유기관" /></td>
					</tr>
					<tr>
						<th scope="row" >저작권자</td>
						<td><input type="text" name="xcopyright" id="ixcopyright" class="fullsize" value="<c:out value='${view.xcopyright}' />" maxlength="25" title="저작권자" /></td>
						<th scope="row" >가격</td>
						<td><input type="text" name="xprice" id="ixprice" class="fullsize" value="<c:out value='${view.xprice}' />" maxlength="25" title="가격" /></td>
					</tr>
					<tr >
						<th scope="row" >형상정보서비스</th>
						<td>
							<select name="xservice">
							    <option value="">false</option>
							    <option value="y">true</option>
							</select>
						</td>
						<th scope="row" >히든여부</th>
						<td>
							<select name="xhidden">
							    <option value="거짓">거짓</option>
							    <option value="참">참</option>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div class="btnBox textRight">
		<c:if test='${not empty view}'>
			<!-- <span class="btn white"><button type="button">수정</button></span> -->
			<span class="btn white"><button type="button">삭제</button></span>
		</c:if>
		<c:if test='${empty view }'>
			<!-- <span class="btn white"><button type="button">등록</button></span> -->
		</c:if>
		<span class="btn gray"><button type="button">목록</button></span>
	</div>
</body>
</html>