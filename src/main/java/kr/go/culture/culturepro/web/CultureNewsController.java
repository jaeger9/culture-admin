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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;


@RequestMapping("/culturepro/cultureNews")
@Controller("CultureNewsController")
public class CultureNewsController {

	private static final Logger logger = LoggerFactory.getLogger(CultureNewsController.class);

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
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("cardnews.listCnt", paramMap));
		model.addAttribute("list", ckDatabaseService.readForList("cardnews.list", paramMap));
		return "/culturepro/cultureNews/list";
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
			modelMap.addAttribute("view", ckDatabaseService.readForObject("cardnews.view", paramMap));

			//파일 목록
			modelMap.addAttribute("listFile", ckDatabaseService.readForList("cardnews.listFile", paramMap));
		}
		
		return "/culturepro/cultureNews/view";
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
		
		int card_news_seq = (Integer) ckDatabaseService.insert("culturenews.insert", paramMap);		
		
		String file_names[] = request.getParameterValues("file_name");
		String descriptions[] = request.getParameterValues("description");
		int cnt = 1;
		for(int i=0; i < file_names.length; i++){
			if( !file_names[i].isEmpty() && file_names[i].length() > 0 ){				
				HashMap<String , Object> param = new HashMap<String, Object>();
				param.put("card_news_seq", card_news_seq);
				param.put("seq_num", cnt);
				param.put("file_name", file_names[i]);
				param.put("description", descriptions[i]);
				param.put("reg_id", request.getSession().getAttribute("admin_id"));
				
				ckDatabaseService.insert("cardnews.insertFile", param);
				cnt++;
			}
		}		
		
		SessionMessage.insert(request);
		
		return "redirect:/culturepro/cultureNews/list.do";
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
		
		ckDatabaseService.insert("culturenews.update", paramMap);
		
		//이미지 삭제기능 추가
		if (paramMap.containsKey("file_delete")) {
			String file_deletes[] = request.getParameterValues("file_delete");
			for(int i=0; i < file_deletes.length; i++){
				fileService.deleteFile("cardnews", file_deletes[i]);
				fileService.deleteFile("cardnewsThumb", file_deletes[i]);
			}
		}
		
		//파일 수정
		ckDatabaseService.insert("cardnews.deleteFile", paramMap);
		
		int card_news_seq = Integer.parseInt(request.getParameter("seq"));
		String file_names[] = request.getParameterValues("file_name");
		String descriptions[] = request.getParameterValues("description");
		int cnt = 1;
		for(int i=0; i < file_names.length; i++){
			if( !file_names[i].isEmpty() && file_names[i].length() > 0 ){
				HashMap<String , Object> param = new HashMap<String, Object>();
				param.put("card_news_seq", card_news_seq);
				param.put("seq_num", cnt);
				param.put("file_name", file_names[i]);
				param.put("description", descriptions[i]);
				param.put("reg_id", request.getSession().getAttribute("admin_id"));
				
				ckDatabaseService.insert("cardnews.insertFile", param);
				cnt++;
			}
		}

		modelMap.addAttribute("paramMap", paramMap);
		SessionMessage.update(request);
		
		return "redirect:/culturepro/cultureNews/view.do?seq=" + request.getParameter("seq");
	}
	
	/**
	 * 문화소식관리 컨텐츠 상태 변경 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		ckDatabaseService.save("culturenews.statusUpdate", paramMap);

		SessionMessage.update(request);
		
		return "forward:/culturepro/cultureNews/list.do";
	}
	
	
	/**
	 * 문화소식관리 컨텐츠 삭제 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		//이미지 삭제기능 추가
		List<Object> list = ckDatabaseService.readForList("cardnews.listFile", paramMap);
		if(list != null && list.size() > 0){
			for(Object obj : list){
				CommonModel cm = (CommonModel)obj;
				
				fileService.deleteFile("cardnews", (String)cm.get("file_name"));
				fileService.deleteFile("cardnewsThumb", (String)cm.get("file_name"));
			}
		}
		
		//이미지 정보 삭제 
		ckDatabaseService.insert("cardnews.deleteFile", paramMap);
				
		//문화소식관리 컨텐츠 삭제 
		ckDatabaseService.delete("cardnews.delete", paramMap);

		SessionMessage.delete(request);

		return "redirect:/culturepro/cultureNews/list.do";
	}

}
