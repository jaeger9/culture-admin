package kr.go.culture.culturepro.web;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.util.CommonUtil;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.magazine.web.CultureAgreeController;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;


@RequestMapping("/culturepro/cultureVideo")
@Controller("CultureVideoController")
public class CultureVideoController {

	private static final Logger logger = LoggerFactory.getLogger(CultureVideoController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "FileService")
	private FileService fileService;

	/**
	 * 문화영상관리  리스트
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("list.do")
	public String allList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("cultureVideo.listCnt", paramMap));
		model.addAttribute("list", ckDatabaseService.readForList("cultureVideo.list", paramMap));
		//model.addAttribute("tvInfo", ckDatabaseService.readForObject("cultureVideo.liveTvInfo", paramMap));
		return "/culturepro/cultureVideo/list";
	}

	
	/**
	 * 문화영상관리 컨텐츠 상세
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
			modelMap.addAttribute("view", ckDatabaseService.readForObject("cultureVideo.view", paramMap));
		}
		
		return "/culturepro/cultureVideo/view";
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

		paramMap.put("u_url_img", request.getParameter("file_name"));
		paramMap.put("del_yn", CommonUtil.nullStr(request.getParameter("del_yn"), "N"));
		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));

		ckDatabaseService.insert("cultureVideo.insert", paramMap);		
		
		SessionMessage.insert(request);
		
		return "redirect:/culturepro/cultureVideo/list.do";
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
		
		String old_file_name = (String)paramMap.get("old_file_name");
		String old_file_type = (String)paramMap.get("old_file_type");
		String file_name = (String)paramMap.get("file_name");
		
		if(StringUtils.equals("D", old_file_type) && !StringUtils.equals(old_file_name, file_name)){
		// TODO 기존 이미지가 직접등록한 이미지인경우 삭제 해야됨.
			fileService.deleteFile("cultureVideo", old_file_name);
		}
		
		ckDatabaseService.insert("cultureVideo.update", paramMap);
		modelMap.addAttribute("paramMap", paramMap);
		SessionMessage.update(request);
		
		return "redirect:/culturepro/cultureVideo/view.do?seq=" + request.getParameter("seq");
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
		ckDatabaseService.save("cultureVideo.statusUpdate", paramMap);

		SessionMessage.update(request);
		
		return "forward:/culturepro/cultureVideo/list.do";
	}
	
	
	/**
	 * 문화영상관리 컨텐츠 삭제 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		//이미지 삭제 
		String old_file_name = (String)paramMap.get("old_file_name");
		String old_file_type = (String)paramMap.get("old_file_type");
		if(StringUtils.equals("D", old_file_type)){
			fileService.deleteFile("cultureVideo", old_file_name);
		}
					
		//문화영상관리 컨텐츠 삭제 
		ckDatabaseService.delete("cultureVideo.delete", paramMap);

		SessionMessage.delete(request);

		return "redirect:/culturepro/cultureNews/list.do";
	}
	
	
	/**
	 * tv live on air 업데이트
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("liveTvUpdate.do")
	public String liveTvUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		ckDatabaseService.save("cultureVideo.liveTvUpdate", paramMap);

		SessionMessage.update(request);
		
		return "redirect:/culturepro/cultureVideo/list.do";
	}

}
