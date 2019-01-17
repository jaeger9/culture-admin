<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<style>
.message_div{
margin-top:5px;
padding:5px;
font-weight:700;
}
div#findloc div:hover{
background-color : #ddd;
color : #444;
font-weight:600}</style>
<script src="https://use.fontawesome.com/f8da1168dd.js"></script>
<!-- <script type="text/javascript" src="//apis.daum.net/maps/maps3.js?apikey=db03179028e54903b88bbf31fe719f9e"></script> -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4c72a26f9d59d4124eee09a5bd2c3127&libraries=services"></script>

<script type="text/javascript">
	//local
	mapkey = 'f7ce22ae3a7f79979d950ef578e2ce31ae308e73';
	localkey = 'ffee37744267b194a8149f6209292e42a915cefb';
	//real port:9999 
	admin = '52c6d4d95b5dd8e6d81a0557eed2f0da';
	admin2 = 'db03179028e54903b88bbf31fe719f9e';

	//좌표 검색하기.
	function gpsMap() {
		var cul_addr1 = $("input[name=cul_addr1]").val();
		var cul_addr2 = $("input[name=cul_addr2]").val();
		var cul_addr3 = $("input[name=cul_addr3]").val();
		var cul_addr = cul_addr1 + " " + cul_addr2 + " " + cul_addr3;
		
		//한글깨짐 방지 인코딩하였습니다.
		var addr = escape(encodeURIComponent(cul_addr));
		
		$.ajax({
			type : "POST",
			url : "/popup/gpsMapajax.do",
			data : "addr=" + addr,
			dataType : "xml",
			async : false,
			success : endXml
		});
	}

	function endXml(xml) {
		$(xml).find("result").each(function(index) {
			var GpsX = $(this).find("getGpsX").text();
			var GpsY = $(this).find("getGpsY").text()
			initialize_nodrag(GpsX, GpsY);
		});
	}

	function initialize_nodrag(GpsX, GpsY) {
		if (GpsX == "" || GpsY == "") {
			return;
		}
		pop_form.cul_gps_x.value = GpsX;
		pop_form.cul_gps_y.value = GpsY;

		var map = new daum.maps.Map(document.getElementById('map'), {
			center : new daum.maps.LatLng(GpsY, GpsX),
			level : 3
		});

		//마커를 표시하여 주고 마커의 위치를 설정하여준다.
		var marker = new daum.maps.Marker({
			position : new daum.maps.LatLng(GpsY, GpsX),
			draggable : (false)
		});
		marker.setMap(map);
	}
	


	function initialize_click() {
		if (navigator.geolocation) {
			// GeoLocation을 이용해서 접속 위치를 얻어옵니다
			navigator.geolocation.getCurrentPosition(function(position) {
				var lat = position.coords.latitude, // 위도
				 	lon = position.coords.longitude; // 경도
				
				lat = 37.566826;
				lon = 126.9786567;
				
				//위치 정보 초기세팅 
				$('input[name=cul_gps_y]').val(lat);
				$('input[name=cul_gps_x]').val(lon);
			
				var map = new daum.maps.Map(document.getElementById('map'), {
					center : new daum.maps.LatLng(lat, lon),
					level : 3
				});
				
				//마커를 표시하여 주고 마커의 위치를 설정하여준다.
				var marker = new daum.maps.Marker({
					position : new daum.maps.LatLng(lat, lon),
					draggable : true
				});
				marker.setMap(map);
				
				var message = '클릭한 위치의 위도는 ' + lat + ' 이고, ';
				message += '경도는 ' + lon + ' 입니다';
				$('#select_div').html(message);
				$("#select_div").attr("style","display:block;");
				
				// 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
				daum.maps.event.addListener(map, 'click', function(mouseEvent) {
					
					// 클릭한 위도, 경도 정보를 가져옵니다
					var latlng = mouseEvent.latLng;

					// 마커 위치를 클릭한 위치로 옮깁니다
					marker.setPosition(latlng);

					var message = '클릭한 위치의 위도는 ' + latlng.getLat() + ' 이고, ';
					message += '경도는 ' + latlng.getLng() + ' 입니다';
					
					$('#select_div').html(message);
					$('#select_div').attr("style","display:block");
					$('input[name=cul_gps_y]').val(latlng.getLat());
					$('input[name=cul_gps_x]').val(latlng.getLng());
				});

			});
		}else{
			alert("fail to use geolocation");
		}
	}
	
	
	var sidoObj = {
			'강원도'			:	'강원',
			'경기도'			:	'경기',
			'경상남도'		:	'경남',
			'경상북도'		:	'경북',
			'광주광역시'		:	'광주',
			'대구광역시'		:	'대구',
			'대전광역시'		:	'대전',
			'부산광역시'		:	'부산',
			'서울특별시'		:	'서울',
			'세종특별자치시'	:	'세종',
			'울산광역시'		:	'울산',
			'인천광역시'		:	'인천',
			'전라남도'		:	'전남',
			'전라북도'		:	'전북',
			'제주특별자치도'	:	'제주',
			'충청남도'		:	'충남',
			'충청북도'		:	'충북'
		};
	

	$(function() {

		//초기 화면은 마커로 이동하는 화면임으로.
		initialize_click();

		$('span a').each(
				function() {
					$(this).click(
							function() {
								if ($(this).html() == '위치선택 완료') {
									var type = $('select[name=type]').val();
									if($('input[name=cul_gps_x]').val() == '' || $('input[name=cul_gps_y]').val() == ''){
										alert("위치를 선택해주세요!");
										return false;
									}
									if(type == 2 && ($("#cul_addr1").val() == '' || $("#cul_addr2").val() == '' || $("#cul_addr3").val() == '' )){
										alert("위치를 선택해주세요!");
										return false;
									}
									
									if (window.opener && window.opener.setCoordinate) {
									window.opener.setCoordinate(
											$('input[name=cul_gps_x]').val()
											, $('input[name=cul_gps_y]').val()
											, $('input[name=num]').val());
									}else{
										alert('callback function undefined');
									}
									self.close();
									return;
								}
							});
				});
		
		$('select[name=type]').change(function(){
			var val = $(this).val();
			$("#select_div").html("");
			$("#select_div").attr("style","display:none;");
			if(val == 1){ // 지도 바로 이동 
				$("#loc_div").attr("style","display:none;");
				initialize_click();
			}else{//지역 선택 
				$("#loc_div").attr("style","display:block;");
				$(".sido").trigger("click");
				initialize_nodrag($('input[name=cul_gps_x]').val(), $('input[name=cul_gps_y]').val());
			}
		});

		//시도 버튼 클릭 시 
		$(".sido").click(function(){
			$("#sido").addClass("dark");
			
			if($("#gu").hasClass("dark")){
				$("#gu").removeClass("dark");
			}
			if($("#dong").hasClass("dark")){
				$("#dong").removeClass("dark");
			}
			
			$(".sido i").addClass("fa-caret-down").removeClass("fa-caret-up");
			$(".gu i").removeClass("fa-caret-down").addClass("fa-caret-up");
			$(".dong i").removeClass("fa-caret-down").addClass("fa-caret-up");
			
			var html = "<div id='findloc' style='border:1px solid grey;margin-top:5px;padding-top:5px; width:99%;height: 150px; overflow-y: scroll;'>";
			var htmlObj = null;
			$.each(sidoObj,function(key, value){
			  html += "<div style='height:21px;' onclick='movegugun(\""+key+"\")'>"+key+"</div>";
			  htmlObj = $("<div>"+key+"</div>")
			});
			html += "</div>";
			$("#location_div").html(html);
		});
		
		//시도 버튼 클릭 시 
		$(".gu").click(function(){
			var sido_val = $("#cul_addr1").val();
			if(sido_val == ''){
				alert("select si/do first");
				return false;
			}
			var sido = "";
			$.each(sidoObj, function(key, value){
			    alert('key:' + key + ' / ' + 'value:' + value);
			    if(value == sido_val){
			    	sido = key;
			    }
			});
			movegugun(sido);
			
		});
		
		//시도 버튼 클릭 시 
		$(".dong").click(function(){
			var sido_val = $("#cul_addr1").val();
			var gugun_val = $("#cul_addr2").val();
			if(sido_val == '' || gugun_val == ''){
				alert("select si/do first");
				return false;
			}
			
			movedong(gugun_val);
			
		});
		
	});
	
	//동까지 선택완료. 
	function selectdong(dong_name){
		$("#select_div").html("선택한 위치 : "+ $('#cul_addr1').val() + " "+ $("#cul_addr2").val() +" " + dong_name);
		$("#select_div").attr("style","display:block;");
		$('input[name=cul_addr3]').val(dong_name);
		
		//선택에 시에 대한 지도 표기 
		gpsMap();
	}
	
	function movegugun(sido){
		$("#select_div").html(sido);
		$("#select_div").attr("style","display:block;");
		$('#cul_addr1').val(sidoObj[sido]);
		$('#cul_addr2').val("");
		$('#cul_addr3').val("");
		
		$(".gu i").addClass("fa-caret-down").removeClass("fa-caret-up");
		$(".sido i").removeClass("fa-caret-down").addClass("fa-caret-up");
		$(".dong i").removeClass("fa-caret-down").addClass("fa-caret-up");

		if($("#sido").hasClass("dark")){
			$("#sido").removeClass("dark");
		}
		if($("#dong").hasClass("dark")){
			$("#dong").removeClass("dark");
		}
		$("#gu").addClass("dark");
		
		
		//선택에 시에 대한 지도 표기 
		gpsMap();
		
		var param = {
				sido : sidoObj[sido],
				condition : 'G'
			};
		
		$.ajax({
			url			:	'/popup/ajax/findLocation.do'
			,type		:	'post'
			,data		:	$.param(param, true)
			,dataType	:	'json'
			,success : function( res ) {
				 var list = res.ziplist;
				 var html = "<div id='findloc' style='border:1px solid grey;margin-top:5px;padding-top:5px; width:99%;height: 150px;overflow-y: scroll;'>";										
				 for(var i = 0 ; i < list.length ; i++){
					 var item = list[i];
					 html += "<div style='height:21px' onclick='movedong(\""+item.gu_name+"\")'>"+item.gu_name+"</div>";
				 }
				 html += "</div>";
				$("#location_div").html(html);
			}
			,error : function(data, status, err) {
				alert("주소를 가져오는 도중 오류가 발생하였습니다.");
			}
		});
	}

	//구/군 선택시 검색 
	function movedong(gugun){
		$("#select_div").html($('#cul_addr1').val() +" " + gugun);
		$("#select_div").attr("style","display:block;");
		$('#cul_addr2').val(gugun);
		$('#cul_addr3').val("");
		
		
		$(".sido i").removeClass("fa-caret-down").addClass("fa-caret-up");
		$(".gu i").removeClass("fa-caret-down").addClass("fa-caret-up");
		$(".dong i").addClass("fa-caret-down").removeClass("fa-caret-up");
		
		if($("#sido").hasClass("dark")){
			$("#sido").removeClass("dark");
		}
		if($("#gu").hasClass("dark")){
			$("#gu").removeClass("dark");
		}
		
		$("#dong").addClass("dark");
		
		//선택에 시에 대한 지도 표기 
		gpsMap();
		
		var param = {
				sido : $('#cul_addr1').val(),
				gugun : gugun,
				condition : 'D'
			};
		
		$.ajax({
			url			:	'/popup/ajax/findLocation.do'
			,type		:	'post'
			,data		:	$.param(param, true)
			,dataType	:	'json'
			,success : function( res ) {
				 var list = res.ziplist;
				 var html = "<div id='findloc' style='border:1px solid grey;margin-top:5px;padding-top:5px; width:99%;height: 150px; overflow-y: scroll;'>";										
				 for(var i = 0 ; i < list.length ; i++){
					 var item = list[i];
					 html += "<div style='height:21px' onclick='selectdong(\""+item.dong_name+"\")'>"+item.dong_name+"</div>";
				 }
				 html += "</div>";
				$("#location_div").html(html);
			}
			,error : function(data, status, err) {
				alert("주소를 가져오는 도중 오류가 발생하였습니다.");
			}
		});
	}
