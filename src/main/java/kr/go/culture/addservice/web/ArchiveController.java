package kr.go.culture.addservice.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.addservice.service.ArchiveService;
import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/addservice/archive")
@Controller
public class ArchiveController {

	private static final Logger logger = LoggerFactory.getLogger(ArchiveController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@Autowired
	private ArchiveService archiveService;

	// 예술자료전시관 > 아카이브관리
	@RequestMapping("/categoryListinc.do")
	@ResponseBody
	public Map<String, Object> categoryList(HttpServletRequest request, ModelMap model) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		List<Object> list = service.readForList("archive.categoryList", paramMap);
		int count = 1;

		if (list != null && list.size() > 0) {
			for (Object o : list) {
				result.put("list" + count, service.readForList("archive.subCategoryList", o));
				count++;
			}
		}

		return result;
	}

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("archive.count", paramMap));
		model.addAttribute("list", service.readForList("archive.list", paramMap));
		model.addAttribute("themeList", service.readForList("archive.themeList", null));

		return "/addservice/archive/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("acm_cls_cd")) {
			resultMap = (CommonModel) service.readForObject("archive.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/archive/list.do";
			}

			model.addAttribute("contentList", service.readForList("archive.contentList", paramMap));
			model.addAttribute("addContentList", service.readForList("archive.addContentList", paramMap));
			model.addAttribute("fileList", service.readForList("archive.fileList", paramMap));
			model.addAttribute("indexList", service.readForList("archive.indexList", paramMap));

			paramMap.put("arc_thm_id", resultMap.get("arc_thm_id"));
			model.addAttribute("mapList", service.readForList("archive.mapList", paramMap));
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);
		model.addAttribute("themeList", service.readForList("archive.themeList", null));

		return "/addservice/archive/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		paramMap.put("arc_file", null);
		paramMap.put("arc_file_sub", null);

		if (paramMap.isNotBlank("acm_cls_cd")) {
			resultMap = (CommonModel) service.readForObject("archive.view", paramMap);
		}

		if (resultMap != null) {
			// update
			service.save("archive.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("archive.insert", paramMap);
			SessionMessage.insert(request);
		}

		// 본문
		archiveService.insertContents(paramMap);

		return "redirect:/addservice/archive/form.do?acm_cls_cd=" + paramMap.getString("acm_cls_cd") + "&qs=" + paramMap.getQREnc();
	}

	@RequestMapping(value = "/approval.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject approval(String[] acm_cls_cds, String arc_status, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (acm_cls_cds == null || acm_cls_cds.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("arc_status", "0".equals(arc_status) ? "0" : "1");
		paramMap.putArray("acm_cls_cds", acm_cls_cds);
		service.save("archive.updateApproval", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] acm_cls_cds, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (acm_cls_cds == null || acm_cls_cds.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("acm_cls_cds", acm_cls_cds);

		service.delete("archive.delete", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/contentDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject contentDelete(String[] ids, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (ids == null || ids.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = null;
		String[] tmp = null;

		for (String id : ids) {
			tmp = id.split("_");

			paramMap = new ParamMap();
			paramMap.put("acm_cls_cd", tmp[0]);
			paramMap.put("act_content_cd", tmp[1]);

			service.delete("archive.deleteByContent", paramMap);
			service.delete("archive.deleteByContentSub", paramMap);
		}

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/fileDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject fileDelete(String[] ids, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (ids == null || ids.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = null;
		String[] tmp = null;

		for (String id : ids) {
			tmp = id.split("_");

			paramMap = new ParamMap();
			paramMap.put("acm_cls_cd", tmp[0]);
			paramMap.put("amd_med_cd", tmp[1]);

			service.delete("archive.deleteByFile", paramMap);
		}

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/mapDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject mapDelete(String[] ids, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (ids == null || ids.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("map_seqs", ids);

		service.delete("archive.deleteByMap", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/indexDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject indexDelete(String[] ids, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (ids == null || ids.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = null;
		String[] tmp = null;

		for (String id : ids) {
			tmp = id.split("_");

			paramMap = new ParamMap();
			paramMap.put("acm_cls_cd", tmp[0]);
			paramMap.put("idx_map_seq", tmp[1]);

			service.delete("archive.deleteByIndex", paramMap);
		}

		jo.put("success", true);
		return jo;
	}

}