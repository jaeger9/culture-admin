package kr.go.culture.addservice.web;

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

@RequestMapping("/addservice/artContent")
@Controller
public class ArtContentController {

	private static final Logger logger = LoggerFactory.getLogger(ArtContentController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@Autowired
	private ArtContentService artContentService;

	// 예술지식백과 > 활용콘텐츠관리
	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("artContent.count", paramMap));
		model.addAttribute("list", service.readForList("artContent.list", paramMap));
		model.addAttribute("codeList", artContentService.getCategoryList());

		return "/addservice/artContent/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("vvm_seq")) {
			resultMap = (CommonModel) service.readForObject("artContent.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/artContent/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);
		model.addAttribute("codeList", artContentService.getCategoryList());

		return "/addservice/artContent/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("user_id", request.getSession().getAttribute("admin_id"));

		CommonModel resultMap = null;

		// ccm_type
		int count = (Integer) service.readForObject("artContent.countByCcmCode", paramMap);
		int vvmType = 0;

		if ("4".equals(paramMap.getString("tmp_depth"))) {
			vvmType = count > 0 ? 0 : 2;
		} else {
			vvmType = 1;
		}
		paramMap.put("vvm_type", vvmType);

		if (paramMap.isNotBlank("vvm_seq")) {
			resultMap = (CommonModel) service.readForObject("artContent.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/artContent/list.do";
			}

			// update
			service.save("artContent.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("artContent.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/addservice/artContent/form.do?vvm_seq=" + paramMap.getString("vvm_seq") + "&qs=" + paramMap.getQREnc();
	}

	@RequestMapping(value = "/approval.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject approval(String[] vvm_seqs, String vvm_status, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (vvm_seqs == null || vvm_seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("vvm_status", "0".equals(vvm_status) ? "0" : "1");
		paramMap.putArray("vvm_seqs", vvm_seqs);
		service.save("artContent.updateApproval", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] vvm_seqs, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (vvm_seqs == null || vvm_seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("vvm_seqs", vvm_seqs);

		service.save("artContent.updateByStatus", paramMap);
		service.delete("artContent.deleteMetMetRst", paramMap);

		jo.put("success", true);
		return jo;
	}

	// 상세 정보
	@RequestMapping(value = "/detailList.do", method = RequestMethod.GET)
	public String detailList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = artContentService.getViewDetail(paramMap);

		if (resultMap == null) {
			SessionMessage.empty(request);
			return "redirect:/addservice/artContent/list.do";
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);
		model.addAttribute("listByDetailAll", service.readForList("artContent.listByDetailAll", paramMap));

		return "/addservice/artContent/detailList";
	}

	@RequestMapping(value = "/detailDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject detailDelete(String[] vvi_seqs, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (vvi_seqs == null || vvi_seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("vvi_seqs", vvi_seqs);

		service.delete("artContent.deleteByDetail", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/detailForm.do", method = RequestMethod.GET)
	public String detailForm(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = artContentService.getViewDetail(paramMap);
		CommonModel detailMap = null;

		if (resultMap == null) {
			SessionMessage.empty(request);
			return "redirect:/addservice/artContent/list.do";
		}

		// VVM_SEQ 포함
		if (paramMap.isNotBlank("vvi_seq")) {
			detailMap = (CommonModel) service.readForObject("artContent.viewByDetail", paramMap);

			if (detailMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/artContent/detailList.do?vvm_seq=" + paramMap.getInt("vvm_seq");
			}

			model.addAttribute("viewDetail", detailMap);
			model.addAttribute("listByViewDetailContent", service.readForList("artContent.listByViewDetailContent", paramMap));
			model.addAttribute("listByViewDetailFile", service.readForList("artContent.listByViewDetailFile", paramMap));
			model.addAttribute("listByViewDetailMapping", service.readForList("artContent.listByViewDetailMapping", paramMap));
			model.addAttribute("listByViewDetailSite", service.readForList("artContent.listByViewDetailSite", paramMap));
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		return "/addservice/artContent/detailForm";
	}

	@RequestMapping(value = "/detailForm.do", method = RequestMethod.POST)
	public String detailFormRegist(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = artContentService.getViewDetail(paramMap);
		CommonModel detailMap = null;

		if (resultMap == null) {
			SessionMessage.empty(request);
			return "redirect:/addservice/artContent/list.do";
		}

		// file blob
		if (paramMap.isBlank("tmp_vvi_ole_file_path")) {
			paramMap.put("vvi_ole_file", null);
		}
		paramMap.put("vvi_ole_file", null);

		if (paramMap.isNotBlank("vvi_seq")) {
			detailMap = (CommonModel) service.readForObject("artContent.viewByDetail", paramMap);

			if (detailMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/artContent/detailList.do?vvm_seq=" + paramMap.getInt("vvm_seq");
			}

			// update
			service.save("artContent.updateByDetail", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("artContent.insertByDetail", paramMap);
			SessionMessage.insert(request);
		}

		// 본문
		artContentService.insertDetailContents(paramMap);

		return "redirect:/addservice/artContent/detailForm.do?vvm_seq=" + paramMap.getInt("vvm_seq") + "&vvi_seq=" + paramMap.getInt("vvi_seq");
	}

	// 상세 - 파일
	@RequestMapping(value = "/detailFileDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject detailFileDelete(String[] file_vmi_seqs, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (file_vmi_seqs == null || file_vmi_seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("vmi_seqs", file_vmi_seqs);

		service.delete("artContent.deleteByDetailFile", paramMap);

		jo.put("success", true);
		return jo;
	}

	// 상세 - 매핑 정보
	@RequestMapping(value = "/detailMapDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject detailMapDelete(String vvi_seq_par, String vvm_seq_par, String[] map_vvm_seqs, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (map_vvm_seqs == null || map_vvm_seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("vvi_seq_par", vvi_seq_par);
		paramMap.put("vvm_seq_par", vvm_seq_par);
		paramMap.putArray("vvm_seqs", map_vvm_seqs);

		service.delete("artContent.deleteByDetailMapping", paramMap);

		jo.put("success", true);
		return jo;
	}

	// 상세 - 사이트
	@RequestMapping(value = "/detailSiteDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject detailSiteDelete(String[] site_vru_seqs, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (site_vru_seqs == null || site_vru_seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("vru_seqs", site_vru_seqs);

		service.delete("artContent.deleteByDetailSite", paramMap);

		jo.put("success", true);
		return jo;
	}

}