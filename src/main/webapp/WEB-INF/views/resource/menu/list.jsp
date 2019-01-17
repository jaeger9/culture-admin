<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<link type="text/css" rel="stylesheet" href="/js/jquery/zTree/zTreeStyle.css" />
<style type="text/css">

#mwrap				{}
.siteWrap			{padding:10px; border:1px solid #ddd;}
.siteWrap label		{display:inline-block; width:60px; vertical-align:middle;}
.siteWrap select	{min-width:200px; height:22px; border:1px solid #ccc; vertical-align:middle;}
.menuMng			{margin:10px 0 0; overflow:hidden; *zoom:1;}
.menuMng:after		{content:""; display:block; clear:both; width:0; height:0; overflow:hidden;}
.menuTreeWrap		{float:left; width:180px; min-height:180px; padding:5px; border:1px solid #ddd;}
.menuDetailWrap		{float:right; width:208px; min-height:180px; padding:15px; border:1px solid #ddd;}
.menuBtnWrap		{padding:10px 0 0; text-align:right;}
.indicator			{background:url('/js/jquery/zTree/img/loading.gif') 50% 50% no-repeat;}
 .tableWrite .reqStar {color:#D20B1E; margin-right:3px;}
</style>
<script type="text/javascript" src="/js/jquery/zTree/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript" src="/js/jquery/tmpl/jquery.tmpl.min.js"></script>
<script type="text/javascript" src="/js/jquery/tmpl/jquery.tmplPlus.min.js"></script>
<script type="text/javascript" src="/js/view/portal/portalMenuResource.js"></script>
</head>
<body>
<div id="mwrap">
	<div class="tableWrite">
		<table summary="메뉴 검색">
			<caption>메뉴 검색</caption>
			<colgroup>
				<col style="width:13%" />
				<col style="*" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">문화정보자원</th>
					<td>
						<select title="문화정보자원메뉴" name="pseq_page_type" style="width:300px;" onchange="javascript:setTree();return;">
							<c:choose>
								<c:when test="${empty pageList}">
									<option value="">'패이지관리' 메뉴에서 페이지를 먼저 등록해주세요.</option>
								</c:when>
								<c:otherwise>
									<c:forEach var="li" items="${pageList}">
										<option value="${li.seq}|${li.page_type}" ${paramMap.pseq eq li.seq ? 'selected="selected"':'' }>${li.title_page_type}</option>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</select>
						<!-- <span class="btn darkS">
							<button name="searchButton" type="button" onclick="javascript:onSubmit();return;">검색</button>
						</span> -->
						<span>
							A타입 1개, B타입 최대 5개, C타입 최대 8개 까지 메뉴 구성
						</span>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div class="tableWrite" style="border-top:0px; border-bottom:0px; margin-top:20px;">
		<table summary="메뉴 등록">
			<caption>메뉴 등록</caption>
			<colgroup>
				<col style="width:25%" />
				<col style="width:25%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<td rowspan="7">
						<!-- 트리영역 -->
						<div class="menuMng">
							<div class="menuTreeWrap">
								<div id="menuTree" class="ztree"></div>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row" style="border-top:0px;"><span class="reqStar">*</span>메뉴명</th>
					<td style="border-top:0px;">
						<input type="text" name="title" maxlength="100" style="width:200px;" />
						<input type="hidden" name="seq" id="seq"/>
					</td>
				</tr>
				<tr>
					<th scope="row"><span class="reqStar">*</span>콘텐츠 형태 선택</th>
					<td>
						<label style="padding-bottom:8px;"><input type="radio" name="con_type" value="1" /> 게시판 형태</label><br/>
						<label style="padding-bottom:8px;"><input type="radio" name="con_type" value="2" /> 게시판 상세페이지 형태</label><br/>
						<label><input type="radio" name="con_type" value="3" /> 콘텐츠 형태 (수동제작)</label>
					</td>
				</tr>
				<tr>
					<th scope="row"><span class="reqStar">*</span>게시판 선택 시 목록 형태</th>
					<td>
						<label><input type="radio" name="list_type" value="1" /> 텍스트</label>
						<label><input type="radio" name="list_type" value="2" /> 썸네일 + 텍스트</label>
					</td>
				</tr>
				<tr>
					<th scope="row"><span class="reqStar">*</span>컨텐츠 수동 URL</th>
					<td>
						<input type="text" name="con_manual_url" maxlength="100" style="width:200px;" />
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="menuBtnWrap">
		<span class="btn white" id="newBtn"><button type="button" onclick="javascript:onInit();return;">신규</button></span>
		<span class="btn white"><button type="button" onclick="javascript:insertMenu();return;">저장</button></span>
	</div>

</div>
</body>
</html>