package kr.go.culture.pattern.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.pattern.service.DBApplyContentInsertService;
import kr.go.culture.pattern.service.DBApplyContentUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/pattern/db/content")
@Controller("DBApplyContentManageController")
public class DBApplyContentManageController {

	private static final Logger logger = LoggerFactory
			.getLogger(DBCategoryController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	@Resource(name = "DBApplyContentInsertService")
	private DBApplyContentInsertService dbApplyContentInsertService;
	
	@Resource(name = "DBApplyContentUpdateService")
	private DBApplyContentUpdateService dbApplyContentUpdateService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		
		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject(
				"db.content.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("db.content.list", paramMap));
		
		model.addAttribute("codeList",
				ckDatabaseService.readForList("db.content.codeList", null));

		return "/pattern/db/content/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("ecim_ecid")) {
			model.addAttribute("view", ckDatabaseService.readForObject(
					"db.content.view", paramMap));
		}
		
		model.addAttribute("codeList",
				ckDatabaseService.readForList("db.content.codeList", null));

		return "/pattern/db/content/view";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model , @RequestParam("uploadFile") MultipartFile multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		dbApplyContentInsertService.insert(paramMap , multi );
		
		SessionMessage.insert(request);
		
		return "redirect:/pattern/db/content/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model , @RequestParam("uploadFile") MultipartFile multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		dbApplyContentUpdateService.update(paramMap , multi );
		
		SessionMessage.update(request);
		
		return "redirect:/pattern/db/content/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		ckDatabaseService.delete("db.content.delete", paramMap);
		
		SessionMessage.delete(request);
		
		return "redirect:/pattern/db/content/list.do";
	}
}
