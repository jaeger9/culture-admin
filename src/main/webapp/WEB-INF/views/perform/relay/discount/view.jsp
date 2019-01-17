<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">

var callback = {
		rdfMetadata : function (res) {
			/*
				JSON.stringify(res) = {
					"cateType"	:	"F"
					,"orgCode"	:	"NLKF02"
					,"orgId"	:	86
					,"category"	:	"도서"
					,"name"		:	"국립중앙도서관"
				}
			*/
			if (res == null) {
				alert('CallBack Res Null');
				return false;
			} 
			//{"url":"","grade":"","extent":"","venue":"홍대 축제4","location":"02","genre":1,"rights":"최용준","time":"12:00 ~ 14:00","referenceidentifierorg":"","referenceidentifier":"fes4.jpg","enddt":20141231,"startdt":20140101,"period":"2014-01-01~2014-12-31","title":"최용준 축제4","type":50,"uci":"92513744511758932","seq":97176}
			console.log(JSON.stringify(res));
			$('#preformCopy').show();
			
			//공연 uci
			if(res.uci) {$('input[name=uci]').val(res.uci);}
			else {alert('공연 uci 값이 존재하지 않습니다.'); return false;}

			//공연 url
			$('input[name=rul]').val(res.url);
			
			//공연 장소
			$('input[name=place]').val(res.venue);
			
			//이미지
			if(res.referenceIdentifier){
				$('#selectedPerformImg').attr('src', res.referenceIdentifier);
				$('input[name=img_url]').val(res.referenceIdentifier);
				$('input[name=img_yn]').val('N');
			}
			if(res.referenceIdentifierOrg){
				$('#selectedPerformImg').attr('src', '/upload/rdf/' + res.referenceIdentifierOrg);
				$('input[name=img_file]').val(res.referenceIdentifierOrg);
				$('input[name=img_yn]').val('Y');
			}
			
/* 			if(res.referenceIdentifier || res.referenceIdentifierOrg)$('input[name=img_yn]').val('Y');
			else $('input[name=img_yn]').val('N'); */
			
			if(res.url)$('input[name=url]').val(res.url);//공연 url
			if(res.startDt)$('input[name=start_date]').val(res.startDt);//공연 시작일
			if(res.endDt)$('input[name=end_date]').val(res.endDt);//공연 시작일
			
			//공연정보
			$('#performInfo').empty();//다 지우고
			
			if(res.title){
				$('#performInfo').append('제목 : '+ res.title + '</br>');
				$('input[name=title]').val(res.title);
			}
			if(res.time)$('#performInfo').append('시간 : '+ res.time + '</br>');
			if(res.venue)$('#performInfo').append('장소 : '+ res.venue + '</br>');
			if(res.extent)$('#performInfo').append('런닝타임: '+ res.extent + '</br>');
			if(res.grade)$('#performInfo').append('연령 : '+ res.grade + '</br>');
			if(res.rights)$('#performInfo').append('주최 : '+ res.rights + '</br>');
			if(res.reference)$('#performInfo').append('제목 : '+ res.reference + '</br>');
			
			return true;
		},relayGroup : function(res) { 
			if (res == null) {
				alert('CallBack Res Null');
				return false;
			};
			
			$('input[name=name]').val(res.name);
			$('input[name=company_seq]').val(res.seq);
		}
};

