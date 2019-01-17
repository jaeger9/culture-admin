package kr.go.culture.knowledge.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/knowledge/gukak")
@Controller("GukakController")
public class GukakController {

	private static final Logger logger = LoggerFactory.getLogger(GukakController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("count",
				(Integer) ckDatabaseService.readForObject("gukak.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("gukak.list", paramMap));

		return "/knowledge/gukak/list";
	}
	
	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		
		if (paramMap.containsKey("seq")) {
			model.addAttribute("view", ckDatabaseService.readForObject(
					"gukak.view", paramMap));
		}

		return "/knowledge/gukak/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("gukak.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/knowledge/gukak/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.insert("gukak.insert", paramMap);
		

		return "redirect:/knowledge/gukak/list.do";
	}

	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("gukak.update", paramMap);
		
		return "redirect:/knowledge/gukak/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("gukak.delete", paramMap);

		return "redirect:/knowledge/gukak/list.do";
	}
	
}
