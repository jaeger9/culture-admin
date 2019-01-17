proj4.defs("EPSG:5179", "+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs");
proj4.defs("EPSG:5181", "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=500000 +ellps=GRS80 +units=m +no_defs");
proj4.defs("EPSG:5186", "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs");

var map;
var naverLayer, naverSatLayer, naverSatLabelLayer;
var daumLayer, daumSatLayer, daumSatLabelLayer;
var googleLayer, googleSatLayer;
var vectorSource;
var vectorLayer;
var mapViewType = "daum";
var isSateliteView = false;
var urlPrefix = "/"; 

var sketch;
var helpTooltipElement;
var helpTooltip;
var measureTooltipElement;
var measureTooltip;
var continuePolygonMsg = '다음 지점 클릭(완료: 더블클릭)';
var continueLineMsg = '다음 지점 클릭(완료: 더블클릭)';
var canvasDraw;
var drawTypeSelect = "";
var drawSource;
var drawVectorLayer;

var facTooltipElement;
var facTooltip;

var searchFeatureSeq = 0;
var printMode = false;
var o2MapWebServiceUrl = '';

initMap = function(cx, cy, cz, mt, sv, intOpt) {	
	naverLayer = new ol.layer.Tile({
		source : new ol.source.XYZ({
			projection : "EPSG:5179",
			url : "http://onetile1.map.naver.net/get/135/0/0/{z}/{x}/{-y}/bl_vc_bg/ol_vc_an",
			tileGrid : new ol.tilegrid.TileGrid({
				extent : [90112, 1192896, 1990673, 2765760],
				tileSize : 256,
				resolutions : [4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1, 0.5, 0.25],
				minZoom : 1
			}), 
			attributions: [ new ol.Attribution({ html: "© NAVER Corp."})]
		}),
		opacity : 1.0,
		visible	: (mt == 'naver' && sv == false) ? true : false
	});
	naverSatLayer = new ol.layer.Tile({
		source : new ol.source.XYZ({
			projection : "EPSG:5179",
			url : "http://onetile1.map.naver.net/get/135/0/1/{z}/{x}/{-y}/bl_st_bg",
			tileGrid : new ol.tilegrid.TileGrid({
				extent : [90112, 1192896, 1990673, 2765760],
				tileSize : 256,
				resolutions : [4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1, 0.5, 0.25],
				minZoom : 1
			}),
			attributions: [ new ol.Attribution({ html: "© NAVER Corp."})]
		}),
		opacity : 1.0,
		visible	: (mt == 'naver' && sv == true) ? true : false
	});
	naverSatLabelLayer = new ol.layer.Tile({
		source : new ol.source.XYZ({
			projection : "EPSG:5179",
			url : "http://onetile1.map.naver.net/get/135/0/0/{z}/{x}/{-y}/empty/ol_st_rd/ol_st_an",
			tileGrid : new ol.tilegrid.TileGrid({
				extent : [90112, 1192896, 1990673, 2765760],
				tileSize : 256,
				resolutions : [4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1, 0.5, 0.25],
				minZoom : 1
			})
		}),
		opacity : 1.0,
		visible	: (mt == 'naver' && sv == true) ? true : false
	});
	
	daumLayer =	new ol.layer.Tile({ 
		source : new ol.source.XYZ({
			projection : "EPSG:5181",
			tileGrid : new ol.tilegrid.TileGrid({
				extent : [(-30000-524288), (-60000-524288), (494288+524288), (988576+524288)],
				tileSize : 256,
				resolutions : [4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1, 0.5, 0.25],
				minZoom : 1
			}),
			tileUrlFunction : function(tileCoord, pixelRatio, projection){
				
				var res = [4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1, 0.5, 0.25];
				var sVal = res[tileCoord[0]];
				
				var yLength = 988576 - (-60000) +524288 + 524288;
				var yTile = yLength / (sVal * 256);

				var tileGap = Math.pow(2, (tileCoord[0] -1));
				yTile = yTile - tileGap;
				
				var xTile = tileCoord[1] - tileGap;
		
				return "http://map1.daumcdn.net/map_2d/4892je/L"+ (15 - tileCoord[0]) +"/"+ (yTile + tileCoord[2]) +"/"+ xTile +".png";
				
			},
			attributions: [ new ol.Attribution({ html: "Daum © Kakao Corp."})]
		}),
		opacity : 1.0,
		visible	: (mt == 'daum' && sv == false) ? true : false
	});
	
	daumSatLayer =	new ol.layer.Tile({
		source : new ol.source.XYZ({
			projection : "EPSG:5181",
			tileGrid : new ol.tilegrid.TileGrid({
				extent : [(-30000-524288), (-60000-524288), (494288+524288), (988576+524288)],
				tileSize : 256,
				resolutions : [4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1, 0.5, 0.25],
				minZoom : 1
			}),
			tileUrlFunction : function(tileCoord, pixelRatio, projection){
				
				var res = [4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1, 0.5, 0.25];
				var sVal = res[tileCoord[0]];
				
				var yLength = 988576 - (-60000) +524288 + 524288;
				var yTile = yLength / (sVal * 256);

				var tileGap = Math.pow(2, (tileCoord[0] -1));
				yTile = yTile - tileGap;
				
				var xTile = tileCoord[1] - tileGap;
		
				return "http://s1.maps.daum-img.net/L"+ (15 - tileCoord[0]) +"/"+ (yTile + tileCoord[2]) +"/"+ xTile +".jpg?v=141021";
				
			},
			attributions: [ new ol.Attribution({ html: "Daum © Kakao Corp."})]
		}),
		opacity : 1.0,
		visible	: (mt == 'daum' && sv == true) ? true : false
	});
	daumSatLabelLayer =	new ol.layer.Tile({
		source : new ol.source.XYZ({
			projection : "EPSG:5181",
			tileGrid : new ol.tilegrid.TileGrid({
				extent : [(-30000-524288), (-60000-524288), (494288+524288), (988576+524288)],
				tileSize : 256,
				resolutions : [4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1, 0.5, 0.25],
				minZoom : 1
			}),
			tileUrlFunction : function(tileCoord, pixelRatio, projection){
				
				var res = [4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1, 0.5, 0.25];
				var sVal = res[tileCoord[0]];
				
				var yLength = 988576 - (-60000) +524288 + 524288;
				var yTile = yLength / (sVal * 256);

				var tileGap = Math.pow(2, (tileCoord[0] -1));
				yTile = yTile - tileGap;
				
				var xTile = tileCoord[1] - tileGap;
		
				return "http://map2.daumcdn.net/map_hybrid/4892je/L"+ (15 - tileCoord[0]) +"/"+ (yTile + tileCoord[2]) +"/"+ xTile +".png";
				
			}
		}),
		opacity : 1.0,
		visible	: (mt == 'daum' && sv == true) ? true : false
	});
	
	googleLayer = new olgm.layer.Google({mapTypeId: google.maps.MapTypeId.ROADMAP});
	googleLayer.setVisible((mt == 'google' && sv == false) ? true : false);
	googleSatLayer = new olgm.layer.Google({mapTypeId: google.maps.MapTypeId.HYBRID});
	googleSatLayer.setVisible((mt == 'google' && sv == true) ? true : false);
	
	var featureFilters = {
		getFeatureFilters: function() {
			var filters = '';
			var sido, gugun, facilityCode, searchKeyword;
			
			if (printMode) {
				sido = $("div.selSido select", window.opener.document).val();
				gugun = $("div.selGugun select", window.opener.document).val();
				facilityCode = $("div.selCode select", window.opener.document).val();
				searchKeyword = $("#searchKeyword", window.opener.document).val();
			} else {
				sido = $("div.selSido select").val();
				gugun = $("div.selGugun select").val();
				facilityCode = $("div.selCode select").val();
				searchKeyword = $("#searchKeyword").val();
			}
			
			if (sido != '') {
				filters = filters + this.getEqualFeature('SIDO', sido);
			}
			
			if (gugun != '') {
				filters = filters + this.getEqualFeature('GUGUN', gugun);
			}
			
			if (facilityCode != '') {
				filters = filters + this.getEqualFeature('CODE', facilityCode);
			}
			
			if (searchKeyword != '') {
				filters = filters + this.getLikeFeature('NAME', searchKeyword);
			}
			
			if (searchFeatureSeq > 0) {
				filters = filters + this.getEqualFeature('SEQ', searchFeatureSeq);
			}
			
			filters = filters + this.getEqualFeature('AVAILABLE', 'Y');
			
			if (filters != '') {
				return '<Filter><And>' + filters + '</And></Filter>';
			} else {
				return '';
			}
		},
		getEqualFeature: function(name, val) {
			return '<PropertyIsEqualTo matchCase="false">' +
						'<PropertyName>' + name + '</PropertyName>' +
						'<Literal>' + val + '</Literal>' +
					'</PropertyIsEqualTo>';
		},
		getLikeFeature: function(name, val) {
			return '<PropertyIsLike wildCard="%" singleChar="_" escapeChar="#@!">' +
						'<PropertyName>' + name + '</PropertyName>' +
						'<Literal>%' + val + '%</Literal>' +
					'</PropertyIsLike>';
		}
	};
	
	vectorSource = new ol.source.Vector({
		loader: function(extent, resolution, projection) {
			var params = {
				service: 'wfs',
				version: '1.1.0',
				request: 'GetFeature',
				typename: 'GIS_FACILITY_INFO',
				propertyname: 'SEQ,CODE,NAME,THE_GEOM',
				srsname: 'EPSG:5186',
				outputFormat: 'application/json',
				bbox: extent.join(',') + ',EPSG:3857'
			};
			
			if (featureFilters.getFeatureFilters() != '') {
				params.filter = featureFilters.getFeatureFilters();
			}
			
			var url = o2MapWebServiceUrl + '?' + jQuery.param(params);
			
			$.ajax(url, {
				type: 'POST',
				data: params
			}).done(loadFeatures);
		},
		strategy: ol.loadingstrategy.tile(ol.tilegrid.createXYZ({}))
	});
	
	loadFeatures = function(response) {
		var geoJSON = new ol.format.GeoJSON();
		vectorSource.addFeatures(geoJSON.readFeatures(response, {featureProjection: 'EPSG:3857'}));
	};
	
	vectorSource.on('addfeature', vectorSourceAddFeature);
	
	vectorLayer = new ol.layer.Vector({
		lname: 'facilityLayer',
		source: vectorSource,
		maxResolution: 1024
	});
	
	drawSource = new ol.source.Vector();
	drawVectorLayer = new ol.layer.Vector({
		source : drawSource,
		style : new ol.style.Style({
			fill : new ol.style.Fill({
				color : 'rgba(255, 255, 255, 0.2)'
			}),
			stroke : new ol.style.Stroke({
				color : '#ff0000',
				width : 1
			}),
			image : new ol.style.Circle({
				radius : 7,
				fill : new ol.style.Fill({
					color : '#ff0000'
				})
			})
		})
	});

	map = new ol.Map({
		interactions: olgm.interaction.defaults(intOpt),
//		interactions: ol.interaction.defaults(intOpt),
		target : 'facilityMap',
		logo: false,
		view : new ol.View({
			projection : 'EPSG:3857',
			extent : [-20037508.34, -20037508.34, 20037508.34, 20037508.34],
			resolutions: [2445.98492, 1222.99246, 611.49623, 305.748115, 152.874058, 76.437029, 38.2185145, 19.1092573, 9.55462865, 4.77731433, 2.38865717, 1.19432859, 0.5971643, 0.29858215, 0.14929108],
// 			center : [ 14130760, 4512842 ],
// 			center: [14253977.1213, 4336804.632619999],
//			center: [14135199.061064802, 4518412.772697475],
			center: [cx, cy],
			zoom : cz
		}),
		controls : [ 
			new ol.control.Attribution({collapsed : false, collapsible: false}),
			new ol.control.MousePosition({
				className : "ol-m-position"
			}) 
		],
		layers: [googleLayer, googleSatLayer, naverLayer, naverSatLayer, naverSatLabelLayer, daumLayer, daumSatLayer, daumSatLabelLayer, vectorLayer, drawVectorLayer]
	});

	var olGM = new olgm.OLGoogleMaps({map: map});
	olGM.activate();
};

