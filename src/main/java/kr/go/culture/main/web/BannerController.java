package kr.go.culture.main.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.main.service.BannerInsertService;
import kr.go.culture.main.service.BannerUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/main/banner/")
@Controller("BannerController")
public class BannerController {

/*	202	0	배너관리구분	1	MAIN_BANNER	
	701	202	이벤트 배너	3	MAIN_BANNER	
	205	202	이벤트 배너	3	MAIN_BANNER	
	206	202	홍보 배너	4	MAIN_BANNER	
	207	202	관련기관 배너	5	MAIN_BANNER	
	571	202	핫존	7	MAIN_BANNER	
	572	202	내부홍보배너	8	MAIN_BANNER	
	573	202	타기관홍보배너	9	MAIN_BANNER	*/
	private String default_menu_type = "701";
	
	private static final Logger logger = LoggerFactory.getLogger(BannerController.class);

	@Resource(name="CkDatabaseService")
	CkDatabaseService ckDatabaseService;

	@Resource(name="BannerInsertService")
	BannerInsertService bannerInsertService;
	
	@Resource(name="BannerUpdateService")
	BannerUpdateService bannerUpdateService;
	
	
	@RequestMapping("list.do")
	public String listForm(HttpServletRequest request , Model model) throws Exception { 
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			if(!paramMap.containsKey("menu_type"))paramMap.put("menu_type", default_menu_type);
				
			paramMap.put("common_code_type", "MAIN_BANNER");
			
			model.addAttribute("paramMap", paramMap);
			model.addAttribute("bannerList" ,  ckDatabaseService.readForList("common.codeListSort", paramMap));
			
			model.addAttribute("count",(Integer) ckDatabaseService.readForObject("banner.listCnt", paramMap));
			model.addAttribute("list",ckDatabaseService.readForList("banner.list", paramMap));
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return "/main/banner/list";
	}
	
	@RequestMapping("statusUpdate.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			model.addAttribute("paramMap", paramMap);
			ckDatabaseService.save("banner.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/main/banner/list.do";
	}
	
	@RequestMapping("view.do")
	public String listData(HttpServletRequest request , Model model) throws Exception { 
		
		ParamMap paramMap = new ParamMap(request);

		try {
			model.addAttribute("paramMap", paramMap);
			
			paramMap.put("common_code_type", "MAIN_BANNER");
			model.addAttribute("bannerList" ,  ckDatabaseService.readForList("common.codeListSort", paramMap));
			
			if (paramMap.containsKey("seq"))
				model.addAttribute("view",
						ckDatabaseService.readForObject("banner.view", paramMap));
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		return "/main/banner/view";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request , ModelMap model , @RequestParam("uploadFile") MultipartFile multi ) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
			bannerInsertService.insert(paramMap , multi);
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);
		
		return "redirect:/main/banner/list.do?menu_type=" + paramMap.getInt("menu_type");
	}
	
	@RequestMapping("insertMulti.do")
	public String insertMulti(HttpServletRequest request , ModelMap model , @RequestParam("tUploadFile") MultipartFile[] tMulti , @RequestParam("mUploadFile") MultipartFile[] mMulti) throws Exception { 
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			//상단배너 화면일 경우는 멀티파일 업로드를 감안해야함...
			bannerInsertService.insertMulti(paramMap, tMulti, mMulti);
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);
		
		return "redirect:/main/banner/list.do?menu_type=" + paramMap.getInt("menu_type");
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request , ModelMap model , @RequestParam("uploadFile") MultipartFile multi) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			bannerUpdateService.update(paramMap , multi);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);
		
		return "redirect:/main/banner/list.do?menu_type=" + paramMap.getInt("menu_type");
	}
	
	@RequestMapping("updateMulti.do")
	public String update(HttpServletRequest request , ModelMap model , @RequestParam("tUploadFile") MultipartFile[] tMulti , @RequestParam("mUploadFile") MultipartFile[] mMulti) throws Exception { 
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			bannerUpdateService.updateMulti(paramMap, tMulti, mMulti);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);
		
		return "redirect:/main/banner/list.do?menu_type=" + paramMap.getInt("menu_type");
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			ckDatabaseService.delete("banner.delete", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.delete(request);
		
		return "redirect:/main/banner/list.do?menu_type=" + paramMap.getInt("menu_type");
	}
}
