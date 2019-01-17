package kr.go.culture.event.web;

import java.util.Collection;
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
@RequestMapping("/event/luckybag")
public class LuckyBagController {

	@Autowired
	private CkDatabaseService ckService;
	
	@RequestMapping("/user/list.do")
	public String userList(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		modelMap.addAttribute("count", ckService.readForObject("luckybag.user.listCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("luckybag.user.list", paramMap));
		
		return "event/luckyBag/user/list";
	}
	
	@RequestMapping("/user/view.do")
	public String userView(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		if(paramMap.containsKey("user_id")) {
			modelMap.addAttribute("entryDateList", ckService.readForList("luckybag.user.entryDateList", paramMap));
			modelMap.addAttribute("view", ckService.readForObject("luckybag.user.view", paramMap));
		}
		
		return "event/luckyBag/user/view";
	}
	
	@RequestMapping("/user/excelDown.do")
	public String userExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"이름", "아이디", "이메일", "휴대폰번호", "응모횟수", "응모일"};
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("luckybag.user.excelList", paramMap);
				
		modelMap.addAttribute("fileNm", "luckybag_user_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);		
		return "excelView";
	}

	@RequestMapping(value="/user/winnerLotPopup.do", method=RequestMethod.GET)
	public String winnerPopup(ModelMap modelMap) throws Exception {	
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("event_cd", "001");
		List<Object> winnerList = ckService.readForList("event.winner.list", paramMap);
		modelMap.addAttribute("winnerList", winnerList);
		return "event/luckyBag/user/winnerLotPopup";
	}
	
	@RequestMapping(value="/user/winnerLotPopup.do", method=RequestMethod.POST)
	public String winnerPopupPost(ModelMap modelMap) throws Exception {
		
		String eventCd = "001";
		
		List<Object> entryList = ckService.readForList("luckybag.user.entryList", null);
		Collections.shuffle(entryList);
		
		int lotNum = (int) (Math.random() * entryList.size());
		
		Map<String, Object> winner = (Map<String, Object>) entryList.get(lotNum);
		
		winner.put("event_cd", eventCd);
		ckService.insert("event.winner.insert", winner);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("event_cd", eventCd);
		List<Object> winnerList = ckService.readForList("event.winner.list", paramMap);
		modelMap.addAttribute("winnerList", winnerList);
		
		return "redirect:/event/luckybag/user/winnerLotPopup.do";
	}
	
	@RequestMapping(value="/user/winnerDelete.do", method=RequestMethod.POST)
	public String winnerDelete(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("event_cd", "001");
		ckService.delete("event.winner.delete", paramMap);
		return "redirect:/event/luckybag/user/winnerLotPopup.do";
	}
	
}
