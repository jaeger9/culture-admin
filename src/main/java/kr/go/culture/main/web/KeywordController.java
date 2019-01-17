package kr.go.culture.main.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.main.service.KeywordViewService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@RequestMapping("/main/keyword")
@Controller("KeywordController")
public class KeywordController {

	private static final Logger logger = LoggerFactory.getLogger(CommonCodeController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	@Resource(name = "KeywordViewService")
	private KeywordViewService keywordViewService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count",
				(Integer) ckDatabaseService.readForObject("keyword.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("keyword.list", paramMap));

		return "/main/keyword/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("idx"))
			model.addAttribute("view",ckDatabaseService.readForList("keyword.view", paramMap));

		return "/main/keyword/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("keyword.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/main/keyword/list.do";
	}
	
	
	
	
	
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model)
			throws Exception {
		
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("keyword.insert", paramMap);

		SessionMessage.insert(request);
		
		return "redirect:/main/keyword/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			ckDatabaseService.delete("keyword.delete", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.delete(request);
		
		return "redirect:/main/keyword/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model,
			RedirectAttributes redirectAttributes) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.delete("keyword.update", paramMap);
		
		redirectAttributes.addFlashAttribute("paramMap", paramMap);
		
		SessionMessage.update(request);
		
		return "redirect:/main/keyword/list.do";
	}
}
