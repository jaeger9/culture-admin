package kr.go.culture.campaign.web;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.DateUtil;
import kr.go.culture.common.util.FileUploadUtil;
import kr.go.culture.common.util.SessionMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
@RequestMapping("/campaign/entry")
public class CampaignEntryController {

//	@Value("#{contextConfig['file.upload.base.location.dir']}")
	@Value(value = "${file.upload.base.location.dir:/data/culture_admin_2015}")
	private String fileUploadBaseLocaionDir;
	
	@Autowired
	private CkDatabaseService ckService;
	
	/**
	 * 문화선물캠페인 응모작 목록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		paramMap.put("use_yn", "Y");		
		modelMap.addAttribute("eventList", ckService.readForList("campaign.eventList", paramMap));
		
		modelMap.addAttribute("count", ckService.readForObject("campaign.entry.listCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("campaign.entry.list", paramMap));
		
		return "/campaign/entry/list";
	}
	
	/**
	 * 문화선물캠페인 응모작 상세
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/view.do")
	public String view(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		if(paramMap.containsKey("seq")) {
			modelMap.addAttribute("view", ckService.readForObject("campaign.entry.view", paramMap));	
		}
		
		return "/campaign/entry/view";
	}
	
	/**
	 * 문화선물캠페인 응모작 수정
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/update.do")
	public String update(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		MultipartHttpServletRequest multi = (MultipartHttpServletRequest) request;
		MultipartFile multiFile = multi.getFile("file");
		
		if(null != multiFile.getOriginalFilename() && !"".equals(multiFile.getOriginalFilename())) {
			String filePath = "/campaign/present/event"+paramMap.get("event_seq");
			Map<String, Object> uploadFileMap = new HashMap<String, Object>();
			Map<String, Object> pMap = new HashMap<String, Object>();
			pMap.put("menuType", "campaign");
			pMap.put("filePath", fileUploadBaseLocaionDir+"/upload"+filePath);
			
			uploadFileMap = FileUploadUtil.uploadFileMap(multiFile, pMap);
			paramMap.put("file_path", "upload"+filePath);
			paramMap.put("ori_file_nm", uploadFileMap.get("fileName").toString());
			paramMap.put("sys_file_nm", uploadFileMap.get("saveFileName").toString());
		}
		
		paramMap.put("admin_id", request.getSession().getAttribute("admin_id"));
		ckService.insert("campaign.entry.update", paramMap);
		
		SessionMessage.update(request);
		
		return "redirect:/campaign/entry/list.do";
	}
	
	/**
	 * 문화선물캠페인 응모작 삭제
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delete.do")
	public String delete(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		ckService.insert("campaign.entry.delete", paramMap);
		
		SessionMessage.delete(request);
		
		return "redirect/campaign/entry/list.do";
	}
	
	/**
	 * 캠페인 응모작 엑셀 다운로드
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/excelDown.do")
	public String excelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"구분", "내용", "작성자", "이메일", "휴대폰번호", "등록일", "노출여부"};
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("campaign.entry.excelList", paramMap);
				
		modelMap.addAttribute("fileNm", "campaign_entry_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);
		
		return "excelView";
	}
	
}
