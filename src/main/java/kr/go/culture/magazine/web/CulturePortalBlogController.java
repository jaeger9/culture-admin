package kr.go.culture.magazine.web;

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

@RequestMapping("/magazine/blog")
@Controller("CulturePortalBlogController")
public class CulturePortalBlogController {

	private static final Logger logger = LoggerFactory.getLogger(CulturePortalBlogController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("sortList",
				ckDatabaseService.readForList("blog.sortList", paramMap));

		model.addAttribute("topList",
				ckDatabaseService.readForList("blog.topList", paramMap));

		model.addAttribute("count", (Integer) ckDatabaseService.readForObject(
				"blog.listCnt", paramMap));

		model.addAttribute("list",
				ckDatabaseService.readForList("blog.list", paramMap));
		
		return "/magazine/blog/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		model.addAttribute("sortList",
				ckDatabaseService.readForList("blog.sortList", paramMap));
		
		if (paramMap.containsKey("seq")) { 
			model.addAttribute("view", ckDatabaseService.readForObject(
					"blog.view", paramMap));
		}

		return "/magazine/blog/view";
	}

	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("blog.statusUpdate", paramMap);

		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		return "forward:/magazine/blog/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.insert("blog.insert", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		SessionMessage.insert(request);
		
		return "redirect:/magazine/blog/list.do";
	}

	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("blog.update", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		SessionMessage.update(request);
		
		return "redirect:/magazine/blog/list.do";
	}

	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {

			ckDatabaseService.delete("blog.delete", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		SessionMessage.delete(request);
		
		return "redirect:/magazine/blog/list.do";
	}
}
