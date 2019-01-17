<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript">
//<![CDATA[
	$(function () {
		//paging
		new Pagination({
			view		:	'#pagination',
			page_count	:	'${count}' / 3,
			page_no		:	'${paramMap.page_no }',
			callback	:	function(pageIndex, e) {
				$('#page_no').val(pageIndex + 1);
				search();
				return false;
			}
		});
	});

	//search
	function search() {
		$('#frm').submit();
	};
	
	//정렬
	function sort(sortType){
		$('#sort_type').val(sortType);
		$('#frm').submit();
	}
	
	//태그 신규등록 및 수정 다이얼로그 팝업 띄우기
	function updateForm(seq,name){
		if( seq == "" ){
			$('#btnTag').html("태그등록");
		}else{
			$('#btnTag').html("태그수정");
		}
		
		$( "#dialog" ).dialog();
		$('input[name=seq]').val(seq);
		$('input[name=name]').val(name);
	}
	
	//인기태그에서 삭제
	function deletePopular(seq){
		if(!confirm("인기태그에서 삭제하시겠습니까?")){
			return;
		}
		
		var request = $.ajax({
	      	url: "/magazine/magazineTags/updatePopular.do",
	      	type: "POST",
	      	data: {
	      		seqs : seq,
	      		popular_yn : 'N'
	      	}
	    });

	    request.done(function( rData ) {
	        if(rData.success == "Y"){
	    		alert('인기태그에서 삭제되었습니다.');
	        	search();
	        }
	    });
	}
	
	//다이얼로그 창 닫기
	function closeDialog(){
		$('#dialog').dialog('close');
		return false;
	}
	
	//태그 신규 등록/수정
	function mergeTagName(){
		var request = $.ajax({
	      	url: "/magazine/magazineTags/merge.do",
	      	type: "POST",
	      	data: {
	      		seq : $('#seq').val(),
	      		name : $('#name').val(),
	      		type : $('#type').val()
	      	}
	    });

	    request.done(function( rData ) {
	        if(rData.success == "Y"){
	        	if($('#seq').val() == ''){
		    		alert('등록되었습니다.');
	        	}else{
		    		alert('수정되었습니다.');
	        	}
	        	search();
	        }
	        
	        if(rData.success == "V"){
	        	alert('동일한 태그명이 존재합니다.');
	        }
	    });
	}
	
	//선택된 태그 삭제 프로세스
	function deleteTagsPr(){
		if($('input[name=chkTags]:checked').length < 1){
			alert("삭제할 태그를 선택해주세요.");
			return;
		}
		
		if(!confirm("선택한 태그를 삭제하시겠습니까?")){
			return;
		}
		
		var chkTags = new Array();
        $("input[name=chkTags]:checked").each(function(i) {
        	chkTags.push($(this).val());
        });
        
        var rtnFlg = true;
		//해당태그가 사용되고 있는지 여부 체크
		var request = $.ajax({
	      	url: "/magazine/magazineTags/using.do",
	      	type: "POST",
	      	data: {
	      		seqs : chkTags,
	      		type : $('#type').val()
	      	},
	      	traditional: true
	    });

	    request.done(function( rData ) {
        	if(rData.use_yn == "Y"){
        		if(confirm("삭제대상 태그에 현재 사용중인 태그가 포함되어있습니다.\n삭제하시겠습니까?\n대상태그:"+rData.targetTags)){
        			rtnFlg = false;
        		}
        	}
        	
    	    if(rtnFlg){
    	    	delectTags(chkTags);
    	    }
	    });
	}
	
	//선택된 태그 삭제
	function delectTags(chkTags){
		var request = $.ajax({
	      	url: "/magazine/magazineTags/delete.do",
	      	type: "POST",
	      	data: {
	      		seqs : chkTags
	      	},
	      	traditional: true
	    });

	    request.done(function( rData ) {
	        if(rData.success == "Y"){
	        	alert("삭제되었습니다");
	        	search();
	        }
	    });
	}
	
	//인기태그 등록
	function updatePopul(){
		if( !confirm("선택된 태그를 인기태그로 등록하시겠습니까?") ){
			return;
		}
		
		if( $("input[name=chkTags]:checked").length < 1 ){
			alert("인기태그로 등록할 태그를 선택해주세요.");
			return;
		}
		
		//선택된 태그의 seq가 담길 배열
		var arrChkTags = new Array();
		//인기태그로 등록된 태그의 seq가 담길 배열
		var arrPopulTags = new Array();
		//위 두 배열을 병합할 임시배열
		var arrTmpMerge = new Array();
		
        $("input[name=chkTags]:checked").each(function(i) {
        	arrChkTags.push($(this).val());
        });
        $("input[name=populSeqs]").each(function(i) {
        	arrPopulTags.push($(this).val());
        });
        
        //중복값 제거
        arrTmpMerge = dumpArray(arrChkTags.concat(arrPopulTags));
        
        //인기태그는 10를 넘길수 없음
        if(arrTmpMerge.length > 10){
        	alert("인기태그는 최대 10개까지만 등록 가능합니다.");
        	return;
        }
        
        //인기태그로 등록
		var request = $.ajax({
	      	url: "/magazine/magazineTags/updatePopular.do",
	      	type: "POST",
	      	data: {
	      		seqs : arrChkTags,
	      		popular_yn : 'Y'
	      	},
	      	traditional: true
	    });

	    request.done(function( rData ) {
	        if(rData.success == "Y"){
	        	alert("인기태그로 등록되었습니다.");
	        	search();
	        }
	    });
	}
	
	//배열 내 중복값을 제거한다.
	function dumpArray(arr){
		var arrTmp = new Array();
		
		//배열의 원소수만큼 반복
		$.each(arr, function(index, element) {
			//result 에서 값을 찾는다.  //값이 없을경우(-1)
			if ($.inArray(element, arrTmp) == -1) {
				arrTmp.push(element);
			}
		});

		return arrTmp;
	}
