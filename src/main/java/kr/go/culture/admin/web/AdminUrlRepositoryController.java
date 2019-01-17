package kr.go.culture.admin.web;

import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/admin/url")
@Controller
public class AdminUrlRepositoryController {

	private static final Logger logger = LoggerFactory.getLogger(AdminUrlRepositoryController.class);

	@Autowired
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.putPageNo(1);
		paramMap.putListUnit(999999999);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("adminUrlRepository.count", paramMap));
		model.addAttribute("list", service.readForList("adminUrlRepository.list", paramMap));

		return "/admin/url/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("url_id")) {
			resultMap = (CommonModel) service.readForObject("adminUrlRepository.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/admin/url/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		return "/admin/url/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("url_id")) {
			resultMap = (CommonModel) service.readForObject("adminUrlRepository.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/admin/url/list.do";
			}

			// update
			service.save("adminUrlRepository.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("adminUrlRepository.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/admin/url/form.do?url_id=" + paramMap.getString("url_id") + "&qs=" + paramMap.getQREnc();
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

		service.delete("adminMenuMapping.deleteByUrlId", paramMap); // admin_menu_mapping
		service.delete("adminUrlRole.deleteByUrlId", paramMap); // admin_url_role
		service.delete("adminUrlRepository.deleteByUrlId", paramMap); // admin_url_reoisutirt

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

		int count = (Integer) service.readForObject("adminUrlRepository.countByUrlString", url_string);

		jo.put("success", count > 0);
		return jo;
	}

}