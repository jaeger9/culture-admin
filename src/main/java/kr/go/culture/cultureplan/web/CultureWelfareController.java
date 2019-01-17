package kr.go.culture.cultureplan.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

@RequestMapping("/cultureplan/cultureWelfare")
@Controller("CultureWelfareController")
public class CultureWelfareController {
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	/**
	 * 문화복지혜택 목록
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("gubun", "W");	//문화복지혜택
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("culture_welfare.cultureWelfareListCnt", paramMap));
		model.addAttribute("list",	ckDatabaseService.readForList("culture_welfare.cultureWelfareList", paramMap));
		
		return "/cultureplan/cultureWelfare/list";
	}
	
	/** 문화복지혜택 상세
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("gubun", "W");	//문화복지혜택

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("seq")) {
			model.addAttribute("view", ckDatabaseService.readForObject("culture_welfare.cultureWelfareView", paramMap));
		}

		return "/cultureplan/cultureWelfare/view";
	}
	
	/**
	 * 문화사업 목록
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("enterpriseList.do")
	public String enterpriseList(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("gubun", "E");	//문화사업
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("culture_welfare.cultureWelfareListCnt", paramMap));
		model.addAttribute("list",	ckDatabaseService.readForList("culture_welfare.cultureWelfareList", paramMap));
		
		return "/cultureplan/cultureWelfare/list";
	}
	
	/** 문화사업 상세
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("enterpriseView.do")
	public String enterpriseView(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("gubun", "E");	//문화사업

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("seq")) {
			model.addAttribute("view", ckDatabaseService.readForObject("culture_welfare.cultureWelfareView", paramMap));
		}

		return "/cultureplan/cultureWelfare/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("culture_welfare.statusUpdate", paramMap);

		if(paramMap.get("gubun").equals("W")){
			return "forward:/cultureplan/cultureWelfare/list.do";
		}else{
			return "forward:/cultureplan/cultureWelfare/enterpriseList.do";
		}
	}
	
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.insert("culture_welfare.insert", paramMap);

		if(paramMap.get("gubun").equals("W")){
			return "forward:/cultureplan/cultureWelfare/list.do";
		}else{
			return "forward:/cultureplan/cultureWelfare/enterpriseList.do";
		}
	}

	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("culture_welfare.update", paramMap);
		
		if(paramMap.get("gubun").equals("W")){
			return "forward:/cultureplan/cultureWelfare/list.do";
		}else{
			return "forward:/cultureplan/cultureWelfare/enterpriseList.do";
		}
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("culture_welfare.delete", paramMap);

		if(paramMap.get("gubun").equals("W")){
			return "forward:/cultureplan/cultureWelfare/list.do";
		}else{
			return "forward:/cultureplan/cultureWelfare/enterpriseList.do";
		}
	}

}
