<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">

var cultureRecomIndex = 0;	
var menu_type = "${paramMap.menu_type }";

setResponseData = function(res){
	
};

// callback
var callback = {
		culturerecom : function(res) { 
			var due = true;
			if (res == null) {
				alert('CallBack Res Null');
				return false;
			};
			if(menu_type == '1'){
				for(var i = 1; i < 5; i++){
					$('#cultureRecom' + i).find('input').each(function(){
						inputForm = $(this);
						name = inputForm.attr('name');
						if(name == 'seq'){
							if(inputForm.val() == res.idx){
								alert("이미 선택된 영상입니다.");
								due = false;
								return false;
							};
						};
						
					});
				};
			}
			if(due == true){
				$('#cultureRecom' + cultureRecomIndex).find('input').each(function(){
					inputForm = $(this);
					name = inputForm.attr('name');
					if(name == 'title')inputForm.val(res.title);
					if(name == 'seq')inputForm.val(res.idx);
					$('#cultureRecom' + cultureRecomIndex + ' td span:first').html(res.title);
				});
			};
		
	}
}



$(function () {
	
	var frm = $('form[name=frm]');
	var recom_start_dat	=	frm.find('input[name=recom_start_dat]');
	var recom_end_dat	=	frm.find('input[name=recom_end_dat]');
	var recom_live_play_dat	=	frm.find('input[name=recom_live_play_dat]');
	new setDatepicker(recom_start_dat);new setDatepicker(recom_end_dat);new setDatepicker(recom_live_play_dat);
	
	<c:if test="${empty recomList}">
		<c:if test="${paramMap.menu_type eq '1' or paramMap.menu_type eq '2' or paramMap.menu_type eq '3' or paramMap.menu_type eq '4'  or paramMap.menu_type eq '5' or paramMap.menu_type eq '6' or paramMap.menu_type eq '7' or paramMap.menu_type eq '8'}">
			var dt = new Date();
			var year = String(dt.getFullYear());
			var month = String(dt.getMonth()+1);
			if(month.length < 2) {
				month = '0'+month;
			}
			var day = String(dt.getDate());
			$('input[name=recom_start_dat]').val(year+'-'+month+'-'+day);
			$('input[name=recom_end_dat]').val(year+'-'+month+'-'+day);
			$('input[name=recom_live_play_dat]').val(year+'-'+month+'-'+day);
		</c:if>
	</c:if>
	
	
	
	<c:if test="${not empty recomList}">
		<c:if test="${paramMap.menu_type eq '4'}">
			$('input[name=recom_live_yn][value="${view.recom_live_yn}"]').prop('checked', 'checked');
		</c:if>
	</c:if>
	
	// radio check
	if ('${view.approval_yn}') {
		$('input:radio[name="approval_yn"][value="${view.approval_yn}"]').prop('checked', 'checked');
	} else {
		$('input:radio[name="approval_yn"][value="W"]').prop('checked', 'checked');
	}
	$('span.btn.whiteS a').each(function(){
		$(this).click(function() {
			//console.log('$(this).html():' + $(this).html());
			///popup/culturerecom.do
			if($(this).html() == '문화 영상 선택') {
				cultureRecomIndex = $(this).attr('index');
				if(menu_type=='1'){
					window.open('/popup/list.do?menu_type='+menu_type+'&exception=Y', 'placePopup', 'scrollbars=yes,width=600,height=630');
				}else{
					window.open('/popup/list.do?menu_type='+menu_type, 'placePopup', 'scrollbars=yes,width=600,height=630');
				}
				
			}
			
		});
	});
	
	var theme_title		= frm.find('input[name=theme_title]');
	
	function chkFrm(type){
		if(type!='list'){
				if(theme_title.val() == '') {
				    alert("제목을 입력하세요");
				    theme_title.focus();
				    return false;
				}
				if(menu_type=='1' || menu_type=='2' || menu_type=='3'){
					
					var recom_start_dat		= frm.find('input[name=recom_start_dat]');
					var recom_end_dat		= frm.find('input[name=recom_end_dat]');
					
					if(recom_start_dat.val() == '') {
					    alert("시작일자를 입력하세요");
					    recom_start_dat.focus();
					    return false;
					}
					if(recom_end_dat.val() == '') {
					    alert("종료일자를 입력하세요");
					    recom_end_dat.focus();
					    return false;
					}
					
					for(var i=0 ; i < 4 ; i++)
					{
						if(document.forms['frm']['seq'][i].value==''){
							alert("추천 영상을 등록 하세요!");
							return false;
						}
					}
				}
				if(menu_type=='4'){
					<c:if test="${paramMap.live_type eq 'Y'}">
						var recom_live_start_hour	= frm.find('input[name=recom_live_start_hour]');
						var recom_live_start_min		= frm.find('input[name=recom_live_start_min]');
						var recom_live_end_hour		= frm.find('input[name=recom_live_end_hour]');
						var recom_live_end_min		= frm.find('input[name=recom_live_end_min]');
						var recom_url		= frm.find('input[name=recom_url]');
						var contents		= frm.find('input[name=contents]');
						
						if(recom_live_play_dat.val() == '') {
						    alert("시작일자를 입력하세요");
						    recom_live_play_dat.focus();
						    return false;
						}
						
						if(recom_live_start_hour.val() == '') {
						    alert("시작시간을 입력하세요");
						    recom_live_start_hour.focus();
						    return false;
						}
						
						if(recom_live_start_min.val() == '') {
						    alert("시작시간을 입력하세요");
						    recom_live_start_min.focus();
						    return false;
						}
						
						if(recom_live_end_hour.val() == '') {
						    alert("종료시간을 입력하세요");
						    recom_live_end_hour.focus();
						    return false;
						}
						
						if(recom_live_end_min.val() == '') {
						    alert("종료시간을 입력하세요");
						    recom_live_end_min.focus();
						    return false;
						}
						
						if(recom_url.val() == '') {
						    alert("영상 주소를 입력하세요");
						    recom_url.focus();
						    return false;
						}
					
					</c:if>
					<c:if test="${paramMap.live_type ne 'Y'}">
						var recom_start_dat		= frm.find('input[name=recom_start_dat]');
						var recom_end_dat		= frm.find('input[name=recom_end_dat]');
						if(recom_start_dat.val() == '') {
						    alert("시작일자를 입력하세요");
						    recom_start_dat.focus();
						    return false;
						}
						if(recom_end_dat.val() == '') {
						    alert("종료일자를 입력하세요");
						    recom_end_dat.focus();
						    return false;
						}
						if(document.getElementById("seq").value==''){
							alert("추천 영상을 등록 하세요!");
							return false;
						}
					</c:if>
					
				}
				if(menu_type=='5' || menu_type=='6' || menu_type=='7' || menu_type=='8'){
					var recom_start_dat		= frm.find('input[name=recom_start_dat]');
					var recom_end_dat		= frm.find('input[name=recom_end_dat]');
					
					if(recom_start_dat.val() == '') {
					    alert("시작일자를 입력하세요");
					    recom_start_dat.focus();
					    return false;
					}
					if(recom_end_dat.val() == '') {
					    alert("종료일자를 입력하세요");
					    recom_end_dat.focus();
					    return false;
					}
					if(document.getElementById("seq").value==''){
						alert("추천 영상을 등록 하세요!");
						return false;
					}
				}
				return true;
			
		}
	}
	
	
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
    		if($(this).html() == '수정') { 
        		if (!confirm('수정하시겠습니까?')) {
        			return false;
        		}
        		action = "update";
        		frm.attr('action' ,'/magazine/recomCulture/insert.do');
        		
        		if(chkFrm('none')){
        			frm.submit();
        		}
        		
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		action = "delete";
        		frm.attr('action' ,'/magazine/recomCulture/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		action = "insert";
        		frm.attr('action' ,'/magazine/recomCulture/insert.do');
        		if(chkFrm('none')){
        			frm.submit();
        		}
        	} else if($(this).html() == '목록') {
        		action = "list";
        		frm.attr('action' ,'/magazine/recomCulture/recomList.do');
        		$('input[name=select_type]').val('list');
        		frm.submit();
        	}   		
    	});
	});
	
});
</script>
</head>
<body>
	<div class="tableWrite">
		<form name="frm" method="post" action="/magazine/recomCulture/update.do" enctype="multipart/form-data">
			<input type="hidden" name="menu_type" value="${paramMap.menu_type }"/>
			<input type="hidden" name="idx" value="${paramMap.idx }"/>
			<input type="hidden" name="select_type" value=""/>
			<c:if test="${not empty recomList}">
				<input type="hidden" name="formstatus" value="update"/>
			</c:if>
			<ul class="tab">
				<c:forEach items="${VodCateList }" var="VodCateList" varStatus="status">
					<li>
						<a href="/magazine/recomCulture/recomList.do?menu_type=${VodCateList.value}" <c:if test="${ paramMap.menu_type eq VodCateList.value }"> class="focus"</c:if>>
							${VodCateList.name}
						</a>
					</li>
				</c:forEach>
			</ul>
			<div id="300">
				<table>
				<caption>추천 영상 관리</caption>
				<colgroup><col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<c:if test="${paramMap.menu_type ne '4'}">
							<th scope="row">테마 제목</th>
							<td colspan="3">
								<input type="text" name="theme_title" style="width:670px" value="${view.theme_title}"/>
							</td>
						</c:if>
						
						<c:if test="${paramMap.menu_type eq '4'}">
							<c:if test="${paramMap.live_type ne 'Y'}">
								<th scope="row">테마 제목</th>
								<td colspan="3">
									<input type="text" name="theme_title" style="width:670px" value="${view.theme_title}"/>
								</td>
							</c:if>
							<c:if test="${paramMap.live_type eq 'Y'}">
								<th scope="row">테마 제목</th>
								<td>
									<input type="text" name="theme_title" style="width:350px" value="${view.theme_title}"/>
								</td>
								<th></th>
								<td>
									<input type="checkbox" value="Y" name="view_recom_live_yn" checked disabled/> 실시간LIVE
									<input type="hidden" value="Y" name="recom_live_yn"/>
								</td>
							</c:if>
						</c:if>
						
						
					</tr>
					
					<c:if test="${not empty recomList}">
							<c:if test="${paramMap.menu_type eq '1' or paramMap.menu_type eq '2' or paramMap.menu_type eq '3' or paramMap.menu_type eq '5' or paramMap.menu_type eq '6' or paramMap.menu_type eq '7' or paramMap.menu_type eq '8'}">
								<tr>
									<th scope="row">시작일</th>
									<td>
										<input type="text" name="recom_start_dat" value="${view.recom_start_dat}" />
									</td>
									<th scope="row">종료일</th>
									<td>
										<input type="text" name="recom_end_dat" value="${view.recom_end_dat}" />
									</td>
								</tr>
							</c:if>
							
							<c:if test="${paramMap.menu_type eq '4'}">
								<c:if test="${paramMap.live_type ne 'Y'}">
									<tr>
										<th scope="row">시작일</th>
										<td>
											<input type="text" name="recom_start_dat" value="${view.recom_start_dat}" />
										</td>
										<th scope="row">종료일</th>
										<td>
											<input type="text" name="recom_end_dat" value="${view.recom_end_dat}" />
										</td>
									</tr>
								</c:if>
								<c:if test="${paramMap.live_type eq 'Y'}">
									<tr>
										<th scope="row">LIVE 시간</th>
										<td colspan="3">
											<input type="text" name="recom_live_play_dat" value="${view.recom_live_play_dat}" />
											&nbsp;&nbsp;
											<input type="text" name="recom_live_start_hour" value="${paramMap.recom_live_start_hour}" style="width:20px"/>시&nbsp;
											<input type="text" name="recom_live_start_min" value="${paramMap.recom_live_start_min}" style="width:20px"/>분&nbsp;~&nbsp;
											<input type="text" name="recom_live_end_hour" value="${paramMap.recom_live_end_hour}" style="width:20px"/>시&nbsp;
											<input type="text" name="recom_live_end_min" value="${paramMap.recom_live_end_min}" style="width:20px"/>분&nbsp;까지&nbsp;
											*실시간 LIVE 일경우 시간을 입력해주세요										
										</td>
									</tr>
									<tr>
										<th scope="row">URL 입력</th>
										<td colspan="3">
											<input type="text" name="recom_url" value="${view.recom_url}" style="width:430px"/>
											*실시간 LIVE 일경우 시간을 입력해주세요.										
										</td>
									</tr>
									<tr>
										<th scope="row">내      용 </th>
										<td colspan="3">
											<textarea rows="3" style="width:430px" name="contents">${view.contents}</textarea>								
										</td>
									</tr>
								</c:if>
							</c:if>
							
							<c:if test="${paramMap.menu_type eq '1' or paramMap.menu_type eq '2' or paramMap.menu_type eq '3'}">
								<c:forEach begin="0" end="5" items="${recomList }" var="recomList" varStatus="status">
									<tr id="cultureRecom${status.count}">
										<c:if test="${status.first }">
											<th scope="row" rowspan="6">문화 영상</th>
										</c:if>
										<td colspan="3">
											<span>${recomList.title}</span>
											<span class="btn whiteS"><a href="#url" index="${status.count}">문화 영상 선택</a></span>
											<input type="hidden" value="${recomList.title}" name="title">
											<input type="hidden" value="${recomList.idx}" name="seq">
										</td>
									</tr>
								</c:forEach>
							</c:if>
							<c:if test="${(paramMap.menu_type eq '4' and paramMap.live_type ne 'Y') or paramMap.menu_type eq '5' or paramMap.menu_type eq '6' or paramMap.menu_type eq '8'}">
								<c:forEach begin="0" end="0" items="${recomList }" var="recomList" varStatus="status">
									<tr id="cultureRecom${status.count}">
										<c:if test="${status.first }">
											<th scope="row" rowspan="1">문화 영상</th>
										</c:if>
										<td colspan="3">
											<span>${recomList.title}</span>
											<span class="btn whiteS"><a href="#url" index="${status.count}">문화 영상 선택</a></span>
											<input type="hidden" value="${recomList.title}" name="title">
											<input type="hidden" value="${recomList.idx}" name="seq" id="seq">
										</td>
									</tr>
								</c:forEach>
							</c:if>
							<c:if test="${paramMap.menu_type eq '7'}">
								<c:forEach begin="0" end="0" items="${recomList }" var="recomList" varStatus="status">
									<tr id="cultureRecom${status.count}">
										<c:if test="${status.first }">
											<th scope="row" rowspan="1">문화 영상</th>
										</c:if>
										<td colspan="3">
											<span>${recomList.title}</span>
											<span class="btn whiteS"><a href="#url" index="${status.count}">문화 영상 선택</a></span>
											<input type="hidden" value="${recomList.title}" name="title">
											<input type="hidden" value="${recomList.idx}" name="seq" id="seq">
										</td>
									</tr>
									<tr>
										<th scope="row">내      용 </th>
										<td colspan="3">
											<textarea rows="3" style="width:430px" name="contents">${view.contents}</textarea>								
										</td>
									</tr>
								</c:forEach>
							</c:if>
					</c:if>
					<c:if test="${empty recomList}">
						<c:if test="${paramMap.menu_type eq '1' or paramMap.menu_type eq '2' or paramMap.menu_type eq '3' or paramMap.menu_type eq '5' or paramMap.menu_type eq '6' or paramMap.menu_type eq '7' or paramMap.menu_type eq '8'}">
								<tr>
									<th scope="row">시작일</th>
									<td>
										<input type="text" name="recom_start_dat" value="" />
									</td>
									<th scope="row">종료일</th>
									<td>
										<input type="text" name="recom_end_dat" value="" />
									</td>
								</tr>
						</c:if>
						<c:if test="${paramMap.menu_type eq '4'}">
							<c:if test="${paramMap.live_type ne 'Y'}">
								<tr>
										<th scope="row">시작일</th>
										<td>
											<input type="text" name="recom_start_dat" value="" />
										</td>
										<th scope="row">종료일</th>
										<td>
											<input type="text" name="recom_end_dat" value="" />
										</td>
								</tr>
							</c:if>
							<c:if test="${paramMap.live_type eq 'Y'}">
								<tr>
									<th scope="row">LIVE 시간</th>
									<td colspan="3">
										<input type="text" name="recom_live_play_dat" value="" />
										&nbsp;&nbsp;
										<input type="text" name="recom_live_start_hour" value="" style="width:20px"/>시&nbsp;
										<input type="text" name="recom_live_start_min" value="" style="width:20px"/>분&nbsp;~&nbsp;
										<input type="text" name="recom_live_end_hour" value="" style="width:20px"/>시&nbsp;
										<input type="text" name="recom_live_end_min" value="" style="width:20px"/>분&nbsp;까지&nbsp;
										*실시간 LIVE 일경우 시간을 입력해주세요.										
									</td>
								</tr>
								<tr>
									<th scope="row">URL 입력</th>
									<td colspan="3">
										<input type="text" name="recom_url" value="" style="width:430px"/>
										*해당 영상 유투브 URL을 입력해주세요.								
									</td>
								</tr>
							</c:if>
						</c:if>
						<c:if test="${paramMap.menu_type eq '1' or paramMap.menu_type eq '2' or paramMap.menu_type eq '3'}">
							<c:forEach begin="0" end="3"  varStatus="status">
								<tr id="cultureRecom${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="6">문화 영상</th>
									</c:if>
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">문화 영상 선택</a></span>
										<input type="hidden" value="" name="title">
										<input type="hidden" value="" name="seq">
									</td>
								</tr>
							</c:forEach>
						</c:if>
						<c:if test="${(paramMap.menu_type eq '4' and paramMap.live_type ne 'Y') or paramMap.menu_type eq '5' or paramMap.menu_type eq '6' or paramMap.menu_type eq '7' or paramMap.menu_type eq '8'}">
							<c:forEach begin="0" end="0"  varStatus="status">
								<tr id="cultureRecom${status.count}">
									<c:if test="${status.first }">
										<th scope="row" rowspan="1">문화 영상</th>
									</c:if>
									<td colspan="3">
										<span></span>
										<span class="btn whiteS"><a href="#url" index="${status.count}">문화 영상 선택</a></span>
										<input type="hidden" value="" name="title">
										<input type="hidden" value="" name="seq" id="seq">
									</td>
								</tr>
							</c:forEach>
						</c:if>
					</c:if>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval_yn" value="W"/> 대기</label>
								<label><input type="radio" name="approval_yn" value="Y"/> 승인</label>
								<label><input type="radio" name="approval_yn" value="N"/> 미승인</label>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>
	</div>
	<div class="btnBox textRight">
		<c:if test='${not empty recomList}'>
			<span class="btn white"><button type="button">수정</button></span>
			<span class="btn white"><button type="button">삭제</button></span>
		</c:if>
		<c:if test='${empty recomList }'>
			<span class="btn white"><button type="button">등록</button></span>
		</c:if>
		<span class="btn gray"><button type="button">목록</button></span>
	</div>
</body>
</html>