package kr.go.culture.talkconcert.web;

import java.util.LinkedHashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.DateUtil;
import kr.go.culture.common.util.SessionMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/talkConcert/user")
public class TalkConcertUserController {

	@Autowired
	private CkDatabaseService ckService;
	
	/**
	 * 토크콘서트 참여자 목록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		modelMap.addAttribute("count", ckService.readForObject("talkconcert.user.listCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("talkconcert.user.list", paramMap));
		
		return "/talkconcert/user/list";
	}
	
	/**
	 * 토크콘서트 참여자 상세보기
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/view.do")
	public String view(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		if(paramMap.containsKey("user_email")) {
			modelMap.addAttribute("view", ckService.readForObject("talkconcert.user.view", paramMap));	
		}
		
		return "/talkconcert/user/view";
	}
	
	/**
	 * 토크콘서트 참여자 수정
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/update.do")
	public String update(HttpServletRequest request, ModelMap modelMap) throws Exception {		
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("admin_id", request.getSession().getAttribute("admin_id"));
		ckService.insert("talkconcert.user.update", paramMap);
		
		SessionMessage.update(request);
		
		return "redirect:/talkConcert/user/list.do";
	}
	
	/**
	 * 토크콘서트 참여자 엑셀 다운로드
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/excelDown.do")
	public String excelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"이름", "이메일", "휴대폰번호", "동반1인 포함 여부", "응모일"};		
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("talkconcert.user.excelList", paramMap);
		
		modelMap.addAttribute("fileNm", "talkconcert_user_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);
		
		return "excelView";
	}
	
}
