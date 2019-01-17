/*
 * Editor default option
 */
var oEditors = [];
var oEditorsOption = {
	oAppRef : oEditors
	,elPlaceHolder : 'contents'
	,sSkinURI : '/editor/SmartEditor2Skin.html'
};

/*
	사용법

	var p = new Pagination({
		view		:	'#pagination',		페이징 html id
		page_count	:	3333,				총 갯수
		page_no		:	1,					페이지 번호
		callback	:	function(pageIndex, e) {
			console.log('pageIndex : ' + pageIndex);
			return false;
		}
	});

*/
var Pagination = function(option) {
	var pluginOpts = {
		num_edge_entries	:	1,
		prev_text			:	'이전',
		next_text			:	'다음',
		ellipse_text		:	'...',
		prev_show_always	:	true,
		next_show_always	:	true,
		current_page		:	0,		// override index
		items_per_page		:	10,		// override
		num_display_entries	:	10,		// override
		link_to				:	'#',	// override
		callback			:	function(pageIndex, e) {// override
			console.log('page index : ' + pageIndex);
			return false;
		}
	};

	var customOpts = $.extend({
		// 필수
		view		:	'#pagination',
		page_count	:	0,
		page_no		:	1,
		link		:	'?page_no=__id__',
		callback	:	function(pageIndex, e) {
			console.log('pageIndex : ' + pageIndex);
			return false;
		},

		// 선택
		page_unit	:	10,
		list_unit	:	10,
		cssClass	:	'pagination'
	}, option || {});

	pluginOpts.current_page			=	customOpts.page_no < 1		? 0	: parseInt(customOpts.page_no) - 1;	// index (ex 3페이지 = 2)
	pluginOpts.items_per_page		=	customOpts.list_unit < 10	? 10: parseInt(customOpts.list_unit);
	pluginOpts.num_display_entries	=	customOpts.page_unit < 5	? 5	: parseInt(customOpts.page_unit);
	pluginOpts.link_to				=	customOpts.link;
	pluginOpts.callback				=	customOpts.callback;

	var $this = $(customOpts.view);

	if ($this.size() == 0) {
		alert('Pagination의 id에 해당하는 element가 존재하지 않습니다.');
		return null;
	}

	if (customOpts.page_count > 0) {
		$this.addClass(customOpts.cssClass).pagination(customOpts.page_count, pluginOpts);
	}

	return $this;
};

// 시작일, 종료일 달력
var Datepicker = function (start, end) {

	var t = this,
		startDate = $(start),
		endDate = $(end);

	startDate.datepicker({
		// defaultDate : "+1w",
		changeYear : true,
		changeMonth : true,
		numberOfMonths : 3,
		onClose : function(selectedDate) {
			endDate.datepicker("option", "minDate", selectedDate);
		},
		showOn : "both",
		buttonImage : "/images/layout/img_calender.jpg",
		buttonImageOnly : true,
		showButtonPanel : true
	});

	endDate.datepicker({
		// defaultDate : "+1w",
		changeYear : true,
		changeMonth : true,
		numberOfMonths : 3,
		onClose : function(selectedDate) {
			startDate.datepicker("option", "maxDate", selectedDate);
		},
		showOn : "both",
		buttonImage : "/images/layout/img_calender.jpg",
		buttonImageOnly : true,
		showButtonPanel : true
	});

	this.setStartDate = function(value) {
		startDate.datepicker('setDate', value);
		endDate.datepicker("option", "minDate", value);
	};

	this.setEndDate = function(value) {
		endDate.datepicker('setDate', value);
		startDate.datepicker("option", "maxDate", value);
	};

	return t;
};

// 날짜 한개
var setDatepicker = function (start) {
	var startDate = $(start);
	startDate.datepicker({
		// defaultDate : "+1w",
		changeYear : true,
		changeMonth : true,
		numberOfMonths : 3,
		showOn : "both",
		buttonImage : "/images/layout/img_calender.jpg",
		buttonImageOnly : true,
		showButtonPanel : true
	});
	return startDate;
};


// 체크박스
// var saleNoAll = $('input[name=jqSaleNoAll]');
// var saleNos = $('.ad_list input[type=checkbox][name=saleNos]');
// var checkbox = new Checkbox(saleNoAll, saleNos);
// var arr = checkbox.getValues();
var Checkbox = function(all, target) {
	var t = this,
		checkboxAll = $(all),
		checkbox = $(target);

	if (checkboxAll.size() == 0 || checkbox.size() == 0) {
		return null;
	}

	checkboxAll.on('click', function() {
		var t = this;
		checkbox.each(function() {
			if (!this.disabled) {
				this.checked = t.checked;
			}
		});
	});

	checkbox.on('click', function() {
		t.checkAll();
	});

	t.checkAll = function() {
		if (checkbox.filter(':checked').size() == checkbox.filter(':enabled').size()) {
			checkboxAll.get(0).checked = true;
		} else {
			checkboxAll.get(0).checked = false;
		}
	};

	t.getValues = function() {
		var arr = [];

		if (checkbox.filter(':checked').size() > 0) {
			checkbox.filter(':checked').each(function() {
				arr.push($(this).val());
			});
		}

		return arr;
	};

	t.getParam = function() {
		var arr = t.getValues();
		var name = checkbox.eq(0).attr('name');
		var param = '';

		for ( var i in arr) {
			param += '&' + name + '=' + arr[i];
		}

		if (param != '') {
			param = param.substring(1);
		}

		return param;
	};

	t.checkAll();

	return t;
};


