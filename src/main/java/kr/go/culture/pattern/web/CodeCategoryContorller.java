package kr.go.culture.pattern.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@RequestMapping("/pattern/code/category")
@Controller("CodeCategoryContorller")
public class CodeCategoryContorller {

	private static final Logger logger = LoggerFactory.getLogger(CodeCategoryContorller.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		
		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject(
				"code.category.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("code.category.list", paramMap));

		return "/pattern/code/category/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("cdem_code")) {
			model.addAttribute("view", ckDatabaseService.readForObject(
					"code.category.view", paramMap));
		}
		
		return "/pattern/code/category/view";
	}

	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model , HttpSession session)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("admin_id", session.getAttribute("admin_id"));
		ckDatabaseService.insert("code.category.insert", paramMap);

		SessionMessage.insert(request);
		
		return "redirect:/pattern/code/category/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model,
			RedirectAttributes redirectAttributes) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("code.category.update", paramMap);
		
		redirectAttributes.addFlashAttribute("paramMap", paramMap);
		
		SessionMessage.update(request);
		
		return "redirect:/pattern/code/category/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model,
			RedirectAttributes redirectAttributes) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.delete("code.category.delete", paramMap);
		
		SessionMessage.delete(request);
		
		return "redirect:/pattern/code/category/list.do";
	}
}
