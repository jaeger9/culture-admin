/**
 * Portal Menu Mapping 관리
 * 
 * jquery zTree : http://www.ztree.me/v3/api.php 참조
 * 
 */
var isDrop = true;

// tree setting
var menuSettings = {
	callback : {
		onClick : onClickNode
	},
	data : {
		key : {
			name : 'menu_view'
		},
		simpleData : { // 단순 list로 tree 구조로 맞춰주는 옵션
			enable : true,
			idKey : 'menu_id',
			pIdKey : 'menu_pid',
			rootPId : 0
		}
	},
	edit : {
		enable : false
	},
	view : {
		fontCss : function (treeId, treeNode) {
			return treeNode.menu_approval != 'Y' ? {color : "#AAA"} : {};
		},
		selectedMulti : false
	}
};

function onClickNode(event, treeId, treeNode) {
	getFormHTML(treeNode);
}

// 등록폼
function getFormHTML(data) {
	Layer.mask();
	$('.menuDetailForm').empty();

	$.get('/portal/sampleMapping/urljson.do', {menu_id : data.menu_id}, function (res) {

		res.menu_id = data.menu_id;
		
		$('#formTemplate').tmpl( res ).appendTo('.menuDetailForm');
		Layer.unmask();

		var wrap		=	$('.menuDetailForm');
		var urlId		=	wrap.find('input[name=url_id]');
		var linkYN		=	wrap.find('input[name=link_yn]');
		
		urlId.click(function () {
			var radio = $(this).parents('tr:eq(0)').find('input[name=link_yn]').get(0);
			if (this.checked) {
				radio.disabled = false;

				if (linkYN.filter(':enabled').size() == 1) {
					linkYN.filter(':enabled').eq(0).click();
				}

			} else {
				radio.disabled = true;
				if (radio.checked) {
					radio.checked = false;

					if (linkYN.filter(':enabled').size() > 0) {
						linkYN.filter(':enabled').eq(0).click();
					}
				}
			}
		});
		
		$('.jqBtnSave').css({display : 'inline-block'});

	}).fail(function() {
		alert('시스템 오류가 발생했습니다.');
	});
}

// 등록 처리
function insertMenu() {
	var w			=	$('#mwrap');
	var menu_id		=	w.find('input[name=menu_id]');

	var wrap		=	$('.menuDetailForm');
	var menuId		=	wrap.find('input[name=menu_id]');
	var urlId		=	wrap.find('input[name=url_id]');
	var linkYN		=	wrap.find('input[name=link_yn]');

	if (menuId.val() == '') {
		alert('menu_id가 존재하지 않습니다.\r\n메뉴를 다시 선택 후 시도해 주세요.');
		return false;
	}
	
	if (linkYN.filter(':checked').size() == 1) {
		var parentTR	=	linkYN.filter(':checked').eq(0).parents('tr:eq(0)');
		var childUrlId	=	parentTR.find('input[name=url_id]:checked');

		if (childUrlId.size() == 0) {
			alert('대표 URL 선택이 올바르지 않습니다.\r\n메뉴를 다시 선택 후 시도해 주세요.');
			return false;
		}
	} else {
		if (urlId.filter(':checked').size() > 0) {
			alert('대표 URL을 선택해 주세요.');
			return false;
		}
	}

	var isMainURL = false;
	var param = {
		menu_id : menu_id.val()
		,nodes : []
		,count : 0
	};

	urlId.filter(':checked').each(function () {
		var _this = this;
		var yn = 'N';
		var $yn = $(this).parents('tr:eq(0)').find('input[name=link_yn]:eq(0)');

		if (!isMainURL && $yn.filter(':checked').size() > 0) {
			isMainURL = true;
			yn = 'Y';
		}

		param.nodes.push({
			url_id : $(_this).val()
			,link_yn : yn
		});
	});
	
	param.count = param.nodes.length;
	param = $.param(param);

	$.post('/portal/sampleMapping/mergejson.do', param, function (data) {
		alert('맵핑이 완료되었습니다.');
	}).fail(function() {
		alert('시스템 오류가 발생했습니다.');
	});
	
	return false;
}

$(function () {
	$('.save_btn').click(function () {
		insertMenu();
		return false;
	});

	$.fn.zTree.destroy('menuTree');
	$('.menuTreeWrap').addClass('indicator').find('#menuTree').empty();

	$.get('/portal/sampleMenu/menujson.do', {}, function (data) {
		$.fn.zTree.init($('#menuTree'), menuSettings, data.menu);
		
		var zTree = $.fn.zTree.getZTreeObj('menuTree');
		zTree.expandAll(true);

		$('.menuTreeWrap').removeClass('indicator');
		$('#menuTree a:eq(0)').click();

	}).fail(function() {
		alert('시스템 오류가 발생했습니다.');
	});
});