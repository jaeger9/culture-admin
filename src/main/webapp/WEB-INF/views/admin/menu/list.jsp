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
.menuDetailWrap		{float:right; width:538px; min-height:250px; padding:15px; border:1px solid #ddd;}
.menuBtnWrap		{padding:10px 0 0; text-align:right;}
.indicator			{background:url('/js/jquery/zTree/img/loading.gif') 50% 50% no-repeat;}

</style>
<script type="text/javascript" src="/js/jquery/zTree/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript" src="/js/jquery/tmpl/jquery.tmpl.min.js"></script>
<script type="text/javascript" src="/js/jquery/tmpl/jquery.tmplPlus.min.js"></script>
<script type="text/javascript" src="/js/view/admin/adminMenu.js"></script>
</head>
<body>
<script id="formTemplate" type="text/x-jquery-tmpl">
<div class="tableWrite">
	<input type="hidden" name="menu_id" value="{{html menu_id}}" />
	<input type="hidden" name="menu_pid" value="{{html menu_pid}}" />
	<input type="hidden" name="menu_sort" value="{{html menu_sort}}" />

	<table summary="게시판 글 등록">
	<caption>게시판 글 등록</caption>
	<colgroup>
		<col style="width:25%" />
		<col />
	</colgroup>
	<tbody>
	<tr>
		<th scope="row">메뉴 아이디</th>
		<td>
			{{if menu_id}}
				{{html menu_id}}
			{{else}}
				-
			{{/if}}
		</td>
	</tr>
	<tr>
		<th scope="row">메뉴명</th>
		<td>
			<input type="text" name="menu_name" value="{{html menu_name}}" maxlength="100" style="width:200px;" />
		</td>
	</tr>
	<tr>
		<th scope="row">메뉴 설명</th>
		<td>
			<input type="text" name="menu_desc" value="{{html menu_desc}}" maxlength="150" style="width:350px;" />
		</td>
	</tr>
	<tr>
		<th scope="row">승인여부</th>
		<td>
			<label><input type="radio" name="menu_approval" value="Y" {{if menu_approval != 'N'}} checked="checked" {{/if}} /> 승인</label>
			<label><input type="radio" name="menu_approval" value="N" {{if menu_approval == 'N'}} checked="checked" {{/if}} /> 미승인</label>
		</td>
	</tr>
{{if menu_user_id && (menu_reg_date || menu_upt_date)}}
	<tr>
		<th scope="row">등록자</th>
		<td>
			{{html menu_user_id}}
		</td>
	</tr>
{{/if}}
{{if menu_reg_date}}
	<tr>
		<th scope="row">등록일</th>
		<td>
			{{html menu_reg_date}}
		</td>
	</tr>
{{/if}}
{{if menu_upt_date}}
	<tr>
		<th scope="row">수정일</th>
		<td>
			{{html menu_upt_date}}
		</td>
	</tr>
{{/if}}
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
				<span class="btn white"><a href="#" class="new_btn">신규</a></span>
				<span class="btn white"><a href="#" class="save_btn">저장</a></span>
			</div>
		</div>
	</div>

</div>
</body>
</html>