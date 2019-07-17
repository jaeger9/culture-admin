<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<script type="text/javascript">

$(function () {

	var frm = $('form[name=frm]');

	frm.submit(function(){
	
		if(frm.attr('action') != '/facility/athletics/delete.do'){
			
			if($('input[name=title]').val() == '') {
			    alert("시설명을 입력해주세요.");
			    $('input[name=title]').focus();
			    return false;
			}

			if(!$('select[name=cate1] > option:selected').val()) {
			    alert("체육시설분류를 선택하세요.");
			    $('select[name=cate1]').focus();
			    return false;
			}
			
			if($('input[name=address]').val() == '') {
			    alert("도로명주소를 입력해주세요.");
			    $('input[name=address]').focus();
			    return false;
			}
			
			if($('input[name=sido]').val() == '') {
			    alert("시도명을 입력해주세요.");
			    $('input[name=sido]').focus();
			    return false;
			}
			
			if($('input[name=gugun]').val() == '') {
			    alert("구군명을 입력해주세요.");
			    $('input[name=gugun]').focus();
			    return false;
			}
			
			if($('select[name=startampm] > option:selected').val()) {
				
				if(!$('select[name=startsi] > option:selected').val()) {
				    alert("개방시간 시간을 선택하세요.");
				    $('select[name=startsi]').focus();
				    return false;
				}else{
					if(!$('select[name=startbun] > option:selected').val()) {
					    alert("개방시간 분을 선택하세요.");
					    $('select[name=startbun]').focus();
					    return false;
					}
				}
			}
			
			if($('select[name=endampm] > option:selected').val()) {
				
				if(!$('select[name=endsi] > option:selected').val()) {
				    alert("종료시간 시간을 선택하세요.");
				    $('select[name=endsi]').focus();
				    return false;
				}else{
					if(!$('select[name=endbun] > option:selected').val()) {
					    alert("종료시간 분을 선택하세요.");
					    $('select[name=endbun]').focus();
					    return false;
					}
				}
			}
		}
		return true;
	});
	
	
	$('span.btn.whiteS a').click(function(){
		if( $(this).html() == '우편번호찾기'){
    		window.open('/popup/jusoPopup.do','postalcodePopup' , 'width=570, height=420, scrollbars=yes, resizable=yes');
    	} else if( $(this).html() == '좌표찾기'){
    		if($('input[name=address]').val() == ''){
    			alert('도로명주소를 입력해주세요');
    			return false;
    		}else{
    			window.open('/popup/coordinate.do','coordinatePopup', 'scrollbars=yes,width=500,height=550');	
    		}
    	}
  	});

	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		if (!confirm('수정하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/facility/athletics/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/facility/athletics/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/facility/athletics/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/facility/athletics/list.do';
        	}   		
    	});
	});
	
	
	//좌표
	setCoordinate = function (cul_gps_x , cul_gps_y){
		$('input[name=gpsx]').val(cul_gps_y);
		$('input[name=gpsy]').val(cul_gps_x);
	}

});




//도로명주소 Open Api
function jusoCallBack(sido, gugun, addr, addr2, zipNo){
	sido = sido.replace('특별시', '');
	sido = sido.replace('광역시', '');
	sido = sido.replace('세종특별자치시', '세종');
	sido = sido.replace('세종시', '세종');
	sido = sido.replace('경기도', '경기');
	sido = sido.replace('강원도', '강원');
	sido = sido.replace('충청북도', '충북');
	sido = sido.replace('충청남도', '충남');
	sido = sido.replace('전라북도', '전북');
	sido = sido.replace('전라남도', '전남');
	sido = sido.replace('경상북도', '경북');
	sido = sido.replace('경상남도', '경남');
	sido = sido.replace('제주특별자치도', '제주');
	sido = sido.replace('제주도', '제주');
	
	$('input[name="sido"]').val(sido);		//시도
	$('input[name="gugun"]').val(gugun);	//구군
	$('input[name="address"]').val(addr + ' ' + addr2);		//기본주소 + 상세주소
	
	$('input[name="cul_addr"]').val(addr);		//기본주소
	$('input[name="cul_addr2"]').val(addr2);	//상세주소
}

