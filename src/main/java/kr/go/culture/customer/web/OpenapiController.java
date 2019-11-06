package kr.go.culture.customer.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.customer.service.OpenapiService;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/customer/openapi")
@Controller
public class OpenapiController {

	private static final Logger logger = LoggerFactory.getLogger(OpenapiController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@Resource(name = "OpenapiService")
	private OpenapiService openapiService;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("openapi.count", paramMap));
		model.addAttribute("list", service.readForList("openapi.list", paramMap));
		model.addAttribute("categoryList", service.readForList("uciOrg.categoryList", null));
		
		//return "/customer/openapi/list";
		return "thymeleaf/customer/openapi/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		// id가 null이 아닌 경우 조회해서 없을 경우 존재하지 않는 글
		if (paramMap.isNotBlank("id")) {
			resultMap = (CommonModel) service.readForObject("openapi.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/customer/openapi/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		return "/customer/openapi/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		CommonModel resultMap = null;

		if (paramMap.isNotBlank("id")) {
			resultMap = (CommonModel) service.readForObject("openapi.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/customer/openapi/list.do";
			}

			// update
			service.save("openapi.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("openapi.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/customer/openapi/form.do?id=" + paramMap.getString("id") + "&qs=" + paramMap.getQREnc();
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] ids, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (ids == null || ids.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("ids", ids);
		service.delete("openapi.delete", paramMap);

		jo.put("success", true);
		return jo;
	}

	// operation
	@RequestMapping(value = "/operation.do", method = RequestMethod.GET)
	public String operation(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if (paramMap.isBlank("openapi_id")) {
			SessionMessage.empty(request);
			return "redirect:/customer/openapi/list.do";
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("list", service.readForList("openapiOperation.list", paramMap));

		return "/customer/openapi/operation";
	}

	@RequestMapping(value = "/operation.do", method = RequestMethod.POST)
	public String operationRegist(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		openapiService.regist(paramMap);
		SessionMessage.update(request);

		return "redirect:/customer/openapi/operation.do?openapi_id=" + paramMap.getInt("openapi_id_temp") + "&qs=" + paramMap.getQREnc();
	}

}