var m100Style;
var m200Style;
var m300Style;
var m400Style;
var m500Style;
var m600Style;

initIconStyle = function() {
	m100Style = new ol.style.Style({
		image: new ol.style.Icon(({ 
			src: urlPrefix + 'images/map/m100.png'
		}))
	});

	m200Style = new ol.style.Style({
		image: new ol.style.Icon(({
			src: urlPrefix + 'images/map/m200.png'
		}))
	});

	m300Style = new ol.style.Style({
		image: new ol.style.Icon(({
			src: urlPrefix + 'images/map/m300.png'
		}))
	});

	m400Style = new ol.style.Style({
		image: new ol.style.Icon(({
			src: urlPrefix + 'images/map/m400.png'
		}))
	});
	
	m500Style = new ol.style.Style({
		image: new ol.style.Icon(({
			src: urlPrefix + 'images/map/m500.png'
		}))
	});
	
	m600Style = new ol.style.Style({
		image: new ol.style.Icon(({
			src: urlPrefix + 'images/map/m600.png'
		}))
	});
};

vectorSourceAddFeature = function(evt) {
	var feature = evt.feature;
	var c = feature.getProperties().CODE;
	
	if (c == 100) {
		feature.setStyle(m100Style);
	} else if (c == 200) {
		feature.setStyle(m200Style);
	} else if (c == 300) {
		feature.setStyle(m300Style);
	} else if (c == 400) {
		feature.setStyle(m400Style);
	} else if (c == 500) {
		feature.setStyle(m500Style);
	} else if (c == 600) {
		feature.setStyle(m600Style);
	}
};

