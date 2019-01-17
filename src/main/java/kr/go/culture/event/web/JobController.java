package kr.go.culture.event.web;

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

@RequestMapping("/event/job")
@Controller
public class JobController {

	private static final Logger logger = LoggerFactory.getLogger(JobController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("type", "52");

		ParamMap topParam = new ParamMap();
		topParam.put("type", "52");
		topParam.put("top_yn", "Y");
		topParam.putListUnit(999999999);
		topParam.putPageNo(1);

		model.addAttribute("paramMap", paramMap);
		// model.addAttribute("creatorList", service.readForList("report.creatorList", paramMap));
		model.addAttribute("count", (Integer) service.readForObject("report.count", paramMap));
		model.addAttribute("list", service.readForList("report.list", paramMap));
		model.addAttribute("topList", service.readForList("report.list", topParam));

		return "/event/job/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("type", "52");

		CommonModel resultMap = null;

		// uci가 null이 아닌 경우 조회해서 없을 경우 존재하지 않는 글
		if (paramMap.isNotBlank("uci")) {
			resultMap = (CommonModel) service.readForObject("report.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/event/job/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		return "/event/job/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("type", "52");
		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));

		CommonModel resultMap = null;

		if (paramMap.isNotBlank("uci")) {
			resultMap = (CommonModel) service.readForObject("report.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/event/job/list.do";
			}

			// update
			if ("CUL".equals(paramMap.get("datasource"))) {
				service.save("report.updateCUL", paramMap);
			} else {
				service.save("report.updateRDF", paramMap);
			}
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("report.insertCUL", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/event/job/list.do";
	}

	@RequestMapping(value = "/approval.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject approval(String[] rdf_ucis, String[] cul_ucis, String approval, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if ((rdf_ucis == null || rdf_ucis.length == 0) && (cul_ucis == null || cul_ucis.length == 0)) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("approval", "Y".equals(approval) ? "Y" : "N");

		if (rdf_ucis != null && rdf_ucis.length > 0) {
			paramMap.putArray("ucis", rdf_ucis);
			service.save("report.updateApprovalRDF", paramMap);
		}

		if (cul_ucis != null && cul_ucis.length > 0) {
			paramMap.putArray("ucis", cul_ucis);
			service.save("report.updateApprovalCUL", paramMap);
		}

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] rdf_ucis, String[] cul_ucis, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if ((rdf_ucis == null || rdf_ucis.length == 0) && (cul_ucis == null || cul_ucis.length == 0)) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();

		if (rdf_ucis != null && rdf_ucis.length > 0) {
			paramMap.putArray("ucis", rdf_ucis);
			service.delete("report.deleteRDF", paramMap);
		}

		if (cul_ucis != null && cul_ucis.length > 0) {
			paramMap.putArray("ucis", cul_ucis);
			service.delete("report.deleteCUL", paramMap);
		}

		jo.put("success", true);
		return jo;
	}

}