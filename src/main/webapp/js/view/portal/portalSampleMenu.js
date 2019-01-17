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
		beforeDrop : beforeDropNode,
		beforeRemove : beforeRemoveNode,
		onClick : onClickNode,
		onDrop : onDropNode
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
		drag : {
			isCopy : false
		},
		editNameSelectAll : false,
		enable : true,
		removeTitle : '삭제',
		renameTitle : '수정',
		showRemoveBtn : true,
		showRenameBtn : false
	},
	view : {
		fontCss : function (treeId, treeNode) {
			return treeNode.menu_approval != 'Y' ? {color : "#AAA"} : {};
		},
		selectedMulti : false
	}
};

function beforeDropNode(treeId, treeNodes, targetNode, moveType) {
	if (!isDrop) {
		alert('변경 된 정보를 저장 중 입니다.\n저장이 완료된 후 이용해 주세요.');
		return false;
	}
	
	/*
	// level은 0부터
	var bMove = true;

	if (moveType == 'prev' || moveType == 'next') {
		if (targetNode.level > 0 && treeNodes[0].children) {
			bMove = false;
			// console.log('prev next 자식 존재로 불가');
		} else {
			// console.log('prev next 자식 미존재 가능');
		}
	} else if (moveType == 'inner') {
		if (targetNode.level > 0 || (targetNode.level == 0 && treeNodes[0].children)) {
			bMove = false;
			// console.log('inner 자식 존재로 불가');
		} else {
			// console.log('inner 자식 미존재 가능');
		}
	}

	if (!bMove) {
		alert('메뉴 구조는 2뎁스 이상 등록하실 수 없습니다.');
		return false;
	}
	*/

	return true;
}

function beforeRemoveNode(treeId, treeNode) {
	var zTree = $.fn.zTree.getZTreeObj('menuTree');
	zTree.selectNode(treeNode);

	if (!confirm('"' + treeNode.menu_view + '"을 삭제하시겠습니까?')) {
		return false;
	}

	var w	=	$('#mwrap');

	var param = {
		menu_id : treeNode.menu_id
	};

	$.post('/portal/sampleMenu/removejson.do', param, function () {

		alert('"' + treeNode.menu_view + '"가 삭제되었습니다.');
		$('.new_btn').click();

	}).fail(function() {
		alert('시스템 오류가 발생했습니다.');
	});;

	return true;
}

function onClickNode(event, treeId, treeNode) {
	getFormHTML(treeNode);
}

function onDropNode(event, treeId, treeNodes, targetNode, moveType) {
	if (moveType != null) {
		var param = setTreeParam();

		if (param != null) {
			isDrop = false;
			// Layer.mask();

			$.get('/portal/sampleMenu/sortjson.do', param, function (data) {
				setTree(function () {
					$('.new_btn').click();
					isDrop = true;
					// Layer.unmask();
				});
			}).fail(function() {
				alert('시스템 오류가 발생했습니다.');
			});
		}
	}
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

function setTreeSort(zTree, zTreeNodes) {
	if (zTreeNodes.length > 0) {
		for (var i = 0; i < zTreeNodes.length; i++) {
			zTreeNodes[i].menu_sort = (i + 1);
			zTree.updateNode(zTreeNodes[i]);

			if (zTreeNodes[i].children) {
				setTreeSort(zTree, zTreeNodes[i].children);
			}
		}
	}
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

/*
	등록/수정 시 해당 부분만 추가하여 db 조회를 최소화하려 했으나 그냥 전체를 다시 조회하는 것으로 대체

	function addNode(id, name) {
		$.fn.zTree.getZTreeObj('menuTree').addNodes(null, {
			menu_id : id,
			menu_pid : 0,
			menu_view : name
		});
	}

	function updateNode(name) {
		var zTree = $.fn.zTree.getZTreeObj('menuTree');
		var nodes = zTree.getSelectedNodes();

		if (nodes != null && nodes.length == 1) {
			nodes[0].menu_view = name;
			zTree.updateNode(nodes[0]);
		}
	}
*/

// 등록폼
function getFormHTML(data) {
	if (data == null) {
		data	=	{
			menu_id		:	null
			,menu_pid		:	0
			,menu_sort		:	function () {
				var result = 0;
				var zTree = $.fn.zTree.getZTreeObj('menuTree');
				var nodes = zTree.getNodesByFilter(function (node) {
					if (node.level < 1) {
						return true;
					}
					return false;
				});

				for (var i in nodes) {
					if (nodes[i].menu_sort && result < parseInt(nodes[i].menu_sort)) {
						result = parseInt(nodes[i].menu_sort);
					}
				}

				result = result + 1;

				if (result <= nodes.length) {
					result = nodes.length + 1;
				}

				return result;
			}
			,menu_name		:	''
			,menu_desc		:	''
			,menu_approval	:	'Y'
			,menu_target	:	''
			,menu_reg_date	:	null
			,menu_upt_date	:	null
			,menu_user_id	:	null
		};
	}

	$('.menuDetailForm').empty();
	$('#formTemplate').tmpl( data ).appendTo('.menuDetailForm');
}

// 등록 처리
function insertMenu() {
	var w		=	$('#mwrap');

	var menu_id			=	w.find('input[name=menu_id]');
	var menu_pid		=	w.find('input[name=menu_pid]');
	var menu_sort		=	w.find('input[name=menu_sort]');
	var menu_name		=	w.find('input[name=menu_name]');
	var menu_desc		=	w.find('input[name=menu_desc]');
	var menu_approval	=	w.find('input[name=menu_approval]:checked');
	var menu_target		=	w.find('input[name=menu_target]:checked');

	if (menu_name.val() == '') {
		menu_name.focus();
		alert('메뉴명을 입력해 주세요.');
		return false;
	}
	if (menu_approval.size() == 0) {
		menu_approval.focus();
		alert('승인 여부를 선택해 주세요.');
		return false;
	}
	
	var param = {
		nodes : [{
			menu_id			:	menu_id.val()
			,menu_pid		:	menu_pid.val()
			,menu_sort		:	menu_sort.val()
			,menu_name		:	menu_name.val()
			,menu_desc		:	menu_desc.val()
			,menu_approval	:	menu_approval.val()
			,menu_target	:	menu_target.val()
		}]
	};

	param.count = param.nodes.length;
	param = $.param(param);

	$.post('/portal/sampleMenu/insertjson.do', param, function (data) {
		setTree(function () {
			$('.new_btn').click();

			if (param.menu_id == '') {
				alert('메뉴가 등록되었습니다.');
			} else {
				alert('메뉴가 수정되었습니다.');
			}
		});
	}).fail(function() {
		alert('시스템 오류가 발생했습니다.');
	});;
}

$(function () {
	$('.new_btn').click(function () {
		getFormHTML(null);
		return false;
	});

	$('.save_btn').click(function () {
		insertMenu();
		return false;
	});

	setTree(function () {
		$('.new_btn').click();
	});
});