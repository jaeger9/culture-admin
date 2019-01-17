package kr.go.culture.magazine.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.CommonUtil;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.festival.service.FestivalMobileUpdateService;
import kr.go.culture.magazine.service.MagazineTagsProcService;
import kr.go.culture.magazine.service.MagazineMobileUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/magazine/cultureissue")
public class CultureIssueController {

	@Autowired
	private CkDatabaseService ckService;

	@Resource(name = "MagazineTagsProcService")
	private MagazineTagsProcService mtmService;
	
	@Resource(name = "MagazineMobileUpdateService")
	private MagazineMobileUpdateService MagazineMobileUpdateService;
	
	private static final Logger logger = LoggerFactory.getLogger(CultureIssueController.class);
	
	//태그내 사용될 매뉴타입 코드
	private static final String MENU_TYPE = "1";
	
	/**
	 * 문화 이슈 컨텐츠 목록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		//태그에 사용될 메뉴코드 추가
		paramMap.put("menuType", MENU_TYPE);
		
		modelMap.addAttribute("paramMap", paramMap); 
		
		paramMap.put("del_yn", CommonUtil.nullStr(request.getParameter("del_yn"), "N"));
		
		modelMap.addAttribute("count", ckService.readForObject("culture.issue.listCnt", paramMap));
		modelMap.addAttribute("list", ckService.readForList("culture.issue.list", paramMap));
		
		modelMap.addAttribute("topList", ckService.readForList("culture.issue.topList", paramMap));
		
		modelMap.addAttribute("categoryNonePaging", ckService.readForList("culture.issue.categoryNonePaging", paramMap));
		
		return "/magazine/cultureissue/list";
	}
	
	/**
	 * 문화 이슈 컨텐츠 상세
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		//태그에 사용될 메뉴코드 추가
		paramMap.put("menuType", MENU_TYPE);
		
		modelMap.addAttribute("paramMap", paramMap);
		
		if (paramMap.containsKey("seq")) {
			modelMap.addAttribute("view", ckService.readForObject("culture.issue.view", paramMap));

			//태그명 가져오기
			modelMap.addAttribute("tagName", mtmService.selectTagMap(paramMap));
		}
		
		return "/magazine/cultureissue/view";
	}
	
	/**
	 * 문화 이슈 컨텐츠 등록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("top_yn", CommonUtil.nullStr(request.getParameter("top_yn"), "N"));
		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		
		ckService.insert("culture.issue.insert", paramMap);

		//태그 등록 프로세스 추가
		mtmService.insertTagMap(paramMap);
		
		SessionMessage.insert(request);
		
		return "redirect:/magazine/cultureissue/list.do";
	}	
	
	/**
	 * 문화 이슈 컨텐츠 수정
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("top_yn", CommonUtil.nullStr(request.getParameter("top_yn"), "N"));
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		//이미지 삭제기능 추가
		if( "Y".equals(request.getParameter("mainImageDelete")) ){
			paramMap.put("img_url", "");
		}
		
		if( "Y".equals(request.getParameter("thumbImageDelete")) ){
			paramMap.put("thumb_url", "");
		}
		
		
		//MagazineMobileUpdateService.Mupdate(paramMap);
		
		if ("Y".equals(paramMap.getString("mobile_yn"))) {
			paramMap.put("gubun", "issue");
			MagazineMobileUpdateService.Mupdate(paramMap);
		}else{
			MagazineMobileUpdateService.MdescUpdate(paramMap,"issue");
		}
		
		ckService.insert("culture.issue.update", paramMap);

		//태그 등록 프로세스 추가
		mtmService.insertTagMap(paramMap);
		
		SessionMessage.update(request);
		
		return "redirect:/magazine/cultureissue/list.do";
	}
	
	/**
	 * 문화 이슈 컨텐츠 상태 변경
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		ckService.save("culture.issue.statusUpdate", paramMap);

		SessionMessage.update(request);
		
		return "forward:/magazine/cultureissue/list.do";
	}
	
	/**
	 * 문화 이슈 컨텐츠 삭제
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		ckService.delete("culture.issue.delete", paramMap);
		
		//태그삭제 프로세스 추가
		mtmService.deleteTagMap(paramMap);

		SessionMessage.delete(request);

		return "redirect:/magazine/cultureissue/list.do";
	}

	/**
	 * 문화 이슈 카테고리 목록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("popup/categoryList.do")
	public String categoryList(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		modelMap.addAttribute("paramMap", paramMap);
		modelMap.addAttribute("count", ckService.readForObject("culture.issue.categoryListCnt", paramMap));
		modelMap.addAttribute("list", ckService.readForList("culture.issue.categoryList", paramMap));
		
		return "/magazine/cultureissue/popup/categoryList";
	}
	
	/**
	 * 문화 이슈 카테고리 상세
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("popup/categoryView.do")
	public String categoryView(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		modelMap.addAttribute("paramMap", paramMap);
		
		if (paramMap.containsKey("seq")) {
			modelMap.addAttribute("view", ckService.readForObject("culture.issue.categoryView", paramMap));
		}
		
		return "/magazine/cultureissue/popup/categoryView";
	}
	
	/**
	 * 문화 이슈 카테고리 등록
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("popup/categoryInsert.do")
	public String categoryInsert(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		ckService.insert("culture.issue.categoryInsert", paramMap);
		
		SessionMessage.insert(request);
		
		return "redirect:/magazine/cultureissue/popup/categoryList.do";		
	}
	
	/**
	 * 문화 이슈 카테고리 수정
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("popup/categoryUpdate.do")
	public String categoryUpdate(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		ckService.insert("culture.issue.categoryUpdate", paramMap);
		
		SessionMessage.update(request);
		
		return "redirect:/magazine/cultureissue/popup/categoryList.do";		
	}
	
	/**
	 * 문화 이슈 카테고리 삭제
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("popup/categoryDelete.do")
	public String categoryDelete(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		ckService.delete("culture.issue.categoryDelete", paramMap);
		
		SessionMessage.delete(request);
		
		return "redirect:/magazine/cultureissue/popup/categoryList.do";
	}
	
}
