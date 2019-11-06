package kr.go.culture.perform.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.perform.service.RelayGroupInsertService;
import kr.go.culture.perform.service.RelayGroupUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@RequestMapping("/perform/relay/group/")
@Controller("RelayGroupController")
public class RelayGroupController {

	private static final Logger logger = LoggerFactory.getLogger(RelayGroupController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "RelayGroupInsertService")
	private RelayGroupInsertService relayGroupInsertService;
	
	@Resource(name = "RelayGroupUpdateService")
	private RelayGroupUpdateService relayGroupUpdateService;

	@Resource(name = "FileService")
	private FileService fileService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("relay_gourp.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("relay_gourp.list", paramMap));

//		return "/perform/relay/group/list";
		return "thymeleaf/perform/relay/group/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		
		if (paramMap.containsKey("seq")) 
			model.addAttribute("view",ckDatabaseService.readForObject("relay_gourp.view", paramMap));
		
		return "/perform/relay/group/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("relay_gourp.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/perform/relay/group/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request , ModelMap model ,  @RequestParam("uploadFile") MultipartFile multi)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		relayGroupInsertService.insert(paramMap, multi);

		SessionMessage.insert(request);
		
		return "redirect:/perform/relay/group/list.do";
	}

	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model,
			RedirectAttributes redirectAttributes) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.delete("relay_gourp.delete", paramMap);
		
		SessionMessage.delete(request);
		
		return "redirect:/perform/relay/group/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request , ModelMap model ,  @RequestParam("uploadFile") MultipartFile multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		//이미지 삭제기능 추가
		if (paramMap.containsKey("imagedelete")) {
			fileService.deleteFile("relay", paramMap.getString("file_delete"));
		}

		relayGroupUpdateService.update(paramMap, multi);
		
		SessionMessage.update(request);
		
		return "redirect:/perform/relay/group/list.do";
	}
}
