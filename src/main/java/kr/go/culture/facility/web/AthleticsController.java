package kr.go.culture.facility.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CuldataDatabaseService;
import kr.go.culture.common.util.SessionMessage;

/**
 * 시설/단체 > 체육시설정보
 */
@RequestMapping("/facility/athletics/")
@Controller("AthleticsController")
public class AthleticsController {

	private static final Logger logger = LoggerFactory.getLogger(AthleticsController.class);
	
	
	@Resource(name = "CuldataDatabaseService")
	private CuldataDatabaseService culdataDatabaseService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) culdataDatabaseService.readForObject("athletics.listCnt", paramMap));
		model.addAttribute("list", culdataDatabaseService.readForList("athletics.list", paramMap));

		return "/facility/athletics/list";
	}
	
	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("seq")) {
			model.addAttribute("view", culdataDatabaseService.readForObject("athletics.view", paramMap));
		}

		return "/facility/athletics/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			culdataDatabaseService.save("athletics.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/facility/athletics/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request , ModelMap model) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
			if(paramMap.get("startampm") != ""){
				String starttime = paramMap.get("startampm") + " " + paramMap.get("startsi") + ":" + paramMap.get("startbun") + ":00";
				paramMap.put("starttime", starttime);
			}
			if(paramMap.get("endampm") != ""){
				String endtime = paramMap.get("endampm") + " " + paramMap.get("endsi") + ":" + paramMap.get("endbun") + ":00";
				paramMap.put("endtime", endtime);
			}			
			
			culdataDatabaseService.insert("athletics.insert", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);
		
		return "redirect:/facility/athletics/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request , ModelMap model) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
			if(paramMap.get("startampm") != ""){
				String starttime = paramMap.get("startampm") + " " + paramMap.get("startsi") + ":" + paramMap.get("startbun") + ":00";
				paramMap.put("starttime", starttime);
			}
			if(paramMap.get("endampm") != ""){
				String endtime = paramMap.get("endampm") + " " + paramMap.get("endsi") + ":" + paramMap.get("endbun") + ":00";
				paramMap.put("endtime", endtime);
			}
			culdataDatabaseService.insert("athletics.update", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);
		
		return "redirect:/facility/athletics/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			culdataDatabaseService.delete("athletics.delete", paramMap);
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.delete(request);
		
		return "redirect:/facility/athletics/list.do";
	}
}
