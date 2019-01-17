package kr.go.culture.festival.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.festival.service.EducationApplyStatusUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/festival/education/apply")
@Controller("EducationApplyController")
public class EducationApplyController {

	private static final Logger logger = LoggerFactory.getLogger(EventController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "EducationApplyStatusUpdateService")
	private EducationApplyStatusUpdateService educationApplyStatusUpdateService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count",
				(Integer) ckDatabaseService.readForObject("education.apply.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("education.apply.list", paramMap));

		return "/festival/education/apply/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		
		if (paramMap.containsKey("applySeq"))
			model.addAttribute("view",
					ckDatabaseService.readForObject("education.apply.view", paramMap));

		paramMap.put("common_code_type", "EMAIL");
		model.addAttribute("emailList", ckDatabaseService.readForList(
				"common.codeList", paramMap));
		
		return "/festival/education/apply/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			educationApplyStatusUpdateService.statusUpdate(paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/festival/education/apply/list.do";
	} 
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("education.apply.delete", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
	
		SessionMessage.delete(request);
		
		return "redirect:/festival/education/apply/list.do?seq=" + paramMap.getInt("seq");
	} 
}
