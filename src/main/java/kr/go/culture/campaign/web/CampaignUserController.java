package kr.go.culture.campaign.web;

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
@RequestMapping("/campaign/user")
public class CampaignUserController {

	@Autowired
	private CkDatabaseService ckService;
	
	/**
	 * 문화선물캠페인 참여자 목록
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
		
		modelMap.addAttribute("count", ckService.readForObject("campaign.user.listCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("campaign.user.list", paramMap));
		
		return "/campaign/user/list";
	}

	/**
	 * 문화선물캠페인 참여자 상세
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
			modelMap.addAttribute("view", ckService.readForObject("campaign.user.view", paramMap));	
		}
		
		return "/campaign/user/view";
	}
	
	/**
	 * 문화선물캠페인 참여자 수정
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/update.do")
	public String update(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("admin_id", request.getSession().getAttribute("admin_id"));
		ckService.insert("campaign.user.update", paramMap);
		
		SessionMessage.update(request);
		
		return "redirect:/campaign/user/list.do";
	}

	@RequestMapping("/excelDown.do")
	public String excelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"구분", "이름", "이메일", "휴대폰번호", "응모작횟수", "댓글횟수", "등록일"};
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("campaign.user.excelList", paramMap);
				
		modelMap.addAttribute("fileNm", "campaign_user_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);
		
		return "excelView";
	}
	
}