layerAllOff = function() {
	naverLayer.setVisible(false);
	naverSatLayer.setVisible(false);
	naverSatLabelLayer.setVisible(false);
	
	daumLayer.setVisible(false);
	daumSatLayer.setVisible(false);
	daumSatLabelLayer.setVisible(false);
	
	googleLayer.setVisible(false);
	googleSatLayer.setVisible(false);
};

changeMapViewType = function() {
	layerAllOff();
	
	if (mapViewType == "naver") {
		if (isSateliteView) {
			naverSatLayer.setVisible(true);
			naverSatLabelLayer.setVisible(true);
		} else {
			naverLayer.setVisible(true);
		}
	} else if (mapViewType == "daum") {
		if (isSateliteView) {
			daumSatLayer.setVisible(true);
			daumSatLabelLayer.setVisible(true);
		} else {
			daumLayer.setVisible(true);
		}
	} else if (mapViewType == "google") {
		if (isSateliteView) {
			googleSatLayer.setVisible(true);
		} else {
			googleLayer.setVisible(true);
		}
	}
};

initMapEvent = function() {
	if (printMode == false) {
		map.on('singleclick', function(evt) {
			if (drawTypeSelect != '') {
				return;
			}
			
			var feature = map.forEachFeatureAtPixel(evt.pixel, function(feature, layer) {
					return feature;
				}, null, function(layer) {
					if (layer.get('lname') == 'facilityLayer') {
						return true;
					}
					
					return false;
				});
		
			if (feature) {
				getFacDetailForm(feature.getProperties().SEQ);
			} else {
				$("div.placeInfoLayer").hide();
			}
		});
		
		$(map.getViewport()).on('mouseout', function() {
			$(helpTooltipElement).addClass('hidden');
		});
		
		createFacTooltip();
		
		map.on('pointermove', pointerMoveHandler);
	}
};

