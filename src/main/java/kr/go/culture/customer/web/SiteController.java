package kr.go.culture.customer.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.customer.service.SiteService;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/customer/site")
@Controller
public class SiteController {

	private static final Logger logger = LoggerFactory.getLogger(SiteController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@Resource(name = "SiteService")
	private SiteService siteService;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		ParamMap categoryMap = null;

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("sitemain.count", paramMap));
		model.addAttribute("list", service.readForList("sitemain.list", paramMap));

		categoryMap = new ParamMap();
		categoryMap.put("common_code_type", "LINK_SITE");
		model.addAttribute("categoryList", service.readForList("common.codeList", categoryMap));

		return "/customer/site/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		ParamMap siteMap = null;
		ParamMap categoryMap = null;
		CommonModel resultMap = null;

		// seq가 null이 아닌 경우 조회해서 없을 경우 존재하지 않는 글
		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) service.readForObject("sitemain.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/customer/site/list.do";
			}

			siteMap = new ParamMap();
			siteMap.put("sub_pseq", paramMap.get("seq"));
			model.addAttribute("siteList", service.readForList("sitesub.list", siteMap));
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		categoryMap = new ParamMap();
		categoryMap.put("common_code_type", "LINK_SITE");
		model.addAttribute("categoryList", service.readForList("common.codeList", categoryMap));

		return "/customer/site/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if (siteService.regist(request, paramMap) < 1) {
			return "redirect:/customer/site/list.do";
		}

		return "redirect:/customer/site/form.do?seq=" + paramMap.getString("seq") + "&qs=" + paramMap.getQREnc();
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] seqs, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (seqs == null || seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		siteService.delete(seqs);

		jo.put("success", true);
		return jo;
	}

	// // operation
	// @RequestMapping(value = "/operation.do", method = RequestMethod.GET)
	// public String operation(HttpServletRequest request, ModelMap model) throws Exception {
	// ParamMap paramMap = new ParamMap(request);
	//
	// if (paramMap.isBlank("openapi_seq")) {
	// SessionMessage.empty(request);
	// return "redirect:/customer/site/list.do";
	// }
	//
	// model.addAttribute("paramMap", paramMap);
	// model.addAttribute("list", service.readForList("openapiOperation.list", paramMap));
	//
	// return "/customer/site/operation";
	// }

}