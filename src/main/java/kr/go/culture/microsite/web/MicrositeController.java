package kr.go.culture.microsite.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/microsite/site")
@Controller
public class MicrositeController {

	private static final Logger logger = LoggerFactory.getLogger(MicrositeController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("microsite.count", paramMap));
		model.addAttribute("list", service.readForList("microsite.list", paramMap));

		return "/microsite/site/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("site_id")) {
			resultMap = (CommonModel) service.readForObject("microsite.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/microsite/site/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		return "/microsite/site/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("user_id", request.getSession().getAttribute("admin_id") == null ? "관리자" : request.getSession().getAttribute("admin_id"));

		if (service.readForObject("microsite.view", paramMap) != null) {
			// update
			service.save("microsite.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("microsite.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/microsite/site/form.do?site_id=" + paramMap.getString("site_id") + "&qs=" + paramMap.getQREnc();
	}

	@RequestMapping(value = "/approval.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject approval(String[] site_ids, String approval, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (site_ids == null || site_ids.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("approval", "Y".equals(approval) ? "Y" : "N");
		paramMap.putArray("site_ids", site_ids);
		service.save("microsite.updateApproval", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] site_ids, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (site_ids == null || site_ids.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("site_ids", site_ids);

		service.delete("micrositeBoard.deleteBySiteId", paramMap);
		service.delete("micrositeMenu.deleteBySiteId", paramMap);
		service.delete("microsite.delete", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/siteIdCheck.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject siteIdCheck(String site_id, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (StringUtils.isBlank(site_id)) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("site_id", site_id);

		if (service.readForObject("microsite.view", paramMap) != null) {
			jo.put("success", false);
		} else {
			jo.put("success", true);
		}

		return jo;
	}

}