<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript">
</script>
<% 
	//request.setCharacterEncoding("UTF-8");  //한글깨지면 주석제거
	//request.setCharacterEncoding("EUC-KR");  //해당시스템의 인코딩타입이 EUC-KR일경우에
	String inputYn = request.getParameter("inputYn"); 
	String roadFullAddr = request.getParameter("roadFullAddr"); 
	String roadAddrPart1 = request.getParameter("roadAddrPart1"); 
	String roadAddrPart2 = request.getParameter("roadAddrPart2"); 
	String engAddr = request.getParameter("engAddr"); 
	String jibunAddr = request.getParameter("jibunAddr"); 
	String zipNo = request.getParameter("zipNo"); 
	String addrDetail = request.getParameter("addrDetail"); 
	String admCd    = request.getParameter("admCd");
	String rnMgtSn = request.getParameter("rnMgtSn");
	String bdMgtSn  = request.getParameter("bdMgtSn");
%>
<script type="text/javascript">
	$(function () {
		var url = location.href;
		//var confmKey = "TESTJUSOGOKR";
		var confmKey = "U01TX0FVVEgyMDE2MDcwODExMDM1MTEzNjcw";
		var inputYn= "<%=inputYn%>";
		if(inputYn != "Y"){
			document.form.confmKey.value = confmKey;
			document.form.returnUrl.value = url;
			document.form.action="http://www.juso.go.kr/addrlink/addrLinkUrl.do"; //인터넷망
			document.form.submit();
		}else{
			var arrData = "<%=roadFullAddr%>".split(" ");
			var sido = arrData[0];
			var gugun = arrData[1];
			/* var pattern = /[군|구]$/;
			gugun = (pattern.test(arrData[2])) ? gugun +" "+ arrData[2] : gugun; */
			
			opener.jusoCallBack(sido, gugun,"<%=roadAddrPart1%>","<%=addrDetail%>","<%=zipNo%>");
			window.close();
		}
	});
</script>
</head>
<body>

<form id="form" name="form" method="post">
	<input type="hidden" id="confmKey" name="confmKey" value=""/>
	<input type="hidden" id="returnUrl" name="returnUrl" value=""/>
	<!-- 해당시스템의 인코딩타입이 EUC-KR일경우에만 추가 START-->
	<!-- 
	<input type="hidden" id="encodingType" name="encodingType" value="EUC-KR"/>
	 -->
	<!-- 해당시스템의 인코딩타입이 EUC-KR일경우에만 추가 END-->
</form>

</body>
</html>