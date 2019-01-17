package kr.go.culture.pattern.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.pattern.service.DBUseDesignDeleteService;
import kr.go.culture.pattern.service.DBUseDesignInsertService;
import kr.go.culture.pattern.service.DBUseDesignUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/pattern/db/design")
@Controller("DBUseDesignController")
public class DBUseDesignController {

	private static final Logger logger = LoggerFactory.getLogger(DBCategoryController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "DBUseDesignInsertService")
	private DBUseDesignInsertService dbUseDesignInsertService;
	
	@Resource(name = "DBUseDesignUpdateService")
	private DBUseDesignUpdateService dbUseDesignUpdateService;
	
	@Resource(name = "DBUseDesignDeleteService")
	private DBUseDesignDeleteService dbUseDesignDeleteService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		
		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject(
				"db.design.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("db.design.list", paramMap));

		return "/pattern/db/design/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("usec_upid")) {
			model.addAttribute("view", ckDatabaseService.readForObject(
					"db.design.viewUse", paramMap));
			
			String usec_ctid = ckDatabaseService.readForList("db.design.viewUpct", paramMap).toString();
			
			usec_ctid = usec_ctid.replace("[", "");
			usec_ctid = usec_ctid.replace("]", "");
			
			model.addAttribute("usec_ctid", usec_ctid);			
		}

		return "/pattern/db/design/view";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model , @RequestParam("uploadFile") MultipartFile[] multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		dbUseDesignInsertService.insert(paramMap , multi );
		
		SessionMessage.insert(request);
		
		return "redirect:/pattern/db/design/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model , @RequestParam("uploadFile") MultipartFile[] multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		dbUseDesignUpdateService.update(paramMap , multi );
		
		SessionMessage.update(request);
		
		return "redirect:/pattern/db/design/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		dbUseDesignDeleteService.delete(paramMap);
		
		SessionMessage.delete(request);
		
		return "redirect:/pattern/db/design/list.do";
	}
	
}
