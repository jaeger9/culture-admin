package kr.go.culture.main.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.main.service.ContentDeleteService;
import kr.go.culture.main.service.ContentInsertService;
import kr.go.culture.main.service.ContentUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/main/content/")
@Controller("ContentController")
public class ContentController {

	/*
		/구버전 하단 메뉴/	
		703  함께 즐겨요
		704  지식이 더해집니다
		705  문화포털 콘텐츠
		706  소식/교육/채용
		707  문화산업URL
	*/
	
	/*
		/2016.09.01 리뉴얼에 의한 메뉴 변경/
		750	함께 즐겨요
		751	지식이 더해집니다
		752	교육/지원사업/문화소식/채용
		753	문화사업
		707	문화산업URL	: AS-IS
		703	우측영역		: 구 함께 즐겨요
	*/
	
	//private String default_menu_type = "750"
	//문화공감
	private String default_menu_type = "1014";
	
	private static final Logger logger = LoggerFactory.getLogger(ContentController.class);
	
	@Resource(name="CkDatabaseService")
	CkDatabaseService ckDatabaseService;
	
	@Resource(name="ContentInsertService")
	ContentInsertService contentInsertService;
	
	@Resource(name="ContentUpdateService")
	ContentUpdateService contentUpdateService;

	@Resource(name="ContentDeleteService")
	ContentDeleteService contentDeleteService;
	
