<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
function getParameter(key){
	var url = location.href;
	var spoint = url.indexOf("?");
	var query = url.substring(spoint,url.length);
	var keys = new Array;
	var values = new Array;
	var nextStartPoint = 0;
	while(query.indexOf("&",(nextStartPoint+1) ) >-1 ){
		var item = query.substring(nextStartPoint, query.indexOf("&",(nextStartPoint+1) ) );
		var p = item.indexOf("=");
		keys[keys.length] = item.substring(1,p);
		values[values.length] = item.substring(p+1,item.length);
		nextStartPoint = query.indexOf("&", (nextStartPoint+1) );
	}
	item = query.substring(nextStartPoint, query.length);
	p = item.indexOf("=");
	keys[keys.length] = item.substring(1,p);
	values[values.length] = item.substring(p+1,item.length);
	var value = "";
	for(var i=0; i<keys.length; i++){
		if(keys[i]==key){
			value = values[i];
		}
	}
	return value;
}

formName = getParameter('writeFormName_');

elements = parent.targetForm.elements;
for(j=0; elements.length>j; j++){
	element = elements[j];
	if(element.type == 'hidden'){
		if(element.name == 'WFCookie'){
			element.parentNode.removeChild(element);
			break;
		}
	}
}

if(formName!=null && formName != '' && formName.length>0){
	parent.document.forms[formName].onSubmit='return true;';
}
parent.restoreForm(formName);
parent.WFsubmitRestore();
parent.targetForm.submit();
parent.WFsubmitCreate();
</script>