getFacilityPosList_BAK = function() {
	vectorSource.clear();
	
	if ($("div.selSido select").val() != '') { 
		if ($("dl.markdl").length > 0) {
			// 검색된 시설물이 있으면 해당 페이지의 시설물 영역으로 이동
			var xvals = [], yvals = [];
			$("dl.markdl").each(function(index) {
				xvals.push($(this).data("xpos"));
				yvals.push($(this).data("ypos"));
			});
			
			var ext = [Math.min.apply(null, xvals), Math.min.apply(null, yvals), Math.max.apply(null, xvals), Math.max.apply(null, yvals)];
			var extent = ol.proj.transformExtent(ext, 'EPSG:5186', 'EPSG:3857');
			map.getView().fit(extent, map.getSize());
		} else {
			// 검색된 시설물이 없으면 시군구 경계로 이동 시킴 (시군구를 선택했을 경우)
			$.ajax({
				url: urlPrefix + "space/facilityPosList.do", 
				type: "POST",
				data: {sido: encodeURI($("div.selSido select").val()), gugun: encodeURI($("div.selGugun select").val()), 'facilityCode': $("div.selCode select").val(), searchKeyword: encodeURI($("#searchKeyword").val())},
				dataType: "json",
				success: function(json) {
					
					if (json.boundary) {
						var ext = [json.boundary.xmin, json.boundary.ymin, json.boundary.xmax, json.boundary.ymax];
						var extent = ol.proj.transformExtent(ext, 'EPSG:4326', 'EPSG:3857');
						map.getView().fit(extent, map.getSize(), {nearest: true});
					} else {
						map.getView().setZoom(10);
						map.getView().setCenter([14135199.061064802, 4518412.772697475]);
					}
				}
			});
		}
	} else {
		map.getView().setZoom(10);
		map.getView().setCenter([14135199.061064802, 4518412.772697475]);
	}
};

