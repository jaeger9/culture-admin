package kr.go.culture.addservice.web;

import java.util.List;

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

@RequestMapping("/addservice/archiveIndex")
@Controller
public class ArchiveIndexController {

	private static final Logger logger = LoggerFactory.getLogger(ArchiveIndexController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	// 예술자료전시관 > 아카이브색인관리
	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		List<Object> selectList = service.readForList("archiveIndex.listByCategory", paramMap);
		if (paramMap.isBlank("arc_idx_id") && selectList != null && selectList.size() > 0) {
			paramMap.put("arc_idx_id", ((CommonModel) selectList.get(0)).get("arc_idx_id"));
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("archiveIndex.count", paramMap));
		model.addAttribute("list", service.readForList("archiveIndex.list", paramMap));
		model.addAttribute("selectList", selectList);

		return "/addservice/archiveIndex/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("idx_dtl_seq")) {
			resultMap = (CommonModel) service.readForObject("archiveIndex.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/archiveIndex/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);
		model.addAttribute("selectList", service.readForList("archiveIndex.listByCategory", paramMap));

		return "/addservice/archiveIndex/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		CommonModel resultMap = null;

		if (paramMap.isNotBlank("idx_dtl_seq")) {
			resultMap = (CommonModel) service.readForObject("archiveIndex.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/archiveIndex/list.do";
			}

			// update
			service.save("archiveIndex.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("archiveIndex.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/addservice/archiveIndex/form.do?idx_dtl_seq=" + paramMap.getInt("idx_dtl_seq") + "&arc_idx_id=" + paramMap.getInt("arc_idx_id") + "&qs=" + paramMap.getQREnc();
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] idx_dtl_seqs, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (idx_dtl_seqs == null || idx_dtl_seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		String[] tmp = null;
		ParamMap paramMap = null;

		for (String s : idx_dtl_seqs) {
			tmp = s.split("_");

			if (tmp != null && tmp.length >= 2) {
				paramMap = new ParamMap();
				paramMap.put("idx_dtl_seq", tmp[0]);
				paramMap.put("arc_idx_id", tmp[1]);
				service.delete("archiveIndex.delete", paramMap);
			}
		}

		jo.put("success", true);
		return jo;
	}

}