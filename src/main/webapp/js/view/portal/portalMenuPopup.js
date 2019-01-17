/**
 * Portal Menu 관리
 * 
 * jquery zTree : http://www.ztree.me/v3/api.php 참조
 * 
 */
var isDrop = true;

// tree setting
var menuSettings = {
	callback : {
		onClick : onClickNode,
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
		drag : false,
		editNameSelectAll : false,
		enable : true,
		showRemoveBtn : false,
		showRenameBtn : false
	},
	view : {
		fontCss : function (treeId, treeNode) {
			return treeNode.menu_approval != 'Y' ? {color : "#AAA"} : {};
		},
		selectedMulti : false
	}
};


function onClickNode(event, treeId, treeNode) {
	var data = new Array();
	
	data['menu_id'] = treeNode.menu_id;
	data['menu_name'] = treeNode.menu_name;
	window.opener.setVal(data);
	window.close();
}

function setTreeParam() {
	var zTree = $.fn.zTree.getZTreeObj('menuTree');
	var zTreeNodes = zTree.transformTozTreeNodes(zTree.getNodes());

	// sort 변경
	setTreeSort(zTree, zTreeNodes);

	// sort 변경 node만 가져옴
	var nodes = zTree.getNodesByFilter(function (node) {
		if (node.org_menu_pid != node.menu_pid || node.org_menu_sort != node.menu_sort) {
			return true;
		}
		return false;
	});

	if (nodes == null || nodes.length == 0) {
		return null;
	}

	var param = {
		nodes : [],
		count : 0
	};

	for (var i = 0; i < nodes.length; i++) {
		param.nodes.push({
			menu_id		:	nodes[i].menu_id
			,menu_pid	:	nodes[i].menu_pid
			,menu_sort	:	nodes[i].menu_sort
		});
	}

	param.count = param.nodes.length;
	param = $.param(param);

	return param;
}

function setTree(callback) {
	$.fn.zTree.destroy('menuTree');
	$('.menuTreeWrap').addClass('indicator').find('#menuTree').empty();

	$.get('/portal/sampleMenu/menujson.do', {}, function (data) {
		$.fn.zTree.init($('#menuTree'), menuSettings, data.menu);
		$.fn.zTree.getZTreeObj('menuTree').expandAll(true);

		$('.menuTreeWrap').removeClass('indicator');

		if (callback != undefined && callback != null) {
			callback();
		}
	}).fail(function() {
		alert('시스템 오류가 발생했습니다.');
	});
}

$(function () {
	setTree();
});