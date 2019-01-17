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
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '목록') {
        		console.log('목록');
        		location.href='/magazine/tag/pdlist.do?seq=${paramMap.seq}';
        	}   		
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/magazine/blog/insert.do">
			<table summary="블로그 등록/수정">
				<caption>블로그 등록/수정</caption>
				<colgroup>
					<col style="width:17%" /><col style="width:33%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">제품명</th>
						<td colspan="3">
							<c:out value="${view.title}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">지역/분류</th>
						<td>
							${view.service_name} / ${view.area_name }
						</td>
						<th scope="row">제작</th>
						<td>
							${view.user_name}
						</td>
					</tr>
					<tr>
						<td class="onPage" colspan="4">
							<div style="width:100%; text-align:center; margin:10px 0 10px 0;">
								<object id="MGPlayer" name="MGPlayer" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="580" height="360" id="player" align="middle">
									<param name="allowScriptAccess" value="always" />
									<param name="allowFullScreen" value="true" />
									<param name="movie" value="/player/MGPlayer.swf?mode=service&accessJS=true&cID=<c:out value="${view.cid}" />&isCopy=true&startTime=0&endTime=0&autoPlay=true&volume=50" />
									<param name="quality" value="high" />
									<param name="bgcolor" value="#000000" />
									<!--[if !IE]>-->
									<object name="MGPlayer" type="application/x-shockwave-flash" width="580" height="360"
										data="/player/MGPlayer.swf?mode=service&accessJS=true&cID=<c:out value="${view.cid}" />&isCopy=true&startTime=0&endTime=0&autoPlay=true&volume=50">
									<param name="allowScriptAccess" value="always" />
									<param name="allowFullScreen" value="true" />
									<param name="quality" value="high" />
									<param name="bgcolor" value="#000000" />
										<!--<![endif]-->
										<p>해당 콘텐츠는 플래시 플레이어 10 이상에서 정상적으로 작동합니다.</p>
										<p><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" border="0" alt="Get Adobe Flash player" title="Get Adobe Flash player" /></a></p>
										<!--[if !IE]>-->
									</object>
									<!--<![endif]-->
								</object>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">관련태그</th>
						<td colspan="3">
							<c:forEach items="${tags}" var="tags" varStatus="status">
								<c:if test="${status.index > 0}">,</c:if>
								<c:out value="${tags.tag_name}" />
							</c:forEach>
						</td>
					</tr>
					<tr>
						<th scope="row">관련사이트</th>
						<td colspan="3">
							<c:forEach var="site" items="${site}" varStatus="status">
								<c:if test="${status.index > 0}">
									<br />
								</c:if>
								<a href="<c:out value="${site.url}" />" target="_blank">
									<c:out value="${site.site_url}" />
								</a>
							</c:forEach>
						</td>
					</tr>
					<c:if test="${cmntList.size > 0}">
						<tr>
							<td class="onPage" colspan="8">
								<c:forEach var="cmntList" items="${cmntList}" varStatus="status">
									<div style="margin-bottom:5px; border-bottom:1px #ccc solid;">
										<c:out value="${cmntList.user_id} | ${cmntList.write_dat} ${cmntList.write_time}" /><br />
										<c:out value="${cmntList.contents}" />
									</div>
								</c:forEach>
							</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</form>
	</div>
	<div class="btnBox textRight">
		<span class="btn gray"><button type="button">목록</button></span>
	</div>
</body>
</html>