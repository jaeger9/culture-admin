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

@RequestMapping("/addservice/artCopyright")
@Controller
public class ArtCopyrightController {

	private static final Logger logger = LoggerFactory.getLogger(ArtCopyrightController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	private boolean isGubun(String gubun) {
		if ("C".equals(gubun) || "A".equals(gubun) || "K".equals(gubun) || "E".equals(gubun)) {
			return true;
		}
		return false;
	}

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("artCopyright.count", paramMap));
		model.addAttribute("list", service.readForList("artCopyright.list", paramMap));

		return "/addservice/artCopyright/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		String vvm_gubun = paramMap.getString("vvm_gubun");

		if (paramMap.isNotBlank("vvm_seq") && isGubun(vvm_gubun)) {
			resultMap = (CommonModel) service.readForObject("artCopyright.view" + vvm_gubun, paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/artCopyright/list.do";
			}
		} else {
			SessionMessage.empty(request);
			return "redirect:/addservice/artCopyright/list.do";
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		return "/addservice/artCopyright/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		String vvm_gubun = paramMap.getString("vvm_gubun");

		if (paramMap.isNotBlank("vvm_seq") && isGubun(vvm_gubun)) {
			resultMap = (CommonModel) service.readForObject("artCopyright.view" + vvm_gubun, paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/artCopyright/list.do";
			}

			// update
			service.save("artCopyright.updateFileComment", paramMap);
			SessionMessage.update(request);

		} else {
			SessionMessage.empty(request);
			return "redirect:/addservice/artCopyright/list.do";
		}

		return "redirect:/addservice/artCopyright/form.do?vvm_seq=" + paramMap.getString("vvm_seq")
				+ "&vvm_gubun=" + vvm_gubun
				+ "&qs=" + paramMap.getQREnc();
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] vvm_file_seqs, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (vvm_file_seqs == null || vvm_file_seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("vvm_file_seqs", vvm_file_seqs);
		service.delete("artCopyright.deleteVliMap", paramMap);
		service.delete("artCopyright.deleteVliFile", paramMap);

		jo.put("success", true);
		return jo;
	}

}