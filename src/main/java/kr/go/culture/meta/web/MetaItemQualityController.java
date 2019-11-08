package kr.go.culture.meta.web;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@RequestMapping("/meta/qualityItem")
@Controller
public class MetaItemQualityController {

	private static final Logger logger = LoggerFactory.getLogger(MetaItemQualityController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/itemQualityList.do")
	public String itemQualityList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		model.addAttribute("dataList", service.readForList("mataManager.itemQualityList", paramMap));
		model.addAttribute("paramMap", paramMap);
		//return "/meta/qualityItem/itemQualityList";
		return "thymeleaf/meta/qualityItem/itemQualityList";
	}

	@RequestMapping(value = "/itemQualityView.do", method = RequestMethod.GET)
	public String itemQualityView(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		List menuList = service.readForList("mataManager.itemQualityMenuList", paramMap);

		// 전체 메뉴 리스트 Map으로 변경
		Map menuListMap = new HashMap();
		for (int i = 0; i < menuList.size(); i++) {
			menuListMap.put(((Map) menuList.get(i)).get("COLUMN_IDX").toString(), ((Map) menuList.get(i)).get("COLUMN_NAME"));
		}

		Map itemQuality = (Map) service.readForObject("mataManager.itemQualityMenuView", paramMap);

		Map expMap = new HashMap();
		String[] expList = itemQuality.get("MARK_ITEM").toString().split(",");
		for (int i = 0; i < expList.length; i++) {
			expMap.put(new BigDecimal(expList[i]), menuListMap.get(expList[i]));
		}

		Map colMap = new HashMap();
		String[] colList = itemQuality.get("COLLECT_ITEM").toString().split(",");
		for (int i = 0; i < colList.length; i++) {
			colMap.put(new BigDecimal(colList[i]), menuListMap.get(colList[i]));
		}

		model.addAttribute("expMap", expMap);
		model.addAttribute("colMap", colMap);
		model.addAttribute("menuList", menuList);
		model.addAttribute("menuListMap", menuListMap);
		model.addAttribute("EO", itemQuality);

		model.addAttribute("paramMap", paramMap);
		return "/meta/qualityItem/itemQualityView";
	}

	@RequestMapping(value = "/itemQualityEdit.do", method = RequestMethod.GET)
	public String itemQualityEdit(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		List menuList = service.readForList("mataManager.itemQualityMenuList", paramMap);

		// 전체 메뉴 리스트 Map으로 변경
		Map menuListMap = new HashMap();
		for (int i = 0; i < menuList.size(); i++) {
			menuListMap.put(((Map) menuList.get(i)).get("COLUMN_IDX").toString(), ((Map) menuList.get(i)).get("COLUMN_NAME"));
		}

		Map itemQuality = (Map) service.readForObject("mataManager.itemQualityMenuView", paramMap);

		Map expMap = new HashMap();
		String[] expList = itemQuality.get("MARK_ITEM").toString().split(",");
		for (int i = 0; i < expList.length; i++) {
			expMap.put(new BigDecimal(expList[i]), menuListMap.get(expList[i]));
		}

		Map colMap = new HashMap();
		String[] colList = itemQuality.get("COLLECT_ITEM").toString().split(",");
		for (int i = 0; i < colList.length; i++) {
			colMap.put(new BigDecimal(colList[i]), menuListMap.get(colList[i]));
		}

		model.addAttribute("expMap", expMap);
		model.addAttribute("colMap", colMap);
		model.addAttribute("menuList", menuList);
		model.addAttribute("menuListMap", menuListMap);
		model.addAttribute("EO", itemQuality);

		model.addAttribute("paramMap", paramMap);
		return "/meta/qualityItem/itemQualityEdit";
	}

	@RequestMapping(value = "/itemQualityEdit.do", method = RequestMethod.POST)
	public String itemQualityPersist(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		service.save("mataManager.itemQualityMenuUpdate", paramMap);
		SessionMessage.update(request);

		return "redirect:/meta/qualityItem/itemQualityEdit.do?group_id=" + paramMap.getString("group_id") + "&job_id=" + paramMap.getString("job_id") + "&qs=" + paramMap.getQREnc();
	}

}