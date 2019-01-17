package kr.go.culture.pattern.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.pattern.service.ApplyDesignInsertService;
import kr.go.culture.pattern.service.ApplyDesignUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

//전통문양 활용 - 제품디자인
@RequestMapping("/pattern/apply/design")
@Controller("ApplyProductDesignController")
public class ApplyProductDesignController {

	private static final Logger logger = LoggerFactory.getLogger(ApplyProductDesignController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "ApplyDesignInsertService")
	private ApplyDesignInsertService applyDesignInsertService;
	
	@Resource(name = "ApplyDesignUpdateService")
	private ApplyDesignUpdateService applyDesignUpdateService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		
		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject(
				"apply.design.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("apply.design.list", paramMap));

		return "/pattern/apply/design/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("seq")) {
			model.addAttribute("view", ckDatabaseService.readForObject(
					"apply.design.view", paramMap));
		}
		
		paramMap.put("common_code_type", "DESIGN_GUBUN");
		model.addAttribute("categoryList", ckDatabaseService.readForList("common.codeList", paramMap));
		
		return "/pattern/apply/design/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("apply.design.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/pattern/apply/design/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.delete("apply.design.delete", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
	
		SessionMessage.delete(request);
		
		return "redirect:/pattern/apply/design/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model , @RequestParam("uploadFile") MultipartFile[] multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		applyDesignInsertService.insert(paramMap , multi );
		
		SessionMessage.insert(request);
		
		return "redirect:/pattern/apply/design/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model , @RequestParam("uploadFile") MultipartFile[] multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		applyDesignUpdateService.update(paramMap , multi );
		
		SessionMessage.update(request);
		
		return "redirect:/pattern/apply/design/list.do";
	}
}
