package kr.go.culture.main.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.main.service.AgencyCodeInsertService;
import kr.go.culture.main.service.AgencyCodeUpdateService;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/main/agencycode/")
@Controller("OrganCodeController")
public class AgencyCodeController {

	private static final Logger logger = LoggerFactory.getLogger(AgencyCodeController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "AgencyCodeInsertService")
	private AgencyCodeInsertService agencyCodeInsertService;
	
	@Resource(name = "AgencyCodeUpdateService")
	private AgencyCodeUpdateService agencyCodeUpdateService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {

			model.addAttribute("paramMap", paramMap);
			model.addAttribute("categoryList" ,  ckDatabaseService.readForList("agencycode.categoryList", paramMap));
			model.addAttribute("count",(Integer) ckDatabaseService.readForObject("agencycode.listCnt", paramMap));
			model.addAttribute("list",ckDatabaseService.readForList("agencycode.list", paramMap));
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}


		return "/main/agencycode/list";
	}

	@RequestMapping("statusUpdate.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("agencycode.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/main/agencycode/list.do";
	}
	
	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {

			model.addAttribute("categoryList" ,  ckDatabaseService.readForList("agencycode.categoryList", null));
			
			if (paramMap.containsKey("org_id"))
				model.addAttribute("view",
						ckDatabaseService.readForObject("agencycode.view", paramMap));
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		return "/main/agencycode/view";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request , ModelMap model , @RequestParam("uploadFile") MultipartFile multi) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			agencyCodeInsertService.insert(paramMap , multi);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		SessionMessage.insert(request);
		
		return "redirect:/main/agencycode/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request , ModelMap model , @RequestParam("uploadFile") MultipartFile multi) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			agencyCodeUpdateService.update(paramMap , multi);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);
		
		return "redirect:/main/agencycode/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			ckDatabaseService.delete("agencycode.delete", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		SessionMessage.delete(request);
		
		return "redirect:/main/agencycode/list.do";
	}
	
	@RequestMapping("codeOverlapCheck.do")
	public @ResponseBody JSONObject codePverlapCheck(HttpServletRequest request ) throws Exception  {

		ParamMap paramMap = new ParamMap(request);
		JSONObject result = new JSONObject();

		try {
			
			result.put("codeCnt" ,ckDatabaseService.readForObject("agencycode.codeCnt", paramMap));
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			result.put("codeCnt", 0);
		}
	
		return result;
	}
}
