package kr.go.culture.cultureplan.web;

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

@RequestMapping("/cultureplan/cultureStory")
@Controller
public class CultureStoryController {

	private static final Logger logger = LoggerFactory.getLogger(CultureStoryController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("common_code_type", "CUL_ENRCH");
		paramMap.put("common_code_pcode", "604");

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("contList", service.readForList("common.codeList", paramMap));
		model.addAttribute("count", (Integer) service.readForObject("cultureStory.count", paramMap));
		model.addAttribute("list", service.readForList("cultureStory.list", paramMap));
		
	

		return "/cultureplan/cultureStory/list";
	}

	@RequestMapping(value = "/view.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;
		
		paramMap.put("common_code_type", "CUL_ENRCH");
		paramMap.put("common_code_pcode", "604");
		

		// seq가 null이 아닌 경우 조회해서 없을 경우 존재하지 않는 글
		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) service.readForObject("cultureStory.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/cultureplan/cultureStory/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("contList", service.readForList("common.codeList", paramMap));
		model.addAttribute("view", resultMap);

		return "/cultureplan/cultureStory/view";
	}

	@RequestMapping(value = "/view.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("user_id", request.getSession().getAttribute("admin_id"));

		CommonModel resultMap = null;

		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) service.readForObject("cultureStory.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/cultureplan/cultureStory/list.do";
			}

			// update
			service.save("cultureStory.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("cultureStory.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/cultureplan/cultureStory/view.do?seq=" + paramMap.getString("seq") + "&qs=" + paramMap.getQREnc();
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
		paramMap.put("approval", "Y".equals(approval) ? "Y" : "N");
		paramMap.putArray("seqs", seqs);
		service.save("cultureStory.updateApproval", paramMap);

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
		service.delete("cultureStory.delete", paramMap);

		jo.put("success", true);
		return jo;
	}

}