</script>
</head>
<body>
	<form name="pop_form" method="post">
	    <input type="hidden" name="num" value="${paramMap.index}"/>
		<input type="hidden" name="cul_gps_y" /> 
		<input type="hidden" name="cul_gps_x" /> 
		<input type="hidden" name="cul_addr1" id="cul_addr1" /> 
		<input type="hidden" name="cul_addr2" id="cul_addr2" /> 
		<input type="hidden" name="cul_addr3" id="cul_addr3" />
	
		<div id="map" style="width: 99%; height: 400px;border:1px solid grey;"></div>
		<div class="btnBox" style="width:100%;">
			<select id="type" name="type" style="width:99%;background-color:#444;border-color:#444;height:26px;color:#fff;text-align:center;">
				<option value="1" selected="selected">지도 바로이동</option>
				<option value="2">지역 이동</option>
			</select>
		</div>
		<div id="select_div" class="message_div" style="display:none;">
		</div>
		<!--  none draggable map -->
		<div id="loc_div" style="display:none;align:center;">
				<div class="btnBox" style="width:100%">
					<span class="btn white" id="sido" style="width:32.1%"><a href="#" class="sido" style="width:80%;">시/도 <i class="fa fa-caret-up"></i></a></span>
					<span class="btn white" id="gu" style="width:32.1%"><a href="#" class="gu" style="width:80%;">구/군 <i class="fa fa-caret-up"></i></a></span>
					<span class="btn white" id="dong" style="width:32.1%"><a href="#" class="dong" style="width:80%;">동/면/리 <i class="fa fa-caret-up"></i></a></span>
				</div>
				<div id="location_div">
				</div>
		</div>
		
		<div class="btnBox" style="width:99%;text-align:center;">
			<span class="btn dark"><a href="#" class="close_btn">위치선택 완료</a></span>
		</div>
		<br/>
	</form>
</body>
</html>