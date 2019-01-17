<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript">
function PopUp(pnum){
	
	var popupX = (window.screen.width / 2) - (300 / 2);
	var popupY= (window.screen.height /2) - (400 / 2);
	
	window.open("/cultureplan/servicemap/popup.do?pnum="+pnum, "placePopup", "scrollbars=yes,width=400,height=300,left="+ popupX + ", top="+ popupY + ", screenX="+ popupX + ", screenY= "+ popupY+"");
}
</script>
<script>
$(function () {
	
	var frm			=	$('form[name=frm]');
	var seq			=	frm.find('input[name=seq]');
	var approval	=	frm.find('input[name=approval]');
	/* var title		=	frm.find('input[name=title]');
	var sub_title	=	frm.find('input[name=sub_title]');
	var code		=	frm.find('select[name=code]');
	var content		=	frm.find('textarea[name=content]');
	var creator		=	frm.find('input[name=creator]');
 */
	frm.submit(function () {
		
		if (seq.val() != '') {
			if (!confirm('수정하시겠습니까?')) {
				return false;
			}
		}
		
		if (approval.filter(':checked').size() == 0) {
			approval.eq(0).focus();
			alert('승인여부를 선택해 주세요.');
			return false;
		}
		return true;
	});

	// 등록/수정
	$('.insert_btn').click(function () {
		
		frm.submit();
		return false;
	});
	
	// 삭제
	if ($('.delete_btn').size() > 0) {
		$('.delete_btn').click(function () {
			// 삭제
			if (!confirm('삭제하시겠습니까?')) {
				return false;
			}
			if (seq.val() == '') {
				alert('seq가 존재하지 않습니다.');
				return false;
			}

			var param = {
				seqs : [ seq.val() ]
			};

			$.ajax({
				url			:	'/cultureplan/servicemap/delete.do'
				,type		:	'post'
				,data		:	$.param(param, true)
				,dataType	:	'json'
				,success	:	function (res) {
					if (res.success) {
						alert("삭제가 완료 되었습니다.");
						location.href = $('.list_btn').attr('href');

					} else {
						alert("삭제 실패 되었습니다.");
					}
				}
				,error : function(data, approval, err) {
					alert("삭제 실패 되었습니다.");
				}
			});

			return false;
		});		
	}

});
</script>
</head>
<body>

