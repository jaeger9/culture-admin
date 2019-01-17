package kr.go.culture.main.web;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@RequestMapping("/main/code/")
@Controller("CommonCodeController")
public class CommonCodeController {

	private static final Logger logger = LoggerFactory.getLogger(CommonCodeController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count",
				(Integer) service.readForObject("commoncode.listCnt", paramMap));
		model.addAttribute("list",
				service.readForList("commoncode.list", paramMap));

		return "/main/code/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		model.addAttribute("parentCodeList",
				service.readForList("commoncode.parentCodeList", null));

		if (paramMap.containsKey("code"))
			model.addAttribute("view",
					service.readForObject("commoncode.view", paramMap));

		return "/main/code/view";
	}

	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model)
			throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			service.save("commoncode.insert", paramMap);	
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		SessionMessage.insert(request);
		
		return "redirect:/main/code/list.do";
	}

	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model,
			RedirectAttributes redirectAttributes) throws Exception {
		ParamMap paramMap = new ParamMap(request);

//		service.readForObject("commoncode.del", paramMap);
		try {
			
			service.delete("commoncode.delete", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		//redirect 할때 값 넘겨주는 건데 고민 why
		redirectAttributes.addFlashAttribute("paramMap", paramMap);

		SessionMessage.update(request);
		
		return "redirect:/main/code/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model,
			RedirectAttributes redirectAttributes) throws Exception {

		ParamMap paramMap = new ParamMap(request);

		try {
		
			service.delete("commoncode.update", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		
		redirectAttributes.addFlashAttribute("paramMap", paramMap);
		
		SessionMessage.delete(request);
		
		return "redirect:/main/code/list.do";
	}
}
