package kr.go.culture.resource.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/resource/banner")
@Controller
public class ResBannerController {

	private static final Logger logger = LoggerFactory.getLogger(ResBannerController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		String[] form_types = {"2"};
		
		model.addAttribute("count", (Integer) service.readForObject("resBanner.count", paramMap));
		model.addAttribute("list", service.readForList("resBanner.list", paramMap));

		paramMap.put("list_unit","9999999");
		paramMap.putArray("form_type", form_types);
		model.addAttribute("siteList", service.readForList("resPage.list", paramMap));

		model.addAttribute("paramMap", paramMap);
		
		return "/resource/banner/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;
		String[] form_types = {"2"};

		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) service.readForObject("resBanner.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/resource/banner/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);
		
		paramMap.put("list_unit","9999999");
		paramMap.putArray("form_type", form_types);
		model.addAttribute("siteList", service.readForList("resPage.list", paramMap));

		return "/resource/banner/form";
	}

	@RequestMapping(value = "/insert.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("reg_id", request.getSession().getAttribute("admin_id") == null ? "관리자" : request.getSession().getAttribute("admin_id"));

		CommonModel resultMap = null;

		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) service.readForObject("resBanner.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/resource/banner/list.do";
			}

			// update
			service.save("resBanner.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("resBanner.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/resource/banner/list.do";
	}

	@RequestMapping(value = "/approval.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject approval(String[] seqs, String approval, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (seqs == null || seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("approval", approval);
		paramMap.putArray("seqs", seqs);
		service.save("resBanner.updateApproval", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] seqs, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (seqs == null || seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("seqs", seqs);

		service.delete("resBanner.delete", paramMap);

		jo.put("success", true);
		return jo;
	}
}