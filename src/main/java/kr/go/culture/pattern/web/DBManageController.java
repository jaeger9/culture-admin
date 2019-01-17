package kr.go.culture.pattern.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/pattern/db/manage")
@Controller("DBManageController")
public class DBManageController {

	private static final Logger logger = LoggerFactory.getLogger(DBManageController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		
		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject(
				"db.manage.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("db.manage.list", paramMap));

		return "/pattern/db/manage/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("did")) {
			model.addAttribute("view", ckDatabaseService.readForObject(
					"db.manage.view", paramMap));
		}

		return "/pattern/db/manage/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("ask.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/pattern/ask/list.do";
	}
}
