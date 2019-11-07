package kr.go.culture.common.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.main.web.SiteController;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/common/reply")
@Controller("ReplyController")
public class ReplyController {
	
	private static final Logger logger = LoggerFactory.getLogger(ReplyController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		//나중에 enum 이던 property 던 빼라...
		paramMap.put("type", new String[]{"06" , "08"});
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("rdfView", ckDatabaseService.readForObject("reply.rdfView", paramMap));
		model.addAttribute("count",
				(Integer) ckDatabaseService.readForObject("reply.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("reply.list", paramMap));

//		return "/common/reply/list";
		return "thymeleaf/common/reply/list";
	}
	
}