//]]>
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" id="frm" method="post" action="/magazine/magazineTags/list.do">
		<input type="hidden" name="page_no" id="page_no" value="${paramMap.page_no}"/>
		<input type="hidden" name="sort_type" id="sort_type" value="${paramMap.sort_type}"/>
		<input type="hidden" name="type" id="type" value="${paramMap.type}"/>
		
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">태그</th>
							<td colspan="3">
								<span>
									태그는 ${paramMap.type eq '1' ? '문화이슈':'문화공감'}에 등록할 태그가 모두 모여있는 곳입니다.<br/>
								</span> 
							</td>
						</tr>
						<tr>
							<th scope="row">검색어</th>
							<td colspan="3">
								<input type="text" name="keyword" title="검색어 입력" value="${paramMap.keyword}"/>
								<span class="btn darkS">
									<button name="searchButton" type="button" onclick="javascript:search();return;">검색</button>
								</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</fieldset>
	
	
		<ul class="tab" style="margin-bottom: 10px;">
			<li><a href="/magazine/magazineTags/list.do?type=1" ${paramMap.type eq '1' ? 'class="focus"':''}>문화이슈</a></li>
			<li><a href="/magazine/magazineTags/list.do?type=2" ${paramMap.type eq '2' ? 'class="focus"':''}>문화공감</a></li>
		</ul>

		<!-- 건수  -->
		<div class="topBehavior">
			<p class="totalCnt">총 <span>${count}</span>건</p>
			<%-- <ul class="sortingList">
				<li class="${paramMap.sort_type eq 'use_cnt' ? 'on':''}"><a href="#url" onclick="javascript:sort('use_cnt'); return false;">동영상많은순</a></li>
				<li class="${paramMap.sort_type ne 'use_cnt' ? 'on':''}"><a href="#url" onclick="javascript:sort('name'); return false;">가나다순</a></li>
			</ul> --%>
		</div>
		<!-- 리스트 -->
		<div class="tableList">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col style="width:20%" />
					<col style="width:20%" />
					<col style="width:20%" />
					<col style="width:20%" />
					<col style="width:20%" />
				</colgroup>
				<tbody>
					<c:choose>
						<c:when test="${ not empty list}">
							<c:forEach begin="0" end="${fn:length(list)-1}" step="5" varStatus="i">
								<tr style="text-align:left;">
									<c:forEach items="${list }" var="item" varStatus="status">
										<c:if test="${status.index < i.index+5 and status.index > i.index-1 }">
											<td>
												<label>
													<input type="checkbox" name="chkTags" value="${item.seq}"/>
													${item.name}
												</label>
												<a onclick="javascript:updateForm('${item.seq}','${item.name}'); return false;" href="#">
													<img border="0" style="width:16px;margin-top:-5px;vertical-align:middle;" src="/images/icon_adjust.gif" />
												</a>
											</td>
											<c:set value="${status.index}" var="lastIdx"></c:set>
										</c:if>
									</c:forEach>
									<!-- 한라인에 데이터가 5개 이하일때 빈공백이 생기므로 빈td태그를 찍어준다. -->
									<c:forEach begin="0" end="${i.index+5-1-lastIdx}">
										<td></td>
									</c:forEach>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<td colspan="5">검색된 결과가 없습니다.</td>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>
	</form>
	<div id="pagination">
	</div>
	
	<fieldset class="searchBox">
		<legend>추천태그 배포 설명</legend>
		<div class="tableWrite">
			<table summary="추천태그 배포 설명">
				<caption>게시판 글 검색</caption>
				<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">인기 태그</th>
						<td colspan="3">
							<span>
							인기태그는 ${paramMap.type eq '1' ? '문화이슈':'문화공감'} 상단에 노출되며 최대 10개까지만 선택이 가능합니다.
							</span> 
						</td>
					</tr>
					<tr>
						<th scope="row">선택된 태그</th>
						<td colspan="3">
							<c:forEach items="${popularList}" var="popularList" varStatus="status">
								<input type="hidden" name="populSeqs" value="${popularList.seq}"/>
								<span style="padding-right:10px;">
									${popularList.name}
									<a href="#" onclick="javascript:deletePopular('${popularList.seq}'); return false;">
										<img src="/images/icoDel.gif" title="삭제" alt="삭제"/>
									</a>
								</span>
							</c:forEach>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</fieldset>
	<form name="diaFrm" id="diaFrm">
		<div id="dialog" title="태그명 관리" style="display:none" >
			<fieldset>
				<input type="hidden" name="seq" id="seq"/>
				<legend>태그 수정</legend>
				<div class="searchForm">
					<input type="text" class="input" name="name" id="name" value="" maxlength="10"/>
					<br/><br/>
					<span class="btn white"><button type="button" id="btnTag" onclick="javascript:mergeTagName(); return;">태그수정</button></span>
					<span class="btn white"><button type="button" onclick="javascript:closeDialog(); return;">취소</button></span>
				</div>
			</fieldset>
		</div>
	</form>
	
	<div class="btnBox textRight">
		<span class="btn white"><a href="#url" onclick="javascript:updateForm('',''); return false;">신규태그등록</a></span>
		<span class="btn white"><a href="#url" onclick="javascript:deleteTagsPr(); return false;">선택태그삭제</a></span>
		<span class="btn dark"><a href="#url" onclick="javascript:updatePopul(); return false;">인기태그등록</a></span>
	</div>
</body>
</html>
