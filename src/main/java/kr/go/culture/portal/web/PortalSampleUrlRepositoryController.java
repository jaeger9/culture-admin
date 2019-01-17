package kr.go.culture.portal.web;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import net.sf.json.JSONObject;

/**
 * TODO UXUI 메뉴구성 임시로 사용
 * @author nakser
 *
 */
@Controller
@RequestMapping("/portal/sampleUrl")
public class PortalSampleUrlRepositoryController {

	private static final Logger logger = LoggerFactory.getLogger(PortalSampleUrlRepositoryController.class);

	@Autowired
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.putPageNo(1);
		paramMap.putListUnit(999999999);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("portalSampleUrlRepository.count", paramMap));
		model.addAttribute("list", service.readForList("portalSampleUrlRepository.list", paramMap));

		return "/portal/sampleUrl/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("url_id")) {
			resultMap = (CommonModel) service.readForObject("portalSampleUrlRepository.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/portal/sampleUrl/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		return "/portal/sampleUrl/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		CommonModel resultMap = null;

		ParamMap paramMap = new ParamMap(request);
		paramMap.put("user_id", request.getSession().getAttribute("admin_id") == null ? "관리자" : request.getSession().getAttribute("admin_id"));

		if (paramMap.isNotBlank("url_id")) {
			resultMap = (CommonModel) service.readForObject("portalSampleUrlRepository.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/portal/sampleUrl/list.do";
			}

			// update
			service.save("portalSampleUrlRepository.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("portalSampleUrlRepository.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/portal/sampleUrl/form.do?url_id=" + paramMap.getString("url_id") + "&qs=" + paramMap.getQREnc();
	}

	@RequestMapping(value = "/approval.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject approval(String[] url_ids, String approval, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (url_ids == null || url_ids.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("approval", "Y".equals(approval) ? "Y" : "N");
		paramMap.putArray("url_ids", url_ids);
		service.save("portalSampleUrlRepository.updateApproval", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] url_ids, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (url_ids == null || url_ids.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("url_ids", url_ids);

		service.delete("portalSampleMenuMapping.deleteByUrlId", paramMap); // portal_menu_mapping
		service.delete("portalSampleUrlRepository.deleteByUrlId", paramMap); // portal_url_reoisutirt

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/existUrl.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject exist(String url_string, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (StringUtils.isBlank(url_string)) {
			jo.put("success", false);
			return jo;
		}

		int count = (Integer) service.readForObject("portalSampleUrlRepository.countByUrlString", url_string);

		jo.put("success", count > 0);
		return jo;
	}
	
}
