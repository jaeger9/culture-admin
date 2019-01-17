package kr.go.culture.main.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.main.service.SiteInsertService;
import kr.go.culture.main.service.SiteUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/main/site")
@Controller("SiteController")
public class SiteController {

	private static final Logger logger = LoggerFactory.getLogger(SiteController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "SiteInsertService")
	private SiteInsertService siteInsertService;

	@Resource(name = "SiteUpdateService")
	private SiteUpdateService siteUpdateService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count",
				(Integer) ckDatabaseService.readForObject("site.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("site.list", paramMap));

		return "/main/site/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("seq"))
			model.addAttribute("view",
					ckDatabaseService.readForObject("site.view", paramMap));

		return "/main/site/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("site.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/main/site/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request , ModelMap model , @RequestParam("uploadFile") MultipartFile multi) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);

		try {
			
			siteInsertService.insert(paramMap , multi);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);
		
		return "redirect:/main/site/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request , ModelMap model , @RequestParam("uploadFile") MultipartFile multi) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			siteUpdateService.update(paramMap , multi);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);
		
		return "redirect:/main/site/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.delete("site.delete", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.delete(request);
		
		return "redirect:/main/site/list.do";
	}
}
