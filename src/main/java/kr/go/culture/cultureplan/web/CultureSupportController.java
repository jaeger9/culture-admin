package kr.go.culture.cultureplan.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.cultureplan.service.CultureSupportDeleteService;
import kr.go.culture.cultureplan.service.CultureSupportInsertService;
import kr.go.culture.cultureplan.service.CultureSupportUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/cultureplan/culturesupport")
@Controller("CultureSupportController")
public class CultureSupportController {
	
	private static final Logger logger = LoggerFactory
			.getLogger(CultureSupportController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "CultureSupportInsertService")
	private CultureSupportInsertService cultureSupportInsertService;
	
	@Resource(name = "CultureSupportUpdateService")
	private CultureSupportUpdateService cultureSupportUpdateService;
	
	@Resource(name = "CultureSupportDeleteService")
	private CultureSupportDeleteService cultureSupportDeleteService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("originList", 
				ckDatabaseService.readForList("culture_support.originList", paramMap));
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject(
				"culture_support.cultureSupportListCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("culture_support.cultureSupportList", paramMap));
		
		return "/cultureplan/culturesupport/list";
	}
	
	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("seq")) {
			model.addAttribute("view", ckDatabaseService.readForObject(
					"culture_support.cultureSupportView", paramMap));
		}

		return "/cultureplan/culturesupport/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("menu_cd", 10);

		ckDatabaseService.save("culture_support.statusUpdate", paramMap);

		return "forward:/cultureplan/culturesupport/list.do";
	}

	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.insert("culture_support.insert", paramMap);

		return "redirect:/cultureplan/culturesupport/list.do";
	}

	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("culture_support.update", paramMap);
		
		return "redirect:/cultureplan/culturesupport/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("culture_support.delete", paramMap);

		return "redirect:/cultureplan/culturesupport/list.do";
	}
	
	@RequestMapping("recomList.do")
	public String recomList(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("menu_cd", 10);
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject(
				"culture_support.recomeListCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("culture_support.recomeList", paramMap));
		
		return "/cultureplan/culturesupport/recomList";
	}
	
	@RequestMapping("recomView.do")
	public String recomView(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("menu_cd", 10);

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("seq")) {
			model.addAttribute("view", ckDatabaseService.readForObject(
					"culture_support.recomView", paramMap));

			model.addAttribute("subList", ckDatabaseService.readForList(
					"culture_support.recomSubList", paramMap));

		}

		return "/cultureplan/culturesupport/recomView";
	}

	@RequestMapping("recomStatusUpdate.do")
	public String recomStatusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("menu_cd", 10);

		ckDatabaseService.save("culture_support.recomStatusUpdate", paramMap);

		return "forward:/cultureplan/culturesupport/recomList.do";
	}

	@RequestMapping("recomInsert.do")
	public String recomInsert(HttpServletRequest request, ModelMap model,
			@RequestParam("uploadFile") MultipartFile[] multis) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("menu_cd", 10);

		cultureSupportInsertService.recomInsert(paramMap, multis);

		return "redirect:/cultureplan/culturesupport/recomList.do";
	}

	@RequestMapping("recomUpdate.do")
	public String recomUpdate(HttpServletRequest request, ModelMap model,
			@RequestParam("uploadFile") MultipartFile[] multis) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("menu_cd", 10);

		cultureSupportUpdateService.recomUpdate(paramMap, multis);
		
		return "redirect:/cultureplan/culturesupport/recomList.do";
	}
	
	@RequestMapping("recomDelete.do")
	public String recomDelete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("menu_cd", 10);

		cultureSupportDeleteService.recomDelete(paramMap);

		return "redirect:/cultureplan/culturesupport/recomList.do";
	}

}
