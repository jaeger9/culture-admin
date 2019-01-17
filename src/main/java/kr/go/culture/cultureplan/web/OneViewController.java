package kr.go.culture.cultureplan.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/cultureplan/oneview")
@Controller("OneViewController")
public class OneViewController {

	private static final Logger logger = LoggerFactory.getLogger(OneViewController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("common_code_type", "CUL_EN_TYPE");
		paramMap.put("common_code_pcode", "609");
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("contList", ckDatabaseService.readForList("common.codeList", paramMap));
		
		model.addAttribute("count",
				(Integer) ckDatabaseService.readForObject("oneview.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("oneview.list", paramMap));

		return "/cultureplan/oneview/list";
	}
	
	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("common_code_type", "CUL_EN_TYPE");
		paramMap.put("common_code_pcode", "609");
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("contList", ckDatabaseService.readForList("common.codeList", paramMap));
		
		if (paramMap.containsKey("seq")) {
			model.addAttribute("view", ckDatabaseService.readForObject(
					"oneview.view", paramMap));
		}

		return "/cultureplan/oneview/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("oneview.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/cultureplan/oneview/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.insert("oneview.insert", paramMap);

		return "redirect:/cultureplan/oneview/list.do";
	}

	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("oneview.update", paramMap);
		
		return "redirect:/cultureplan/oneview/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("oneview.delete", paramMap);

		return "redirect:/cultureplan/oneview/list.do";
	}
	
}
