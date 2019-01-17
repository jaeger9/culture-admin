package kr.go.culture.microsite.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.microsite.service.MicrositeMenuService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/microsite/menu")
@Controller
public class MicrositeMenuController {

	private static final Logger logger = LoggerFactory.getLogger(MicrositeMenuController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@Resource(name = "MicrositeMenuService")
	private MicrositeMenuService micrositeMenuService;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		List<Object> siteList = service.readForList("microsite.listBySiteName", null);
		JSONArray menuJa = new JSONArray();

		if (siteList == null || siteList.size() == 0) {
			SessionMessage.empty(request);
			return "redirect:/microsite/site/list.do";
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("siteList", siteList);

		return "/microsite/menu/list";
	}

	// , method = RequestMethod.GET
	@RequestMapping(value = "/menujson.do")
	@ResponseBody
	public Map<String, Object> menujson(HttpServletRequest request, ModelMap model) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		List<Object> menuList = new ArrayList<Object>();

		ParamMap paramMap = new ParamMap(request);

		if (paramMap.isNotBlank("site_id")) {
			menuList = micrositeMenuService.getMenuList(paramMap.getString("site_id"));
		}

		result.put("menu", menuList);
		return result;
	}

	@RequestMapping(value = "/removejson.do")
	@ResponseBody
	public JSONObject removejson(@RequestParam(value = "site_id", required = true) String site_id, @RequestParam(value = "menu_id", required = true) String menu_id, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		ParamMap paramMap = new ParamMap();
		paramMap.put("site_id", site_id);
		paramMap.put("menu_id", menu_id);

		service.delete("micrositeMenu.deleteByMenuIdTree", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/insertjson.do")
	@ResponseBody
	public JSONObject insertjson(HttpServletRequest request, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		ParamMap paramMap = new ParamMap(request);
		paramMap.put("user_id", request.getSession().getAttribute("admin_id") == null ? "관리자" : request.getSession().getAttribute("admin_id"));

		micrositeMenuService.mergeMenu(paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/sortjson.do")
	@ResponseBody
	public JSONObject sortjson(HttpServletRequest request, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		ParamMap paramMap = new ParamMap(request);
		paramMap.put("user_id", request.getSession().getAttribute("admin_id") == null ? "관리자" : request.getSession().getAttribute("admin_id"));

		micrositeMenuService.updateMenuSort(paramMap);

		jo.put("success", true);
		return jo;
	}

	// 게시판 선택 시 select box에서 사이트 선택 시 메뉴 목록
	@RequestMapping(value = "/menuidjson.do")
	@ResponseBody
	public Map<String, Object> menuidjson(String site_id, ModelMap model) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();

		ParamMap paramMap = new ParamMap();
		paramMap.put("site_id", site_id);

		result.put("menuList", service.readForList("micrositeMenu.listByTree", paramMap));
		result.put("success", true);

		return result;
	}

}