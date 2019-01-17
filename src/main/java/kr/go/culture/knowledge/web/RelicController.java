package kr.go.culture.knowledge.web;

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

@RequestMapping("/knowledge/relic")
@Controller
public class RelicController {

	private static final Logger logger = LoggerFactory.getLogger(RelicController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ParamMap topParam = new ParamMap();
		topParam.put("top_yn", "Y");
		topParam.putListUnit(999999999);
		topParam.putPageNo(1);

		model.addAttribute("paramMap", paramMap);
		// model.addAttribute("creatorList", service.readForList("relic.creatorList", paramMap));
		model.addAttribute("count", (Integer) service.readForObject("relic.count", paramMap));
		model.addAttribute("list", service.readForList("relic.list", paramMap));
		model.addAttribute("topList", service.readForList("relic.list", topParam));

		return "/knowledge/relic/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		// uci가 null이 아닌 경우 조회해서 없을 경우 존재하지 않는 글
		if (paramMap.isNotBlank("uci")) {
			resultMap = (CommonModel) service.readForObject("relic.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/knowledge/relic/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		return "/knowledge/relic/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));

		CommonModel resultMap = null;

		if (paramMap.isNotBlank("uci")) {
			resultMap = (CommonModel) service.readForObject("relic.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/knowledge/relic/list.do";
			}

			// update
			service.save("relic.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("relic.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/knowledge/relic/form.do?uci=" + paramMap.getString("uci").replace("+", "%2b") + "&qs=" + paramMap.getQREnc();

	}

	@RequestMapping(value = "/approval.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject approval(String[] ucis, String approval, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (ucis == null || ucis.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("approval", "Y".equals(approval) ? "Y" : "N");
		paramMap.putArray("ucis", ucis);
		service.save("relic.updateApproval", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] ucis, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (ucis == null || ucis.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("ucis", ucis);
		service.delete("relic.delete", paramMap);

		jo.put("success", true);
		return jo;
	}

}