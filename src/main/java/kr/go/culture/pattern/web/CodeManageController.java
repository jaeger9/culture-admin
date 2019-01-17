package kr.go.culture.pattern.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.pattern.service.CodeManageDeleteService;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@RequestMapping("/pattern/code/manage")
@Controller("CodeManageController")
public class CodeManageController {

	private static final Logger logger = LoggerFactory
			.getLogger(CodeManageController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "CodeManageDeleteService")
	private CodeManageDeleteService codeManageDeleteService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		
		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject(
				"code.manage.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("code.manage.list", paramMap));

		return "/pattern/code/manage/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("cded_code") && paramMap.containsKey("cded_pcde")) {
			model.addAttribute("view", ckDatabaseService.readForObject(
					"code.manage.view", paramMap));
		}
		
		model.addAttribute("codeList", ckDatabaseService.readForList(
				"code.manage.categoryList", paramMap));
		
		return "/pattern/code/manage/view";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model , HttpSession session)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("admin_id", session.getAttribute("admin_id"));

		ckDatabaseService.insert("code.manage.insert", paramMap);

		SessionMessage.insert(request);
		
		return "redirect:/pattern/code/manage/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model,
			RedirectAttributes redirectAttributes) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("code.manage.update", paramMap);
		
		redirectAttributes.addFlashAttribute("paramMap", paramMap);
		
		SessionMessage.update(request);
		
		return "redirect:/pattern/code/manage/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model,
			RedirectAttributes redirectAttributes) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		codeManageDeleteService.delete(paramMap);
		
		SessionMessage.delete(request);
		
		return "redirect:/pattern/code/manage/list.do";
	}
	
	@RequestMapping("codeOverlapCheck.do")
	public @ResponseBody JSONObject codePverlapCheck(HttpServletRequest request ) throws Exception  {

		ParamMap paramMap = new ParamMap(request);
		JSONObject result = new JSONObject();

		try {
//			("CDED_PCDE", "CDED_CODE")
			result.put("codeCnt" ,ckDatabaseService.readForObject("code.manage.codeCnt", paramMap));
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			result.put("codeCnt", 0);
		}
	
		return result;
	}
}
