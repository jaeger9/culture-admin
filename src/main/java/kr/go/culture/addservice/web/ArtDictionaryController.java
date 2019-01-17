package kr.go.culture.addservice.web;

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

@RequestMapping("/addservice/artDictionary")
@Controller
public class ArtDictionaryController {

	private static final Logger logger = LoggerFactory.getLogger(ArtDictionaryController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("artDictionary.count", paramMap));
		model.addAttribute("list", service.readForList("artDictionary.list", paramMap));

		return "/addservice/artDictionary/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("id")) {
			resultMap = (CommonModel) service.readForObject("artDictionary.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/artDictionary/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		return "/addservice/artDictionary/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("id")) {
			resultMap = (CommonModel) service.readForObject("artDictionary.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/artDictionary/list.do";
			}

			// update
			service.save("artDictionary.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("artDictionary.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/addservice/artDictionary/form.do?id=" + paramMap.getString("id") + "&qs=" + paramMap.getQREnc();
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
		service.delete("artDictionary.delete", paramMap);

		jo.put("success", true);
		return jo;
	}

}