getFacilityPosList = function() {
	vectorSource.clear();
	
	if ($("dl.markdl").length > 0) {
		var xvals = [], yvals = [];
		$("dl.markdl").each(function(index) {
			xvals.push($(this).data("xpos"));
			yvals.push($(this).data("ypos"));
		});
		
		var ext = [Math.min.apply(null, xvals), Math.min.apply(null, yvals), Math.max.apply(null, xvals), Math.max.apply(null, yvals)];
		var extent = ol.proj.transformExtent(ext, 'EPSG:5186', 'EPSG:3857');
		map.getView().fit(extent, map.getSize());
	} else {
		// 검색된 시설물이 없으면 시군구 경계로 이동 시킴 (시군구를 선택했을 경우)
		$.ajax({
			url: urlPrefix + "space/facilityPosList.do", 
			type: "POST",
			data: {sido: encodeURI($("div.selSido select").val()), gugun: encodeURI($("div.selGugun select").val()), 'facilityCode': $("div.selCode select").val(), searchKeyword: encodeURI($("#searchKeyword").val())},
			dataType: "json",
			success: function(json) {
				
				if (json.boundary) {
					var ext = [json.boundary.xmin, json.boundary.ymin, json.boundary.xmax, json.boundary.ymax];
					var extent = ol.proj.transformExtent(ext, 'EPSG:4326', 'EPSG:3857');
					map.getView().fit(extent, map.getSize(), {nearest: true});
				} else {
					map.getView().setZoom(10);
					map.getView().setCenter([14135199.061064802, 4518412.772697475]);
				}
			}
		});
	}
};

setFacilityMark = function(seq, xpos, ypos, fcode, name) {
	var pt = ol.proj.transform([xpos, ypos], "EPSG:5186", "EPSG:3857");

	searchFeatureSeq = seq;
	
	map.getView().setZoom(10);
	map.getView().setCenter(pt);
	
	vectorSource.clear();
};

getFacDetailForm = function(data) {
	$.ajax({
		url: urlPrefix + "spaceDetail/facilityDetail.do",
		type: 'GET',
		data: {seq: data},
		dataType: "html",
		success: function(html) {
			$("div.placeInfoLayer").html(html);
			$("div.placeInfoLayer").show();
		}
	});
};

var pointerMoveHandler = function(evt) {
	if (evt.dragging) {
		return;
	}
	
	if (drawTypeSelect == '') {
		var pixel = map.getEventPixel(evt.originalEvent);
		var feature = map.forEachFeatureAtPixel(pixel, function(feature, layer) {
			return feature;
		}, null, function(layer) {
			if (layer.get('lname') == 'facilityLayer') {
				return true;
			}
			
			return false;
		});
		
		if (feature) {
			if (feature.getProperties().NAME) {
				facTooltipElement.innerHTML = feature.getProperties().NAME;
				facTooltip.setPosition(evt.coordinate);
			
				$(facTooltipElement).show();
			}
		} else {
			$(facTooltipElement).hide();
		}
		
	} else {
		var helpMsg = '시작지점 클릭';
	
		if (sketch) {
			var geom = (sketch.getGeometry());
			if (geom instanceof ol.geom.Polygon) {
				helpMsg = continuePolygonMsg;
			} else if (geom instanceof ol.geom.LineString) {
				helpMsg = continueLineMsg;
			}
		}
	
		helpTooltipElement.innerHTML = helpMsg;
		helpTooltip.setPosition(evt.coordinate);
	
		$(helpTooltipElement).removeClass('hidden');
	}
};

