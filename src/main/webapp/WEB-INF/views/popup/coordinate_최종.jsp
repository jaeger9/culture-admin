<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4c72a26f9d59d4124eee09a5bd2c3127&libraries=services"></script>
<script type="text/javascript">
	
	var gpsX = null;
	var gpsY = null;
	var addr = opener.document.frm.addr1.value;
	if(addr == '' ){
		alert("우편번호 찾기를 통해 주소를 먼저 찾아주세요.");
		self.close();
	}
	var position; // 좌표값 저장
	
	$(function () {
		
		/*적용하기 function*/
		$('span a').each(function(){
			$(this).click(function(){
			    if($(this).html() == '적용하기'){
			    	if(gpsX == null || gpsY == null){alert("지도를 조작하여 좌표값을 얻어내야 합니다.");}
		    		window.opener.setCoordinate( gpsX , gpsY );
			    	self.close();
				}
			});
		});
	});
	
</script>
</head>

<body>
	<p style="margin-top:-12px">
	    <em class="link">
	        <a href="javascript:void(0);" onclick="window.open('http://fiy.daum.net/fiy/map/CsGeneral.daum', '_blank', 'width=981, height=650')"> 혹시 주소 결과가 잘못 나오는 경우에는 여기에 제보해주세요. </a>
	    </em>
	</p>
	<div id="map" style="width:100%;height:350px;"></div>
	
	<script>
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = {
	        center: new daum.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
	        level: 3 // 지도의 확대 레벨
	    };  
	
	// 지도를 생성합니다    
	var map = new daum.maps.Map(mapContainer, mapOption); 
	
	// 주소-좌표 변환 객체를 생성합니다
	var geocoder = new daum.maps.services.Geocoder();
	
	// 주소로 좌표를 검색합니다
	geocoder.addressSearch(addr, function(result, status) {
	
	    // 정상적으로 검색이 완료됐으면 
	     if (status === daum.maps.services.Status.OK) {
	
	        var coords = new daum.maps.LatLng(result[0].y, result[0].x);
	
	        // 결과값으로 받은 위치를 마커로 표시합니다
	        var marker = new daum.maps.Marker({
	            map: map,
	            position: coords
	          //  draggable: true
	        });
	        
	        //marker.setDraggable(true);
	        
	        
	        // 지도에 클릭 이벤트를 등록합니다
// 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
daum.maps.event.addListener(map, 'click', function(mouseEvent) {        
    
    // 클릭한 위도, 경도 정보를 가져옵니다 
    var latlng = mouseEvent.latLng; 
    
    // 마커 위치를 클릭한 위치로 옮깁니다
    marker.setPosition(latlng);
    
/*     var message = '클릭한 위치의 위도는 ' + latlng.getLat() + ' 이고, ';
    message += '경도는 ' + latlng.getLng() + ' 입니다';
    
    var resultDiv = document.getElementById('clickLatlng'); 
    resultDiv.innerHTML = message; */
    
});
	        
	
	        // 인포윈도우로 장소에 대한 설명을 표시합니다
	        var infowindow = new daum.maps.InfoWindow({
	            content: '<div style="width:150px;text-align:center;padding:6px 0;">'+addr+'</div>'
	        });
	        infowindow.open(map, marker);
	
	        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
	        map.setCenter(coords);
	        position = map.getCenter();
	        
	     	// 지도의  레벨을 얻어옵니다
		    var level = map.getLevel();
		    // 지도의 중심좌표를 얻어옵니다 
		    var latlng = map.getCenter();
		    
	        var message = '<p>지도 레벨 :  [ ' + level + ' ]</p>';
		    message += '<p>지도 위도 : [ ' + latlng.getLat() + ' ] </br>지도 경도 : [ ' + latlng.getLng() + ' ]</p>';
		    
		    gpsX = latlng.getLat();
		    gpsY = latlng.getLng();
		
		    var resultDiv = document.getElementById('result');
		    resultDiv.innerHTML = message;
	    } 
	    
	    
	    
	    
	    
	});    
	</script>
	<p id="result"></p>
	<div class="btnBox">
		<span class="btn dark fr"><a href="#" class="close_btn">적용하기</a></span>
	</div>
</body>
</html>