</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/facility/athletics/insert.do">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			
			<input type="hidden"  name="cul_addr" value="${view.address }"/>
			<input type="hidden"  name="cul_addr2" value=""/>
			
			
			<table summary="체육시설 등록/수정">
				<caption>체육시설 등록/수정</caption>
				<colgroup>
					<col style="width:20%" /><col style="width:30%" /><col style="width:22%" /><col style="width:28%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row"><span style="color: red">*</span> 시설명</th>
						<td colspan="3">
							<input type="text" name="title" value="${view.title }" maxlength="300" style="width:450px;"/>
						</td>
					</tr>
					<tr>
						<th scope="row">분류명</th>
						<td colspan="3">
							<input type="text" name="keyword" value="${view.keyword }" maxlength="200" style="width:450px;"/>
						</td>
					</tr>
					<tr>
						<th scope="row"><span style="color: red">*</span> 체육시설분류</th>
						<td>
							<select name="cate1">
								<option value="" ${empty view.cate1}>선택</option>
								<option value="간이" ${view.cate1 eq '간이' ? 'selected' : ''}>간이</option>
								<option value="공공" ${view.cate1 eq '공공' ? 'selected' : ''}>공공</option>
								<option value="기금" ${view.cate1 eq '기금' ? 'selected' : ''}>기금</option>
								<option value="기타" ${view.cate1 eq '기타' ? 'selected' : ''}>기타</option>
							</select>
						</td>
						<th scope="row">간이운동장 체육시설분류</th>
						<td>
							<input type="text" name="catge2" value="${view.catge2 }" maxlength="50" style="width:200px;"/>
						</td>
					</tr>
					<tr>
						<th scope="row">소유기관</th>
						<td>
							<input type="text" name="rights" value="${view.rights }" maxlength="50" style="width:200px;"/>
						</td>
						<th scope="row">관리주체</th>
						<td>
							<input type="text" name="contributor" value="${view.contributor}" maxlength="50" style="width:200px;"/>
						</td>
					</tr>					
					<tr>
						<th scope="row"><span style="color: red">*</span> 도로명주소</th>
						<td colspan="3">
							<div class="inputBox">
								<input type="text" name="address" value="${view.address }" maxlength="500" style="width:450px;"/>
								<span class="btn whiteS"><a href="#url">우편번호찾기</a></span>
								<span class="btn whiteS"><a href="#url">좌표찾기</a></span>
							</div>						
						</td>
					</tr>
					<tr>
						<th scope="row"><span style="color: red">*</span> 시도명</th>
						<td>
							<input type="text" name="sido" value="${view.sido}" maxlength="50" style="width:200px;"/>
						</td>
						<th scope="row"><span style="color: red">*</span> 구군명</th>
						<td>
							<input type="text" name="gugun" value="${view.gugun}" maxlength="50" style="width:200px;"/>
						</td>
					</tr>
					<tr>
						<th scope="row">동읍면</th>
						<td>
							<input type="text" name="dong" value="${view.dong}" maxlength="50" style="width:200px;"/>
						</td>
						<th scope="row">리</th>
						<td>
							<input type="text" name="li" value="${view.li}" maxlength="500" style="width:200px;"/>
						</td>
					</tr>
					<tr>
						<th scope="row">위도</th>
						<td>
							<input type="text" name="gpsx" value="${view.gpsx}" maxlength="50" style="width:200px;"/>
						</td>
						<th scope="row">경도</th>
						<td>
							<input type="text" name="gpsy" value="${view.gpsy}" maxlength="50" style="width:200px;"/>
						</td>					
					</tr>
					<tr>
						<th scope="row">시설면적</th>
						<td>
							<input type="text" name="sisul" value="${view.sisul}" maxlength="50" style="width:200px;"/>
						</td>
						<th scope="row">수용인원</th>
						<td>
							<input type="text" name="person" value="${view.person}" maxlength="50" style="width:200px;"/>
						</td>
					</tr>
					<tr>
						<th scope="row">관람석</th>
						<td>
							<input type="text" name="gaunram" value="${view.gaunram}" maxlength="50" style="width:200px;"/>
						</td>
						<th scope="row">관할지자체과</th>
						<td>
							<input type="text" name="rights2" value="${view.rights2}" maxlength="50" style="width:200px;"/>
						</td>
					</tr>
					<tr>
						<th scope="row">담당자연락처</th>
						<td>
							<input type="text" name="tel" value="${view.tel}" maxlength="50" style="width:200px;"/>
						</td>
						<th scope="row">홈페이지</th>
						<td>
							<input type="text" name="homepage" value="${view.homepage}" maxlength="500" style="width:200px;"/>
						</td>
					</tr>
					<tr>
						<th scope="row">개방시간</th>
						<td>
							<select name="startampm">
								<option value="">선택</option>
								<option value="오전" <c:if test="${'오전' eq view.startampm}">selected</c:if>>오전</option>
								<option value="오후" <c:if test="${'오후' eq view.startampm}">selected</c:if>>오후</option>
							</select>
							<select name="startsi">
								<option value="">선택</option>
								<c:forEach begin="1" end="12" var="i">
									<option value="${i}" <c:if test="${i eq view.startsi}">selected</c:if>>${i}</option>
								</c:forEach>
							</select>시
							<select name="startbun">
								<option value="">선택</option>
								<c:forEach begin="0" end="59" var="i">
									<c:choose>
										<c:when test="${i < 10 }">
											<c:set var="bun" value="0${i}"/>
										</c:when>
										<c:otherwise><c:set var="bun" value="${i}"/></c:otherwise>
									</c:choose>
									<option value="${bun}" <c:if test="${bun eq view.startbun}">selected</c:if>>${bun}</option>
								</c:forEach>
							</select>분
						</td>
						<th scope="row">종료시간</th>
						<td>
							<select name="endampm">
								<option value="">선택</option>
								<option value="오전" <c:if test="${'오전' eq view.endampm}">selected</c:if>>오전</option>
								<option value="오후" <c:if test="${'오후' eq view.endampm}">selected</c:if>>오후</option>
							</select>
							<select name="endsi">
								<option value="">선택</option>
								<c:forEach begin="1" end="12" var="i">
									<option value="${i}" <c:if test="${i eq view.endsi}">selected</c:if>>${i}</option>
								</c:forEach>
							</select>시
							<select name="endbun">
								<option value="">선택</option>
								<c:forEach begin="0" end="59" var="i">
									<c:choose>
										<c:when test="${i < 10 }">
											<c:set var="bun" value="0${i}"/>
										</c:when>
										<c:otherwise><c:set var="bun" value="${i}"/></c:otherwise>
									</c:choose>
									<option value="${bun}" <c:if test="${bun eq view.endbun}">selected</c:if>>${bun}</option>
								</c:forEach>
							</select>분
						</td>		
					</tr>
					<tr>
						<th scope="row">휴무일</th>
						<td colspan="3">
							<input type="text" name="rest" value="${view.rest}" maxlength="500" style="width:450px;"/>
						</td>
					</tr>
					<tr>
						<th scope="row">대중교통안내</th>
						<td colspan="3">
							<input type="text" name="trafic" value="${view.trafic}" maxlength="2000" style="width:450px;"/>
						</td>
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval" value="W" <c:if test="${empty view.approval or view.approval eq 'W'}">checked</c:if>/>대기</label>
								<label><input type="radio" name="approval" value="Y" <c:if test="${view.approval eq 'Y'}">checked</c:if>/>승인</label>
								<label><input type="radio" name="approval" value="N" <c:if test="${view.approval eq 'N'}">checked</c:if>/>미승인</label>
							</div>
						</td>
					</tr>
				</tbody>
			</table>

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