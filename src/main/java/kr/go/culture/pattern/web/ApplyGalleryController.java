package kr.go.culture.pattern.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.pattern.service.ApplyGalleryInsertService;
import kr.go.culture.pattern.service.ApplyGalleryUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

//전통문양 활용 - 활용갤러리
@RequestMapping("/pattern/apply/gallery")
@Controller("ApplyGalleryController")
public class ApplyGalleryController {

	private static final Logger logger = LoggerFactory.getLogger(ApplyGalleryController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "ApplyGalleryInsertService")
	private ApplyGalleryInsertService applyGalleryInsertService;
	
	@Resource(name = "ApplyGalleryUpdateService")
	private ApplyGalleryUpdateService applyGalleryUpdateService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		
		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject(
				"apply.gallery.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("apply.gallery.list", paramMap));

		return "/pattern/apply/gallery/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("seq")) {
			model.addAttribute("view", ckDatabaseService.readForObject(
					"apply.gallery.view", paramMap));
		}
		
		paramMap.put("common_code_type", "DESIGN_GUBUN");
		model.addAttribute("categoryList", ckDatabaseService.readForList("common.codeList", paramMap));
		
		return "/pattern/apply/gallery/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("apply.gallery.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/pattern/apply/gallery/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.delete("apply.gallery.delete", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.delete(request);
		
		return "redirect:/pattern/apply/gallery/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model , HttpSession session , @RequestParam("uploadFile") MultipartFile multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		
		paramMap.put("admin_id", session.getAttribute("admin_id"));
		
		applyGalleryInsertService.insert(paramMap , multi );
		
		SessionMessage.insert(request);
		
		return "redirect:/pattern/apply/gallery/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model , @RequestParam("uploadFile") MultipartFile multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		applyGalleryUpdateService.update(paramMap , multi );
		
		SessionMessage.update(request);
		
		return "redirect:/pattern/apply/gallery/list.do";
	}
}
