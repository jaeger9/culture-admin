package kr.go.culture.facility.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.facility.service.GroupInsertService;
import kr.go.culture.facility.service.GroupUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;


@RequestMapping("/facility/group/")
@Controller("GroupController")
public class GroupController {

	private static final Logger logger = LoggerFactory.getLogger(PlaceController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "GroupInsertService")
	private GroupInsertService groupInsertService;
	
	@Resource(name = "GroupUpdateService")
	private GroupUpdateService groupUpdateService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("group.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("group.list", paramMap));
		
		//문화예술단체 분류 리스트를 가져온다.
		paramMap.put("common_code_pcode", "664");
		model.addAttribute("facilityGroupTypeList", ckDatabaseService.readForList("common.codeListSort", paramMap));


//		return "/facility/group/list";
		return "thymeleaf/facility/group/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("genreList", ckDatabaseService.readForList("common.codeList", paramMap));
		
		//문화예술단체 분류 리스트를 가져온다.
		paramMap.put("common_code_pcode", "664");
		model.addAttribute("facilityGroupTypeList", ckDatabaseService.readForList("common.codeListSort", paramMap));
		
		if (paramMap.containsKey("seq"))
			model.addAttribute("view",
					ckDatabaseService.readForObject("group.view", paramMap));

//		return "/facility/group/view";
		return "thymeleaf/facility/group/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("group.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/facility/group/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request , ModelMap model ,  @RequestParam("uploadFile") MultipartFile multi) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			groupInsertService.insert(paramMap, multi);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);
		
		return "redirect:/facility/group/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request , ModelMap model ,@RequestParam("uploadFile") MultipartFile multi) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			groupUpdateService.update(paramMap, multi);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);
		
		return "redirect:/facility/group/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.delete("group.delete", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.delete(request);
		
		return "redirect:/facility/group/list.do";
	}
}
