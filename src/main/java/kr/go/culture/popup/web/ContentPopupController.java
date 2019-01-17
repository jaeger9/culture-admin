package kr.go.culture.popup.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.CultureDatabaseService;
import kr.go.culture.common.service.KiissDataBaseService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/popup")
@Controller("ContentPopup")
public class ContentPopupController {

	private static final Logger logger = LoggerFactory.getLogger(ContentPopupController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "KiissDataBaseService")
	private KiissDataBaseService kiissDataBaseService;
	
	@Resource(name = "CultureDatabaseService")
	private CultureDatabaseService cultureDatabaseService;
	
	//태그내 사용될 매뉴타입 코드
	private String default_menu_type = "1";
	
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		
		
		ParamMap paramMap = new ParamMap(request);
		try {
			
			if(!paramMap.containsKey("menu_type"))paramMap.put("menu_type", default_menu_type);
			if(request.getParameter("keyword")==null || request.getParameter("keyword").equals("")){
				paramMap.put("keyword", "");
			}else{
				paramMap.put("keyword", request.getParameter("keyword").toString());
			}
			
			if(request.getParameter("searchGubun")==null || request.getParameter("searchGubun").equals("")){
				paramMap.put("searchGubun", "");
			}else{
				paramMap.put("searchGubun", request.getParameter("searchGubun").toString());
			}
			
			
			paramMap.put("common_code_type", "VOD_TYPE");
			model.addAttribute("VodCateList" ,  ckDatabaseService.readForList("common.codeList", paramMap));
			model.addAttribute("paramMap", paramMap);
			
			setUccParamMap2(paramMap);
			setPagingNum2(paramMap);
			
			if(request.getParameter("exception")!=null){
				model.addAttribute("exception", request.getParameter("exception").toString());
			}
			if(request.getParameter("sub_menu_type")!=null){
				model.addAttribute("sub_menu_type", request.getParameter("sub_menu_type").toString());
			}
			
			model.addAttribute("list", kiissDataBaseService.readForList("culture.recommand.vodList", paramMap));
			model.addAttribute("count", kiissDataBaseService.readForObject("culture.recommand.vodListCnt", paramMap));
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return "/popup/cultureRecomList";
		//return "/magazine/recomCulture/list";
	}
	
	private void setUccParamMap2(ParamMap paramMap ) throws Exception { 
		String area_group = null;
		String culture_review = null;
		String job30 = null;
		String culture100 = null;
		String human_lecture = null;
		String forecast = null;
			
		String menu_type = paramMap.getString("menu_type");
		
		//국내외영상 : 1/ 국내영상 : 2 / 국외영상 : 3 / 문화TV : 4 / 문화직업30 : 5 / 한국문화100 : 6 / 인문학강연 : 7
		if ("1".equals(menu_type)) {
			area_group="total";
		}else if ("2".equals(menu_type)) {
			area_group="0";
		}else if ("3".equals(menu_type)) {
			area_group="1";
		}else if ("4".equals(menu_type)) {
			culture_review="Y";
		}else if ("5".equals(menu_type)) {
			job30="Y";
		}else if ("6".equals(menu_type)) {
			culture100="Y";
		}else if ("7".equals(menu_type)) {
			human_lecture="Y";
		}else if ("8".equals(menu_type)) {
			forecast="Y";
		}
		
		
		paramMap.put("area_group", area_group);
		paramMap.put("culture_review", culture_review);
		paramMap.put("job30", job30);
		paramMap.put("culture100", culture100);
		paramMap.put("human_lecture", human_lecture);
		paramMap.put("forecast", forecast);
	}
	
	//paramaMap 에 있음 좋겠다...
	private void setPagingNum2(ParamMap paramMap) { 
		int pageNo = paramMap.getInt("page_no");
		int listUnit = paramMap.getInt("list_unit");
		
		paramMap.put("snum", (pageNo - 1) * listUnit + 1);
		paramMap.put("enum", pageNo * listUnit);
	}
	
	
	
	//////////////////////////////////////////////////////
	
	
	@RequestMapping("/culturerecom.do")
	public String culturerecom(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("list", service.readForList("content.popup.culturerecomList", paramMap));
		model.addAttribute("count", service.readForObject("content.popup.culturerecomListCnt", paramMap));

		return "/popup/culturerecom";
	}

	@RequestMapping("/ucc.do")
	public String ucc(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		setUccParamMap(paramMap);
		setPagingNum(paramMap);
		
		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("list", kiissDataBaseService.readForList("content.popup.uccList", paramMap));
		model.addAttribute("count", kiissDataBaseService.readForObject("content.popup.uccListCnt", paramMap));

		return "/popup/ucc";
	}
	@RequestMapping("/ucc1.do")
	public String ucc1(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		setUccParamMap(paramMap);
		setPagingNum(paramMap);
		
		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("list", kiissDataBaseService.readForList("content.popup.uccList1", paramMap));
		model.addAttribute("count", kiissDataBaseService.readForObject("content.popup.uccListCnt1", paramMap));

		return "/popup/ucc1";
	}
	
	@RequestMapping("/cultureplace.do")
	public String cultureplace(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("list", service.readForList("content.popup.cultureplaceList", paramMap));
		model.addAttribute("count", service.readForObject("content.popup.cultureplaceListCnt", paramMap));

		return "/popup/cultureplace";
	}
	
	@RequestMapping("/culturegroup.do")
	public String culturegroup(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("list", service.readForList("content.popup.cultureGroupList", paramMap));
		model.addAttribute("count", service.readForObject("content.popup.cultureGroupListCnt", paramMap));

		return "/popup/culturegroup";
	}
	