$(function () {

	var frm = $('form[name=frm]');
	var title		= frm.find('input[name=title]');
	var name		= frm.find('input[name=name]');
	//layout
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	if('${view.note1}')$('input:radio[name="note1"][value="${view.note1}"]').prop('checked', 'checked');
	
	//select selected
	if('${view.genre}')$("select[name=genre]").val('${view.genre}').attr("selected", "selected");
	if('${view.discount}')$("select[name=discount]").val('${view.discount}').attr("selected", "selected");
	
		
	//URL 미리보기
	goLink = function() { 
		window.open($('input[name=url]').val());
	}
	
	//공연상 선택
	$('span.btn.whiteS a').each(function(){
	  	$(this).click(function(){
	    	if( $(this).html() == '선택'){
	      		window.open('/popup/relayGroup.do', 'placePopup', 'scrollbars=yes,width=600,height=630');
	    	} else if( $(this).html() == '공연선택'){
	      		window.open('/popup/rdfMetadataPerform.do', 'placePopup', 'scrollbars=yes,width=600,height=630');
	    	} 
	  	});
	});
	
	frm.submit(function(){
		//DB NOT NULL 기준 체크
		if(title.val() ==''){
			alert('공연 선택하세요');
			title.focus();
			return false;
		}

		if(name.val() ==''){
			alert('기관/단체명 입력하세요');
			name.focus();
			return false;
		}
		
		return true;
	});
	
	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		if (!confirm('수정하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/perform/relay/discount/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		if (!confirm('삭제 하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/perform/relay/discount/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		if (!confirm('등록하시겠습니까?')) {
        			return false;
        		}
        		frm.attr('action' ,'/perform/relay/discount/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		location.href='/perform/relay/discount/list.do';
        	}   		
    	});
	});
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/perform/relay/discount/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<table summary="할인중인 공연 작성">
				<caption>할인중인 공연  글쓰기</caption>
				<colgroup>
					<col style="width:15%" /><col style="width:35%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">공연 전시 제목</th>
						<td colspan="3">
							<input type="text" name="title" id="title" style="width:600px"  value="<c:out value='${view.title }'/>" readonly>
							<span class="btn whiteS"><a href="#url">공연선택</a></span>
						</td>
					</tr>
					<tr>
						<th scope="row">기관/단체명</th>
						<td colspan="3">
							<input type="text" name="name" id="name" style="width:624px"  value="${view.name }" readonly>
							<input type="hidden" name="company_seq" id="company_seq" style="width:624px"  value="${view.company_seq }">
							<span class="btn whiteS"><a href="#url">선택</a></span>
						</td>
					</tr>
					<tr>
						<th scope="row">선택한</br>공연/전시 정보</th>
						<td colspan="3">
							<input type="hidden" name="uci" value="<c:out value="${view.uci }" />"/>
							<input type="hidden" name="url" value="<c:out value="${view.url }" />"/>
							<input type="hidden" name="start_date" value="<c:out value="${view.start_date }" />"/>
							<input type="hidden" name="end_date" value="<c:out value="${view.start_date }" />"/>
							<input type="hidden" name="img_url" value="<c:out value="${view.img_url }" />"/>
							<input type="hidden" name="img_file" value="<c:out value="${view.img_file }" />"/>
							<input type="hidden" name="img_yn" value="<c:out value="${view.img_yn }" />"/>
							<input type="hidden" name="place" value="<c:out value="${view.place }" />"/>
							<input type="hidden" value="1" name="category">
							<input type="hidden" name="img_url" value="<c:out value="${view.img_url }" />"/>
							
							
							
							<span id="preformCopy">
								
								<c:if test="${not empty view.seq}">
									<c:if test="${ 'Y' eq view.img_yn }">
										<c:if test="${not empty view.img_file}">
											<img id="selectedPerformImg" src="/upload/rdf/<c:out value="${view.img_file}" />" style="width:225px;height:282px"/>
										</c:if>
									</c:if>
									<c:if test="${ 'N' eq view.img_yn }">
										<c:if test="${not empty view.img_url}">
											<img id="selectedPerformImg" src="<c:out value="${view.img_url }" />" style="width:225px;height:282px" />
										</c:if>
									</c:if>
								</c:if>
								<c:if test="${empty view.seq}">
									<img id="selectedPerformImg" src=""/>
								</c:if>
							<br/>
							<div id="performInfo">
								<c:if test="${not empty view.title }">제목 :<c:out value="${view.title }" /> <br /></c:if>
								<c:if test="${not empty view.url }">URL :<c:out value="${view.url }" /><br /></c:if>
								<c:if test="${not empty view.img_yn }">내부이미지 : <c:out value="${view.img_yn }" /> <br /></c:if>
								<c:if test="${not empty view.start_date }">시작일 : <c:out value="${view.start_date }" /><br /></c:if>
								<c:if test="${not empty view.end_date }">종료일:<c:out value="${view.end_date }" /> <br /></c:if>
							</div>
							</span>
						</td>
					</tr>
					<tr>
						<th scope="row">할인률</th>
						<td colspan="3">
							<select title="할인률 선택하세요" name="discount">
								<option value="10">10%</option>
								<option value="15">15%</option>
								<option value="20">20%</option>
								<option value="25">25%</option>
								<option value="30">30%</option>									
								<option value="35">35%</option>
								<option value="40">40%</option>									
								<option value="50">50%</option>									
								<option value="60">60%</option>
								<option value="1">1%</option>
											<option value="2">2%</option>
											<option value="3">3%</option>
											<option value="4">4%</option>
											<option value="5">5%</option>
											<option value="6">6%</option>
											<option value="7">7%</option>
											<option value="8">8%</option>
											<option value="9">9%</option>
											<option value="10">10%</option>
											<option value="11">11%</option>
											<option value="12">12%</option>
											<option value="13">13%</option>
											<option value="14">14%</option>
											<option value="15">15%</option>
											<option value="16">16%</option>
											<option value="17">17%</option>
											<option value="18">18%</option>
											<option value="19">19%</option>
											<option value="20">20%</option>
											<option value="21">21%</option>
											<option value="22">22%</option>
											<option value="23">23%</option>
											<option value="24">24%</option>
											<option value="25">25%</option>
											<option value="26">26%</option>
											<option value="27">27%</option>
											<option value="28">28%</option>
											<option value="29">29%</option>
											<option value="30">30%</option>
											<option value="31">31%</option>
											<option value="32">32%</option>
											<option value="33">33%</option>
											<option value="34">34%</option>
											<option value="35">35%</option>
											<option value="36">36%</option>
											<option value="37">37%</option>
											<option value="38">38%</option>
											<option value="39">39%</option>
											<option value="40">40%</option>
											<option value="41">41%</option>
											<option value="42">42%</option>
											<option value="43">43%</option>
											<option value="44">44%</option>
											<option value="45">45%</option>
											<option value="46">46%</option>
											<option value="47">47%</option>
											<option value="48">48%</option>
											<option value="49">49%</option>
											<option value="50">50%</option>
											<option value="51">51%</option>
											<option value="52">52%</option>
											<option value="53">53%</option>
											<option value="54">54%</option>
											<option value="55">55%</option>
											<option value="56">56%</option>
											<option value="57">57%</option>
											<option value="58">58%</option>
											<option value="59">59%</option>
											<option value="60">60%</option>
											<option value="61">61%</option>
											<option value="62">62%</option>
											<option value="63">63%</option>
											<option value="64">64%</option>
											<option value="65">65%</option>
											<option value="66">66%</option>
											<option value="67">67%</option>
											<option value="68">68%</option>
											<option value="69">69%</option>
											<option value="70">70%</option>
											<option value="71">71%</option>
											<option value="72">72%</option>
											<option value="73">73%</option>
											<option value="74">74%</option>
											<option value="75">75%</option>
											<option value="76">76%</option>
											<option value="77">77%</option>
											<option value="78">78%</option>
											<option value="79">79%</option>
											<option value="80">80%</option>
											<option value="81">81%</option>
											<option value="82">82%</option>
											<option value="83">83%</option>
											<option value="84">84%</option>
											<option value="85">85%</option>
											<option value="86">86%</option>
											<option value="87">87%</option>
											<option value="88">88%</option>
											<option value="89">89%</option>
											<option value="90">90%</option>
											<option value="91">91%</option>
											<option value="92">92%</option>
											<option value="93">93%</option>
											<option value="94">94%</option>
											<option value="95">95%</option>
											<option value="96">96%</option>
											<option value="97">97%</option>
											<option value="98">98%</option>
											<option value="99">99%</option>
											<option value="100">100%</option>								
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval" value="W" checked/> 대기</label>
								<label><input type="radio" name="approval" value="Y"/> 승인</label>
								<label><input type="radio" name="approval" value="N"/> 미승인</label>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div class="btnBox textRight">
		<c:if test='${not empty view}'>
			<span class="btn white"><button type="button">수정</button></span>
			<span class="btn white"><button type="button">삭제</button></span>
		</c:if>
		<c:if test='${empty view }'>
			<span class="btn white"><button type="button">등록</button></span>
		</c:if>
		<span class="btn gray"><button type="button">목록</button></span>
	</div>
</body>
</html>