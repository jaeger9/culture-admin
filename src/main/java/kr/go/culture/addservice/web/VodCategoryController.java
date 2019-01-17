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

@RequestMapping("/addservice/vodCategory")
@Controller
public class VodCategoryController {

	private static final Logger logger = LoggerFactory.getLogger(VodCategoryController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("vodCategory.count", paramMap));
		model.addAttribute("list", service.readForList("vodCategory.list", paramMap));

		ParamMap categoryParam = new ParamMap();
		categoryParam.put("vcm_depth", "1");
		model.addAttribute("listByVodCode", service.readForList("vod.listByVodCode", categoryParam));

		return "/addservice/vodCategory/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		// vcm_code가 null이 아닌 경우 조회해서 없을 경우 존재하지 않는 글
		if (paramMap.isNotBlank("vcm_code")) {
			resultMap = (CommonModel) service.readForObject("vodCategory.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/vodCategory/list.do";
			}
		} else {
			SessionMessage.empty(request);
			return "redirect:/addservice/vodCategory/list.do";
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		ParamMap categoryParam = new ParamMap();
		categoryParam.put("vcm_depth", "1");
		model.addAttribute("listByVodCode", service.readForList("vod.listByVodCode", categoryParam));

		return "/addservice/vodCategory/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		paramMap.put("vcm_upd_name", request.getSession().getAttribute("admin_id"));

		if (paramMap.isNotBlank("vcm_code")) {
			resultMap = (CommonModel) service.readForObject("vodCategory.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/vodCategory/list.do";
			}

			// update
			service.save("vodCategory.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			// service.insert("vodCategory.insert", paramMap);
			// SessionMessage.insert(request);
			SessionMessage.empty(request);
			return "redirect:/addservice/vodCategory/list.do";
		}

		return "redirect:/addservice/vodCategory/form.do?vcm_code=" + paramMap.getString("vcm_code") + "&qs=" + paramMap.getQREnc();
	}

	@RequestMapping(value = "/approval.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject approval(String[] vcm_codes, String vcm_status, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (vcm_codes == null || vcm_codes.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("vcm_status", "Y".equals(vcm_status) ? "0" : "1");
		paramMap.putArray("vcm_codes", vcm_codes);
		service.save("vodCategory.updateApproval", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] vcm_codes, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (vcm_codes == null || vcm_codes.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("vcm_codes", vcm_codes);
		service.delete("vodCategory.delete", paramMap);

		jo.put("success", true);
		return jo;
	}

}