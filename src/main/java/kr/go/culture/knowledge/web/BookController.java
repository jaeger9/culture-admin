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

@RequestMapping("/knowledge/book")
@Controller
public class BookController {

	private static final Logger logger = LoggerFactory.getLogger(BookController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);


		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("book.count", paramMap));
		model.addAttribute("list", service.readForList("book.list", paramMap));

		return "/knowledge/book/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		// uci가 null이 아닌 경우 조회해서 없을 경우 존재하지 않는 글
		if (paramMap.isNotBlank("uci")) {
			resultMap = (CommonModel) service.readForObject("book.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/knowledge/book/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("form", resultMap);

		return "/knowledge/book/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));

		CommonModel resultMap = null;

		if (paramMap.isNotBlank("uci")) {
			resultMap = (CommonModel) service.readForObject("book.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/knowledge/book/list.do";
			}

			// update
			service.save("book.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("book.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/knowledge/book/form.do?uci=" + paramMap.getString("uci").replace("+", "%2b") + "&qs=" + paramMap.getQREnc();

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
		service.save("book.updateApproval", paramMap);

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
		service.delete("book.delete", paramMap);

		jo.put("success", true);
		return jo;
	}

}