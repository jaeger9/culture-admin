<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4c72a26f9d59d4124eee09a5bd2c3127&libraries=services"></script>
<script type="text/javascript">
	var detailAddr22 =  null;
	var gpsX = null;
	var gpsY = null;
	var addr = opener.document.frm.addr1.value;
	//var addr = '서울특별시 은평구 진관1로 40';
	alert(addr);
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
		    		window.opener.document.getElementById("cul_addr").value = detailAddr22;
		    		window.opener.document.getElementById("addr1").value = detailAddr22;
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
	
/*  	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        center: new daum.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };

	
	// 지도를 생성합니다    
	var map = new daum.maps.Map(mapContainer, mapOption); 
	
	// 주소-좌표 변환 객체를 생성합니다
	var geocoder = new daum.maps.services.Geocoder();
	
	// 지도를 클릭한 위치에 표출할 마커입니다
	var marker = new daum.maps.Marker({
	    // 지도 중심좌표에 마커를 생성합니다 
	    position: map.getCenter() 
	}); 
	// 지도에 마커를 표시합니다
	marker.setMap(map);
	
	 // 인포윈도우로 장소에 대한 설명을 표시합니다
    var infowindow = new daum.maps.InfoWindow({
        content: '<div style="width:180px;text-align:center;padding:6px 0;">'+addr+'</div>'
    });
    infowindow.open(map, marker);
	
	geocoder.addressSearch(addr, function(result, status) {
	// 지도에 클릭 이벤트를 등록합니다
	// 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
		daum.maps.event.addListener(map, 'click', function(mouseEvent) {       
		    
		    // 클릭한 위도, 경도 정보를 가져옵니다 
		    var latlng = mouseEvent.latLng; 
		    
		    // 마커 위치를 클릭한 위치로 옮깁니다
		    marker.setPosition(latlng);
		    

		    var message = '<p>지도 레벨 :  [ ' + mapOption.level + ' ]</p>';
		    	message += '<p>지도 위도 : [ ' + latlng.getLat() + ' ] </br>지도 경도 : [ ' + latlng.getLng() + ' ]</p>';
		    
		    gpsX = latlng.getLat();
		    gpsY = latlng.getLng();
		
		    var resultDiv = document.getElementById('result');
		    resultDiv.innerHTML = message;
		    
		});
	});

	 */ 
	 

	
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
            position: coords,
          //  draggable: true
        });
        
    	// 지도에 클릭 이벤트를 등록합니다
    	// 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
    		daum.maps.event.addListener(map, 'click', function(mouseEvent) {       
    		    
    		    // 클릭한 위도, 경도 정보를 가져옵니다 
    		    var latlng = mouseEvent.latLng; 
    		    
    		    // 마커 위치를 클릭한 위치로 옮깁니다
    		    marker.setPosition(latlng);
    		    
    		    infowindow.close();
    		    
    		    
    		    
    		    searchDetailAddrFromCoords(mouseEvent.latLng, function(result, status) {
    		        if (status === daum.maps.services.Status.OK) {
    		            detailAddr = !!result[0].road_address ? '<div>도로명주소 : ' + result[0].road_address.address_name + '</div>' : '';
    		            detailAddr += '<div>지번 주소 : ' + result[0].address.address_name + '</div>';
    		            
    		            var content = '<div class="bAddr">' +
    		                            '<span class="title">주소정보</span>' + 
    		                            detailAddr + 
    		                        '</div>';

    		                        detailAddr22=result[0].address.address_name;
    		            // 마커를 클릭한 위치에 표시합니다 
    		            marker.setPosition(mouseEvent.latLng);
    		            marker.setMap(map);

    		            // 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
    		            infowindow.setContent(content);
    		            infowindow.open(map, marker);
    		        }   
    		    });   		    
    		    
    		    
    		    
    		    
    		    

     		    var message = '<p>지도 레벨 :  [ ' + mapOption.level + ' ]</p>';
    		    	message += '<p>지도 위도 : [ ' + latlng.getLat() + ' ] </br>지도 경도 : [ ' + latlng.getLng() + ' ]</p>';
    		    
    		    gpsX = latlng.getLat();
    		    gpsY = latlng.getLng();
    		
    		    var resultDiv = document.getElementById('result');
    		    resultDiv.innerHTML = message;
    		     
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



daum.maps.event.addListener(map, 'idle', function() {
    searchAddrFromCoords(map.getCenter(), displayCenterInfo);
});

function searchAddrFromCoords(coords, callback) {
    // 좌표로 행정동 주소 정보를 요청합니다
    geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);         
}

function searchDetailAddrFromCoords(coords, callback) {
    // 좌표로 법정동 상세 주소 정보를 요청합니다
    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
}



//지도 좌측상단에 지도 중심좌표에 대한 주소정보를 표출하는 함수입니다
function displayCenterInfo(result, status) {
    if (status === daum.maps.services.Status.OK) {
        var infoDiv = document.getElementById('centerAddr');

        for(var i = 0; i < result.length; i++) {
            // 행정동의 region_type 값은 'H' 이므로
            if (result[i].region_type === 'H') {
                infoDiv.innerHTML = result[i].address_name;
                break;
            }
        }
    }   
}
	
	</script>
	<p id="result"></p>
	<div class="btnBox">
		<span class="btn dark fr"><a href="#" class="close_btn">적용하기</a></span>
	</div>
</body>
</html>