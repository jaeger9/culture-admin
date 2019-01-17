<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript">
//javascript array remove index
Array.prototype.remove = function(from ,to) {
	  var rest = this.slice(((to || from ) * 1) + 1  , this.length);
	  this.length = from < 0 ? this.length + from : from;
	  return this.push.apply(this, rest);
};
	
var checkedTags = [];


removeCheckedTagsValue = function(seq) { 
	console.log('removeCheckedTagsValue seq:' + seq);
  for(index in checkedTags){
    if(checkedTags[index] == seq) {
    	console.log('match delete checkedTags[index]:' + index + ":"+ checkedTags[index]);
        checkedTags.remove(index);
        return true;
    }
  }
}

$(function () {

	var frm = $('form[name=frm]');
	var page_no = frm.find('input[name=page_no]');
	var reg_date_start = frm.find('input[name=reg_start]');
	var reg_date_end = frm.find('input[name=reg_end]');
	/* var creators = frm.find('input[name=creators]');
	var approval = frm.find('input[name=approval]');
	var reg_date_start = frm.find('inpput[name=reg_date_start]');
	var reg_date_end = frm.find('inpput[name=reg_date_end]');
	var insert_date_start = frm.find('inpput[name=insert_date_start]');
	var insert_date_end = frm.find('inpput[name=insert_date_end]');
	var search_type = frm.find('select[name=search_type]');
	var search_word = frm.find('inpput[name=search_word]'); */

	//layout
	if('${view.order}') {
		if('${view.order}' == '') {
			$('ul.sortingList li:first').addClass('on');
			$('ul.sortingList li:last').removeClass('on');
		} else if('${view.order}' == 'abc'){ 
			$('ul.sortingList li:first').removeClass('on');
			$('ul.sortingList li:last').addClass('on');
		}
	}
	
	new Datepicker(reg_date_start, reg_date_end);
	
	//paging
	var p = new Pagination({
		view		:	'#pagination',
		page_count	:	'${count }' / 3,
		page_no		:	'${paramMap.page_no }',
		/* link		:	'/main/code/list.do?page_no=__id__', */
		callback	:	function(pageIndex, e) {
			console.log('pageIndex : ' + pageIndex);
			page_no.val(pageIndex + 1);
			search();
			return false;
		}
	});
	
	//checked tag
	setCheckedValued = function() {
		$('input[name=sw]').prop('checked' , false);
		
		for(index in checkedTags)
			$('input[name=sw][value="' + checkedTags[index] + '"]').prop('checked' , 'checked');
	}
	
	if($.cookie('checkedTags') && $.cookie('checkedTags') != "null") { 
		checkedTags = $.cookie('checkedTags').split(',');
		/* for(index in checkedTags)
			$('input[name=sw][value="' + checkedTags[index] + '"]').prop('checked' , 'checked'); */
		setCheckedValued();
		
	} else {
		console.log('checkedTags cookie null');
	}
	
	//checkbox
	new Checkbox('input[name=seqAll]', 'input[name=seq]');
	
	//selectbox
	if('${paramMap.approval}')$("select[name=approval]").val('${paramMap.approval}').attr("selected", "selected");
	if('${paramMap.search_type}')$("select[name=search_type]").val('${paramMap.search_type}').attr("selected", "selected");
	if('${paramMap.searchGubun}')$("select[name=searchGubun]").val('${paramMap.searchGubun}').attr("selected", "selected");
	
	//checkbox check event
	$('input[name=sw]').change(function() {
	  	if($(this).prop('checked')){
	  		if(checkedTags.length >= 10){
	  			alert('추천 태그는 최대 10개 입니다.');
	  			$(this).prop('checked' , false);
	  			return true;
	  		}
	      	checkedTags.push($(this).val());
	  	} else {
	  		removeCheckedTagsValue($(this).val());
	  	}
	  
	  	console.log(checkedTags);
	  	$.cookie('checkedTags' , checkedTags);
	});
	
	//tag info get
	getSelectedTagInfo = function() { 
		var request = $.ajax({
	      	url: "/magazine/tag/selectedTagInfo.do",
	      	type: "POST",
	      	data: { seq : checkedTags}
	    });

	    request.done(function( rData ) {
	    			    		    	
	    	console.log(rData.length);
	    	$('#checkedTagInfo').empty();
	    	for(index = 0 ; index < rData.length ; index++) {
	    		$('#checkedTagInfo').append(rData[index].tag_name + '<img border="0" src="/images/icoDel.gif" seq="' + rData[index].seq + '">');
	    	}
	    	
	    	applyTagDeleteEvent();
	    });
	    
	    request.fail(function( jqXHR, textStatus ) {
	      	console.log( "Request failed: " + textStatus );
	      	$('#checkedTagInfo').empty();
		});
	}
	
	//delete selected value event
	applyTagDeleteEvent = function() { 
		$('#checkedTagInfo img').click(function() { 
			seq = $(this).attr('seq');
			
			console.log('delete seq:' + seq);
			removeCheckedTagsValue(seq);
			
			$.cookie('checkedTags' , checkedTags);
			
			getSelectedTagInfo();
			
			setCheckedValued();
		});
	}
	
	//검색
	$('button[name=searchButton]').click(function(){
		$('input[name=page_no]').val('1');
		$('form[name=frm]').submit();
	});
	
	search = function() { 
		frm.submit();
	}
	
	//정렬
	$('ul.sortingList li a').click(function(){
	    url = '/magazine/tag/list.do';
	  
	    if($(this).html() == '동영상많은순') {
	    		$('input[name=order]').val('');
	        formSubmit(url);
	    } else if($(this).html() == '가나다순') {
					$('input[name=order]').val('abc');
	        formSubmit(url);
	    }
	});

	
	//상세
	$('div.tableList table tbody tr td').each(function() {
		if(!$(this).find('input').attr('type') && !$(this).find('span').attr('class')){
    		$(this).click(function(){
        		view($(this).parent().first().find('input').attr('type' , 'checkbox').val());
    		});
  		}
	});
	
	view = function(seq) { 
		url = '/magazine/tag/view.do';
		if(seq)
			url += '?seq=' + seq;
		
		location.href = url;
	}
	
	//등록 & 상세
	$('span.btn.dark.fr a').click(function(){
		
		if($(this).html() == '추천태그선택') {
			getSelectedTagInfo();
		} else if($(this).html() == '배포') {
			$.removeCookie('checkedTags');
			$('input[name=seq]').val(checkedTags);
			formSubmit('/magazine/tag/distribute.do')
		}
	});
	
	//승인 , 미승인 , 삭제 이벤트 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		deleteSites();
        	} else if($(this).html() == '승인') {
        		if (!confirm('승인 처리 하시겠습니까?')) {
        			return false;
        		}
				$('input[name=updateStatus]').val('Y');
				updateStatus();
        	} else if($(this).html() == '미승인') {
        		if (!confirm('미승인 처리 하시겠습니까?')) {
        			return false;
        		}
        		$('input[name=updateStatus]').val('N');
        		updateStatus();
			}
    	});
	});
	
	updateTagName = function() { 
	  	var request = $.ajax({
			url: "/magazine/tag/updateTagName.do",
		    type: "POST",
	        data: { seq : $('input[name=selectedSeq]').val() , tag_name : $('input[name=tag_name]').val()}
		});

		request.done(function( rData ) {
	        if(rData.success){
	    		alert('수정되었습니다.');
	    		formSubmit('/magazine/tag/list.do');
	        }
		});
		    
		request.fail(function( jqXHR, textStatus ) {
			console.log( "Request failed: " + textStatus );
	    });
	}
	
	$('td a img').each(function(){
	  $(this).click(function(){
	      $( "#dialog" ).dialog();
	      $('input[name=selectedSeq]').val($(this).parent().parent().find('input[name=sw]').val());
	      $('input[name=tag_name]').val( $(this).parent().prev().html());
	  });  
	  //  console.log($(this).parent().find('input[type=checkbox]').val());
	});

	$('span.btn.white button').each(function(){
	  $(this).click(function(){
	    if($(this).html() == '태그수정'){
	        updateTagName();
	    } else if($(this).html() == '취소'){
	        $( "#dialog" ).dialog('close');
	    }
	  });
	})

	
	//submit
	formSubmit = function (url) { 
		if(url) frm.attr('action' , url);
		frm.submit();		
	};
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<form name="frm" method="get" action="/magazine/tag/list.do">
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/> 
		<input type="hidden" name="order"/>
		<input type="hidden" name="seq"/>
		<fieldset class="searchBox">
			<legend>검색</legend>
			<div class="tableWrite">
				<table summary="게시판 글 검색">
					<caption>게시판 글 검색</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">태그 라이브러리</th>
							<td colspan="3">
								<span>
								태그 라이브러리는 문화동영상 등록시 입력된 태그가 모두 모여있는 곳입니다.</br>
								태그선택시 해당 태그 관련 동영상 목록을 확인하실 수 있습니다.
								</span> 
							</td>
						</tr>
						<tr>
							<th scope="row">검색어</th>
							<td colspan="3">
								<input type="text" name="keyword" title="검색어 입력" value="${paramMap.keyword}"/>
								<span class="btn darkS">
									<button name="searchButton" type="button">검색</button>
								</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</fieldset>
	
		<!-- 건수  -->
		<div class="topBehavior">
			<p class="totalCnt">총 <span>${count}</span>건</p>
			<ul class="sortingList">
				<li class="on"><a href="#url" orader="">동영상많은순</a></li>
				<li><a href="#url" order="abc">가나다순</a></li>
			</ul>
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
				<!-- <thead>
					<tr>
						<th scope="col"><input type="checkbox" name="seqAll" title="리스트 전체 선택" /></th>
						<th scope="col">번호</th>
						<th scope="col">분류</th>
						<th scope="col">제목</th>
						<th scope="col">블로그 URL</th>
						
						<th scope="col">등록일</th>
						<th scope="col">승인여부</th>
					</tr>
				</thead> -->
				<tbody>

					<tr>					
						<c:forEach items="${list }" var="item" varStatus="status">
							<c:if test="${status.count % 5 eq 0 }">
								<c:if test="${status.count / 5 ne 6 }">
									<td>
										<input type="checkbox" name="sw" value="${item.seq}"/>
										<a href="pdlist.do?seq=${item.seq}">${item.tag_name}</a>
										<a onclick="updateForm('${item.seq}')" href="#"><img border="0" style="width:16px;margin-top:-5px;vertical-align:middle;" src="/images/icon_adjust.gif"></a>
									</td>
									</tr>
									<tr>
								</c:if>
								<c:if test="${status.count / 5 eq 6 }">
										<td>
											<input type="checkbox" name="sw" value="${item.seq}"/>
											<a href="pdlist.do?seq=${item.seq}">${item.tag_name}</a>
											<a onclick="updateForm('${item.seq}')" href="#"><img border="0" style="width:16px;margin-top:-5px;vertical-align:middle;" src="/images/icon_adjust.gif"></a>
										</td>
									</tr>
								</c:if>
							</c:if>
							<c:if test="${status.count % 5 ne 0 }">
								<td>
									<input type="checkbox" name="sw" value="${item.seq}"/>
									<a href="pdlist.do?seq=${item.seq}">${item.tag_name}</a>
									<a onclick="updateForm('${item.seq}')" href="#"><img border="0" style="width:16px;margin-top:-5px;vertical-align:middle;" src="/images/icon_adjust.gif"></a>
								</td>
							</c:if>
						</c:forEach>
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
						<th scope="row">추천 태그</th>
						<td colspan="3">
							<span>
							추천태그는 문화PD영상 검색 영역 하단에 노출되며 최대 10개까지만 선택이 가능합니다.</br>
							배포 버튼 클릭 시 추천태그가 문화포털에 반영됩니다. 
							</span> 
						</td>
					</tr>
					<tr>
						<th scope="row">선택된 태그</th>
						<td colspan="3">
							<div id="checkedTagInfo">
								
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</fieldset>
	<div class="sTitBar">
		<h4>배포된 추천태그</h4>
		<h4 id="">
			<c:forEach items="${recomTagLibList}" var="recomTagLibList" varStatus="status">
				${recomTagLibList.tag_name}
				<c:if test="${!status.last}"> , </c:if>
			</c:forEach>
		</h4>
	</div>
	<div id="dialog" title="태그명 수정" style="display:none" >
		<fieldset>
			<input type="hidden" name="selectedSeq"/>
			<legend>태그 수정</legend>
			<div class="searchForm">
				<input type="text" class="input" name="tag_name" value="해외문화PD" />
				</br></br>
				<span class="btn white"><button type="button">태그수정</button></span>
				<span class="btn white"><button type="button">취소</button></span>
			</div>
		</fieldset>
	</div>
	<div class="btnBox">
		<span class="btn dark fr"><a href="#url">배포</a></span>
		<span class="btn dark fr"><a href="#url">추천태그선택</a></span>
	</div>
</body>
</html>
