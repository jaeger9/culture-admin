/**
 * 
 * jquery zTree : http://www.ztree.me/v3/api.php 참조
 * 
 */
var isDrop = true;

var menuSettings;
var noneSeleteMenuSettings;

$(function () {
	// tree setting
	menuSettings = {
		callback : {
			beforeDrop : beforeDropNode,
			onClick : onClickNode,
			beforeRemove : beforeRemoveNode,
			onDrop : onDropNode
		},
		data : {
			key : {
				name : 'title'
			},
			simpleData : { // 단순 list로 tree 구조로 맞춰주는 옵션
				enable : true,
				idKey : 'seq',
				rootPId : 0
			}
		},
		edit : {
			drag : {
				isCopy : false
			},
			editNameSelectAll : false,
			enable : true,
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
	
	// tree setting
	noneSelectMenuSettings = {
			callback : {
				onClick : onClickNode,
				beforeRemove : beforeRemoveNode
			},
			data : {
				key : {
					name : 'title'
				},
				simpleData : { // 단순 list로 tree 구조로 맞춰주는 옵션
					enable : true,
					idKey : 'seq',
					rootPId : 0
				}
			},
			edit : {
				drag : {
					isCopy : false
				},
				editNameSelectAll : false,
				enable : true,
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
	
	setTree();
});

function onDropNode(event, treeId, treeNodes, targetNode, moveType) {
	if (moveType != null) {
		var param = setTreeParam();

		if (param != null) {
			isDrop = false;
			// Layer.mask();
			
			$.get('/resource/menu/sortjson.do', param, function (data) {
				setTree(function () {
					setTree();
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
	var nodes = zTree.getNodes();

	if (nodes == null || nodes.length == 0) {
		return null;
	}

	var param = {
		nodes : [],
		count : 0
	};

	for (var i = 0; i < nodes.length; i++) {
		param.nodes.push({
			seq		:	nodes[i].seq
			,sort	:	nodes[i].sort
		});
	}

	param.count = param.nodes.length;
	param = $.param(param);

	return param;
}

function setTreeSort(zTree, zTreeNodes) {
	if (zTreeNodes.length > 0) {
		for (var i = 0; i < zTreeNodes.length; i++) {
			zTreeNodes[i].sort = (i + 1);
			zTree.updateNode(zTreeNodes[i]);

			if (zTreeNodes[i].children) {
				setTreeSort(zTree, zTreeNodes[i].children);
			}
		}
	}
}

function beforeDropNode(treeId, treeNodes, targetNode, moveType) {
	if (!isDrop) {
		alert('변경 된 정보를 저장 중 입니다.\n저장이 완료된 후 이용해 주세요.');
		return false;
	}

	if (moveType == 'inner') {
		return false;
	}

	return true;
}

function beforeRemoveNode(treeId, treeNode) {
	var zTree = $.fn.zTree.getZTreeObj('menuTree');
	zTree.selectNode(treeNode);

	if (!confirm('"' + treeNode.title + '"을 삭제하시겠습니까?')) {
		return false;
	}

	var param = {
		seq : treeNode.seq
	};
	
	$.post('/resource/menu/removejson.do', param, function () {
		alert('"' + treeNode.title + '"가 삭제되었습니다.');
		setTree();
	}).fail(function() {
		alert('시스템 오류가 발생했습니다.');
	});;

	return true;
}

//신규입력 양식으로 폼 초기화
function onInit(type){
	$('input[name=con_type]').attr("checked",false);
	$('input[name=con_type]:radio[value="1"]').prop("checked",true);
	$('input[name=list_type]:radio[value="1"]').prop("checked",true);
	$('input[name=con_manual_url]').val('');
	$('input[name=seq]').val('');
	if(type != 'A'){
		$('input[name=title]').val('');
	}else{
		$('#menuTree_1_span').trigger('click');
	}
}

function onClickNode(event, treeId, treeNode) {
	$('input[name=title]').val(treeNode.title);
	$('input[name=con_manual_url]').val(treeNode.con_manual_url);
	$('input[name=con_type]:radio[value="'+treeNode.con_type+'"]').prop("checked",true);
	$('input[name=list_type]:radio[value="'+treeNode.list_type+'"]').prop("checked",true);
	$('input[name=seq]').val(treeNode.seq);
}

//트리메뉴 셋팅
function setTree(callback) {
	$.fn.zTree.destroy('menuTree');
	$('.menuTreeWrap').addClass('indicator').find('#menuTree').empty();
	
	$.get('/resource/menu/menujson.do', {pseq:$('select[name=pseq_page_type]').val().split("|")[0]}, function (data) {
		if( $('select[name=pseq_page_type]').val().split("|")[1] == 'A' && data.menu.length < 1 ){
			$.fn.zTree.init($('#menuTree'), noneSelectMenuSettings, null);
			$('#newBtn').hide();
		}else{
			if($('select[name=pseq_page_type]').val().split("|")[1] != 'A'){
				$.fn.zTree.init($('#menuTree'), menuSettings, data.menu);
				$('input[name=title]').prop('readonly','');
				$('#newBtn').show();
			}else{
				$.fn.zTree.init($('#menuTree'), noneSelectMenuSettings, data.menu);
				$('input[name=title]').prop('readonly','readonly');
				$('#newBtn').hide();
			}
		}

		$.fn.zTree.getZTreeObj('menuTree').expandAll(true);

		$('.menuTreeWrap').removeClass('indicator');

		if (callback != undefined && callback != null) {
			callback();
		}
		
		onInit($('select[name=pseq_page_type]').val().split("|")[1]);
	}).fail(function() {
		alert('시스템 오류가 발생했습니다.');
	});
}

//등록 처리
function insertMenu() {
	var w		=	$('#mwrap');
	var seq					=	w.find('input[name=seq]');
	var title				=	w.find('input[name=title]');
	var con_type			=	w.find('input[name=con_type]:checked');
	var list_type			=	w.find('input[name=list_type]:checked');
	var con_manual_url		=	w.find('input[name=con_manual_url]');
	var pData				=	w.find('select[name=pseq_page_type]').val().split("|");
	var pseq 				=	pData[0];
	var page_type			=	pData[1];
	var zTree 				= 	$.fn.zTree.getZTreeObj('menuTree');
	
	if(seq.val() == ""){
		if(!confirm("메뉴를 등록하시겠습니까?")){
			return;
		}
		
		if( page_type == 'B' ){
			//B타입은 5개 이상 등록할 수 없다.
			if( zTree.getNodes().length == 5 ){
				alert("B타입은 5개 까지만 등록 가능합니다.");
				return;
			}
		}else if( page_type == 'C' ){
			//B타입은 5개 이상 등록할 수 없다.
			if( zTree.getNodes().length == 8 ){
				alert("C타입은 8개 까지만 등록 가능합니다.");
				return;
			}
		}
	}else{
		if(!confirm("메뉴를 수정하시겠습니까?")){
			return;
		}
	}
	
	if (title.val() == '') {
		title.focus();
		alert('메뉴명을 입력해 주세요.');
		return false;
	}
	if (con_type.size() == 0) {
		con_type.focus();
		alert('콘텐츠 형태를 선택해 주세요.');
		return false;
	}
	if (list_type.size() == 0) {
		list_type.focus();
		alert('게시판 선택 시 목록 형태를 선택해 주세요.');
		return false;
	}
	if (con_manual_url.val() == '') {
		if(con_type.val() == '3'){
			con_manual_url.focus();
			alert('컨텐츠 수동 URL을 입력해 주세요.');
			return false;
		}
	}
	
	var param = {
		seq			:	seq.val()
		,pseq		:	pseq
		,title		:	title.val()
		,con_type		:	con_type.val()
		,list_type		:	list_type.val()
		,con_manual_url	:	con_manual_url.val()
	};

	$.post('/resource/menu/insertjson.do', param, function (data) {
		setTree();
		if (seq.val() == '') {
			alert('메뉴가 등록되었습니다.');
		} else {
			alert('메뉴가 수정되었습니다.');
		}
	}).fail(function() {
		alert('시스템 오류가 발생했습니다.');
	});;
}
