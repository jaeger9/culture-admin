package kr.go.culture.event.web;

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

@RequestMapping("/event/tour")
@Controller("TourController")
public class TourController {

	private static final Logger logger = LoggerFactory.getLogger(TourController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("common_code_type", "TOUR_LOCATION");
		paramMap.put("common_code_pcode", "615");
		model.addAttribute("locList", ckDatabaseService.readForList("common.codeList", paramMap));
		
		paramMap.put("common_code_type", "TOUR_TYPE");
		paramMap.put("common_code_pcode", "633");
		model.addAttribute("typeList", ckDatabaseService.readForList("common.codeList", paramMap));
		
		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("count",
				(Integer) ckDatabaseService.readForObject("tour.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("tour.list", paramMap));

		return "/event/tour/list";
	}
	
	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("common_code_type", "TOUR_LOCATION");
		paramMap.put("common_code_pcode", "615");
		model.addAttribute("locList", ckDatabaseService.readForList("common.codeList", paramMap));
		
		paramMap.put("common_code_type", "TOUR_TYPE");
		paramMap.put("common_code_pcode", "633");
		model.addAttribute("typeList", ckDatabaseService.readForList("common.codeList", paramMap));
		
		model.addAttribute("paramMap", paramMap);
		
		if (paramMap.containsKey("pcn_bno")) {
			model.addAttribute("view", ckDatabaseService.readForObject(
					"tour.view", paramMap));
		}

		return "/event/tour/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("tour.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/event/tour/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.insert("tour.insert", paramMap);

		SessionMessage.insert(request);
		
		return "redirect:/event/tour/list.do";
	}

	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("tour.update", paramMap);
		
		SessionMessage.update(request);
		
		return "redirect:/event/tour/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("tour.delete", paramMap);

		SessionMessage.delete(request);
		
		return "redirect:/event/tour/list.do";
	}
	
}
