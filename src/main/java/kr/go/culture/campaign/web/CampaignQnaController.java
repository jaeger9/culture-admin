package kr.go.culture.campaign.web;

import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/campaign/qna")
public class CampaignQnaController {

	@Autowired
	private CkDatabaseService ckService;
	
	/**
	 * 문화선물캠페인 문의하기 목록
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
		
		paramMap.put("del_yn", "N");
		modelMap.addAttribute("count", ckService.readForObject("campaign.qna.listCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("campaign.qna.list", paramMap));
		
		return "/campaign/qna/list";
	}
	
	/**
	 * 문화선물캠페인 문의하기 상세
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/view.do")
	public String view(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		paramMap.put("use_yn", "Y");
		modelMap.addAttribute("eventList", ckService.readForList("campaign.eventList", paramMap));
		
		if(paramMap.containsKey("seq")) {
			modelMap.addAttribute("view", ckService.readForObject("campaign.qna.view", paramMap));
		}
		
		return "/campaign/qna/view";
	}
	
	/**
	 * 문화선물캠페인 문의하기 수정
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/update.do")
	public String update(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("admin_id", request.getSession().getAttribute("admin_id"));
		ckService.insert("campaign.qna.update", paramMap);
		
		SessionMessage.update(request);
		
		return "redirect:/campaign/qna/list.do";
	}
	
	@RequestMapping("/reply.do")
	public String reply(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("admin_id", request.getSession().getAttribute("admin_id"));
		ckService.insert("campaign.qna.reply", paramMap);
		
		SessionMessage.update(request);
		
		return "redirect:/campaign/qna/list.do";
	}
	
	/**
	 * 문화선물캠페인 문의하기 삭제
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delete.do")
	public String delete(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		ckService.insert("campaign.qna.delete", paramMap);
		
		SessionMessage.delete(request);
		
		return "redirect:/campaign/qna/list.do";
	}
	
}
