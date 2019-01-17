package kr.go.culture.addservice.web;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.DateUtil;

@Controller
@RequestMapping(value="/event/offer")
public class OfferEventController {
	
	@Autowired
	private CkDatabaseService ckService;
	
	@RequestMapping("/offerList.do")
	public String offerList(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		modelMap.addAttribute("count", ckService.readForObject("offerEvent.offerListCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("offerEvent.offerList", paramMap));
		
		return "addservice/offer/offerList";
	}
	
	@RequestMapping("/offerView.do")
	public String offerView(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		if(paramMap.containsKey("seq")) {
			modelMap.addAttribute("view", ckService.readForObject("offerEvent.offerView", paramMap));
		}
		
		return "addservice/offer/offerView";
	}
	
	@RequestMapping("/commentEntry.do")
	public String commentEntry(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		modelMap.addAttribute("count", ckService.readForObject("offerEvent.commentListCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("offerEvent.commentList", paramMap));
		
		return "addservice/offer/commentList";
	}
	
	@RequestMapping("/offerExcelDown.do")
	public String offerExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"순번", "성명", "아이디", "이메일", "휴대폰번호", "제목", "분류", "현황 및 문제점", "제안 내용", "접수일"};
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("offerEvent.offerExcelList", paramMap);
				
		modelMap.addAttribute("fileNm", "offerEvent_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);		
		return "excelView";
	}
	
	@RequestMapping("/commentExcelDown.do")
	public String commentExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"순번", "성명", "휴대폰번호", "공유 URL", "등록일"};
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("offerEvent.commentExcelList", paramMap);
				
		modelMap.addAttribute("fileNm", "commentEvent_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);		
		return "excelView";
	}
	
	@RequestMapping(value="/winnerPopup.do", method=RequestMethod.GET)
	public String winnerPopupGet(HttpServletRequest request, ModelMap modelMap) throws Exception {	
		ParamMap paramMap = new ParamMap(request);

		List<Object> winnerList = ckService.readForList("offerEvent.commentWinnerList", paramMap);
		modelMap.addAttribute("winnerList", winnerList);
		return "addservice/offer/winnerPopup";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/winnerPopup.do", method=RequestMethod.POST)
	public String winnerPopupPost(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);	
		
		for(int i=0; i<20 ; i++){//당첨자20명
		
			List<Object> entryList = ckService.readForList("offerEvent.commentEntryList", paramMap);
			
			if (!entryList.isEmpty()) {
				
				Collections.shuffle(entryList);
				int lotNum = (int) (Math.random() * entryList.size());
				Map<String, Object> winner = (Map<String, Object>) entryList.get(lotNum);		
				ckService.insert("offerEvent.commentWinnerInsert", winner);
			}
		}
		
		return "redirect:/event/offer/winnerPopup.do";
	}
	
	@RequestMapping(value="/winnerDelete.do", method=RequestMethod.POST)
	public String winnerDelete(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckService.delete("offerEvent.commentWinnerDelete", paramMap);
		return "redirect:/event/offer/winnerPopup.do";
	}
}
