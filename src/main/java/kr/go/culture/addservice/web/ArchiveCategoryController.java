package kr.go.culture.addservice.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.addservice.service.ArtContentService;
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

@RequestMapping("/addservice/archiveCategory")
@Controller
public class ArchiveCategoryController {

	private static final Logger logger = LoggerFactory.getLogger(ArchiveCategoryController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@Autowired
	private ArtContentService artContentService;

	private String setKey(ParamMap paramMap) {
		String sKey = paramMap.getString("sKey");

		if (!"mid".equals(sKey) && !"back".equals(sKey)) {
			paramMap.put("sKey", "top");
		}

		return paramMap.getString("sKey");
	}

	// 예술자료전시관 > 아카이브분류체계관리
	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		String sKey = setKey(paramMap);
		int count = 0;
		List<Object> list = null;

		if ("mid".equals(sKey)) {
			count = (Integer) service.readForObject("archiveCategory.getArchiveCategory2DptListCnt", paramMap);
			list = service.readForList("archiveCategory.getArchiveCategory2DptList", paramMap);

		} else if ("back".equals(sKey)) {
			count = (Integer) service.readForObject("archiveCategory.getArchiveCategory3DptListCnt", paramMap);
			list = service.readForList("archiveCategory.getArchiveCategory3DptList", paramMap);

		} else {
			count = (Integer) service.readForObject("archiveCategory.getArchiveCategory1DptListCnt", paramMap);
			list = service.readForList("archiveCategory.getArchiveCategory1DptList", paramMap);
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", count);
		model.addAttribute("list", list);

		return "/addservice/archiveCategory/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		String sKey = setKey(paramMap);

		if ("mid".equals(sKey)) {
			// 잘못된 접근
			if (paramMap.isBlank("arc_thm_id")) {
				SessionMessage.invalid(request);
				return "redirect:/addservice/archiveCategory/list.do";
			}

			if (paramMap.isNotBlank("mst_class")) {
				resultMap = (CommonModel) service.readForObject("archiveCategory.getArchiveCategory2DptView", paramMap);
			}

		} else if ("back".equals(sKey)) {
			// 잘못된 접근
			if (paramMap.isBlank("arc_thm_id") || paramMap.isBlank("mst_class")) {
				SessionMessage.invalid(request);
				return "redirect:/addservice/archiveCategory/list.do";
			}

			if (paramMap.isNotBlank("dtl_code")) {
				resultMap = (CommonModel) service.readForObject("archiveCategory.getArchiveCategory3DptView", paramMap);
			}

		} else {
			if (paramMap.isNotBlank("arc_thm_id")) {
				resultMap = (CommonModel) service.readForObject("archiveCategory.getArchiveCategory1DptView", paramMap);
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);
		model.addAttribute("codeList", artContentService.getCategoryList());

		return "/addservice/archiveCategory/form_" + paramMap.getString("sKey");
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		String sKey = setKey(paramMap);
		String returnParameter = null;

		if ("mid".equals(sKey)) {
			// 잘못된 접근
			if (paramMap.isBlank("arc_thm_id")) {
				SessionMessage.invalid(request);
				return "redirect:/addservice/archiveCategory/list.do";
			}

			if (paramMap.isNotBlank("mst_class")) {
				service.save("archiveCategory.updateArchiveCategory2Dpt", paramMap);
				SessionMessage.update(request);
			} else {
				service.insert("archiveCategory.insertArchiveCategory2Dpt", paramMap);
				SessionMessage.insert(request);
			}

			returnParameter = "?arc_thm_id=" + paramMap.getString("arc_thm_id") + "&mst_class=" + paramMap.getString("mst_class");

		} else if ("back".equals(sKey)) {
			// 잘못된 접근
			if (paramMap.isBlank("arc_thm_id") || paramMap.isBlank("mst_class")) {
				SessionMessage.invalid(request);
				return "redirect:/addservice/archiveCategory/list.do";
			}

			if (paramMap.isNotBlank("dtl_code")) {
				service.save("archiveCategory.updateArchiveCategory3Dpt", paramMap);
				SessionMessage.update(request);
			} else {
				service.insert("archiveCategory.insertArchiveCategory3Dpt", paramMap);
				SessionMessage.insert(request);
			}

			returnParameter = "?arc_thm_id=" + paramMap.getString("arc_thm_id") + "&mst_class=" + paramMap.getString("mst_class") + "&dtl_code=" + paramMap.getString("dtl_code");

		} else {
			if (paramMap.isNotBlank("arc_thm_id")) {
				service.save("archiveCategory.updateArchiveCategory1Dpt", paramMap);
				SessionMessage.update(request);
			} else {
				service.insert("archiveCategory.insertArchiveCategory1Dpt", paramMap);
				SessionMessage.insert(request);
			}

			returnParameter = "?arc_thm_id=" + paramMap.getString("arc_thm_id");
		}

		return "redirect:/addservice/archiveCategory/form.do" + returnParameter + "&sKey=" + paramMap.getString("sKey");
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] arc_thm_ids, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (arc_thm_ids == null || arc_thm_ids.length == 0) {
			jo.put("success", false);
			return jo;
		}

		String[] tmp = null;
		ParamMap paramMap = null;

		for (String s : arc_thm_ids) {
			tmp = s.split("_");

			if (tmp != null && tmp.length > 0) {
				paramMap = new ParamMap();

				if (tmp.length == 2) {
					paramMap.put("arc_thm_id", tmp[0]);
					paramMap.put("mst_class", tmp[1]);

					service.delete("archiveCategory.deleteArchiveCategory2Dpt", paramMap);
				} else if (tmp.length == 3) {
					paramMap.put("arc_thm_id", tmp[0]);
					paramMap.put("mst_class", tmp[1]);
					paramMap.put("dtl_code", tmp[2]);

					service.delete("archiveCategory.deleteArchiveCategory3Dpt", paramMap);
				} else {
					paramMap.put("arc_thm_id", tmp[0]);
					service.delete("archiveCategory.deleteArchiveCategory1Dpt", paramMap);
				}
			}

		}

		jo.put("success", true);
		return jo;
	}

}