function addInteraction() {
	refreshMap();
	
	var type = (drawTypeSelect == 'area' ? 'Polygon' : 'LineString');
	canvasDraw = new ol.interaction.Draw({
		source : drawSource,
		type : (type),
		style : new ol.style.Style({
			fill : new ol.style.Fill({
				color : 'rgba(255, 255, 255, 0.2)'
			}),
			stroke : new ol.style.Stroke({
				color : 'rgba(0, 0, 0, 0.5)',
				lineDash : [ 0, 0 ],
				width : 1
			}),
			image : new ol.style.Circle({
				radius : 5,
				stroke : new ol.style.Stroke({
					color : 'rgba(0, 0, 0, 0.7)'
				}),
				fill : new ol.style.Fill({
					color : 'rgba(255, 255, 255, 0.2)'
				})
			})
		})
	});
	map.addInteraction(canvasDraw);

	createMeasureTooltip();
	createHelpTooltip();

	var listener;
	canvasDraw.on('drawstart', function(evt) {
		sketch = evt.feature;

		var tooltipCoord = evt.coordinate;

		listener = sketch.getGeometry().on('change', function(evt) {
			var geom = evt.target;
			var output;
			if (geom instanceof ol.geom.Polygon) {
				output = formatArea((geom));
				tooltipCoord = geom.getInteriorPoint().getCoordinates();
			} else if (geom instanceof ol.geom.LineString) {
				output = formatLength((geom));
				tooltipCoord = geom.getLastCoordinate();
			}
			measureTooltipElement.innerHTML = output;
			measureTooltip.setPosition(tooltipCoord);
		});
	}, this);

	canvasDraw.on('drawend', function(evt) {
		measureTooltipElement.className = 'tooltip tooltip-static';
		measureTooltip.setOffset([ 0, -7 ]);
		
		sketch = null;
		
		measureTooltipElement = null;
		createMeasureTooltip();
		ol.Observable.unByKey(listener);
		
		refreshMap();
		drawTypeSelect = "";
	}, this);
}

function refreshMap() {
	map.removeInteraction(canvasDraw);
	canvasDraw = null;
	map.removeOverlay(helpTooltip);
	map.removeOverlay(measureTooltip);
}

function createHelpTooltip() {
	if (helpTooltipElement) {
		helpTooltipElement.parentNode.removeChild(helpTooltipElement);
	}
	helpTooltipElement = document.createElement('div');
	helpTooltipElement.className = 'tooltip hidden';
	helpTooltip = new ol.Overlay({
		element : helpTooltipElement,
		offset : [ 15, 0 ],
		positioning : 'center-left'
	});
	map.addOverlay(helpTooltip);
}

function createMeasureTooltip() {
	if (measureTooltipElement) {
		measureTooltipElement.parentNode.removeChild(measureTooltipElement);
	}
	measureTooltipElement = document.createElement('div');
	measureTooltipElement.className = 'tooltip tooltip-measure';
	measureTooltip = new ol.Overlay({
		element : measureTooltipElement,
		offset : [ 0, -15 ],
		positioning : 'bottom-center'
	});
	map.addOverlay(measureTooltip);
}

function createFacTooltip() {
	if (facTooltipElement) {
		facTooltipElement.parentNode.removeChild(facTooltipElement);
	}
	facTooltipElement = document.createElement('div');
	facTooltipElement.className = 'tooltip-fac hidden';
	facTooltip = new ol.Overlay({
		element : facTooltipElement,
		offset : [ 0, -5 ],
		positioning : 'bottom-center'
	});
	map.addOverlay(facTooltip);
}

var wgs84Sphere = new ol.Sphere(6378137);

var formatLength = function(line) {
	var length;
//	length = Math.round(line.getLength() * 100) / 100;
	
	var coordinates = line.getCoordinates();
	length = 0;
	var sourceProj = map.getView().getProjection();
	for (var i = 0, ii = coordinates.length - 1; i < ii; ++i) {
		var c1 = ol.proj.transform(coordinates[i], sourceProj, 'EPSG:4326');
		var c2 = ol.proj.transform(coordinates[i + 1], sourceProj, 'EPSG:4326');
		length += wgs84Sphere.haversineDistance(c1, c2);
	}
	
	var output;
	if (length > 100) {
		output = (Math.round(length / 1000 * 100) / 100) + ' ' + 'km';
	} else {
		output = (Math.round(length * 100) / 100) + ' ' + 'm';
	}
	return output;
};

var formatArea = function(polygon) {
	var area;
	//area = polygon.getArea();
	
	var sourceProj = map.getView().getProjection();
	var geom = (polygon.clone().transform(sourceProj, 'EPSG:4326'));
	var coordinates = geom.getLinearRing(0).getCoordinates();
	area = Math.abs(wgs84Sphere.geodesicArea(coordinates));
    
	var output;
	if (area > 10000) {
		output = (Math.round(area / 1000000 * 100) / 100) + ' ' + 'km<sup>2</sup>';
	} else {
		output = (Math.round(area * 100) / 100) + ' ' + 'm<sup>2</sup>';
	}
	return output;
};