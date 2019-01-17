package kr.go.culture.portal.web;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.portal.service.PortalSampleMenuMappingService;


/**
 * TODO UXUI 메뉴구성 임시로 사용
 * @author nakser
 *
 */
@Controller
@RequestMapping("/portal/sampleMapping")
public class PortalSampleMenuMappingController {

	private static final Logger logger = LoggerFactory.getLogger(PortalSampleMenuMappingController.class);

	@Autowired
	private CkDatabaseService service;

	@Autowired
	private PortalSampleMenuMappingService portalMenuMappingService;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		model.addAttribute("paramMap", paramMap);
		return "/portal/sampleMapping/list";
	}

	@RequestMapping(value = "/urljson.do")
	@ResponseBody
	public Map<String, Object> removejson(String menu_id, ModelMap model) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();

		ParamMap paramMap = new ParamMap();
		paramMap.put("menu_id", menu_id);

		result.put("urls", service.readForList("portalSampleMenuMapping.listByMenuId", paramMap));
		result.put("success", true);
		return result;
	}

	@RequestMapping(value = "/mergejson.do")
	@ResponseBody
	public Map<String, Object> mergejson(HttpServletRequest request, ModelMap model) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();

		ParamMap paramMap = new ParamMap(request);
		paramMap.put("user_id", request.getSession().getAttribute("admin_id") == null ? "관리자" : request.getSession().getAttribute("admin_id"));

		portalMenuMappingService.mergeMapping(paramMap);

		result.put("success", true);
		return result;
	}
	
}
