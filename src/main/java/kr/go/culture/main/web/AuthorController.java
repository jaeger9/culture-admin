package kr.go.culture.main.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.main.service.AuthorInsertService;
import kr.go.culture.main.service.AuthorUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/main/author/")
@Controller("AuthorController")
public class AuthorController {

	private static final Logger logger = LoggerFactory.getLogger(AuthorController.class);

	@Resource(name="CkDatabaseService")
	CkDatabaseService ckDatabaseService;

	@Resource(name="AuthorInsertService")
	AuthorInsertService authorInsertService;

	@Resource(name="AuthorUpdateService")
	AuthorUpdateService authorUpdateService;
	
	@RequestMapping("list.do")
	public String listForm(HttpServletRequest request , Model model) throws Exception { 
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
		
			paramMap.put("common_code_type", "WRITER_CD");
			
			model.addAttribute("paramMap", paramMap);
			model.addAttribute("sourceList" ,  ckDatabaseService.readForList("common.codeList", paramMap));
			model.addAttribute("count",(Integer) ckDatabaseService.readForObject("author.listCnt", paramMap));
			model.addAttribute("list",ckDatabaseService.readForList("author.list", paramMap));
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return "/main/author/list";
	}
	
	@RequestMapping("statusUpdate.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("author.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/main/author/list.do";
	}
	
	@RequestMapping("view.do")
	public String listData(HttpServletRequest request , Model model) throws Exception { 
		
		ParamMap paramMap = new ParamMap(request);

		try {

			paramMap.put("common_code_type", "WRITER_CD");
			model.addAttribute("sourceList" ,  ckDatabaseService.readForList("common.codeList", paramMap));
			
			paramMap.put("common_code_type", "WRITER_CD_DEPTH2");
			model.addAttribute("subSourceList" ,  ckDatabaseService.readForList("common.codeList", paramMap));
			
			paramMap.put("common_code_type", "EMAIL");
			model.addAttribute("mailAddressList" ,  ckDatabaseService.readForList("common.codeList", paramMap));
			
			if (paramMap.containsKey("seq"))
				model.addAttribute("view",
						ckDatabaseService.readForObject("author.view", paramMap));
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		return "/main/author/view";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request , ModelMap model , @RequestParam("uploadFile") MultipartFile multi) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			authorInsertService.insert(paramMap , multi);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);
		
		return "redirect:/main/author/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request , ModelMap model , @RequestParam("uploadFile") MultipartFile multi) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			authorUpdateService.update(paramMap , multi);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);
		
		return "redirect:/main/author/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			ckDatabaseService.delete("author.delete", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.delete(request);
		
		return "redirect:/main/author/list.do";
	}
}
