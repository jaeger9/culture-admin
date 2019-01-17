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

@RequestMapping("/event/event")
@Controller
public class EventController {

	private static final Logger logger = LoggerFactory.getLogger(EventController.class);

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
		model.addAttribute("count", (Integer) service.readForObject("event.count", paramMap));
		model.addAttribute("list", service.readForList("event.list", paramMap));
		model.addAttribute("topList", service.readForList("event.list", topParam));

		return "/event/event/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		// event_id가 null이 아닌 경우 조회해서 없을 경우 존재하지 않는 글
		if (paramMap.isNotBlank("event_id")) {
			resultMap = (CommonModel) service.readForObject("event.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/event/event/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		return "/event/event/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("user_id", request.getSession().getAttribute("admin_id"));

		CommonModel resultMap = null;

		if (paramMap.isNotBlank("event_id")) {
			resultMap = (CommonModel) service.readForObject("event.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/event/event/list.do";
			}

			// update
			service.save("event.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("event.insert", paramMap);
			SessionMessage.insert(request);
		}
		// return "redirect:/event/event/form.do?event_id=" + paramMap.getString("event_id") + "&qs=" + paramMap.getQREnc();
		return "redirect:/event/event/list.do";
	}

	@RequestMapping(value = "/approval.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject approval(String[] event_ids, String approval, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (event_ids == null || event_ids.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("approval", "Y".equals(approval) ? "Y" : "N");
		paramMap.putArray("event_ids", event_ids);
		service.save("event.updateApproval", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] event_ids, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (event_ids == null || event_ids.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("event_ids", event_ids);
		service.save("event.updateDelete", paramMap);

		jo.put("success", true);
		return jo;
	}

}