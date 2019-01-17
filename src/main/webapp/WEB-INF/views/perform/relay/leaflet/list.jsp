<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
$(function () {

	//layout
	
	//승인 , 미승인 , 삭제 이벤트 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '삭제') {
        		deleteSites();
        	} else if($(this).html() == '승인') {
				$('input[name=updateStatus]').val('Y');
				updateStatus();
        	} else if($(this).html() == '미승인') {
        		$('input[name=updateStatus]').val('N');
        		updateStatus();
			}
    	});
	});
	
	fileUpload = function(index){
		if (!confirm('배포 하시겠습니까?')) {
			return false;
		}
		frm = $('#frm' + index);
		frm.attr('action' , "/perform/relay/leaflet/distribute.do");
		frm.submit();

		return true;
	}

	fileDel = function(index){
		if(!confirm('삭제 하시겠습니까?')){
			return;
		}
		frm = $('#frm' + index);
		frm.attr('action' , "/perform/relay/leaflet/delete.do");
		frm.submit();
	}
	
	//삭제
	deleteSites = function () { 
		
		if(getCheckBoxCheckCnt() == 0) {
			alert('삭제할 코드를 선택하세요');
			return false;
		}
		
		formSubmit('/perform/show/delete.do');
	}
	
	//submit
	formSubmit = function (url) { 
		frm.attr('action' , url);
		frm.submit();		
	};
});


</script>
</head>
<body>
	<!-- 검색 필드 -->
		<input type="hidden" name="page_no" value="${paramMap.page_no }"/>
		<input type="hidden" name="updateStatus" value=""/> 
		<!-- 건수  -->
		<div class="topBehavior">
			<p class="totalCnt">총 <span>${count}</span>건</p>
			<ul class="sortingList">
				<li class="on"><a href="#url">최신순</a></li>
				<li><a href="#url">조회순</a></li>
			</ul>
		</div>
		<!-- 리스트 -->
		<div class="tableList">
			<table summary="리플렛 파일  목록">
				<caption>리플렛 파일 목록</caption>
				<colgroup>
					<col style="width:10%" />
					<col style="width:20%" />
					<col style="width:%" />
					<col style="width:10%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">기간</th>
						<th scope="col">리플렛</th>
						<th scope="col">등록여부</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="list" varStatus="status">
							<tr>
								<td>${status.count}</td>
								<td>
									<c:choose>
										<c:when test="${list.gubun eq 1 }"><c:out value="${list.year }" />년&nbsp;01월~02월</c:when>
										<c:when test="${list.gubun eq 2 }"><c:out value="${list.year }" />년&nbsp;03월~04월</c:when>
										<c:when test="${list.gubun eq 3 }"><c:out value="${list.year }" />년&nbsp;05월~06월</c:when>
										<c:when test="${list.gubun eq 4 }"><c:out value="${list.year }" />년&nbsp;07월~08월</c:when>
										<c:when test="${list.gubun eq 5 }"><c:out value="${list.year }" />년&nbsp;09월~10월</c:when>
										<c:when test="${list.gubun eq 6 }"><c:out value="${list.year }" />년&nbsp;11월~12월</c:when>
									</c:choose>
								</td>
								<td>
									<form name="form" id="frm<c:out value="${status.count }" />" action="relayLeafletPersist.do" method="post" enctype="multipart/form-data">
										<input type="file" name="uploadFile"  />
										<input type="hidden" name="gubun" value="<c:out value="${list.year }${list.gubun}" />" />
										
										<span class="btn whiteS"><a href="#" class="btnN" onclick="fileUpload('<c:out value="${status.count }" />')">배포</a></span>
										<span class="btn whiteS"><a href="#" class="btnN" onclick="fileDel('<c:out value="${status.count}" />')">삭제</a></span>
									</form>
								</td>
								<td>
									<c:set value="${list.year }${list.gubun }.jpg" var="jpg"/>
									<c:choose>
										<c:when test="${not empty fileList[jpg] }">등록</c:when>
										<c:otherwise>미등록</c:otherwise>
									</c:choose>
								</td>
							</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>
