<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
</head>
<body>
	
		<!-- 리스트 -->
		<div class="tableList">
			<table summary="게시판 글 목록">
				<caption>게시판 글 목록</caption>
				<colgroup>
					<col />
					<col />
				</colgroup>
				<thead>	
					<tr>
						<th scope="col">투표 작품명</th>
						<th scope="col">투표수</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list }" var="item" varStatus="status">
						<tr>
							<td>
								<c:choose>
									<c:when test="${item.poll_num eq 1}">골목매표소</c:when>
									<c:when test="${item.poll_num eq 2}">문화N티켓</c:when>
									<c:when test="${item.poll_num eq 3}">문화상회(文化商會)</c:when>
									<c:when test="${item.poll_num eq 4}">소중한 티켓</c:when>
									<c:when test="${item.poll_num eq 5}">문화누리마루</c:when>
								</c:choose>								
							</td>
							<td>${item.cnt}</td>
						</tr>
					</c:forEach>
					<tr style="background-color:#F0F0F0;">
						<td>총계</td>
						<td>${all_cnt }</td>
					</tr>		
				</tbody>
			</table>
		</div>

</body>
</html>