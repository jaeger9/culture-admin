package kr.go.culture.magazine.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.CuldataDatabaseService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/magazine/column")
@Controller("ColumnController")
public class ColumnController {

	private static final Logger logger = LoggerFactory.getLogger(ColumnController.class);

	@Resource(name = "CuldataDatabaseService")
	private CuldataDatabaseService culdataDatabaseService;

	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {

			model.addAttribute("paramMap", paramMap);
			model.addAttribute("count",(Integer) culdataDatabaseService.readForObject("column.listCnt", paramMap));
			model.addAttribute("list",culdataDatabaseService.readForList("column.list", paramMap));
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}


		return "/magazine/column/list";
	}

	@RequestMapping("statusUpdate.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			culdataDatabaseService.save("column.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/magazine/column/list.do";
	}
	
	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {

			
			if (paramMap.containsKey("uci"))
				model.addAttribute("view",
						culdataDatabaseService.readForObject("column.view", paramMap));
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		return "/magazine/column/view";
	}
}
