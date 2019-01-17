package kr.go.culture.microsite.web;

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

@RequestMapping("/microsite/board")
@Controller
public class MicrositeBoardController {

	private static final Logger logger = LoggerFactory.getLogger(MicrositeBoardController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ParamMap topParam = new ParamMap();
		topParam.put("notice", "Y");
		topParam.putListUnit(999999999);
		topParam.putPageNo(1);

		if (paramMap.isNotBlank("site_id")) {
			topParam.put("site_id", paramMap.get("site_id"));
		}
		if (paramMap.isNotBlank("menu_id")) {
			topParam.put("menu_id", paramMap.get("menu_id"));
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("micrositeBoard.count", paramMap));
		model.addAttribute("list", service.readForList("micrositeBoard.list", paramMap));
		model.addAttribute("topList", service.readForList("micrositeBoard.list", topParam));
		model.addAttribute("siteList", service.readForList("microsite.listBySiteName", null));

		return "/microsite/board/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) service.readForObject("micrositeBoard.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/microsite/board/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);
		model.addAttribute("siteList", service.readForList("microsite.listBySiteName", null));

		return "/microsite/board/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("writer", request.getSession().getAttribute("admin_id") == null ? "관리자" : request.getSession().getAttribute("admin_id"));

		CommonModel resultMap = null;

		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) service.readForObject("micrositeBoard.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/microsite/board/list.do";
			}

			// update
			service.save("micrositeBoard.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("micrositeBoard.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/microsite/board/form.do?seq=" + paramMap.getString("seq") + "&qs=" + paramMap.getQREnc();
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
		service.save("micrositeBoard.updateApproval", paramMap);

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

		service.delete("micrositeBoard.delete", paramMap);

		jo.put("success", true);
		return jo;
	}

}