	/*
	* 	750	함께 즐겨요
	*	751	지식이 더해집니다
	*	752	교육/지원사업/문화소식/채용
	*	753	문화사업
	*	707	문화산업URL
	*	703	우측영역	
	*/    
	@RequestMapping("list.do")
	public String listForm(HttpServletRequest request , Model model) throws Exception { 
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			System.out.println(default_menu_type+" default_menu_typedefault_menu_type");
			if(!paramMap.containsKey("menu_type"))paramMap.put("menu_type", default_menu_type);
			
			paramMap.put("common_code_type", "MAIN_CONTENT_TAB");
			
			model.addAttribute("paramMap", paramMap);
			model.addAttribute("tabList", ckDatabaseService.readForList("common.codeListSort", paramMap));
			
			model.addAttribute("count",(Integer) ckDatabaseService.readForObject("content.listCnt", paramMap));
			model.addAttribute("list",ckDatabaseService.readForList("content.list", paramMap));
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return "/main/content/list";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			model.addAttribute("paramMap", paramMap);
			ckDatabaseService.save("content.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/main/content/list.do";
	}
	
	@RequestMapping("view.do")
	public String view(HttpServletRequest request , Model model) throws Exception { 
		
		ParamMap paramMap = new ParamMap(request);
		
		String rtnVal = "";

		List<Object> tabList = null;
		try {

			paramMap.put("common_code_type", "MAIN_CONTENT_TAB");
			tabList =  ckDatabaseService.readForList("common.codeListSort", paramMap);
			
			model.addAttribute("paramMap", paramMap);
			model.addAttribute("tabList" ,  tabList);

			

			if( "703".equals( paramMap.get("menu_type") ) ){
				//함께즐겨요
				rtnVal = "/main/content/view";
				
				//게시글 정보
				model.addAttribute("view",
						ckDatabaseService.readForObject("content.view", paramMap));
				//그룹 별 정보
				model.addAttribute("subGrpList",
						ckDatabaseService.readForList("content.subGrpList", paramMap));
				//그룹 별 로우 정보
				model.addAttribute("subList",
						ckDatabaseService.readForList("content.subList2", paramMap));
			} else if( "704".equals( paramMap.get("menu_type") ) ){
				//지식이 대해집니다.
				rtnVal = "/main/content/viewKnow";
				
				paramMap.put("common_code_type", "MAIN_CONTENT_KNOW");
				
				model.addAttribute("paramMap", paramMap);
				model.addAttribute("menuList", ckDatabaseService.readForList("common.codeListSort", paramMap));
				
				//게시글 정보
				model.addAttribute("view",
						ckDatabaseService.readForObject("content.view", paramMap));
				//그룹 별 로우 정보
				model.addAttribute("subList",
						ckDatabaseService.readForList("content.subList2", paramMap));
				
			} else if( "705".equals( paramMap.get("menu_type") ) ){
				//문화포털 콘텐츠
				rtnVal = "/main/content/viewCult";
				
				//게시글 정보
				model.addAttribute("view",
						ckDatabaseService.readForObject("content.view", paramMap));
				//그룹 별 로우 정보
				model.addAttribute("subList",
						ckDatabaseService.readForList("content.subList2", paramMap));
				
			} else if( "706".equals( paramMap.get("menu_type") ) ){
				//지식이 대해집니다.(구)
				rtnVal = "/main/content/viewNoti";
				
				paramMap.put("common_code_type", "MAIN_CONTENT_NOTICE");
				
				model.addAttribute("paramMap", paramMap);
				model.addAttribute("menuList", ckDatabaseService.readForList("common.codeListSort", paramMap));
				
				//게시글 정보
				model.addAttribute("view",
						ckDatabaseService.readForObject("content.view", paramMap));
				//그룹 별 로우 정보
				model.addAttribute("subList",
						ckDatabaseService.readForList("content.subList2", paramMap));
				
			} else if( "707".equals( paramMap.get("menu_type") ) ){
				//문화산업URL
				rtnVal = "/main/content/viewUrl";
				
				//게시글 정보
				model.addAttribute("view",
						ckDatabaseService.readForObject("content.view", paramMap));
				//그룹 별 로우 정보
				model.addAttribute("subList",
						ckDatabaseService.readForList("content.subList2", paramMap));
				
			} else if( "750".equals( paramMap.get("menu_type") ) ){
				/* 750	함께즐겨요 */				
				rtnVal = "/main/content/viewEnjoy";
				
				//게시글 정보
				model.addAttribute("view",
						ckDatabaseService.readForObject("content.view", paramMap));
				//그룹 별 정보
				model.addAttribute("subGrpList",
						ckDatabaseService.readForList("content.subGrpList", paramMap));
				//그룹 별 로우 정보
				model.addAttribute("subList",
						ckDatabaseService.readForList("content.subList2", paramMap));
				
			} else if( "751".equals( paramMap.get("menu_type") ) ){
				/* 751	지식이 더해집니다 */
				rtnVal = "/main/content/viewKnowledge";
				
				//게시글 정보
				model.addAttribute("view",
						ckDatabaseService.readForObject("content.view", paramMap));
				//그룹 별 정보
				model.addAttribute("subGrpList",
						ckDatabaseService.readForList("content.subGrpList", paramMap));
				//그룹 별 로우 정보
				model.addAttribute("subList",
						ckDatabaseService.readForList("content.subList2", paramMap));
				
			} else if( "752".equals( paramMap.get("menu_type") ) ){
				/* 752	교육/지원사업/문화소식/채용 */
				rtnVal = "/main/content/viewNotice";
				
				paramMap.put("common_code_type", "MAIN_CONTENT_NOTICE");
				
				model.addAttribute("paramMap", paramMap);
				model.addAttribute("menuList", ckDatabaseService.readForList("common.codeListSort", paramMap));
				
				//게시글 정보
				model.addAttribute("view",
						ckDatabaseService.readForObject("content.view", paramMap));
				//그룹 별 로우 정보
				model.addAttribute("subList",
						ckDatabaseService.readForList("content.subList2", paramMap));
				
			} else if( "753".equals( paramMap.get("menu_type") ) ){
				/* 753	문화사업 */
				rtnVal = "/main/content/viewEnterprise";
				
				//게시글 정보
				model.addAttribute("view",
						ckDatabaseService.readForObject("content.view", paramMap));
				//그룹 별 로우 정보
				model.addAttribute("subList",
						ckDatabaseService.readForList("content.subList2", paramMap));
				
			} else if( "1014".equals( paramMap.get("menu_type") ) ){
				/* 1014	문화공감 */				
				rtnVal = "/main/content/viewSympathy";
				
				//게시글 정보
				model.addAttribute("view",
						ckDatabaseService.readForObject("content.view", paramMap));
				//그룹 별 정보
				model.addAttribute("subGrpList",
						ckDatabaseService.readForList("content.subGrpList", paramMap));
				//그룹 별 로우 정보
				model.addAttribute("subList",
						ckDatabaseService.readForList("content.subList2", paramMap));
			}else if("1015".equals( paramMap.get("menu_type") )){
				/* 1015	문화광장 */				
				rtnVal = "/main/content/viewSquare";
				
				paramMap.put("common_code_type", "MAIN_CONTENT_NOTICE");
				
				model.addAttribute("paramMap", paramMap);
				model.addAttribute("menuList", ckDatabaseService.readForList("common.codeListSort", paramMap));
				
				//게시글 정보
				model.addAttribute("view",
						ckDatabaseService.readForObject("content.view", paramMap));
				//그룹 별 로우 정보
				model.addAttribute("subList",
						ckDatabaseService.readForList("content.subList2", paramMap));
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		return rtnVal;
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			contentDeleteService.delete(paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.delete(request);
		// return "forward:/main/content/list.do";
		return "redirect:/main/content/list.do?menu_type=" + paramMap.getString("menu_type");
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			contentInsertService.insert(paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);
		
		// return "redirect:/main/content/list.do";
		return "redirect:/main/content/list.do?menu_type=" + paramMap.getString("menu_type");
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			contentUpdateService.update(paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);
		
		// return "redirect:/main/content/list.do";
		return "redirect:/main/content/list.do?menu_type=" + paramMap.getString("menu_type");
	}
	
	@RequestMapping("insertMain.do")
	public String insertMain(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			contentInsertService.insertMain(paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);
		
		// return "redirect:/main/content/list.do";
		return "redirect:/main/content/list.do?menu_type=" + paramMap.getString("menu_type");
	}
	
	@RequestMapping("updateMain.do")
	public String updateMain(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			contentUpdateService.updateMain(paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);
		
		// return "redirect:/main/content/list.do";
		return "redirect:/main/content/list.do?menu_type=" + paramMap.getString("menu_type");
	}

	@RequestMapping("insertKnow.do")
	public String insertKnow(HttpServletRequest request, ModelMap model, @RequestParam("uploadFile") MultipartFile[] multi) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			contentInsertService.insertKnow(paramMap, multi);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);
		
		// return "redirect:/main/content/list.do";
		return "redirect:/main/content/list.do?menu_type=" + paramMap.getString("menu_type");
	}
	
	@RequestMapping("updateKnow.do")
	public String updateKnow(HttpServletRequest request, ModelMap model, @RequestParam("uploadFile") MultipartFile[] multi) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			contentUpdateService.updateKnow(paramMap, multi);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);
		
		// return "redirect:/main/content/list.do";
		return "redirect:/main/content/list.do?menu_type=" + paramMap.getString("menu_type");
	}
	
	@RequestMapping("insertMainContents.do")
	public String insertMainContents(HttpServletRequest request, ModelMap model,@RequestParam("uploadFile") MultipartFile[]multipartFiles) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			contentInsertService.insertMainContents(paramMap,multipartFiles);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);

		return "redirect:/main/content/list.do?menu_type=" + paramMap.getString("menu_type");
	}
	
	@RequestMapping("updateMainContents.do")
	public String updateMainContents(HttpServletRequest request, ModelMap model,@RequestParam("uploadFile") MultipartFile[]multipartFiles) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			contentUpdateService.updateMainContents(paramMap,multipartFiles);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);
		return "redirect:/main/content/list.do?menu_type=" + paramMap.getString("menu_type");
	}

}
