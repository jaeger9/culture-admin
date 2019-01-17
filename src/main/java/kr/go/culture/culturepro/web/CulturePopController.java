package kr.go.culture.culturepro.web;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.service.FileService.MenuUploadFilePath;
import kr.go.culture.common.util.SessionMessage;


@RequestMapping("/culturepro/culturePop")
@Controller("CulturePopController")
public class CulturePopController{
	
	@Resource(name = "FileService")
	private FileService fileService;
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	/**
	 * 팝업 관리
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("list.do")
	public String allList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("list", ckDatabaseService.readForList("culture_pop.list", paramMap));
		model.addAttribute("cnt", (Integer) ckDatabaseService.readForObject("culture_pop.listCnt", paramMap));
		
		return "/culturepro/culturePop/list";
	}

	
	/**
	 * 팝업 관리 상세
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		modelMap.addAttribute("paramMap", paramMap);
		if (paramMap.containsKey("seq")) {
			ckDatabaseService.insert("culture_pop.viewCnt", paramMap);
			modelMap.addAttribute("view", ckDatabaseService.readForObject("culture_pop.view", paramMap));
		}
		
		return "/culturepro/culturePop/view";
	}
	
	/**
	 * 팝업 등록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("insert.do")
	public String insert(String menu_type, HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		//String fileName = fileService.writeFile(multi, "cultureAppPop");
		
		String filePath = MenuUploadFilePath.valueOf("cultureAppPop").getMenuUploadPath();
		paramMap.put("imgUrl", filePath+paramMap.get("file_name"));
		ckDatabaseService.insert("culture_pop.insert", paramMap);		
		
		SessionMessage.insert(request);
		
		return "redirect:/culturepro/culturePop/list.do";
	}
	
	
	/**
	 * 팝업 수정
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		ckDatabaseService.insert("culture_pop.update", paramMap);
		modelMap.addAttribute("paramMap", paramMap);
		SessionMessage.update(request);
		
		return "redirect:/culturepro/culturePop/view.do?seq=" + request.getParameter("seq");
	}
	
	/**
	 * 상태변경
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		ckDatabaseService.insert("culture_pop.statusUpdate", paramMap);
		modelMap.addAttribute("paramMap", paramMap);
		SessionMessage.update(request);
		
		return "forward:/culturepro/culturePop/list.do";
	}
}