	@RequestMapping("/relic.do")
	public String relic(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		setPagingNum(paramMap);
		
		model.addAttribute("list", service.readForList("content.popup.relicList", paramMap));
		model.addAttribute("count", service.readForObject("content.popup.relicListCnt", paramMap));

		return "/popup/relic";
	}
	
	@RequestMapping("/educationsource.do")
	public String educationsource(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		setPagingNum(paramMap);
		
		model.addAttribute("list", service.readForList("content.popup.educationsourceList", paramMap));
		model.addAttribute("count", service.readForObject("content.popup.educationsourceListCnt", paramMap));

		return "/popup/educationsource";
	}
	
	@RequestMapping("/culturestatistic.do")
	public String culturestatistic(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		setPagingNum(paramMap);
		
		model.addAttribute("list", cultureDatabaseService.readForList("content.popup.culturestatisticList", paramMap));
		model.addAttribute("count", cultureDatabaseService.readForObject("content.popup.culturestatisticListCnt", paramMap));

		return "/popup/culturestatistic";
	}
	
	@RequestMapping("/notice.do")
	public String notice(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		setPagingNum(paramMap);
		
		model.addAttribute("list", service.readForList("content.popup.noticeList", paramMap));
		model.addAttribute("count", service.readForObject("content.popup.noticeListCnt", paramMap));

		return "/popup/notice";
	}

	@RequestMapping("/hiring.do")
	public String hiring(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		paramMap.put("type", new String[] { "52" });
		setPagingNum(paramMap);
		
		model.addAttribute("list", service.readForList("content.popup.hiringList", paramMap));
		model.addAttribute("count", service.readForObject("content.popup.hiringListCnt", paramMap));

		return "/popup/hiring";
	}
	
	@RequestMapping("/portalcolumn.do")
	public String portalcolumn(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		setPagingNum(paramMap);
		
		model.addAttribute("list", service.readForList("webzine.popup.culturecolumnList", paramMap));
		model.addAttribute("count", service.readForObject("webzine.popup.culturecolumnListCnt", paramMap));

		return "/popup/portalcolumn";
	}
	
	@RequestMapping("/event.do")
	public String event(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		setPagingNum(paramMap);
		
		model.addAttribute("list", service.readForList("webzine.popup.eventBannerList", paramMap));
		model.addAttribute("count", service.readForObject("webzine.popup.eventBannerListCnt", paramMap));

		return "/popup/event";
	}
	
	@RequestMapping("/culturenews.do")
	public String cultureNews(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		String sKey = paramMap.getString("sKey");
		String[] types = null;
		
		model.addAttribute("paramMap", paramMap);
		setPagingNum(paramMap);
		
		if ("46".equals(sKey)) {
			types = new String[] { "46" };
		} else if ("52".equals(sKey)) {
			types = new String[] { "52" };
		} else {
			types = new String[] { "46", "52" };
		}
		
		paramMap.put("type", types);
		
		model.addAttribute("list", service.readForList("webzine.popup.infoList", paramMap));
		model.addAttribute("count", service.readForObject("webzine.popup.infoListCnt", paramMap));

		return "/popup/culturenews";
	}
	
	@RequestMapping("cultureprosperity")
	public String cultureprosperity(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		
		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("list", service.readForList("content.popup.prosperityList", paramMap));
		model.addAttribute("count", service.readForObject("content.popup.prosperityListCnt", paramMap));

		return "/popup/cultureprosperity";
	}
	
	@RequestMapping("/news.do")
	public String news(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		
		paramMap.put("type", "46");
		
		model.addAttribute("list", service.readForList("content.popup.newsList", paramMap));
		model.addAttribute("count", service.readForObject("content.popup.newsListCnt", paramMap));

		return "/popup/news";
	}
	
	@RequestMapping("/prizewinner.do")
	public String prizewinner(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("list", service.readForList("content.popup.prizewinnerList", paramMap));
		model.addAttribute("count", service.readForObject("content.popup.prizewinnerListCnt", paramMap));

		return "/popup/prizewinner";
	}
	
	@RequestMapping("/tour.do")
	public String tour(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("category", service.readForList("content.popup.tourCategory", paramMap));
		model.addAttribute("list", service.readForList("content.popup.tourList", paramMap));
		model.addAttribute("count", service.readForObject("content.popup.tourListCnt", paramMap));

		return "/popup/tour";
	}
	
	//////////////////////////////////////////////////////////// 쓸데 없어... 귀찮아 이런거 그냥 넘겨줘 다음엔...
	private void setUccParamMap(ParamMap paramMap ) throws Exception { 
		String area_group = null;
		String culture100 = null;
			
		String subType = paramMap.getString("subType");
		
		//문화영상 세부분류 - 0:국내영상, 1-국외영상, Y-한국대표100
		if ("0".equals(subType)) {
			area_group = "0";
			culture100 = "N";
		}
		else if ("1".equals(subType)) {
			area_group = "1";
		}
		else if ("Y".equals(subType)) {
			area_group = "0";
			culture100 = "Y";
		}
		paramMap.put("area_group", area_group);
		paramMap.put("culture100", culture100);
	}
	
	//paramaMap 에 있음 좋겠다...
	private void setPagingNum(ParamMap paramMap) { 
		int pageNo = paramMap.getInt("page_no");
		int listUnit = paramMap.getInt("list_unit");
		
		paramMap.put("snum", (pageNo - 1) * listUnit + 1);
		paramMap.put("enum", pageNo * listUnit);
	}
}
