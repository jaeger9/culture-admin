package kr.go.culture.magazine.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.magazine.service.RecomCultureAgreeInsertService;
import kr.go.culture.magazine.service.RecomCultureAgreeUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/magazine/recom")
@Controller("RecomCultureAgreeController")
public class RecomCultureAgreeController {

	private static final Logger logger = LoggerFactory.getLogger(RecomCultureAgreeController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "RecomCultureAgreeInsertService")
	private RecomCultureAgreeInsertService recomCultureAgreeInsertService;
	
	@Resource(name = "RecomCultureAgreeUpdateService")
	private RecomCultureAgreeUpdateService recomCultureAgreeUpdateService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("menu_cd", "8");
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject(
				"theme.recomeListCnt", paramMap));

		model.addAttribute("list",
				ckDatabaseService.readForList("theme.recomeList", paramMap));

		return "/magazine/recom/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("menu_cd", "8");
		
		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("seq")) { 
			model.addAttribute("view", ckDatabaseService.readForObject(
					"theme.recomView", paramMap));
			model.addAttribute("subList", ckDatabaseService.readForList(
					"theme.recomSubList", paramMap));
		}

		return "/magazine/recom/view";
	}

	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			paramMap.put("menu_cd", "8");
			
			ckDatabaseService.save("theme.statusUpdate", paramMap);

		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		return "forward:/magazine/recom/list.do";
	}

	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			paramMap.put("menu_cd", "8");
			recomCultureAgreeInsertService.insert(paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);

		return "redirect:/magazine/recom/list.do";
	}

	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			paramMap.put("menu_cd", "8");
			recomCultureAgreeUpdateService.update(paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		SessionMessage.update(request);
		
		return "redirect:/magazine/recom/list.do";
	}

	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			paramMap.put("menu_cd", "8");
			ckDatabaseService.delete("theme.delete", paramMap);
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		SessionMessage.delete(request);
		
		return "redirect:/magazine/recom/list.do";
	}
	
}
