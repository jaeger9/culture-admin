package kr.go.culture.festival.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;


//@RequestMapping("/festival/education")
//@Controller("EducationController")
public class EducationController_old {
	private static final Logger logger = LoggerFactory.getLogger(EventController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		//나중에 enum 이던 property 던 빼라...
		paramMap.put("type", new String[]{"49"});
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("officeList" , ckDatabaseService.readForList("show.officeList", paramMap));
		model.addAttribute("count",
				(Integer) ckDatabaseService.readForObject("education.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("education.list", paramMap));

		return "/festival/education/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("common_code_type", "LOCATION");
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("locationList", ckDatabaseService.readForList("common.codeList", paramMap));
		
		if (paramMap.containsKey("uci"))
			model.addAttribute("view",
					ckDatabaseService.readForObject("education.view", paramMap));

		return "/festival/education/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("education.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/festival/education/list.do";
	}

	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			//이것도 어디 밖아두고 써라 나중에..
			paramMap.put("type", "49");
			
			ckDatabaseService.insert("education.insert", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);
		
		return "redirect:/festival/education/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("education.update", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);
		
		return "redirect:/festival/education/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.delete("education.delete", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.delete(request);
		
		return "redirect:/festival/education/list.do";
	}
}
