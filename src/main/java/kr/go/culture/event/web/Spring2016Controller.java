package kr.go.culture.event.web;

import java.util.Collections;
import java.util.HashMap;
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
@RequestMapping(value="/event/spring2016")
public class Spring2016Controller {

	@Autowired
	private CkDatabaseService ckService;
	
	@RequestMapping("/user/list.do")
	public String userList(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		modelMap.addAttribute("count", ckService.readForObject("spring2016.user.listCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("spring2016.user.list", paramMap));
		
		return "event/spring2016/user/list";
	}
	
	@RequestMapping("/user/view.do")
	public String userView(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		if(paramMap.containsKey("user_id")) {
			modelMap.addAttribute("entryDateList", ckService.readForList("spring2016.user.entryDateList", paramMap));
			modelMap.addAttribute("view", ckService.readForObject("spring2016.user.view", paramMap));
		}
		
		return "event/spring2016/user/view";
	}
	
	@RequestMapping("/user/excelDown.do")
	public String userExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"이름", "아이디", "이메일", "휴대폰번호", "응모횟수", "응모일"};
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("spring2016.user.excelList", paramMap);
				
		modelMap.addAttribute("fileNm", "spring2016_user_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);		
		return "excelView";
	}

	@RequestMapping(value="/user/winnerLotPopup.do", method=RequestMethod.GET)
	public String winnerPopup(HttpServletRequest request, ModelMap modelMap) throws Exception {	
		ParamMap paramMap = new ParamMap(request);
		
		String eventCd = "002";
		if ("ATT".equals(paramMap.get("wtype"))) eventCd = "003";
		
		
		paramMap.put("event_cd", eventCd);
		List<Object> winnerList = ckService.readForList("event.winner.list", paramMap);
		modelMap.addAttribute("winnerList", winnerList);
		return "event/spring2016/user/winnerLotPopup";
	}
	
	@RequestMapping(value="/user/winnerLotPopup.do", method=RequestMethod.POST)
	public String winnerPopupPost(HttpServletRequest request, ModelMap modelMap) throws Exception {
		
		String eventCd = "002";
		String attEventCd = "003";
		
		ParamMap paramMap = new ParamMap(request);	
		paramMap.put("event_cd", eventCd);
		paramMap.put("att_event_cd", attEventCd);
		
		String statment = "spring2016.user.entryList";
		
		if ("ATT".equals(paramMap.get("wtype"))){
			eventCd = attEventCd;
			statment = "spring2016.user.attEntryList";
		} 
		
		List<Object> entryList = ckService.readForList(statment, paramMap);
		
		if (!entryList.isEmpty()) {
			
			Collections.shuffle(entryList);
			
			int lotNum = (int) (Math.random() * entryList.size());
			
			Map<String, Object> winner = (Map<String, Object>) entryList.get(lotNum);
			
			winner.put("event_cd", eventCd);
			ckService.insert("event.winner.insert", winner);
			
			List<Object> winnerList = ckService.readForList("event.winner.list", paramMap);
			modelMap.addAttribute("winnerList", winnerList);
			
		}
		
		return "redirect:/event/spring2016/user/winnerLotPopup.do?wtype="+paramMap.get("wtype");
	}
	
	@RequestMapping(value="/user/winnerDelete.do", method=RequestMethod.POST)
	public String winnerDelete(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		String eventCd = "002";
		if ("ATT".equals(paramMap.get("wtype"))) eventCd = "003";
		
		paramMap.put("event_cd", eventCd);
		ckService.delete("event.winner.delete", paramMap);
		return "redirect:/event/spring2016/user/winnerLotPopup.do?wtype="+paramMap.get("wtype");
	}
	
	@RequestMapping("/rumor/list.do")
	public String rumorList(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		modelMap.addAttribute("count", ckService.readForObject("spring2016.rumor.listCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("spring2016.rumor.list", paramMap));
		
		return "event/spring2016/rumor/list";
	}
	
	@RequestMapping("/rumor/excelDown.do")
	public String rumorExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"이름", "공유 URL", "휴대폰번호", "등록일"};
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("spring2016.rumor.excelList", paramMap);
				
		modelMap.addAttribute("fileNm", "rumor_user_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);		
		return "excelView";
	}

	@RequestMapping(value="/rumor/winnerLotPopup.do", method=RequestMethod.GET)
	public String rumorWinnerList(HttpServletRequest request, ModelMap modelMap) throws Exception {	
		ParamMap paramMap = new ParamMap(request);
		
		List<Object> winnerList = ckService.readForList("spring2016.rumor.winnerList", paramMap);
		
		modelMap.addAttribute("winnerList", winnerList);
		return "event/spring2016/rumor/winnerLotPopup";
	}
	
	@RequestMapping(value="/rumor/winnerLotPopup.do", method=RequestMethod.POST)
	public String rumorWinnerListPost(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);	
		
		String statment = "spring2016.rumor.entryList";
		
		List<Object> entryList = ckService.readForList(statment, paramMap);
		
		if (!entryList.isEmpty()) {
			
			Collections.shuffle(entryList);
			
			int lotNum = (int) (Math.random() * entryList.size());
			
			Map<String, Object> winner = (Map<String, Object>) entryList.get(lotNum);
			
			ckService.insert("spring2016.rumor.winnerInsert", winner);
			
			List<Object> winnerList = ckService.readForList("spring2016.rumor.winnerList", paramMap);
			modelMap.addAttribute("winnerList", winnerList);
		}
		
		return "redirect:/event/spring2016/rumor/winnerLotPopup.do";
	}
	
	@RequestMapping(value="/rumor/winnerDelete.do", method=RequestMethod.POST)
	public String rumorWinnerDelete(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckService.delete("spring2016.rumor.winnerDelete", paramMap);
		return "redirect:/event/spring2016/rumor/winnerLotPopup.do";
	}
	
	@RequestMapping("/contents/list.do")
	public String contentsList(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		if (paramMap.isBlank("order")) paramMap.put("order","DESC");
		modelMap.addAttribute("paramMap", paramMap);
		
		modelMap.addAttribute("count", ckService.readForObject("spring2016.user.contentsListCnt", paramMap));
		modelMap.addAttribute("list", ckService.readForList("spring2016.user.contentsList", paramMap));
		
		return "event/spring2016/contents/list";
	}
	
	@RequestMapping("/contents/excelDown.do")
	public String contentsExcel(HttpServletRequest request, ModelMap modelMap) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"콘텐츠구분", "콘텐츠제목", "콘텐츠URL", "좋아요횟수"};
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("spring2016.user.contentsExcelList", paramMap);
				
		modelMap.addAttribute("fileNm", "contents_excel_list_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);	
		
		return "excelView";
	}
	
}
