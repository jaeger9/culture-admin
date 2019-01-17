package kr.go.culture.addservice.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

@RequestMapping("/addservice/englishVod")
@Controller
public class EnglishVodController {
	
	private static final Logger logger = LoggerFactory.getLogger(EnglishVodController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("englishVod.count", paramMap));
		model.addAttribute("list", service.readForList("englishVod.list", paramMap));

		return "/addservice/englishVod/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		// seq가 null이 아닌 경우 조회해서 없을 경우 존재하지 않는 글
		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) service.readForObject("englishVod.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/englishVod/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		return "/addservice/englishVod/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) service.readForObject("englishVod.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/englishVod/list.do";
			}

			// update
			service.save("englishVod.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			paramMap.put("user_id", request.getSession().getAttribute("admin_id") == null ? "관리자" : request.getSession().getAttribute("admin_id"));
			service.insert("englishVod.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/addservice/englishVod/list.do";
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
		service.save("englishVod.updateApproval", paramMap);

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
		service.delete("englishVod.delete", paramMap);

		jo.put("success", true);
		return jo;
	}

}
