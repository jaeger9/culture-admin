package kr.go.culture.campaign.web;

import java.util.LinkedHashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.DateUtil;
import kr.go.culture.common.util.SessionMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/campaign/comment")
public class CampaignCommentController {

	private static final Logger logger = LoggerFactory.getLogger(CampaignCommentController.class);
	
	@Autowired
	private CkDatabaseService ckService;
	
	/**
	 * 문화선물캠페인 댓글 목록
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
		
		modelMap.addAttribute("count", ckService.readForObject("campaign.comment.listCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("campaign.comment.list", paramMap));
		
		return "/campaign/comment/list";
	}
	
	/**
	 * 문화선물캠페인 댓글 상세
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
			modelMap.addAttribute("view", ckService.readForObject("campaign.comment.view", paramMap));	
		}
		
		return "/campaign/comment/view";
	}
	
	/**
	 * 문화선물캠페인 댓글 수정
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/update.do")
	public String update(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("admin_id", request.getSession().getAttribute("admin_id"));
		ckService.insert("campaign.comment.update", paramMap);
		
		SessionMessage.update(request);
		
		return "redirect:/campaign/comment/list.do";
	}
	
	/**
	 * 문화선물캠페인 댓글 삭제
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delete.do")
	public String delete(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		ckService.insert("campaign.comment.delete", paramMap);
		
		SessionMessage.delete(request);
		
		return "redirect:/campaign/comment/list.do";
	}
	
	/**
	 * 문화선물캠페인 댓글 엑셀 다운로드
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/excelDown.do")
	public String excelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"구분", "내용", "작성자", "이메일", "휴대폰번호", "등록일", "노출여부"};
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("campaign.comment.excelList", paramMap);
				
		modelMap.addAttribute("fileNm", "campaign_comment_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);
		
		return "excelView";
	}

	/**
	 * 문화선물캠페인 댓글 이벤트 당첨자 조회
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/popup/winnerList.do")
	public String winnerListPopup(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		paramMap.put("use_yn", "Y");
		modelMap.addAttribute("eventList", ckService.readForList("campaign.eventList", paramMap));		
		
		if(paramMap.containsKey("event_seq")) {		
			modelMap.addAttribute("winnerList", ckService.readForList("campaign.comment.winnerList", paramMap));
		}
		
		return "/campaign/comment/popup/winnerList";
	}
	
	/**
	 * 문화선물캠페인 댓글 이벤트 당첨자 추첨
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/popup/winnerRandomLot.do")
	public String winnerLotPopup(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		List<Object> randomLotList = ckService.readForList("campaign.comment.winnerRandomLotList", paramMap);		
		ckService.delete("campaign.comment.deleteWinner", paramMap);		
		ckService.insert("campaign.comment.insertWinner", randomLotList);
		
		return "redirect:/campaign/comment/popup/winnerList.do?event_seq="+paramMap.get("event_seq");
	}
	
}
