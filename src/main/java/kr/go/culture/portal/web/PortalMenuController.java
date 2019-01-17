package kr.go.culture.portal.web;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.portal.service.PortalMenuService;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/portal/menu")
@Controller
public class PortalMenuController {

	private static final Logger logger = LoggerFactory.getLogger(PortalMenuController.class);

	@Autowired
	private CkDatabaseService service;

	@Autowired
	private PortalMenuService portalMenuService;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		model.addAttribute("paramMap", paramMap);
		return "/portal/menu/list";
	}

	// , method = RequestMethod.GET
	@RequestMapping(value = "/menujson.do")
	@ResponseBody
	public Map<String, Object> menujson(ModelMap model) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("menu", portalMenuService.getMenuList());
		return result;
	}

	@RequestMapping(value = "/removejson.do")
	@ResponseBody
	public JSONObject removejson(String menu_id, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		ParamMap paramMap = new ParamMap();
		paramMap.put("menu_id", menu_id);

		// 1. mapping에 들어간 menu_id를 모두 삭제
		// 2. menu 삭제
		service.delete("portalMenuMapping.deleteByMenuIdTree", paramMap);
		service.delete("portalMenu.deleteByMenuIdTree", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/insertjson.do")
	@ResponseBody
	public JSONObject insertjson(HttpServletRequest request, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		ParamMap paramMap = new ParamMap(request);
		paramMap.put("user_id", request.getSession().getAttribute("admin_id") == null ? "관리자" : request.getSession().getAttribute("admin_id"));

		portalMenuService.mergeMenu(paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/sortjson.do")
	@ResponseBody
	public JSONObject sortjson(HttpServletRequest request, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		ParamMap paramMap = new ParamMap(request);
		paramMap.put("user_id", request.getSession().getAttribute("admin_id") == null ? "관리자" : request.getSession().getAttribute("admin_id"));

		portalMenuService.updateMenuSort(paramMap);

		jo.put("success", true);
		return jo;
	}

}