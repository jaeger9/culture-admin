package kr.go.culture.magazine.web;

import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.util.CommonUtil;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.magazine.service.MagazineMobileUpdateService;

@RequestMapping("/magazine/culturemedia")
@Controller("CultureMediaController")
public class CultureMediaController {

	private static final Logger logger = LoggerFactory.getLogger(CultureAgreeController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	@Resource(name = "FileService")
	private FileService fileService;
	
	@Resource(name = "MagazineMobileUpdateService")
	private MagazineMobileUpdateService magazineMobileUpdateService;
	
	/**
	 * 문화TV 촬영신청 목록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("del_yn", CommonUtil.nullStr(request.getParameter("del_yn"), "N"));

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("culturemedia.listCnt", paramMap));
		model.addAttribute("list", ckDatabaseService.readForList("culturemedia.list", paramMap));
		
		return "/magazine/culturemedia/list";
	}
	
	/**
	 * 카드 뉴스 컨텐츠 상세
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		modelMap.addAttribute("paramMap", paramMap);
		
		ParamMap tmpMap = new ParamMap();
		tmpMap.put("common_code_type", "PHONE");
		modelMap.addAttribute("phoneList", ckDatabaseService.readForList("common.codeList", tmpMap));
		
		
		if (paramMap.containsKey("tv_seq")) {
			modelMap.addAttribute("view", ckDatabaseService.readForObject("culturemedia.view", paramMap));

			//파일 목록
			/*
			 * modelMap.addAttribute("listFile",
			 * ckDatabaseService.readForList("culturemedia.listFile", paramMap));
			 */		}
		
		return "/magazine/culturemedia/view";
	}
	
	/**
	 * 카드 뉴스 컨텐츠 등록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		ckDatabaseService.insert("culturemedia.insert",paramMap);
		/*
		 * int card_news_seq = (Integer) ckDatabaseService.insert("culturemedia.insert",
		 * paramMap);
		 * 
		 * String file_names[] = request.getParameterValues("file_name"); String
		 * descriptions[] = request.getParameterValues("description"); int cnt = 1;
		 * for(int i=0; i < file_names.length; i++){ if( !file_names[i].isEmpty() &&
		 * file_names[i].length() > 0 ){ HashMap<String , Object> param = new
		 * HashMap<String, Object>(); param.put("card_news_seq", card_news_seq);
		 * param.put("seq_num", cnt); param.put("file_name", file_names[i]);
		 * param.put("description", descriptions[i]); param.put("reg_id",
		 * request.getSession().getAttribute("admin_id"));
		 * 
		 * ckDatabaseService.insert("culturemedia.insertFile", param); cnt++; } }
		 */
		
		SessionMessage.insert(request);
		
		return "redirect:/magazine/culturemedia/list.do";
	}	
	
	/**
	 * 카드 뉴스 컨텐츠 수정
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		
		
//		magazineMobileUpdateService.Mupdate(paramMap);
		
		ckDatabaseService.insert("culturemedia.update", paramMap);
		
		/*
		 * //이미지 삭제기능 추가 if (paramMap.containsKey("file_delete")) { String
		 * file_deletes[] = request.getParameterValues("file_delete"); for(int i=0; i <
		 * file_deletes.length; i++){ fileService.deleteFile("culturemedia",
		 * file_deletes[i]); fileService.deleteFile("culturemediaThumb",
		 * file_deletes[i]); } }
		 */
		
		//파일 수정
		/*
		 * ckDatabaseService.insert("culturemedia.deleteFile", paramMap);
		 * 
		 * int card_news_seq = Integer.parseInt(request.getParameter("seq")); String
		 * file_names[] = request.getParameterValues("file_name"); String descriptions[]
		 * = request.getParameterValues("description"); int cnt = 1; for(int i=0; i <
		 * file_names.length; i++){ if( !file_names[i].isEmpty() &&
		 * file_names[i].length() > 0 ){ HashMap<String , Object> param = new
		 * HashMap<String, Object>(); param.put("card_news_seq", card_news_seq);
		 * param.put("seq_num", cnt); param.put("file_name", file_names[i]);
		 * param.put("description", descriptions[i]); param.put("reg_id",
		 * request.getSession().getAttribute("admin_id"));
		 * 
		 * ckDatabaseService.insert("culturemedia.insertFile", param); cnt++; } }
		 */

		modelMap.addAttribute("paramMap", paramMap);
		SessionMessage.update(request);
		
		return "redirect:/magazine/culturemedia/list.do";
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
		ckDatabaseService.save("culturemedia.statusUpdate", paramMap);

		SessionMessage.update(request);
		
		return "forward:/magazine/culturemedia/list.do";
	}
	
	/**
	 * 카드 뉴스 컨텐츠 삭제
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		ckDatabaseService.delete("culturemedia.delete", paramMap);

		SessionMessage.delete(request);

		return "redirect:/magazine/culturemedia/list.do";
	}
	
}