var Layer = {
	mask : function(z, callback) {
		if ($('.jq_mask').size() == 0) {
			$('body').append('<div class="jq_mask" />');
		}
		if (!$('div.jq_mask').is('visible')) {
			$('div.jq_mask').stop().css({
				opacity : 0.3,
				backgroundColor : '#000',
				width : '100%',
				height : '100%',
				top : 0,
				left : 0,
				position : 'fixed',
				zIndex : (z == undefined ? 9999 : z),
				display : 'none'
			}).show();
		}

		if (callback != undefined && callback != null) {
			callback();
		}
	}
	,unmask : function(callback) {
		$('.jq_mask').stop().hide();

		if (callback != undefined && callback != null) {
			callback();
		}
	}
};

var common = {
		 chkByteLen : function(field, maxlimit, messageid){
			
			var str = $("#"+field).val();
			var len = 0;
			var intMax= 0;
			var onechar;
			
			for(var i = 0 ; i < str.length ; i++){
				len += (str.charCodeAt(i) > 128) ?  3: 1;
				onechar = str.charAt(i);
				
				if(escape(onechar) == '%0A'){
					len++;
				}
				
				if(intMax == 0 && len > maxlimit){
					intMax = i;
				}
			}
			
			if(messageid != null)
				$("#"+ messageid).html(len);
			
			if(len > maxlimit){
				$("#"+field).attr("value", str.substring(0,intMax-1));
				len = maxlimit;
				return false;
			}
			
			return true;
		}
}

// Popup
var Popup = {
	findLocation : function (num) {		
		window.open('/popup/findLocation.do?index='+num, 'findLocation', 'width=600,height=600');
		return false;
	},	
	linkPath : function () {
		window.open('/popup/pushLinkPage.do', 'findLocation', 'width=600,height=600');
		return false;
	},	
	zipcode : function () {
		window.open('/common/popup/zipcode.do', 'zipcodePopup', 'width=600,height=600');
		return false;
	},
	zipcodeRoad : function () {
		window.open('/common/popup/zipcodeRoad.do', 'zipcodePopup', 'width=600,height=600');
		return false;
	},
	userId : function (value) {
		window.open('/popup/userId.do?user_id=' + value, 'userIdPopup', 'width=600,height=600');
		return false;
	},
	adminId : function (value) {
		window.open('/popup/adminId.do?user_id=' + value, 'adminIdPopup', 'width=600,height=600');
		return false;
	},
	roleId : function (value) {
		window.open('/popup/roleId.do?role_id=' + value, 'roleIdPopup', 'width=600,height=600');
		return false;
	},
	fileUpload : function (menu_type, file_type) { //사용
		window.open('/popup/pro/fileupload.do?menu_type=' + menu_type + '&file_type=' + file_type, 'fileUploadPopup', 'width=600,height=250');
		return false;
	},
	artContentFile : function (vvm_seq, vvi_seq) {
		window.open('/popup/artContent/file/form.do?vvm_seq=' + vvm_seq + '&vvi_seq=' + vvi_seq, 'acfPopup', 'width=600,height=600');
		return false;
	},
	artContentMap : function (vvm_seq, vvi_seq) {
		window.open('/popup/artContent/map/form.do?vvm_seq=' + vvm_seq + '&vvi_seq=' + vvi_seq, 'acfPopup', 'width=600,height=600');
		return false;
	},
	artContentSite : function (vvm_seq, vvi_seq) {
		window.open('/popup/artContent/site/form.do?vvm_seq=' + vvm_seq + '&vvi_seq=' + vvi_seq, 'acfPopup', 'width=600,height=600');
		return false;
	},
	archiveContent : function (acm_cls_cd) {
		window.open('/popup/archive/content/form.do?acm_cls_cd=' + acm_cls_cd, 'archiveContentPopup', 'width=600,height=600');
		return false;
	},
	archiveFile : function (acm_cls_cd) {
		window.open('/popup/archive/file/form.do?acm_cls_cd=' + acm_cls_cd, 'archiveContentPopup', 'width=600,height=600');
		return false;
	},
	archiveMap : function (acm_cls_cd, arc_thm_id) {
		window.open('/popup/archive/map/form.do?acm_cls_cd=' + acm_cls_cd + '&arc_thm_id=' + arc_thm_id, 'archiveContentPopup', 'width=600,height=600');
		return false;
	},
	archiveIndex : function (acm_cls_cd) {
		window.open('/popup/archive/index/form.do?acm_cls_cd=' + acm_cls_cd, 'archiveContentPopup', 'width=600,height=600');
		return false;
	}
	
};