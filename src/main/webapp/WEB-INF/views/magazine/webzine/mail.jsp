<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="/crosseditor/js/namo_scripteditor.js"></script>

<script type="text/javascript">
var target = null;
var targetView = null;

var callback = {
	fileUpload : function (res) {
		target.val(res.file_path);
		targetView.html('<img src="/upload/issue/' + res.file_path + '" width="100" height="100" alt="" />');
	}
};

$(function() {	
	//발송 방법
	$("#divReserve").hide();
	$("input[name=reserve_fg]").change(function() {
		if($(this).val() == "Y"){
			$("#divReserve").show();
		}else{
			$("#divReserve").hide();
		}
	});
	
	//예약발송일시
	var dt = new Date();
	dt = new Date(Date.parse(dt) + 1000 * 600);
	var year = String(dt.getFullYear());
	var month = String(dt.getMonth()+1);
	month = (month.length < 2) ? "0" + month : month;
	var day = String(dt.getDate());
	day = (day.length < 2) ? "0" + day : day;
	
	$("#reserve_day").val(year+'-'+month+'-'+day);
	new setDatepicker($("#reserve_day"));
	
	var hh = "";
	var mm = ""
	for(var i = 0; i < 25; i++){
		hh = (i < 10) ? "0" + i : i;
		if(dt.getHours() == i){
			$("#reserve_hh").append("<option value='"+ hh +"' selected='selected'>"+ hh +"&nbsp;</option>");
		}else{
			$("#reserve_hh").append("<option value='"+ hh +"'>"+ hh +"&nbsp;</option>");
		}
	}
	
	for(var i = 0; i < 60; i++){
		mm = (i < 10) ? "0" + i : i;
		if(dt.getMinutes() == i){
			$("#reserve_mm").append("<option value='"+ mm +"' selected='selected'>"+ mm +"&nbsp;</option>");
		}else{
			$("#reserve_mm").append("<option value='"+ mm +"'>"+ mm +"&nbsp;</option>");
		}
	}

	//메일 아이디
	var tmpStr='';
	for(var i=0; i<5; i++){
		tmpStr += Math.floor(Math.random()*10)+1;
 	}
	$("#campid").val("pcn"+year+month+day+dt.getHours()+dt.getMinutes()+tmpStr);
	
	//Submit
	var frm = $('form[name=frm]');
	frm.submit(function() {
		if($(':radio[name="reserve_fg"]:checked').val() == "Y"){
			$("#reserve_date").val($("#reserve_day").val().replace(/-/g, "") + $("#reserve_hh").val() + $("#reserve_mm").val());
		}else{
			$("#reserve_date").val("");
		}
		
		if ($("#from").val() == "") {
			alert("보내는 사람을 입력해 주세요");
			$("#from").focus();
			return false;
		}
		if ($("#to").val() == "") {
			alert("수신자를 입력해 주세요");
			$("#to").focus();
			return false;
		}
		if ($("#subject").val() == "") {
			alert("제목을 입력해 주세요");
			$("#subject").focus();
			return false;
		}
		if ($("#body").val() == "") {
			alert("내용을 입력해 주세요");
			$("#body").focus();
			return false;
		}
		
		return true;
	});

	//button Event
	$('span > button').each(function() {
		$(this).click(function() {
			if ($(this).html() == '발송') {
				if (!confirm('발송하시겠습니까?')) {
					return false;
				}
        		document.getElementById("body").value = CrossEditor.GetBodyValue("XHTML");
				frm.submit();
			} else if ($(this).html() == '목록') {
				location.href = '/magazine/webzine/list.do';
			}
		});
	});
});
</script>
</head>
<body>
<!-- 검색 필드 -->
<div class="tableWrite">
	<form name="frm" method="post" action="http://ems.kcis.or.kr/servlet/sendemailu" enctype="multipart/form-data">
		<input type="hidden" name="returnUrl" value="http://www.culture.go.kr:9999/magazine/webzine/list.do"/>
		<input type="hidden" name="reserve_date" id="reserve_date" value=""/>
		<input type="hidden" name="campid" id="campid" value=""/>
		
		<div class="tableWrite">	
			<table summary="문화 이슈 컨텐츠 작성">
				<caption>문화 이슈 컨텐츠 글쓰기</caption>
				<colgroup>
					<col style="width:15%" />
					<col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">보내는 사람</th>
						<td>
							<input type="text" name="from" id="from" value="문화포털관리자<culture@kcisa.kr>" style="width:250px;" />
							<span style="color:red">(주의)</span> 홍길동&lt;master@mydomain.com&gt;과 같은 형식으로 입력하세요.
						</td>
					</tr>
					<tr>
						<th scope="row">수신자</th>
						<td>
							<textarea name="to" id="to" style="width:100%;height:100px;"><c:forEach items="${list }" var="item" varStatus="status">${item.email}, </c:forEach></textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">제목</th>
						<td>
							<input type="text" name="subject" id="subject" style="width:500px"  value="[문화톡 감성톡 ${view.numbers}호] ${view.title}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">발송 시간</th>
						<td>
							<label><input type="radio" name="reserve_fg" id="reserve_fg" value="N" checked="checked"/> 즉시발송</label>
							<label><input type="radio" name="reserve_fg" id="reserve_fg" value="Y"/> 예약발송</label>
							
							<div id="divReserve" name="divReserve">
								<input type="text" name="reserve_day" id="reserve_day" value="" />
								<select name="reserve_hh" id="reserve_hh"></select>
								<select name="reserve_mm" id="reserve_mm"></select>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">첨부파일</th>
						<td>
							<input type="file" name="upfile1" id="upfile1" class="btn" style="width:300px" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div class="tableWrite">	
			<table summary="웹진 메일 컨텐츠 작성">
			<caption>웹진 메일 컨텐츠 글쓰기</caption>
			<tbody>
				<tr>
					<td colspan="4" style="padding-left:40px;">
						<script type="text/javascript" language="javascript">
							var CrossEditor = new NamoSE('body');
							CrossEditor.params.Width = "100%";
							CrossEditor.params.Height = "800px";
							CrossEditor.params.UserLang = "auto";
							CrossEditor.params.UploadFileSizeLimit = "image:10485760";
							CrossEditor.params.Font = {"NanumGothic":"나눔고딕","Dotum":"돋움", "Gulim":"굴림", "Batang":"바탕", "Gungsuh":"궁서", "맑은 고딕":"맑은 고딕"  ,"David":"David", "MS Pgothic":"MS Pgothic","Simplified Arabic":"Simplified Arabic","SimSun":"SimSun","Arial":"Arial","Courier New":"Courier New", "Tahoma":"Tahoma", "Times New Roman":"Times New Roman", "verdana":"Verdana"};
							CrossEditor.EditorStart();
							function OnInitCompleted(e){
								e.editorTarget.SetBodyValue(document.getElementById("body").value);
							}
						</script>
						<textarea id="body" name="body" style="width:100%;height:400px;display:none;"><c:out value="${mailbody }" escapeXml="true" /></textarea>
					</td>	
				</tr>
			</tbody>
			</table>
		</div>
	</form>
</div>
<div class="btnBox textRight">
	<span class="btn white"><button type="button">발송</button></span>
	<span class="btn gray"><button type="button">목록</button></span>
</div>
</body>
</html>