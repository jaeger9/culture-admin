package kr.go.culture.culturepro.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.util.CommonUtil;
import kr.go.culture.common.util.SessionMessage;


@RequestMapping("/culturepro/cultureNotice")
@Controller("CultureNoticeController")
public class CultureNoticeController {

	private static final Logger logger = LoggerFactory.getLogger(CultureNoticeController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "FileService")
	private FileService fileService;

	/**
	 * 문화소식관리 리스트
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("list.do")
	public String allList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("cultureNotice.listCnt", paramMap));
		model.addAttribute("list", ckDatabaseService.readForList("cultureNotice.list", paramMap));
		return "/culturepro/notice/list";
	}

	
	/**
	 * 문화소식관리 컨텐츠 상세
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
			modelMap.addAttribute("view", ckDatabaseService.readForObject("cultureNotice.view", paramMap));
		}
		
		return "/culturepro/notice/view";
	}
	
	/**
	 * 문화소식관리 컨텐츠 등록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("del_yn", CommonUtil.nullStr(request.getParameter("del_yn"), "N"));
		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		
		ckDatabaseService.insert("cultureNotice.insert", paramMap);		
		
		SessionMessage.insert(request);
		
		return "redirect:/culturepro/cultureNotice/list.do";
	}
	
	
	/**
	 * 문화소식관리 컨텐츠 수정
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		ckDatabaseService.insert("cultureNotice.update", paramMap);
		modelMap.addAttribute("paramMap", paramMap);
		SessionMessage.update(request);
		
		return "redirect:/culturepro/cultureNotice/view.do?seq=" + request.getParameter("seq");
	}
	
	
	/**
	 * 공지사항 삭제
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		ckDatabaseService.delete("cultureNotice.delete", paramMap);
//		modelMap.addAttribute("paramMap", paramMap);
		SessionMessage.delete(request);
		
		return "forward:/culturepro/cultureNotice/list.do";
	}
	
	/**
	 * 카드 뉴스 컨텐츠 상태 변경
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		ckDatabaseService.save("cultureNotice.statusUpdate", paramMap);

		SessionMessage.update(request);
		
		return "forward:/culturepro/cultureNotice/list.do";
	}
	

}
