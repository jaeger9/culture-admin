package kr.go.culture.culturepro.web;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.util.CommonUtil;
import kr.go.culture.common.util.SessionMessage;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;


@RequestMapping("/culturepro/cultureQna")
@Controller("CultureQnaController")
public class CultureQnaController{
	
	@Resource(name = "FileService")
	private FileService fileService;
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	/**
	 * 문의/제안 관리
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("list.do")
	public String allList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		List<HashMap<String, Object>> list = ckDatabaseService.readForListMap("culture_qna.list", paramMap);
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("culture_qna.listCnt", paramMap));
		model.addAttribute("list", list);
		
		return "/culturepro/cultureQna/list";
	}

	
	/**
	 * 문의/제안 관리 상세
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
			modelMap.addAttribute("view", ckDatabaseService.readForObject("culture_qna.view", paramMap));
		}
		
		return "/culturepro/cultureQna/view";
	}
	
	/**
	 * 문의/제안 등록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		ckDatabaseService.insert("culture_qna.insert", paramMap);		
		
		SessionMessage.insert(request);
		
		return "redirect:/culturepro/cultureQna/list.do";
	}
	
	/**
	 * 문의/제안 삭제
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("delete.do")
	public String delte(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		ckDatabaseService.insert("culture_qna.delete", paramMap);		
		
		SessionMessage.delete(request);
		
		return "redirect:/culturepro/cultureQna/list.do";
	}
	
	
	/**
	 * 문의/제안 수정
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		ckDatabaseService.insert("culture_qna.update", paramMap);
		modelMap.addAttribute("paramMap", paramMap);
		SessionMessage.update(request);
		
		return "redirect:/culturepro/cultureQna/view.do?seq=" + request.getParameter("seq");
	}
	
	/**
	 * 문의/제안 답변
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("comments.do")
	public String comments(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("rep_id", request.getSession().getAttribute("admin_id"));
		
		ckDatabaseService.insert("culture_qna.comments", paramMap);
		modelMap.addAttribute("paramMap", paramMap);
		SessionMessage.update(request);
		
		return "redirect:/culturepro/cultureQna/view.do?seq=" + request.getParameter("seq");
	}
}
