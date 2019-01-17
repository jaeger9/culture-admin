package kr.go.culture.resource.web;

import java.util.HashMap;
import java.util.Map;

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

@RequestMapping("/resource/board")
@Controller
public class ResBoardController {

	private static final Logger logger = LoggerFactory.getLogger(ResBoardController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ParamMap topParam = new ParamMap();
		topParam.put("notice", "Y");
		topParam.putListUnit(999999999);
		topParam.putPageNo(1);

		if (paramMap.isNotBlank("page_seq")) {
			topParam.put("page_seq", paramMap.get("page_seq"));
		}
		if (paramMap.isNotBlank("menu_seq")) {
			topParam.put("menu_seq", paramMap.get("menu_seq"));
		}

		model.addAttribute("count", (Integer) service.readForObject("resBoard.count", paramMap));
		model.addAttribute("list", service.readForList("resBoard.list", paramMap));
		model.addAttribute("topList", service.readForList("resBoard.list", topParam));

		paramMap.put("list_unit","9999999");
		model.addAttribute("siteList", service.readForList("resPage.list", paramMap));

		model.addAttribute("paramMap", paramMap);
		
		return "/resource/board/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) service.readForObject("resBoard.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/resource/board/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);
		paramMap.put("list_unit","9999999");
		model.addAttribute("siteList", service.readForList("resPage.list", paramMap));

		return "/resource/board/form";
	}

	@RequestMapping(value = "/insert.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("reg_id", request.getSession().getAttribute("admin_id") == null ? "관리자" : request.getSession().getAttribute("admin_id"));

		CommonModel resultMap = null;

		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) service.readForObject("resBoard.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/resource/board/list.do";
			}

			// update
			service.save("resBoard.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("resBoard.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/resource/board/list.do";
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
		service.save("resBoard.updateApproval", paramMap);

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

		service.delete("resBoard.delete", paramMap);

		jo.put("success", true);
		return jo;
	}

	// 게시판 선택 시 select box에서 사이트 선택 시 메뉴 목록
	@RequestMapping(value = "/menujson.do")
	@ResponseBody
	public Map<String, Object> menujson(String page_seq, ModelMap model) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		String con_types[] = {"1","2"};
		
		ParamMap paramMap = new ParamMap();
		paramMap.put("pseq", page_seq);
		paramMap.putArray("con_types", con_types);

		result.put("menuList", service.readForList("resMenu.listByTree", paramMap));
		result.put("success", true);

		return result;
	}
}