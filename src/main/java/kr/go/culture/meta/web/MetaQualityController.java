package kr.go.culture.meta.web;

import java.text.SimpleDateFormat;
import java.util.Date;

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

@RequestMapping("/meta/quality")
@Controller
public class MetaQualityController {

	private static final Logger logger = LoggerFactory.getLogger(MetaQualityController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	// /metaManager/metaQualityList.do
	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("dataList", service.readForList("mataManager.metaQualityList", paramMap));

//		return "/meta/quality/list";
		return "thymeleaf/meta/quality/list";
	}

	// /metaManager/metaQualityView.do
	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		SimpleDateFormat sdf = null;
		Date date = null;

		if (paramMap.isBlank("reg_start") && paramMap.isBlank("reg_end")) {
			String reg_start = null;
			String reg_end = null;

			sdf = new SimpleDateFormat("yyyy-MM-dd");
			date = new java.sql.Date(new java.util.Date().getTime());

			reg_start = sdf.format(new java.util.Date());
			paramMap.put("reg_start", reg_start);
			model.addAttribute("reg_start", reg_start);
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("EO", service.readForObject("mataManager.metaQualityView", paramMap));
		model.addAttribute("dataList", service.readForList("mataManager.statisticView", paramMap));
		model.addAttribute("rowspan", service.readForObject("mataManager.statisticRowCnt", paramMap));
		model.addAttribute("viewName", service.readForObject("mataManager.statisticViewName", paramMap));
		return "thymeleaf/meta/quality/form";
//		return "/meta/quality/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if (paramMap.isNotBlank("group_id")) {
			// update
			service.save("mataManager.metaQualityUpdate", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			SessionMessage.empty(request);
			return "redirect:/meta/quality/list.do";
		}

		return "redirect:/meta/quality/form.do?group_id=" + paramMap.getString("group_id") + "&qs=" + paramMap.getQREnc();
	}

	// /metaManager/metaStatisticList.do
	@RequestMapping("/statisticList.do")
	public String statisticList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("dataList", service.readForList("mataManager.statisticList", paramMap));

		return "/meta/quality/statisticList";
	}

	// /metaManager/metaStatisticView.do
	@RequestMapping("/statisticView.do")
	public String statisticView(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if (paramMap.isBlank("reg_start") && paramMap.isBlank("reg_end")) {
			String reg_start;
			String reg_end;

			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");

			java.sql.Date date1 = new java.sql.Date(new java.util.Date().getTime());

			reg_start = sdf.format(new java.util.Date(date1.getTime() - 7 * 1000 * 60 * 60 * 24));
			reg_end = sdf.format(new java.util.Date());

			paramMap.put("reg_start", reg_start);
			model.addAttribute("reg_start", reg_start);
			paramMap.put("reg_end", reg_end);
			model.addAttribute("reg_end", reg_end);
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("dataList", service.readForList("mataManager.statisticView", paramMap));
		model.addAttribute("rowspan", service.readForObject("mataManager.statisticRowCnt", paramMap));
		model.addAttribute("viewName", service.readForObject("mataManager.statisticViewName", paramMap));

		return "/meta/quality/statisticView";
	}

}