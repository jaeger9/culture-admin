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

$(function () {
	//menu_type 에 의한 div empty 시키고 시작
	
	/*	
		202	0	배너관리구분	1	MAIN_BANNER	
		701	0	상단배너	2	MAIN_BANNER	
		205	202	이벤트 배너	3	MAIN_BANNER	
		206	202	홍보 배너	4	MAIN_BANNER	
		207	202	관련기관 배너	5	MAIN_BANNER	
		571	202	핫존	7	MAIN_BANNER	
		572	202	내부홍보배너	8	MAIN_BANNER	
		573	202	타기관홍보배너	9	MAIN_BANNER
		
		
		206 홍보배너 editor 필요
		
	*/
	var bannerCodeList = new Array();
	
	<c:forEach items="${bannerList}" var="bannerList">
		bannerCodeList.push("${bannerList.code}");
	</c:forEach>
	
	menu_type = '${paramMap.menu_type}';
	
	for(var index = 0 ; index < bannerCodeList.length ; index++) { 
		if(menu_type != bannerCodeList[index])
			$('#' + bannerCodeList[index]).empty();
	}
	
	var frm = $('form[name=frm]');
	var title			= frm.find('input[name=title]');
	var banner_title	= frm.find('input[name=banner_title]');
	var start_date		= frm.find('input[name=start_date]');
	var end_date		= frm.find('input[name=end_date]');
	var url				= frm.find('input[name=url]');
//	var mobile_url		= frm.find('input[name=mobile_url]');
	var tel				= frm.find('input[name=tel]');
	
	//layout
	if(menu_type != '207') {
		new Datepicker(start_date, end_date);
	}
	// 에디터 HTML 적용
	if(menu_type == '206')nhn.husky.EZCreator.createInIFrame( oEditorsOption );
	
	//radio check
	if('${view.status}')$('input:radio[name="status"][value="${view.status}"]').prop('checked', 'checked');
	else $('input:radio[name="status"][value="W"]').prop('checked', 'checked');
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		if(action == 'list'){
			return true;
		}

		if(title.val() == '') {
		    alert("제목 입력하세요");
		    title.focus();
		    return false;
		}
		if(menu_type == '701') {
			var rtnFlg = true;
			if(title.val() == ''){
				alert('제목 선택 하세요');
				title.focus();
				return false;
			}
			
			if(start_date.val() == ''){
				alert('시작일 선택 하세요');
				start_date.focus();
				return false;
			}
	
			if(end_date.val() == ''){
				alert('종료일 선택 하세요');
				end_date.focus();
				return false;
			}
			for(var i=1; i<=rowNum[$('select[name=top_banner_type]').val()]; i++){
				tmpNum = i;
				if( i == 1 ) tmpNum='';
				if($('textarea[name=summary'+tmpNum+']').val() == ''){
					alert('이미지 설명을 입력 하세요.');
					$('textarea[name=summary'+tmpNum+']').focus();
					rtnFlg = false;
					break;
				}
				if($('input[name=url'+tmpNum+']').val() == ''){
					alert('URL을 입력 하세요.');
					$('input[name=url'+tmpNum+']').focus();
					rtnFlg = false;
					break;
				}
/* 				if($('input[name=mobile_url'+tmpNum+']').val() == ''){
					alert('MOBILE URL을 입력 하세요.');
					$('input[name=mobile_url'+tmpNum+']').focus();
					rtnFlg = false;
					break;
				} */
			}
			
			if( !rtnFlg ){
				return rtnFlg;
			}
			
			return true;
		}
		
		if(menu_type != '' && action == 'insert'){
			if(menu_type == '205') {
				
				if(title.val() == ''){
					alert('제목 선택 하세요');
					title.focus();
					return false;
				}
				
				if(start_date.val() == ''){
					alert('시작일 선택 하세요');
					start_date.focus();
					return false;
				}

				if(end_date.val() == ''){
					alert('종료일 선택 하세요');
					end_date.focus();
					return false;
				}
				
			} else if(menu_type == '206') {
				if(title.val() == ''){
					alert('제목 선택 하세요');
					title.focus();
					return false;
				}
				
				if(start_date.val() == ''){
					alert('시작일 선택 하세요');
					start_date.focus();
					return false;
				}

				if(end_date.val() == ''){
					alert('종료일 선택 하세요');
					end_date.focus();
					return false;
				}
				
				if(tel.val() == ''){
					alert('연락처 선택 하세요');
					tel.focus();
					return false;
				}
			} else if(menu_type == '207') {
				
				if(title.val() == ''){
					alert('제목 선택 하세요');
					title.focus();
					return false;
				}
				
				if(url.val() == ''){
					alert('URL 선택 하세요');
					url.focus();
					return false;
				}
				
			} else if(menu_type == '571') {

				if(banner_title.val() == ''){
					alert('핫존영역제목 선택 하세요');
					title.focus();
					return false;
				}
				
				if(title.val() == ''){
					alert('제목 선택 하세요');
					title.focus();
					return false;
				}
				
				if(start_date.val() == ''){
					alert('시작일 선택 하세요');
					start_date.focus();
					return false;
				}

				if(end_date.val() == ''){
					alert('종료일 선택 하세요');
					end_date.focus();
					return false;
				}
				
				if(url.val() == ''){
					alert('URL 선택 하세요');
					url.focus();
					return false;
				}
				
			} else if(menu_type == '572') {
				
				if(title.val() == ''){
					alert('제목 선택 하세요');
					title.focus();
					return false;
				}
				
				if(start_date.val() == ''){
					alert('시작일 선택 하세요');
					start_date.focus();
					return false;
				}

				if(end_date.val() == ''){
					alert('종료일 선택 하세요');
					end_date.focus();
					return false;
				}
				
				if(url.val() == ''){
					alert('URL 선택 하세요');
					url.focus();
					return false;
				}
				
			} else if(menu_type == '573') {
				if(title.val() == ''){
					alert('제목 선택 하세요');
					title.focus();
					return false;
				}
				
				if(start_date.val() == ''){
					alert('시작일 선택 하세요');
					start_date.focus();
					return false;
				}

				if(end_date.val() == ''){
					alert('종료일 선택 하세요');
					end_date.focus();
					return false;
				}
				
				if(url.val() == ''){
					alert('URL 선택 하세요');
					url.focus();
					return false;
				}
			}
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
        		action = "update";
        		if(menu_type == '701'){
	        		frm.attr('action' ,'/main/banner/updateMulti.do');
        		}else{
	        		frm.attr('action' ,'/main/banner/update.do');
        		}
        		if(menu_type == '206')oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		action = "delete";
        		frm.attr('action' ,'/main/banner/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		action = "insert";
        		if(menu_type == '701'){
	        		frm.attr('action' ,'/main/banner/insertMulti.do');
        		}else{
	        		frm.attr('action' ,'/main/banner/insert.do');
        		}
        		
        		if(menu_type == '206')oEditors.getById['contents'].exec("UPDATE_CONTENTS_FIELD", []);
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		action = "list";
        		$('input[name=start_date]').val('');
        		$('input[name=end_date]').val('');
        		$('input[name=status]').val('');
        		frm.attr('action' ,'/main/banner/list.do');
        		frm.submit();
        	}   		
    	});
	});
	
	
	validValue = function() {
		
		if($('input[name=title]') == '') {
			alert('제목을 입력하세요');
			return false;
		}
	};

	//파일 선택 시 파일명 표시되도록
	$('input[name=tUploadFile]').each(function(i) {
		$(this).change(function() {
			$(this).parent().find('.inputText').val(getFileName($(this).val()));
		});
	});
	$('input[name=mUploadFile]').each(function(i) {
		$(this).change(function() {
			$(this).parent().find('.inputText').val(getFileName($(this).val()));
		});
	});
	
	selType('${view.top_banner_type}');
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

