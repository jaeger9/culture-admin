package kr.go.culture.pattern.web;

import java.util.LinkedHashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.DateUtil;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.pattern.service.MarkUseAskDeleteService;
import kr.go.culture.pattern.service.MarkUseAskInsertService;
import kr.go.culture.pattern.service.MarkUseAskUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/pattern/ask")
@Controller("MarkUseAskController")
public class MarkUseAskController {

	private static final Logger logger = LoggerFactory.getLogger(DBCategoryController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	@Resource(name = "MarkUseAskInsertService")
	private MarkUseAskInsertService markUseAskInsertService;
	
	@Resource(name = "MarkUseAskUpdateService")
	private MarkUseAskUpdateService markUseAskUpdateService;
	
	@Resource(name = "MarkUseAskDeleteService")
	private MarkUseAskDeleteService markUseAskDeleteService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		
		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject(
				"ask.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("ask.list", paramMap));

		return "/pattern/askuse/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("seq")) {
			model.addAttribute("view", ckDatabaseService.readForObject("ask.view", paramMap));
			model.addAttribute("useMarkList", ckDatabaseService.readForList("ask.useMarkList", paramMap));
		}
		
		paramMap.put("common_code_type", "EMAIL");
		model.addAttribute("emailList", ckDatabaseService.readForList("common.codeList", paramMap));
		
		paramMap.put("common_code_type", "PHONE");
		model.addAttribute("phoneList", ckDatabaseService.readForList("common.codeList", paramMap));
		
		paramMap.put("common_code_type", "AREA_TELNUM");
		model.addAttribute("areaTelNumList", ckDatabaseService.readForList("common.codeList", paramMap));
		
		paramMap.put("common_code_type", "PATTERN_GUBUN");
		model.addAttribute("patternGubunList", ckDatabaseService.readForList("common.codeListSort", paramMap));
		
		return "/pattern/askuse/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("ask.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/pattern/ask/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		markUseAskInsertService.insert(paramMap);
		
		SessionMessage.insert(request);
		
		return "redirect:/pattern/ask/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		markUseAskUpdateService.update(paramMap);
		
		SessionMessage.update(request);
		
		return "redirect:/pattern/ask/list.do";
	}

	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		markUseAskDeleteService.delete(paramMap);
		
		SessionMessage.delete(request);
		
		return "redirect:/pattern/ask/list.do";
	}
	
	@RequestMapping("excelDownload.do")
	public String excelDownload(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"No.", "신청일자", "승인일자", "승인여부", "신청자", "연락처(휴대폰)", "이메일", "해당데이터", "분류", "콘텐츠 사용옹도(이용목적)"};

		List<LinkedHashMap<String, Object>> list = ckDatabaseService.readForLinkedList("ask.excelList", paramMap);
				
		model.addAttribute("fileNm", "pattrnAsk_"+DateUtil.getDateTime("YMD"));
		model.addAttribute("headerArr", headerArr);
		model.addAttribute("excelList", list);		
		return "excelView";
	}
	
	@RequestMapping("excelDownload2.do")
	public String excelDownload2(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"신청일자", "신청자", "건수"};

		List<LinkedHashMap<String, Object>> list = ckDatabaseService.readForLinkedList("ask.excelList2", paramMap);
				
		model.addAttribute("fileNm", "pattrnAskCount_"+DateUtil.getDateTime("YMD"));
		model.addAttribute("headerArr", headerArr);
		model.addAttribute("excelList", list);		
		return "excelView";
	}
}
