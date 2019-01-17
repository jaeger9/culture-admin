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

@RequestMapping("/addservice/vod")
@Controller
public class VodController {

	private static final Logger logger = LoggerFactory.getLogger(VodController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("vod.count", paramMap));
		model.addAttribute("list", service.readForList("vod.list", paramMap));

		model.addAttribute("listByVodOrg", service.readForList("vod.listByVodOrg", null));
		model.addAttribute("listByVodCode", service.readForList("vod.listByVodCode", null));

		return "/addservice/vod/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		// tvm_seq가 null이 아닌 경우 조회해서 없을 경우 존재하지 않는 글
		if (paramMap.isNotBlank("tvm_seq")) {
			resultMap = (CommonModel) service.readForObject("vod.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/vod/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		model.addAttribute("listByVodOrg", service.readForList("vod.listByVodOrg", null));
		model.addAttribute("listByVodCode", service.readForList("vod.listByVodCode", null));

		return "/addservice/vod/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("tvm_seq")) {
			resultMap = (CommonModel) service.readForObject("vod.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/vod/list.do";
			}

			// update
			service.save("vod.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("vod.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/addservice/vod/form.do?tvm_seq=" + paramMap.getString("tvm_seq") + "&qs=" + paramMap.getQREnc();
	}

	@RequestMapping(value = "/approval.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject approval(String[] tvm_seqs, String tvm_viewflag, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (tvm_seqs == null || tvm_seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("tvm_viewflag", "Y".equals(tvm_viewflag) ? "0" : "1");
		paramMap.putArray("tvm_seqs", tvm_seqs);
		service.save("vod.updateApproval", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] tvm_seqs, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (tvm_seqs == null || tvm_seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("tvm_seqs", tvm_seqs);
		service.delete("vod.delete", paramMap);

		jo.put("success", true);
		return jo;
	}

}