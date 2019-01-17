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
.menuTreeWrap		{float:left; width:220px; min-height:350px; padding:5px; border:1px solid #ddd;}
.menuDetailWrap		{float:right; width:538px; min-height:330px; padding:15px; border:1px solid #ddd;}
.menuBtnWrap		{padding:10px 0 0; text-align:right;}
.indicator			{background:url('/js/jquery/zTree/img/loading.gif') 50% 50% no-repeat;}
.jqBtnSave			{display:none;}
.tableList.type2 th,
.tableList.type2 td	{font-size:11px;}
.tableList.type2 th.c1,
.tableList.type2 td.c1 {padding-left:4px; text-align:left;}
.sideArea			{display:none;}

</style>
<script type="text/javascript" src="/js/jquery/zTree/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript" src="/js/jquery/tmpl/jquery.tmpl.min.js"></script>
<script type="text/javascript" src="/js/jquery/tmpl/jquery.tmplPlus.min.js"></script>
<script type="text/javascript" src="/js/view/admin/adminMapping.js"></script>
</head>
<body>
<script id="formTemplate" type="text/x-jquery-tmpl">
<div class="tableList type2">
	<input type="hidden" name="menu_id" value="{{html menu_id}}" />

	<table summary="게시판 글 목록">
	<caption>게시판 글 목록</caption>
	<colgroup>
		<col style="width:6%" />
		<col style="width:6%" />
		<col style="width:40%" />
		<col />
	</colgroup>
	<thead>
		<tr>
			<th scope="col">선택</th>
			<th scope="col">대표</th>
			<th scope="col">내용</th>
			<th scope="col">URL</th>
		</tr>
	</thead>
	<tbody>
	{{each urls}}
	<tr>
		<td>
			<input type="checkbox" name="url_id" value="{{html url_id}}" {{html (checked_url_id == 'Y' ? ' checked="checked" ' : '')}} alt="{{html url_id}}" title="{{html url_id}}" />
		</td>
		<td>
			<input type="radio" name="link_yn" value="Y" {{html (checked_url_link == 'Y' ? ' checked="checked" ' : '')}} {{html (checked_url_id != 'Y' ? ' disabled="disabled" ' : '')}} alt="{{html url_id}}" title="{{html url_id}}" />
		</td>
		<td class="c1">
			{{html description}}
		</td>
		<td class="c1">
			{{html url_string}}
		</td>
	</tr>
	{{/each}}
	</tbody>
	</table>
</div>
</script>
<div id="mwrap">

	<div class="menuMng">
		<div class="menuTreeWrap">
			<div id="menuTree" class="ztree"></div>
		</div>

		<div class="menuDetailWrap">
			<div class="menuDetailForm"></div>

			<div class="menuBtnWrap">
				<span class="btn white jqBtnSave"><a href="#" class="save_btn">저장</a></span>
			</div>
		</div>
	</div>

</div>

<span class="btn white jqBtnSave sideArea"><a href="#" class="save_btn">저장</a></span>

</body>
</html>