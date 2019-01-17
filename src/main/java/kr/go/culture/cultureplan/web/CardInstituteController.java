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

@RequestMapping("/cultureplan/cardInstitute")
@Controller("CardInstituteController")
public class CardInstituteController {

	private static final Logger logger = LoggerFactory.getLogger(CardInstituteController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("cardInstitute.listCnt", paramMap));
		model.addAttribute("list", ckDatabaseService.readForList("cardInstitute.list", paramMap));
		
		return "/cultureplan/cardInstitute/list";
	}
	
	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		if (paramMap.containsKey("seq")) {
			model.addAttribute("view", ckDatabaseService.readForObject("cardInstitute.view", paramMap));
		}

		return "/cultureplan/cardInstitute/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
			ckDatabaseService.save("cardInstitute.statusUpdate", paramMap);
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		return "forward:/cultureplan/cardInstitute/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		ckDatabaseService.insert("cardInstitute.insert", paramMap);
		
		return "redirect:/cultureplan/cardInstitute/list.do";
	}

	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		ckDatabaseService.save("cardInstitute.update", paramMap);	
		
		return "redirect:/cultureplan/cardInstitute/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		ckDatabaseService.save("cardInstitute.delete", paramMap);
		
		return "redirect:/cultureplan/cardInstitute/list.do";
	}
	
}
