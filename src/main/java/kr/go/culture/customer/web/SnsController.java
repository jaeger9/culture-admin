package kr.go.culture.customer.web;

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

@RequestMapping("/customer/sns")
@Controller
public class SnsController {

	private static final Logger logger = LoggerFactory.getLogger(SnsController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		ParamMap categoryMap = null;

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("sns.count", paramMap));
		model.addAttribute("list", service.readForList("sns.list", paramMap));

		categoryMap = new ParamMap();
		categoryMap.put("common_code_pcode", 190);
		model.addAttribute("categoryList", service.readForList("common.codeList", categoryMap));

//		return "/customer/sns/list";
		return "thymeleaf/customer/sns/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		ParamMap categoryMap = null;
		CommonModel resultMap = null;

		// idx가 null이 아닌 경우 조회해서 없을 경우 존재하지 않는 글
		if (paramMap.isNotBlank("idx")) {
			resultMap = (CommonModel) service.readForObject("sns.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/customer/sns/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		categoryMap = new ParamMap();
		categoryMap.put("common_code_pcode", 190);
		model.addAttribute("categoryList", service.readForList("common.codeList", categoryMap));
		return "thymeleaf/customer/sns/form";
//		return "/customer/sns/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));

		CommonModel resultMap = null;

		if (paramMap.isNotBlank("idx")) {
			resultMap = (CommonModel) service.readForObject("sns.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/customer/sns/list.do";
			}

			// update
			service.save("sns.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("sns.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/customer/sns/form.do?idx=" + paramMap.getString("idx") + "&qs=" + paramMap.getQREnc();
	}

	@RequestMapping(value = "/approval.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject approval(String[] idxs, String approval, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (idxs == null || idxs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("approval", "Y".equals(approval) ? "Y" : "N");
		paramMap.putArray("idxs", idxs);
		service.save("sns.updateApproval", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] idxs, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (idxs == null || idxs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("idxs", idxs);
		service.delete("sns.delete", paramMap);

		jo.put("success", true);
		return jo;
	}

}