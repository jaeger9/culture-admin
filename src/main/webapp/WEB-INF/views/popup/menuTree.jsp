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
.menuTreeWrap		{float:left; width:350px; min-height:370px; padding:5px; border:1px solid #ddd;}
.menuDetailWrap		{float:right; width:538px; min-height:250px; padding:15px; border:1px solid #ddd;}
.menuBtnWrap		{padding:10px 0 0; text-align:right;}
.indicator			{background:url('/js/jquery/zTree/img/loading.gif') 50% 50% no-repeat;}

</style>
<script type="text/javascript" src="/js/jquery/zTree/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript" src="/js/jquery/tmpl/jquery.tmpl.min.js"></script>
<script type="text/javascript" src="/js/jquery/tmpl/jquery.tmplPlus.min.js"></script>
<script type="text/javascript" src="/js/view/portal/portalMenuPopup.js"></script>
</head>
<body>
<script id="formTemplate" type="text/x-jquery-tmpl">
</script>
<div id="mwrap">

	<div class="menuMng">
		<div class="menuTreeWrap">
			<div id="menuTree" class="ztree"></div>
		</div>
	</div>

</div>
</body>
</html>