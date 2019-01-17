<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">

$(function () {

	// 비밀번호 수정
	$('.resetPassword_btn').click(function () {
		// 삭제
		if (!confirm('비밀번호를 수정 하시겠습니까?')) {
			return false;
		}

		var frm = $('form[name=frm]');
		var seq = frm.find('input[name=seq]');
		var pwd = frm.find('input[name=pwd]');

		if (pwd.val() == '') {
			pwd.focus();
			alert('비밀번호를 입력해 주세요.');
			return false;
		}

		var param = {
			seq : seq.val()
			,pwd  : pwd.val()
		};

		$.ajax({
			url			:	'/addservice/contest/password.do'
			,type		:	'post'
			,data		:	$.param(param, true)
			,dataType	:	'json'
			,success	:	function (res) {
				if (res.success) {
					alert("비밀번호가 '" + pwd.val() + "' 수정 되었습니다.");
					pwd.val('');
				} else {
					alert("비밀번호 수정에 실패했습니다.");
				}
			}
			,error : function(data, status, err) {
				alert("비밀번호 수정에 실패했습니다.");
			}
		});

		return false;
	});

});
</script>
</head>
<body>

<form name="frm">
	<input type="hidden" name="qs" value="${paramMap.qr }" />
	<input type="hidden" name="seq" value="${view.seq }" />

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
					<th scope="row">고유번호</th>
					<td>
						${view.seq }
					</td>
					<th scope="row">등록일</th>
					<td>
						${view.reg_dt }
					</td>
				</tr>
				<tr>
					<th scope="row">성명</th>
					<td>
						${view.name }
					</td>
					<th scope="row">소속</th>
					<td>
						${view.attach }
					</td>
				</tr>
				<tr>
					<th scope="row">팀원</th>
					<td colspan="3">
						${view.team }
					</td>
				</tr>
				<tr>
					<th scope="row">비밀번호 초기화</th>
					<td colspan="3">
						<input type="text" name="pwd" value="" style="width:150px" />
						<span class="btn whiteS"><a href="#" class="resetPassword_btn">비밀번호 변경</a></span>
					</td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td colspan="3">
						${view.email }
					</td>
				</tr>
				<tr>
					<th scope="row">전화번호</th>
					<td colspan="3">
						${view.tel }
					</td>
				</tr>
				<tr>
					<th scope="row">휴대전화번호</th>
					<td colspan="3">
						${view.hp }
					</td>
				</tr>
				<tr>
					<th scope="row">주소</th>
					<td colspan="3">
						[${view.zipcode }]
						${view.addr }
						${view.addr_detail }
					</td>
				</tr>
				<tr>
					<th scope="row">서비스 제목</th>
					<td colspan="3">
						${view.title }
					</td>
				</tr>
				<tr>
					<th scope="row">접수 번호</th>
					<td colspan="3">
						${view.receipt }
					</td>
				</tr>
				<tr>
					<th scope="row">접수분야</th>
					<td colspan="3">
						<c:choose>
							<c:when test="${view.category eq 'WEB' }">웹</c:when>
							<c:when test="${view.category eq 'MOB' }">모바일</c:when>
							<c:when test="${view.category eq 'OFF' }">아이디어기획</c:when>
							<c:when test="${view.category eq 'DEV' }">제품개발창업</c:when>
							<c:otherwise>기타</c:otherwise>
						</c:choose>
						/
						<c:choose>
							<c:when test="${view.category eq 'ON' }">온라인</c:when>
							<c:when test="${view.category eq 'OFF' }">오프라인</c:when>
							<c:when test="${view.category eq 'APP' }">모바일앱웹</c:when>
							<c:when test="${view.category eq 'DEV' }"></c:when>
							<c:otherwise></c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th scope="row">활용기관</th>
					<td colspan="3">
						${view.agents }
					</td>
				</tr>
				<tr>
					<th scope="row">서비스 설명</th>
					<td colspan="3">
						${view.serviceinfo }
					</td>
				</tr>
				<tr>
					<th scope="row">다운로드</th>
					<td colspan="3">
						<c:if test="${not empty view.file_sysname }">
							<c:url var="urlFile" value="http://www.culture.go.kr/download.do">
								<c:param name="filename" value="/contest/${view.file_sysname }" />
								<c:param name="orgname" value="${view.file_orgname }" />
							</c:url>
							<a href="${urlFile }" target="_blank">첨부파일 다운로드</a>
						</c:if>
						<c:if test="${empty view.file_sysname }">-</c:if>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div class="btnBox textRight">
		<span class="btn gray"><a href="/addservice/contest/list.do?${paramMap.qr_dec }" class="list_btn">목록</a></span>
	</div>
</form>
</body>
</html>