<form name="frm" method="POST" action="/cultureplan/servicemap/view.do" >
<fieldset class="searchBox">
	<legend>상세 보기</legend>
	<input type="hidden" name="seq" value="${view.seq}" />

	<div class="tableWrite">
		<table summary="게시판 글 등록">
			<caption>게시판 글 등록</caption>
			<colgroup>
				<col style="width:15%" />
				<col style="width:35%" />
				<col style="width:15%" />
				<col style="width:35%" />
			</colgroup>
			<tbody>

				 <tr>
						<th scope="row">서비스비용</th>
						<td colspan="3">
							<input type="text" name="org_cost"  value="${view.org_cost }" style="width:400px" />
							<span class="btn whiteS"><a href="#" onclick="PopUp('1')">코드선택</a></span>
						</td>
				</tr>
				<tr>
					<th scope="row">서비스유형-오프라인</th>
					<td colspan="3">
						<input type="text" name="org_offline"  value="${view.org_offline }" style="width:400px" />
							<span class="btn whiteS"><a href="#" onclick="PopUp('2')">코드선택</a></span>
					</td>
				</tr>
				<tr>
					<th scope="row">서비스유형-온라인</th>
					<td colspan="3">
						<input type="text" name="org_online"  value="${view.org_online }" style="width:400px" />
						<span class="btn whiteS"><a href="#" onclick="PopUp('3')">코드선택</a></span>
					</td>
				</tr>
				<tr>
					<th scope="row">서비스대상-연령</th>
					<td colspan="3">
						<input type="text" name="org_age"  value="${view.org_age }" style="width:400px" />
						<span class="btn whiteS"><a href="#" onclick="PopUp('4')">코드선택</a></span>
					</td>
				</tr>
				<tr>
						<th scope="row">서비스대상-다양성</th>
						<td colspan="3">
							<input type="text" name="org_poly"  value="${view.org_poly }" style="width:400px" />
						<span class="btn whiteS"><a href="#" onclick="PopUp('5')">코드선택</a></span>
						</td>
				</tr>
					<tr>
						<th scope="row">서비스대상-직업</th>
						<td colspan="3">
							<input type="text" name="org_special"  value="${view.org_special }" style="width:400px" />
						<span class="btn whiteS"><a href="#" onclick="PopUp('6')">코드선택</a></span>
						</td>
					</tr>
					<tr>
						<th scope="row">서비스장르</th>
						<td colspan="3">
							<input type="text" name="org_genre" value="${view.org_genre }"  style="width:400px" />
						<span class="btn whiteS"><a href="#" onclick="PopUp('7')">코드선택</a></span>
						</td>
					</tr>
					<tr>
						<th scope="row">서비스구분</th>
						<td colspan="3">
							<input type="text" name="org_service"  value="${view.org_service }" style="width:400px" />
						<span class="btn whiteS"><a href="#" onclick="PopUp('8')">코드선택</a></span>
						</td>
					</tr>
					<tr>
						<th scope="row">서비스 기관구분</th>
						<td colspan="3">
						<select name="org_gubun">
									<option value="공기업" ${'공기업' eq view.org_gubun ? 'selected=selected' : ''}>공기업</option>
									<option value="기타 공공기관" ${'기타 공공기관' eq view.org_gubun ? 'selected=selected' : ''}>기타 공공기관</option>
									<option value="소관외청" ${'소관외청' eq view.org_gubun ? 'selected=selected' : ''}>소관외청</option>
									<option value="소속기관" ${'소속기관' eq view.org_gubun ? 'selected=selected' : ''}>소속기관</option>
									<option value="준정부기관" ${'준정부기관' eq view.org_gubun ? 'selected=selected' : ''}>준정부기관</option>
									<option value="준정부기관(위탁)" ${'준정부기관(위탁)' eq view.org_gubun ? 'selected=selected' : ''}>준정부기관(위탁)</option>
							</select>

						</td>
					</tr>
					<tr>
						<th scope="row">서비스 기관명</th>
						<td colspan="3">
						<input type="text" name="org_organ" value="${view.org_organ}"  style="width:400px" />
						</td>
					</tr>
				<tr>
					<th scope="row">서비스키워드</th>
					<td colspan="3">
	        			<textarea id="contents" name="org_keyword" style="width:100%;height:30px;">${view.org_keyword}</textarea>
	        			<b>ex)입력형식:#역사#고궁#궁궐#문화유산#4대궁#종묘#교육#관람안내</b>
					</td>
				</tr>
				<tr>
						<th scope="row">기관 사이트명</th>
						<td colspan="3">
						<input type="text" name="org_sitename" value="${view.org_sitename}" style="width:400px" />
						</td>
					</tr>
				<tr>
						<th scope="row">기관 URL</th>
						<td colspan="3">
						<input type="text" name="org_url" value="${view.org_url}" style="width:400px" /><br/>
						<b>URL 앞에 http:// 필수입력</b>
						</td>
					</tr>
					<tr>
						<th scope="row">기관 KeyService</th>
						<td colspan="3">
						<input type="text" name="org_keyservice"  value="${view.org_keyservice}"style="width:400px" />
						</td>
					</tr>	
				<tr>
					<th scope="row">승인여부${view.approval}</th>
					<td colspan="3">
						<label><input type="radio" name="approval" value="W" ${view.approval eq 'W' or empty view.approval ? 'checked="checked"' : '' } /> 대기</label>
						<label><input type="radio" name="approval" value="Y" ${view.approval eq 'Y' ? 'checked="checked"' : '' } /> 승인</label>
						<label><input type="radio" name="approval" value="N" ${view.approval eq 'N' ? 'checked="checked"' : '' } /> 미승인</label>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="btnBox textRight">
		<span class="btn white"><a href="#" class="insert_btn">${empty view.seq ? '등록' : '수정' }</a></span>
<c:if test="${not empty view.seq }">
			<span class="btn white"><a href="#" class="delete_btn">삭제</a></span>
		</c:if>
<span class="btn gray"><a href="/cultureplan/servicemap/list.do" class="list_btn">목록</a></span>
	</div>

</fieldset>
</form>

</form>

</body>
</html>