//var trName = ['#trImage','#trMobileImage','#trSummary','#trUrl','#trMobileUrl'];
var trName = ['#trImage','#trSummary','#trUrl'];
var trHide = {
 		'A1':'', 'A2':'none',	'A3':'none', 'A4':'none',
		'B1':'', 'B2':'',	'B3':'', 'B4':'none',
		'C1':'', 'C2':'',	'C3':'', 'C4':''
		};
var rowNum = {'A':1, 'B':3, 'C':4};

function selType(val){
	if( val == '' ){
		val = 'A';
	}
	
	for( var j=0; j<trName.length; j++ ){
		for( var i=1; i<=4; i++ ){
			$(trName[j]+i).css('display',trHide[val+i]);
			if(i == 1){
				$(trName[j]+i + ' th:first').attr("rowspan",rowNum[val]);
			}
		}
	}
	
	if( val == 'A' ){
		$('#spanText1').show();
		$('#spanText2').hide();
		$('#spanText3').hide();
		$('#spanText4').hide();
		$('#divImg1').show();
		$('#divImg2').hide();
		$('#divImg3').hide();
		$('#divImg4').hide();
//		$('#divMobileImg1').show();
//		$('#divMobileImg2').hide();
//		$('#divMobileImg3').hide();
		$('#imgSize1').text('882 * 140 px에 맞추어 등록해주시기 바랍니다.');
	}else if( val == 'B' ){
		$('#spanText1').hide();
		$('#spanText2').hide();
		$('#spanText3').show();
		$('#spanText4').hide();
		$('#divImg1').hide();
		$('#divImg2').hide();
		$('#divImg3').show();
		$('#divImg4').hide();
//		$('#divMobileImg1').hide();
//		$('#divMobileImg2').show();
//		$('#divMobileImg3').hide();
		$('#imgSize1').html('294 * 140 px에 맞추어 등록해주시기 바랍니다.');
	}else{
		$('#spanText1').hide();
		$('#spanText2').hide();
		$('#spanText3').hide();
		$('#spanText4').show();
		$('#divImg1').hide();
		$('#divImg2').hide();
		$('#divImg3').hide();
		$('#divImg4').show();
//		$('#divMobileImg1').hide();
//		$('#divMobileImg2').hide();
//		$('#divMobileImg3').show();
		$('#imgSize1').html('294 * 140 px에 맞추어 등록해주시기 바랍니다.');
	}
}
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/main/code/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.seq }'>
				<input type="hidden" name="seq" value="${view.seq }"/>
			</c:if>
			<input type="hidden" name="menu_type" value="${paramMap.menu_type }"/>
			<div id="205">
				<table summary="이벤트 베너 작성">
					<caption>이벤트 배너 작성</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">제목</th>
							<td colspan="3">
								<input type="text" name="title" style="width:670px" value="${view.title}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">시작일</th>
							<td>
								<input type="text" name="start_date" style="width:100px" value="${view.start_date}"/>
							</td>
							<th scope="row">종료일</th>
							<td>
								<input type="text" name="end_date" style="width:100px" value="${view.end_date}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">배너 이미지</th>
							<td colspan="3">
								<div class="fileInputs">
									<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
									<div class="fakefile">
										<input type="text" title="" class="inputText" />
										<span class="btn whiteS"><button>찾아보기</button></span>
									</div>
								</div>
								<span class="txt">300 * 160 px에 맞추어 등록해주시기 바랍니다.</span>
								<div>
									<c:if test='${not empty view.image_url }'>
										<img width="300" height="160" alt="" src="${view.image_url}">
									</c:if>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">이미지 설명</th>
							<td colspan="3">
								<textarea name="summary" style="width:100%;height:100px;"><c:out value="${view.summary }" escapeXml="true" /></textarea>
							</td>
						</tr>
						<tr>
							<th scope="row">URL</th>
							<td colspan="3">
								<input type="text" name="url" style="width:670px" value="${view.url}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">MOBILE URL</th>
							<td colspan="3">
								<input type="text" name="mobile_url" style="width:670px" value="${view.mobile_url}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">승인여부</th>
							<td colspan="3">
								<div class="inputBox">
									<label><input type="radio" name="status" value="W" checked="checked"/> 대기</label>
									<label><input type="radio" name="status" value="Y"/> 승인</label>
									<label><input type="radio" name="status" value="N"/> 미승인</label>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div id="206">
				<table summary="홍보배너 작성">
					<caption>홍보 배너 작성</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">제목</th>
							<td colspan="3">
								<input type="text" name="title" style="width:670px" value="${view.title}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">작성자</th>
							<td>
								<c:if test="${not empty view.user_id}">
									${view.user_id}
								</c:if>
								<c:if test="${empty view.user_id}">
									<c:out value='${sessionScope.admin_id}'/>
								</c:if>
							</td>
							<th scope="row">등록일</th>
							<td>
								<c:if test="${empty view.reg_date}">
									<jsp:useBean id="toDay" class="java.util.Date" />
									<fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" />
								</c:if>
								<c:if test="${empty view.reg_date}">
									${view.reg_date}
									<c:if test="${not empty view.upd_date}">
										(최종수정일 ${view.upd_date}) 
									</c:if>
								</c:if>
							</td>
						</tr>
						<tr>
							<th scope="row">시작일</th>
							<td>
								<input type="text" name="start_date" style="width:100px" value="${view.start_date}"/>
							</td>
							<th scope="row">종료일</th>
							<td>
								<input type="text" name="end_date" style="width:100px" value="${view.end_date}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">배너 이미지</th>
							<td colspan="3">
								<div class="fileInputs">
									<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
									<div class="fakefile">
										<input type="text" title="" class="inputText" />
										<span class="btn whiteS"><button>찾아보기</button></span>
									</div>
								</div>
								<span class="txt">169 * 90 px에 맞추어 등록해주시기 바랍니다.</span>
								<div>
									<c:if test='${not empty view.image_url }'>
										<img width="169" height="90" alt="" src="${view.image_url}">
									</c:if>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">연락처</th>
							<td colspan="3">
								<input type="text" name="tel" style="width:100px" value="${view.tel}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">URL</th>
							<td colspan="3">
								<input type="text" name="url" style="width:670px" value="${view.url}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">내용</th>
							<td colspan="3">
								<textarea id="contents" name="content" style="width:100%;height:100px;"><c:out value="${view.content}" escapeXml="true" /></textarea>
							</td>
						</tr>
						<tr>
							<th scope="row">요청사항</th>
							<td colspan="3">
								<textarea id="contents" name="request" style="width:100%;height:100px;"><c:out value="${view.request}" escapeXml="true" /></textarea>
							</td>
						</tr>
						<tr>
							<th scope="row">승인여부</th>
							<td colspan="3">
								<div class="inputBox">
									<label><input type="radio" name="status" value="W" checked="checked"/> 대기</label>
									<label><input type="radio" name="status" value="Y"/> 승인</label>
									<label><input type="radio" name="status" value="N"/> 미승인</label>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div id="207">
				<input type="hidden" name="start_date" value='2015-01-20'/>
				<input type="hidden" name="end_date" value='2099-01-20'/>
				<table summary="관련기관 배너 작성">
					<caption>관련기관 배너 작성</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">제목</th>
							<td colspan="3">
								<input type="text" name="title" style="width:100px" value="${view.title}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">배너 이미지</th>
							<td colspan="3">
								<div class="fileInputs">
									<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
									<div class="fakefile">
										<input type="text" title="" class="inputText" />
										<span class="btn whiteS"><button>찾아보기</button></span>
									</div>
								</div>
								<span class="txt">167 * 88 px에 맞추어 등록해주시기 바랍니다.</span>
								<div>
									<c:if test='${not empty view.image_url }'>
										<img width="167" height="88" alt="" src="${view.image_url}">
									</c:if>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">URL</th>
							<td colspan="3">
								<input type="text" name="url" style="width:670px" value="${view.url}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">승인여부</th>
							<td colspan="3">
								<div class="inputBox">
									<label><input type="radio" name="status" value="W" checked="checked"/> 대기</label>
									<label><input type="radio" name="status" value="Y"/> 승인</label>
									<label><input type="radio" name="status" value="N"/> 미승인</label>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div id="571">
				<table summary="핫존 작성">
					<caption>핫존 작성</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">핫존영역제목</th>
							<td colspan="3">
								<input type="text" name="banner_title" style="width:100px" value="${view.banner_title}"/>※ (예)추천문화공간, 추천문화공감 등
							</td>
						</tr>
						<tr>
							<th scope="row">제목</th>
							<td colspan="3">
								<input type="text" name="title" style="width:600px" value="${view.title}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">시작일</th>
							<td>
								<input type="text" name="start_date" style="width:100px" value="${view.start_date}"/>
							</td>
							<th scope="row">종료일</th>
							<td>
								<input type="text" name="end_date" style="width:100px" value="${view.end_date}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">배너 이미지</th>
							<td colspan="3">
								<div class="fileInputs">
									<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
									<div class="fakefile">
										<input type="text" title="" class="inputText" />
										<span class="btn whiteS"><button>찾아보기</button></span>
									</div>
								</div>
								<span class="txt">229 * 224 px에 맞추어 등록해주시기 바랍니다.</span>
								<div>
									<c:if test='${not empty view.image_url }'>
										<img width="229" height="224" alt="" src="${view.image_url}">
									</c:if>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">URL</th>
							<td colspan="3">
								<input type="text" name="url" style="width:670px" value="${view.url}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">승인여부</th>
							<td colspan="3">
								<div class="inputBox">
									<label><input type="radio" name="status" value="W" checked="checked"/> 대기</label>
									<label><input type="radio" name="status" value="Y"/> 승인</label>
									<label><input type="radio" name="status" value="N"/> 미승인</label>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div id="572">
				<table summary="내부홍보 베너 작성">
					<caption>내부홍보 배너 작성</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">제목</th>
							<td colspan="3">
								<input type="text" name="title" style="width:600px" value="${view.title}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">시작일</th>
							<td>
								<input type="text" name="start_date" style="width:100px" value="${view.start_date}"/>
							</td>
							<th scope="row">종료일</th>
							<td>
								<input type="text" name="end_date" style="width:100px" value="${view.end_date}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">배너 이미지</th>
							<td colspan="3">
								<div class="fileInputs">
									<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
									<div class="fakefile">
										<input type="text" title="" class="inputText" />
										<span class="btn whiteS"><button>찾아보기</button></span>
									</div>
								</div>
								<span class="txt">180 * 92px에 맞추어 등록해주시기 바랍니다.</span>
								<div>
									<c:if test='${not empty view.image_url }'>
										<img width="180" height="92" alt="" src="${view.image_url}">
									</c:if>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">이미지 설명</th>
							<td colspan="3">
								 ※ 웹접근성준수사항 - 이미지에 있는 텍스트를 동일하게 적어주세요. (주의: 개행없이 한줄로 작성, 내용 구분은 | 로 구분)
								<textarea name="summary" style="width:100%;height:100px;"><c:out value="${view.summary }" escapeXml="true" /></textarea>
							</td>
						</tr>
						<tr>
							<th scope="row">URL</th>
							<td colspan="3">
								<input type="text" name="url" style="width:670px" value="${view.url}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">승인여부</th>
							<td colspan="3">
								<div class="inputBox">
									<label><input type="radio" name="status" value="W" checked="checked"/> 대기</label>
									<label><input type="radio" name="status" value="Y"/> 승인</label>
									<label><input type="radio" name="status" value="N"/> 미승인</label>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			
			<div id="573">
				<table summary="타기관 홍보 베너 작성">
					<caption>타기관 홍보 배너 작성</caption>
					<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
					<tbody>
						<tr>
							<th scope="row">제목</th>
							<td colspan="3">
								<input type="text" name="title" style="width:600px" value="${view.title}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">시작일</th>
							<td>
								<input type="text" name="start_date" style="width:100px" value="${view.start_date}"/>
							</td>
							<th scope="row">종료일</th>
							<td>
								<input type="text" name="end_date" style="width:100px" value="${view.end_date}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">배너 이미지</th>
							<td colspan="3">
								<div class="fileInputs">
									<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
									<div class="fakefile">
										<input type="text" title="" class="inputText" />
										<span class="btn whiteS"><button>찾아보기</button></span>
									</div>
								</div>
								<span class="txt">294 * 88 px에 맞추어 등록해주시기 바랍니다.</span>
								<div>
									<c:if test='${not empty view.image_url }'>
										<img width="294" height="88" alt="" src="${view.image_url}">
									</c:if>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">이미지 설명</th>
							<td colspan="3">
								<textarea name="summary" style="width:100%;height:100px;"><c:out value="${view.summary }" escapeXml="true" /></textarea>
							</td>
						</tr>
						<tr>
							<th scope="row">URL</th>
							<td colspan="3">
								<input type="text" name="url" style="width:670px" value="${view.url}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">승인여부</th>
							<td colspan="3">
								<div class="inputBox">
									<label><input type="radio" name="status" value="W" checked="checked"/> 대기</label>
									<label><input type="radio" name="status" value="Y"/> 승인</label>
									<label><input type="radio" name="status" value="N"/> 미승인</label>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			
			
			<div id="701">
				<table summary="상단 베너 작성">
					<caption>상단 배너 작성</caption>
					<colgroup>
						<col style="width:15%" />
						<col style="width:15%" />
						<col style="width:15%" />
						<col style="width:15%" />
						<col style="width:35%" />
						<col style="" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">타입</th>
							<td>
								<select name="top_banner_type" style="width:100px;" title="상단배너타입 선택" onchange="javascript:selType(this.value);return;">
									<option value="A" ${empty view.top_banner_type or view.top_banner_type eq 'A' ? 'selected="selected"' : ''}>A</option>
									<option value="B" ${view.top_banner_type eq 'B' ? 'selected="selected"' : ''}>B</option>
									<%-- <option value="C" ${view.top_banner_type eq 'C' ? 'selected="selected"' : ''}>C</option> --%>
								</select>
							</td>
							<th scope="row">제목</th>
							<td colspan="3">
								<input type="text" name="title" style="width:100%" value="${view.title}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">시작일</th>
							<td colspan="2">
								<input type="text" name="start_date" style="width:100px" value="${view.start_date}"/>
							</td>
							<th scope="row">종료일</th>
							<td colspan="2">
								<input type="text" name="end_date" style="width:100px" value="${view.end_date}"/>
							</td>
						</tr>
						<tr id="trImage1">
							<th scope="row" rowspan="3">이미지</th>
							<td colspan="5">
								<div class="fileInputs">
									<input type="file" name="tUploadFile" class="file hidden" title="상단 첨부파일 선택" />
									<div class="fakefile">
										<input type="text" title="상단 이미지" class="inputText" value=""/>
										<span class="btn whiteS"><button>찾아보기</button></span>
									</div>
								</div>
								<span class="txt" id="imgSize1">882 * 140 px에 맞추어 등록해주시기 바랍니다.</span>
								<div id="divImg1">
									<c:if test="${view.image_url  ne 'http://www.culture.go.kr/upload/banner/' and not empty view.image_name }">
										<img src="${view.image_url}"  alt="${view.summary}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.image_url2  ne 'http://www.culture.go.kr/upload/banner/' and not empty view.image_name2 }">
										<img src="${view.image_url2}"  alt="${view.summary2}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.image_url3  ne 'http://www.culture.go.kr/upload/banner/' and not empty view.image_name3 }">
										<img src="${view.image_url3}"  alt="${view.summary3}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.image_url4  ne 'http://www.culture.go.kr/upload/banner/' and not empty view.image_name4 }">
										<img src="${view.image_url4}"  alt="${view.summary4}" style="width:auto; height:140px;"/>
									</c:if>
								</div>
							</td>
						</tr>
						<tr id="trImage2">
							<td colspan="5">
								<div class="fileInputs">
									<input type="file" name="tUploadFile" class="file hidden" title="상단 첨부파일 선택" />
									<div class="fakefile">
										<input type="text" title="상단 이미지" class="inputText" />
										<span class="btn whiteS"><button>찾아보기</button></span>
									</div>
								</div>
								<span class="txt">294 * 140 px에 맞추어 등록해주시기 바랍니다.</span>
								<div id="divImg2">
									<c:if test="${view.image_url  ne 'http://www.culture.go.kr/upload/banner/' and not empty view.image_name }">
										<img src="${view.image_url}"  alt="${view.summary}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.image_url2  ne 'http://www.culture.go.kr/upload/banner/' and not empty view.image_name2 }">
										<img src="${view.image_url2}"  alt="${view.summary2}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.image_url3  ne 'http://www.culture.go.kr/upload/banner/' and not empty view.image_name3 }">
										<img src="${view.image_url3}"  alt="${view.summary3}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.image_url4  ne 'http://www.culture.go.kr/upload/banner/' and not empty view.image_name4 }">
										<img src="${view.image_url4}"  alt="${view.summary4}" style="width:auto; height:140px;"/>
									</c:if>
								</div>
							</td>
						</tr>
						<tr id="trImage3">
							<td colspan="5">
								<div class="fileInputs">
									<input type="file" name="tUploadFile" class="file hidden" title="상단 첨부파일 선택" />
									<div class="fakefile">
										<input type="text" title="상단 이미지" class="inputText" />
										<span class="btn whiteS"><button>찾아보기</button></span>
									</div>
								</div>
								<span class="txt">294 * 140 px에 맞추어 등록해주시기 바랍니다.</span>
								<div id="divImg3">
									<c:if test="${view.image_url  ne 'http://www.culture.go.kr/upload/banner/' and not empty view.image_name }">
										<img src="${view.image_url}"  alt="${view.summary}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.image_url2  ne 'http://www.culture.go.kr/upload/banner/' and not empty view.image_name2 }">
										<img src="${view.image_url2}"  alt="${view.summary2}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.image_url3  ne 'http://www.culture.go.kr/upload/banner/' and not empty view.image_name3 }">
										<img src="${view.image_url3}"  alt="${view.summary3}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.image_url4  ne 'http://www.culture.go.kr/upload/banner/' and not empty view.image_name4 }">
										<img src="${view.image_url4}"  alt="${view.summary4}" style="width:auto; height:140px;"/>
									</c:if>
								</div>
							</td>
						</tr>
						<tr id="trImage4">
							<td colspan="5">
								<div class="fileInputs">
									<input type="file" name="tUploadFile" class="file hidden" title="상단 첨부파일 선택" />
									<div class="fakefile">
										<input type="text" title="상단 이미지" class="inputText" />
										<span class="btn whiteS"><button>찾아보기</button></span>
									</div>
								</div>
								<span class="txt">294 * 140 px에 맞추어 등록해주시기 바랍니다.</span>
								<div id="divImg4">
									<c:if test="${view.image_url  ne 'http://www.culture.go.kr/upload/banner/' and not empty view.image_name }">
										<img src="${view.image_url}"  alt="${view.summary}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.image_url2  ne 'http://www.culture.go.kr/upload/banner/' and not empty view.image_name2 }">
										<img src="${view.image_url2}"  alt="${view.summary2}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.image_url3  ne 'http://www.culture.go.kr/upload/banner/' and not empty view.image_name3 }">
										<img src="${view.image_url3}"  alt="${view.summary3}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.image_url4  ne 'http://www.culture.go.kr/upload/banner/' and not empty view.image_name4 }">
										<img src="${view.image_url4}"  alt="${view.summary4}" style="width:auto; height:140px;"/>
									</c:if>
								</div>
							</td>
						</tr>
						<%-- 
						모바일용 이미지는 기존 메인배너를 사용하기로 변경
						--%>
						<tr id="trMobileImage1" style="display:none;">
							<th scope="row" rowspan="3">모바일이미지</th>
							<td colspan="5">
								<div class="fileInputs">
									<input type="file" name="mUploadFile" class="file hidden" title="모바일 첨부파일 선택" />
									<div class="fakefile">
										<input type="text" title="모바일 이미지" class="inputText" />
										<span class="btn whiteS"><button>찾아보기</button></span>
									</div>
								</div>
								<span class="txt">882 * 140 px에 맞추어 등록해주시기 바랍니다.</span>
								<div>
									<c:if test='${view.mobile_image_url ne "http://www.culture.go.kr/upload/banner/" }'>
										<img width="253"  alt="" src="${view.mobile_image_url}">
									</c:if>
								</div>
								<div id="divMobileImg1">
									<c:if test="${view.mobile_image_url  ne 'http://www.culture.go.kr/upload/banner/' }">
										<img src="${view.mobile_image_url}"  alt="${view.summary}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.mobile_image_url2  ne 'http://www.culture.go.kr/upload/banner/' }">
										<img src="${view.mobile_image_url2}"  alt="${view.summary2}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.mobile_image_url3  ne 'http://www.culture.go.kr/upload/banner/' }">
										<img src="${view.mobile_image_url3}"  alt="${view.summary3}" style="width:auto; height:140px;"/>
									</c:if>
								</div>
							</td>
						</tr>
						<tr id="trMobileImage2" style="display:none;">
							<td colspan="5">
								<div class="fileInputs">
									<input type="file" name="mUploadFile" class="file hidden" title="모바일 첨부파일 선택" />
									<div class="fakefile">
										<input type="text" title="모바일 이미지" class="inputText" />
										<span class="btn whiteS"><button>찾아보기</button></span>
									</div>
								</div>
								<span class="txt">294 * 140 px에 맞추어 등록해주시기 바랍니다.</span>
								<div>
									<c:if test='${view.mobile_image_url2 ne "http://www.culture.go.kr/upload/banner/" }'>
										<img width="294" height="140" alt="" src="${view.mobile_image_url2}">
									</c:if>
								</div>
								<div id="divMobileImg2">
									<c:if test="${view.mobile_image_url  ne 'http://www.culture.go.kr/upload/banner/' }">
										<img src="${view.mobile_image_url}"  alt="${view.summary}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.mobile_image_url2  ne 'http://www.culture.go.kr/upload/banner/' }">
										<img src="${view.mobile_image_url2}"  alt="${view.summary2}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.mobile_image_url3  ne 'http://www.culture.go.kr/upload/banner/' }">
										<img src="${view.mobile_image_url3}"  alt="${view.summary3}" style="width:auto; height:140px;"/>
									</c:if>
								</div>
							</td>
						</tr>
						<tr id="trMobileImage3" style="display:none;">
							<td colspan="5">
								<div class="fileInputs">
									<input type="file" name="mUploadFile" class="file hidden" title="모바일 첨부파일 선택" />
									<div class="fakefile">
										<input type="text" title="모바일 이미지" class="inputText" />
										<span class="btn whiteS"><button>찾아보기</button></span>
									</div>
								</div>
								<span class="txt">294 * 140 px에 맞추어 등록해주시기 바랍니다.</span>
								<div>
									<c:if test='${view.mobile_image_url3 ne "http://www.culture.go.kr/upload/banner/" }'>
										<img width="294" height="140" alt="" src="${view.mobile_image_url3}">
									</c:if>
								</div>
								
								<div id="divMobileImg3">
									<c:if test="${view.mobile_image_url  ne 'http://www.culture.go.kr/upload/banner/' }">
										<img src="${view.mobile_image_url}"  alt="${view.summary}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.mobile_image_url2  ne 'http://www.culture.go.kr/upload/banner/' }">
										<img src="${view.mobile_image_url2}"  alt="${view.summary2}" style="width:auto; height:140px;"/>
									</c:if>
									<c:if test="${view.mobile_image_url3  ne 'http://www.culture.go.kr/upload/banner/' }">
										<img src="${view.mobile_image_url3}"  alt="${view.summary3}" style="width:auto; height:140px;"/>
									</c:if>
								</div>
							</td>
						</tr>
						<tr id="trSummary1">
							<th scope="row" rowspan="3">이미지 설명</th>
							<td colspan="5">
								<textarea name="summary" style="width:100%;height:100px;"><c:out value="${view.summary }" escapeXml="true" /></textarea>
								<span id="spanText1" style="display:none;">※ 웹 접근성 준수사항으로 반드시 작성해야 합니다.<br/>(작성 방법: 이미지에 있는 텍스트 동일하게 기입. / 한 줄로 작성. / 내용은 ‘| ‘로 구분 )</span>
							</td>
						</tr>
						<tr id="trSummary2">
							<td colspan="5">
								<textarea name="summary2" style="width:100%;height:100px;"><c:out value="${view.summary2 }" escapeXml="true" /></textarea>
								<span id="spanText2" style="display:none;">※ 웹 접근성 준수사항으로 반드시 작성해야 합니다.<br/>(작성 방법: 이미지에 있는 텍스트 동일하게 기입. / 한 줄로 작성. / 내용은 ‘| ‘로 구분 )</span>
							</td>
						</tr>
						<tr id="trSummary3">
							<td colspan="5">
								<textarea name="summary3" style="width:100%;height:100px;"><c:out value="${view.summary3 }" escapeXml="true" /></textarea>
								<span id="spanText3">※ 웹 접근성 준수사항으로 반드시 작성해야 합니다.<br/>(작성 방법: 이미지에 있는 텍스트 동일하게 기입. / 한 줄로 작성. / 내용은 ‘| ‘로 구분 )</span>
							</td>
						</tr>
						<tr id="trSummary4">
							<td colspan="5">
								<textarea name="summary4" style="width:100%;height:100px;"><c:out value="${view.summary4 }" escapeXml="true" /></textarea>
								<span id="spanText4">※ 웹 접근성 준수사항으로 반드시 작성해야 합니다.<br/>(작성 방법: 이미지에 있는 텍스트 동일하게 기입. / 한 줄로 작성. / 내용은 ‘| ‘로 구분 )</span>
							</td>
						</tr>
						<tr id="trUrl1">
							<th scope="row" rowspan="3">URL</th>
							<td colspan="5">
								<input type="text" name="url" style="width:670px" value="${view.url}"/>
							</td>
						</tr>
						<tr id="trUrl2">
							<td colspan="5">
								<input type="text" name="url2" style="width:670px" value="${view.url2}"/>
							</td>
						</tr>
						<tr id="trUrl3">
							<td colspan="5">
								<input type="text" name="url3" style="width:670px" value="${view.url3}"/>
							</td>
						</tr>
						<tr id="trUrl4">
							<td colspan="5">
								<input type="text" name="url4" style="width:670px" value="${view.url4}"/>
							</td>
						</tr>
						<%-- <tr id="trMobileUrl1">
							<th scope="row" rowspan="3">MOBILE URL</th>
							<td colspan="5">
								<input type="text" name="mobile_url" style="width:670px" value="${view.mobile_url}"/>
							</td>
						</tr>
						<tr id="trMobileUrl2">
							<td colspan="5">
								<input type="text" name="mobile_url2" style="width:670px" value="${view.mobile_url2}"/>
							</td>
						</tr>
						<tr id="trMobileUrl3">
							<td colspan="5">
								<input type="text" name="mobile_url3" style="width:670px" value="${view.mobile_url3}"/>
							</td>
						</tr> --%>
						<tr>
							<th scope="row">승인여부</th>
							<td colspan="5">
								<div class="inputBox">
									<label><input type="radio" name="status" value="W" checked="checked"/> 대기</label>
									<label><input type="radio" name="status" value="Y"/> 승인</label>
									<label><input type="radio" name="status" value="N"/> 미승인</label>
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