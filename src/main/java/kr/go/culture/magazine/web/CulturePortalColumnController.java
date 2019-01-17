package kr.go.culture.magazine.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.magazine.service.CultureAgreeDeleteService;
import kr.go.culture.magazine.service.CultureAgreeInsertService;
import kr.go.culture.magazine.service.CultureAgreeUpdateService;
import kr.go.culture.magazine.service.MagazineTagsProcService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/magazine/portalcolumn")
@Controller("CulturePortalColumnController")
public class CulturePortalColumnController {

	private static final Logger logger = LoggerFactory.getLogger(CulturePortalColumnController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	@Resource(name = "CultureAgreeInsertService")
	private CultureAgreeInsertService cultureAgreeInsertService;

	@Resource(name = "CultureAgreeUpdateService")
	private CultureAgreeUpdateService cultureAgreeUpdateService;

	@Resource(name = "CultureAgreeDeleteService")
	private CultureAgreeDeleteService cultureAgreeDeleteService;

	@Resource(name = "MagazineTagsProcService")
	private MagazineTagsProcService mtmService;

	//태그내 사용될 매뉴타입 코드
	private static final String MENU_TYPE = "663";
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		//태그에 사용될 메뉴코드 추가
		paramMap.put("menuType", MENU_TYPE);
		
		if (!paramMap.containsKey("cont_type"))
			paramMap.put("cont_type", "C");

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("culture.agree.listCnt", paramMap));
		model.addAttribute("topList", ckDatabaseService.readForList("culture.agree.topList", paramMap));

		model.addAttribute("list", ckDatabaseService.readForList("culture.agree.list", paramMap));

		return "/magazine/portalcolumn/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		//태그에 사용될 메뉴코드 추가
		paramMap.put("menuType", MENU_TYPE);
		
		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("seq")) {
			model.addAttribute("view", ckDatabaseService.readForObject("culture.agree.view", paramMap));
			model.addAttribute("imgViewList", ckDatabaseService.readForList("culture.agree.imgView", paramMap));
			model.addAttribute("textViewList", ckDatabaseService.readForList("culture.agree.textView", paramMap));

			//태그명 가져오기
			model.addAttribute("tagName", mtmService.selectTagMap(paramMap));
		}

		return "/magazine/portalcolumn/view";
	}

	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("culture.agree.statusUpdate", paramMap);

		return "forward:/magazine/portalcolumn/list.do";
	}

	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model)
	/* @RequestParam("recomUploadFile") MultipartFile[] recomUploadFile) */
	throws Exception {
		ParamMap paramMap = new ParamMap(request);

		/* cultureAgreeInsertService.insert( paramMap , uploadFile , recomUploadFile); */
		cultureAgreeInsertService.insert(paramMap);

		//태그 등록 프로세스 추가
		mtmService.insertTagMap(paramMap);
		
		SessionMessage.insert(request);

		return "redirect:/magazine/portalcolumn/list.do";
	}

	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		/* @RequestParam("recomUploadFile") MultipartFile[] recomUploadFile) */
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("parent_seq", paramMap.get("seq"));
		paramMap.put("open_date", paramMap.get("reg_date").toString().replaceAll("-", ""));
		/* cultureAgreeUpdateService.update(paramMap, uploadFile, recomUploadFile); */
		cultureAgreeUpdateService.update(paramMap);

		//태그 등록 프로세스 추가
		mtmService.insertTagMap(paramMap);
		
		SessionMessage.update(request);

		return "redirect:/magazine/portalcolumn/list.do";
	}

	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		cultureAgreeDeleteService.delete(paramMap);

		//태그삭제 프로세스 추가
		mtmService.deleteTagMap(paramMap);
		
		SessionMessage.delete(request);

		return "redirect:/magazine/portalcolumn/list.do";
	}

}
