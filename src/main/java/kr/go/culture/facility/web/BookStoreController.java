package kr.go.culture.facility.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;

/**
 * 시설/단체 > 서점
 */
@RequestMapping("/facility/bookStore/")
@Controller("BookStoreController")
public class BookStoreController {

	private static final Logger logger = LoggerFactory.getLogger(BookStoreController.class);
	
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("bookStore.listCnt", paramMap));
		model.addAttribute("list", ckDatabaseService.readForList("bookStore.list", paramMap));

		return "/facility/bookStore/list";
	}
	
	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("seq")) {
			model.addAttribute("view", ckDatabaseService.readForObject("bookStore.view", paramMap));
		}

		return "/facility/bookStore/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("bookStore.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/facility/bookStore/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request , ModelMap model) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			ckDatabaseService.insert("bookStore.insert", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);
		
		return "redirect:/facility/bookStore/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request , ModelMap model) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
			ckDatabaseService.save("bookStore.update", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);
		
		return "redirect:/facility/bookStore/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			ckDatabaseService.delete("bookStore.delete", paramMap);
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.delete(request);
		
		return "redirect:/facility/bookStore/list.do";
	}
	
}
