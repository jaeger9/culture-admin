<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>KCISA 문화포털 통합관리시스템</title>
		<link href="/css/commonNew.css" rel="stylesheet" type="text/css" media="all" />
		<style type="text/css">
		.detailContent {
			padding: 0;
			margin-left: 20px;
			line-height:1.5;
			width: 30%;
			float:left;
		}
		.detailContent div {
		margin-bottom:10px;
		}
		
		.detailContent h3 {
			font-size:1.2em;
			font-weight:bold;
			color:#4b6de6;
			margin: 0;
			padding: 10px 0 0 0;
		}
		
		.detailContent ul {
			margin-top: 5px
		}
	</style>
</head>
<body>

	<!-- <table border="1">
		<thead>
			<tr>
				<th>메인/공통</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><a href="/main/banner/list.do">배너관리</a></td>
				<td><a href="/main/content/list.do">메인콘텐츠관리</a></td>
			</tr>
		</tbody> -->
	
	<%-- 2015.07.27 접근 가능한 메뉴 연동 --%>
	<c:if test="${not empty allMenuTree }">
		<c:forEach var="dep1" items="${allMenuTree }" varStatus="status1">
			<c:if test="${status1.index % 5 == 0 }">
				<div class="detailContent">
			</c:if>
			
			<h3>${dep1.menu_name }</h3>
			<c:if test="${not empty dep1.childMenuList }">
				<ul>
					<c:forEach var="dep2" items="${dep1.childMenuList }">
						<li><a href="${dep2.firstUrl }"${dep2.menu_id eq currentMenuIdParent or dep2.menu_id eq currentMenuId ? ' class="focus"' : '' }>${dep2.menu_name }</a></li>
					</c:forEach>
				</ul>
			</c:if>
				
			<c:if test="${status1.count != 0 && status1.count % 5 == 0 }">
				</div>
			</c:if>
		</c:forEach>
	</c:if>

	<%-- 2015.07.27 백업
	<div class="detailContent">
		<div>
		<h3>배너관리</h3>
			<ul>
				<li><a href="/main/banner/list.do">배너관리</a></li>
				<li><a href="/main/content/list.do">메인콘텐츠관리</a></li>
				<li><a href="/main/site/list.do">사이트관리</a></li>
				<li><a href="/main/keyword/list.do">검색어관리</a></li>
				<li><a href="/main/author/list.do">필진관리</a></li>
				<li><a href="/main/code/list.do">공통코드관리</a></li>
				<li><a href="/main/agencycode/list.do">기관코드관리</a></li>
			</ul>
		</div>
		<div>
			<h3>공연/전시</h3>
			<ul>
				<li><a href="/perform/show/list.do">공연/전시</a></li>
				<li><a href="/perform/recom/play/list.do">추천공연</a></li>
				<li><a href="/perform/recom/display/list.do">추천전시</a></li>
				<li><a href="/perform/ticket/list.do">할인티켓</a></li>
				<li><a href="/perform/relay/discount/list.do">문화릴레이티켓</a></li>
				<li><a href="/perform/review/list.do">관람후기</a></li>
			</ul>
		</div>
		<div>
			<h3>행사/교육</h3>
			<ul>
				<li><a href="/festival/event/list.do">축제/행사</a></li>
				<li><a href="/festival/recom/festival/list.do">추천축제</a></li>
				<li><a href="/festival/recom/event/list.do">추천행사</a></li>
				<li><a href="/event/tour/list.do">관광</a></li>
				<li><a href="/education/humanLecture/list.do">인문학강연</a></li>
				<li><a href="/festival/education/class/list.do">교육</a></li>
			</ul>
		</div>
		<div>
			<h3>매거진/문화영상</h3>
			<ul>
				<li><a href="/magazine/cultureagree/list.do">문화공감</a></li>
				<li><a href="/magazine/portalcolumn/list.do">문화포털 칼럼</a></li>
				<li><a href="/magazine/column/list.do">관련기관 칼럼</a></li>
				<li><a href="/magazine/webzine/list.do">웹진</a></li>
				<li><a href="/magazine/tag/list.do">문화영상 태그관리</a></li>
				<li><a href="/magazine/agency/list.do">기관별 영상</a></li>
				<li><a href="/magazine/blog/list.do">문화포털 블로그</a></li>
			</ul>
		</div>
	</div>	
	
	<div class="detailContent">
		<div>
			<h3>전통디자인</h3>
			<ul>
				<li><a href="/pattern/db/manage/list.do">문양DB관리</a></li>
				<li><a href="/pattern/code/category/list.do">코드관리</a></li>
				<li><a href="/pattern/apply/design/list.do">전통문양활용</a></li>
				<li><a href="/pattern/ask/list.do">전통문양 사용신청</a></li>
			</ul>
		</div>
		<div>
			<h3>시설/단체</h3>
			<ul>
				<li><a href="/facility/place/list.do">문화시설</a></li>
				<li><a href="/facility/group/list.do">문화예술단체</a></li>
			</ul>
		</div>
		<div>
			<h3>문화지식/정책</h3>
			<ul>
				<li><a href="/knowledge/report/list.do">연구보고서</a></li>
				<li><a href="/knowledge/relic/list.do">국가유물</a></li>
				<li><a href="/knowledge/ict/list.do">교육활용자료</a></li>
				<li><a href="/addservice/artContent/list.do">예술지식백과사전</a></li>
				<li><a href="/knowledge/gukak/list.do">국악음원자료</a></li>
				<li><a href="/knowledge/book/list.do">도서</a></li>
				<li><a href="/cultureplan/culturesupport/recomList.do">문화지원사업</a></li>
				<li><a href="/cultureplan/cultureStory/list.do">문화융성</a></li>
			</ul>
		</div>
		<div>
			<h3>이벤트/소식</h3>
			<ul>
				<li><a href="/event/invitation/list.do">문화초대이벤트</a></li>
				<li><a href="/event/event/list.do">문화포털이벤트</a></li>
				<li><a href="/event/notice/list.do">공지/당첨자발표</a></li>
				<li><a href="/event/notice/list.do">뉴스</a></li>
				<li><a href="/event/job/list.do">채용</a></li>
			</ul>
		</div>
		<div>
			<h3>이용안내</h3>
			<ul>
				<li><a href="/customer/faq/list.do">자주찾는질문</a></li>
				<li><a href="/customer/qna/list.do">서비스문의</a></li>
				<li><a href="/customer/openapi/list.do">공공문화정보API</a></li>
				<li><a href="/customer/site/list.do">관련사이트</a></li>
				<li><a href="/customer/sns/list.do">문화SNS지도</a></li>
			</ul>
		</div>
	</div>

	<div class="detailContent">
		<div>	
			<h3>회원관리</h3>
			<ul>
				<li><a href="/member/portal/list.do">회원조회</a></li>
				<li><a href="/member/portalWithdraw/list.do">탈퇴회원</a></li>
				<li><a href="/member/portalStat/list.do">회원통계</a></li>
				<li><a href="/member/agent/list.do">기관회원</a></li>
				<li><a href="/member/point/list.do">포인트관리</a></li>
			</ul>
		</div>
		<div>
			<h3>메타통합관리</h3>
			<ul>
				<li><a href="/meta/quality/list.do">품질관리</a></li>
				<li><a href="/meta/quality/statisticList.do">메타통계</a></li>
			</ul>
		</div>
	   <div>
			<h3>부가서비스</h3>
			<ul>
				<li><a href="/addservice/contest/list.do">공모전관리</a></li>
				<li><a href="/addservice/archive/list.do">예술자료전시관</a></li>
				<li><a href="/addservice/vod/list.do">예술VOD</a></li>
				<li><a href="/microsite/site/list.do">마이크로사이트</a></li>
				<li><a href="/portal/menu/list.do">문화포털</a></li>
				<li><a href="/admin/member/list.do">관리자 관리</a></li>
			</ul>
		</div>
	</div>
	 --%>

</body>
</html>