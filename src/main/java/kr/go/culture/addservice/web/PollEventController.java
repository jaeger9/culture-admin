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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.go.culture.addservice.service.PollEventService;
import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.DateUtil;
import kr.go.culture.common.util.SessionMessage;
import net.sf.json.JSONObject;

@Controller
@RequestMapping(value="/addservice/pollEvent")
public class PollEventController {

	@Autowired
	private CkDatabaseService ckService;
	
	@Autowired
	private PollEventService pollEventService;

	
	/** 
	 * 2016문화초대이벤트 > 이벤트 페이지 관리 - 목록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/pollList.do")
	public String pollList(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		modelMap.addAttribute("count", ckService.readForObject("pollEvent.pollListCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("pollEvent.pollList", paramMap));
		
		return "addservice/pollEvent/pollList";
	}
	
	/** 
	 * 2016문화초대이벤트 > 이벤트 페이지 관리 - 상세
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/pollForm.do", method = RequestMethod.GET)
	public String pollForm(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultPollMap = null;
	
		if (paramMap.isNotBlank("event_seq")) {
			
			resultPollMap = pollEventService.getPoll(paramMap);
			
			if (resultPollMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/pollEvent/pollList.do";
			}
			
			model.addAttribute("view", resultPollMap);
		}
		model.addAttribute("paramMap", paramMap);
		return "addservice/pollEvent/pollForm";
	}
	
	/**
	 * 2016문화초대이벤트 > 이벤트 페이지 관리 - 등록, 수정
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/pollForm.do", method = RequestMethod.POST)
	public String pollFormPost(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if (paramMap.isNotBlank("event_seq")) {
			// update
			pollEventService.updatePollEvent(paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			pollEventService.insertPollEvent(paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/addservice/pollEvent/pollList.do";

	}
	
	/**
	 * 2016문화초대이벤트 > 이벤트 페이지 관리 - 이벤트 회차 중복체크
	 * @param event_seq
	 * @param event_number
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/eventNumberDuplCheck.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject pollNumberDuplCheck(String event_seq, String event_number, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (event_number == null) {
			jo.put("result", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		
		paramMap.put("event_seq", event_seq);
		paramMap.put("event_number", event_number);
		
		Integer cnt = (Integer) ckService.readForObject("pollEvent.pollNumberDuplCount", paramMap);
		if(cnt > 0){
			jo.put("result", false);
		}else{
			jo.put("result", true);
		}

		return jo;
	}
	
	/**
	 * 2016문화초대이벤트 > 이벤트 페이지 관리 - 이벤트 기간 중복체크
	 * @param event_seq
	 * @param poll_start_date
	 * @param poll_end_date
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/pollPeriodDuplCheck.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject pollPeriodDuplCheck(String event_seq, String poll_start_date, String poll_end_date, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (poll_start_date == null || poll_end_date == null) {
			jo.put("result", false);
			return jo;
		}

		ParamMap paramMap = null;

		paramMap = new ParamMap();
		paramMap.put("event_seq", event_seq);
		paramMap.put("poll_start_date", poll_start_date);
		paramMap.put("poll_end_date", poll_end_date);
				
		Integer cnt = (Integer) ckService.readForObject("pollEvent.pollPeriodDuplCount", paramMap);
		if(cnt > 0){
			jo.put("result", false);
		}else{
			jo.put("result", true);
		}

		return jo;
	}
	
	
	/**
	 * 2016문화초대이벤트 > 이벤트 페이지 관리 - 승인, 미승인 처리
	 * @param seqs
	 * @param approval
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/approval.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject approval(String[] seqs, String approval, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (seqs == null || seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("approval", "Y".equals(approval) ? "Y" : "N");
		paramMap.putArray("seqs", seqs);
		ckService.save("pollEvent.updateApproval", paramMap);

		jo.put("success", true);
		return jo;
	}
	
	/**
	 * 2016문화초대이벤트 > 이벤트 페이지 관리 - 이벤트 삭제
	 * @param seqs
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/pollDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject pollDelete(String[] seqs, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();
		
		ParamMap paramMap = new ParamMap();
		paramMap.putArray("seqs", seqs);
		
		boolean result = pollEventService.deletePollEvent(paramMap);

		jo.put("success", result);
		return jo;
	}
	

	/**
	 * 2016문화초대이벤트 > 투표자 조회 - 목록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/voterList.do")
	public String voterList(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		modelMap.addAttribute("count", ckService.readForObject("pollEvent.voterListCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("pollEvent.voterList", paramMap));
		
		return "addservice/pollEvent/voterList";
	}
	
	/**
	 * 2016문화초대이벤트 > 투표자 조회 - 엑셀다운로드
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/voterExcelDown.do")
	public String voterExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"순번", "회차", "성명", "휴대폰번호", "투표구분", "투표작품", "등록일"};
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("pollEvent.voterExcelList", paramMap);
				
		modelMap.addAttribute("fileNm", "voterEvent_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);		
		return "excelView";
	}
	
	/**
	 * 2016문화초대이벤트 > 투표자 조회 - 당첨자 팝업
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/pollWinnerPopup.do", method=RequestMethod.GET)
	public String pollWinnerPopup(HttpServletRequest request, ModelMap modelMap) throws Exception {	
		ParamMap paramMap = new ParamMap(request);
		
		List<Object> eventNumberList = ckService.readForList("pollEvent.eventNumberList", paramMap); //회차리스트
		modelMap.addAttribute("eventNumberList", eventNumberList);
		
		List<Object> pollTitleList = ckService.readForList("pollEvent.pollTitleList", paramMap); //투표제목리스트
		modelMap.addAttribute("pollTitleList", pollTitleList);
		
		List<Object> workTitleList = ckService.readForList("pollEvent.workTitleList", paramMap); //투표작품리스트
		modelMap.addAttribute("workTitleList", workTitleList);
		
		if(paramMap.get("work_seq") != null){
			List<Object> winnerList = ckService.readForList("pollEvent.pollWinnerList", paramMap);
			modelMap.addAttribute("winnerList", winnerList);
		}
		
		modelMap.addAttribute("paramMap", paramMap);
		
		return "addservice/pollEvent/pollWinnerPopup";
	}
	
	/**
	 * 2016문화초대이벤트 > 투표자 조회 - 당첨자 추첨
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/pollWinnerPopup.do", method=RequestMethod.POST)
	public String pollWinnerPopupPost(HttpServletRequest request, RedirectAttributes redirectAttributes) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		int max =  Integer.parseInt((String)paramMap.get("lottery_number"));				
		for(int i=0; i<max ; i++){//당첨자 max명(추첨건수)까지
		
			List<Object> list = ckService.readForList("pollEvent.pollWinnerPotentialList", paramMap);	//당첨 가능한 사람목록	
			if (!list.isEmpty()) {				
				Collections.shuffle(list);
				int lotNum = (int) (Math.random() * list.size());
				Map<String, Object> winner = (Map<String, Object>) list.get(lotNum);

				ckService.insert("pollEvent.pollWinnerInsert", winner); //당첨자 당첨테이블에 insert
			}else{
				redirectAttributes.addFlashAttribute("msg", "당첨가능한 사람이 없습니다.");
			}
		}
		
		return "redirect:/addservice/pollEvent/pollWinnerPopup.do?event_number="+paramMap.get("event_number")+"&poll_seq="+paramMap.get("poll_seq")+"&work_seq="+paramMap.get("work_seq");
	}
	
	/**
	 * 2016문화초대이벤트 > 투표자 조회 - 당첨자 삭제
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/pollWinnerDelete.do", method=RequestMethod.POST)
	public String pollWinnerDelete(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		ckService.delete("pollEvent.pollWinnerDelete", paramMap);
		return "redirect:/addservice/pollEvent/pollWinnerPopup.do?event_number="+paramMap.get("event_number")+"&poll_seq="+paramMap.get("poll_seq")+"&work_seq="+paramMap.get("work_seq");
	}
	
	/**
	 * 2016문화초대이벤트 > 투표자 조회 - 엑셀다운로드
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/pollWinnerExcelDown.do")
	public String pollWinnerExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"순번", "회차", "투표제목", "작품제목", "성명", "핸드폰번호", "투표날짜"};
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("pollEvent.pollWinnerExcelList", paramMap);
				
		modelMap.addAttribute("fileNm", "pollEvent_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);		
		return "excelView";
	}
	
	/**
	 * 2016문화초대이벤트 > 추천참여자 조회 - 목록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/recommendList.do")
	public String recommendList(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		modelMap.addAttribute("count", ckService.readForObject("pollEvent.recommendListCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("pollEvent.recommendList", paramMap));
		
		return "addservice/pollEvent/recommendList";
	}
	
	/**
	 * 2016문화초대이벤트 > 추천참여자 조회 - 엑셀다운로드
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/recommendExcelDown.do")
	public String recommendExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"순번", "참여월", "성명", "휴대폰번호", "추천 작품명", "등록일"};
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("pollEvent.recommendExcelList", paramMap);
				
		modelMap.addAttribute("fileNm", "recommendEvent_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);		
		return "excelView";
	}
	
	/**
	 * 2016문화초대이벤트 > 추천참여자 조회 - 당첨자 팝업
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/recommendWinnerPopup.do", method=RequestMethod.GET)
	public String recommendWinnerPopup(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if(paramMap.isNotBlank("entry_month")){
			List<Object> winnerList = ckService.readForList("pollEvent.recommendWinnerList", paramMap);
			modelMap.addAttribute("winnerList", winnerList);
		}
		
		
		List<Object> recommendMonthList = ckService.readForList("pollEvent.recommendMonthList", paramMap); //월 리스트
		modelMap.addAttribute("recommendMonthList", recommendMonthList);
		modelMap.addAttribute("paramMap", paramMap);
		
		return "addservice/pollEvent/recommendWinnerPopup";
	}
	
	/**
	 * 2016문화초대이벤트 > 추천참여자 조회 - 당첨자 추첨
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/recommendWinnerPopup.do", method=RequestMethod.POST)
	public String recommendWinnerPopupPost(HttpServletRequest request, RedirectAttributes redirectAttributes) throws Exception {
		ParamMap paramMap = new ParamMap(request);	
		
		int max =  Integer.parseInt((String)paramMap.get("lottery_number"));				
		for(int i=0; i<max ; i++){//당첨자 max명(추첨건수)까지
		
			List<Object> list = ckService.readForList("pollEvent.recommendWinnerPotentialList", paramMap);	//당첨 가능한 사람목록	
			if (!list.isEmpty()) {				
				Collections.shuffle(list);
				int lotNum = (int) (Math.random() * list.size());
				Map<String, Object> winner = (Map<String, Object>) list.get(lotNum);

				ckService.insert("pollEvent.recommendWinnerInsert", winner); //당첨자 당첨테이블에 insert
			}else{
				redirectAttributes.addFlashAttribute("msg", "당첨가능한 사람이 없습니다.");
			}
		}		
		return "redirect:/addservice/pollEvent/recommendWinnerPopup.do?entry_month="+paramMap.get("entry_month");
	}
	
	/**
	 * 2016문화초대이벤트 > 추천참여자 조회 - 당첨자 삭제
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/recommendWinnerDelete.do", method=RequestMethod.POST)
	public String recommendWinnerDelete(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckService.delete("pollEvent.recommendWinnerDelete", paramMap);
		return "redirect:/addservice/pollEvent/recommendWinnerPopup.do?entry_month="+paramMap.get("entry_month");
	}
	
	
	/**
	 * 2016문화초대이벤트 > 댓글참여자 조회 - 목록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/commentEntry.do")
	public String commentEntry(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		modelMap.addAttribute("count", ckService.readForObject("pollEvent.commentListCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("pollEvent.commentList", paramMap));
		
		return "addservice/pollEvent/commentList";
	}
	
	/**
	 * 2016문화초대이벤트 > 댓글참여자 조회 - 엑셀다운로드
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/commentExcelDown.do")
	public String commentExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"순번", "참여월", "성명", "휴대폰번호", "공유 URL", "등록일"};
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("pollEvent.commentExcelList", paramMap);
				
		modelMap.addAttribute("fileNm", "commentEvent_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);		
		return "excelView";
	}
	
	/**
	 * 2016문화초대이벤트 > 댓글참여자 조회 - 당첨자 팝업
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/commentWinnerPopup.do", method=RequestMethod.GET)
	public String commentWinnerPopup(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if(paramMap.isNotBlank("entry_month")){
			List<Object> winnerList = ckService.readForList("pollEvent.commentWinnerList", paramMap);
			modelMap.addAttribute("winnerList", winnerList);
		}
		List<Object> commentMonthList = ckService.readForList("pollEvent.commentMonthList", paramMap); //월 리스트
		modelMap.addAttribute("commentMonthList", commentMonthList);
		modelMap.addAttribute("paramMap", paramMap);
		
		return "addservice/pollEvent/commentWinnerPopup";
	}
	
	/**
	 * 2016문화초대이벤트 > 댓글참여자 조회 - 당첨자 추첨
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/commentWinnerPopup.do", method=RequestMethod.POST)
	public String commentWinnerPopupPost(HttpServletRequest request, RedirectAttributes redirectAttributes) throws Exception {
		ParamMap paramMap = new ParamMap(request);	
		
		int max =  Integer.parseInt((String)paramMap.get("lottery_number"));				
		for(int i=0; i<max ; i++){//당첨자 max명(추첨건수)까지
			List<Object> list = ckService.readForList("pollEvent.commentWinnerPotentialList", paramMap); // 당첨 가능한 사람 목록
			if (!list.isEmpty()) {				
				Collections.shuffle(list);
				int random_num = (int) (Math.random() * list.size()) + 1; //1~ 당첨가능한사람수
				paramMap.put("random_num", random_num);
				Map<String, Object> winner = (Map<String, Object>) ckService.readForObject("pollEvent.commentWinnerPotentialList", paramMap);

				ckService.insert("pollEvent.commentWinnerInsert", winner); //당첨자 당첨테이블에 insert
			}else{
				redirectAttributes.addFlashAttribute("msg", "당첨가능한 사람이 없습니다.");
			}
			paramMap.put("random_num", null);
		}		
		return "redirect:/addservice/pollEvent/commentWinnerPopup.do?entry_month="+paramMap.get("entry_month");
	}
	
	/**
	 * 2016문화초대이벤트 > 댓글참여자 조회 - 당첨자 삭제
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/commentWinnerDelete.do", method=RequestMethod.POST)
	public String commentWinnerDelete(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckService.delete("pollEvent.commentWinnerDelete", paramMap);
		return "redirect:/addservice/pollEvent/commentWinnerPopup.do?entry_month="+paramMap.get("entry_month");
	}
	
	
	/**
	 * 2016문화초대이벤트 > 이벤트 공지 - 목록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/noticeList.do")
	public String noticeList(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		modelMap.addAttribute("count", ckService.readForObject("pollEvent.noticeListCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("pollEvent.noticeList", paramMap));
		
		return "addservice/pollEvent/noticeList";
	}
	
	/**
	 * 2016문화초대이벤트 > 이벤트 공지 - 상세
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/noticeForm.do", method = RequestMethod.GET)
	public String noticeForm(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;
		
		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) ckService.readForObject("pollEvent.getNotice", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/pollEvent/noticeList.do";
			}
			
			model.addAttribute("view", resultMap);
		}
		model.addAttribute("paramMap", paramMap);
		return "addservice/pollEvent/noticeForm";
	}
	
	/**
	 * 2016문화초대이벤트 > 이벤트 공지 - 등록, 수정
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/noticeForm.do", method = RequestMethod.POST)
	public String noticeFormPost(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if (paramMap.isNotBlank("seq")) {
			// update
			ckService.save("pollEvent.updateNotice", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			ckService.save("pollEvent.insertNotice", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/addservice/pollEvent/noticeList.do";
	}
	

	/**
	 * 2016문화초대이벤트 > 이벤트 공지 - 삭제
	 * @param seqs
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/noticeDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject noticeDelete(String[] seqs, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (seqs == null || seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("seqs", seqs);
		
		ckService.delete("pollEvent.noticeDelete", paramMap);

		jo.put("success", true);
		return jo;
	}
	
	/**
	 * 2016문화초대이벤트 > 이벤트 공지 - 승인, 미승인 처리
	 * @param seqs
	 * @param approval
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/noticeApproval.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject noticeApproval(String[] seqs, String approval, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (seqs == null || seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("approval", "Y".equals(approval) ? "Y" : "N");
		paramMap.putArray("seqs", seqs);
		ckService.save("pollEvent.updateNoticeApproval", paramMap);

		jo.put("success", true);
		return jo;
	}
}
