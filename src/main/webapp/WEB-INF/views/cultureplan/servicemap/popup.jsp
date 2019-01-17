<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head></head>
<script>
	$(document).ready(function() {

		var param = "";
		
		$(".sel_btn").click(function() {
			var pnum = eval($(".pnum").val());
			param = "";
			$(".chkVal").each(function() {
				if ($(this).is(":checked")) {
					if (param == "") {
						param = this.value;
					} else {
						param = param + "," + this.value;
					}
				}// if end
			});
			//alert(param);
			if(pnum==1){
				opener.document.frm.org_cost.value = param;
			}else if(pnum==2){
				opener.document.frm.org_offline.value = param;
			}else if(pnum==3){
				opener.document.frm.org_online.value = param;
			}else if(pnum==4){
				opener.document.frm.org_age.value = param;
			}else if(pnum==5){
				opener.document.frm.org_poly.value = param;
			}else if(pnum==6){
				opener.document.frm.org_special.value = param;
			}else if(pnum==7){
				opener.document.frm.org_genre.value = param;
			}else if(pnum==8){
				opener.document.frm.org_service.value = param;
			}
			self.close();
		});
	});
</script>
<body>
	<fieldset class="searchBox"></fieldset>
	<!-- table list -->
	<div class="tableList">
		<table summary="게시판 글 목록">
			<caption>서비스</caption>
			<colgroup>
				<col />
				<col />
			</colgroup>

			<thead>
				<tr>
					<th scope="col">선택</th>
					<th scope="col">${serviceTitle}</th>

				</tr>
			</thead>
			<tbody>
				<c:set var="num" value="1" />
				<fmt:formatNumber value="${num}" type="number" var="numberType" />
				<c:forEach items="${mapData}" var="item" varStatus="status">
					<tr>
						<td><input type="checkbox" id="chk${numberType}" class="chkVal"  value="${item}" /></td>
						<td><label for="chk${numberType}"><p style="cursor: pointer">${item}</p></label></td>
						<c:set var="numberType" value="${numberType+1}" />
					</tr>

				</c:forEach>
			</tbody>
		</table>
	</div>
<input type="hidden" class="pnum" value="${pnum}"  />
	<div class="btnBox">
		<span class="btn white"><a href="#" class="sel_btn">선택</a></span> <span
			class="btn dark fr"><a href="javascript:self.close();"
			class="close_btn">닫기</a></span>
	</div>
	</form>

</body>
</html>