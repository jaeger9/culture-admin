package kr.go.culture.addservice.web;

import java.util.LinkedHashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.DateUtil;
import net.sf.json.JSONObject;

/**
 * 부가메뉴 > 플랫폼 네이밍공모전
 *
 */
@RequestMapping("/addservice/naming")
@Controller
public class NamingEventController {
	
	private static final Logger logger = LoggerFactory.getLogger(NamingEventController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;
	
	/**
	 * 부가메뉴 > 플랫폼 네이밍공모전 > 응모 현황
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/entryList.do")
	public String entryList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("event", "NAMING"); //네이밍 공모전 이벤트 구분
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("list", service.readForList("portalEvent.eventEntryList", paramMap)); //이벤트 현황목록
		model.addAttribute("count", service.readForObject("portalEvent.eventEntryCnt", paramMap)); //이벤트 총계

		return "/addservice/naming/entryList";
	}
	
	/**
	 * 부가메뉴 > 플랫폼 네이밍공모전 > 응모 현황 > 상세
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/entryView.do")
	public String entryView(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		model.addAttribute("paramMap", paramMap);
		
		if(paramMap.containsKey("seq")) {
			model.addAttribute("view", service.readForObject("portalEvent.eventEntryView", paramMap));
		}

		return "/addservice/naming/entryView";
	}
	
	/**
	 * 부가메뉴 > 플랫폼 네이밍공모전 > 응모 현황 > 엑셀다운로드
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/namingExcelDown.do")
	public String namingExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"순번", "성명", "이메일", "휴대폰번호", "네이밍", "네이밍 설명", "응모날짜"};
		
		paramMap.put("event", "NAMING"); //네이밍 공모전 이벤트 구분
		List<LinkedHashMap<String, Object>> list = service.readForLinkedList("portalEvent.eventEntryExcelList", paramMap);
				
		modelMap.addAttribute("fileNm", "namingEvent_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);		
		return "excelView";
	}
	
	/**
	 * 부가메뉴 > 플랫폼 네이밍공모전 > 댓글 관리
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/replyList.do")
	public String replyList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("gubun", "4"); //네이밍 공모전 이벤트 구분
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("list", service.readForList("portalEvent.shareEventList", paramMap)); // 댓글 목록(공유이벤트 테이블사용)
		model.addAttribute("count", service.readForObject("portalEvent.shareEventCnt", paramMap)); // 댓글 수(공유이벤트 테이블사용)

		return "/addservice/naming/replyList";
	}
	
	/**
	 * 부가메뉴 > 플랫폼 네이밍공모전 > 댓글 관리 > 삭제
	 * @param seqs
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/replyDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject replyDelete(String[] seqs, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (seqs == null || seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("seqs", seqs);
		service.delete("portalEvent.shareEventDelete", paramMap);// 공유이벤트 테이블사용

		jo.put("success", true);
		return jo;
	}
	
	/**
	 * 부가메뉴 > 플랫폼 네이밍공모전 > 투표 현황
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/pollState.do")
	public String pollState(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("event", "NAMINGPOLL"); //네이밍 공모전 이벤트 구분
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("list", service.readForList("portalEvent.pollState", paramMap)); //네이밍 공모전 투표 현황
		model.addAttribute("all_cnt", service.readForObject("portalEvent.eventEntryCnt", paramMap)); //투표 총계
		return "/addservice/naming/pollState";
	}
	
	
	/**
	 * 부가메뉴 > 플랫폼 네이밍공모전 > 투표자 조회
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/voterList.do")
	public String voterList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("event", "NAMINGPOLL"); //네이밍 공모전 이벤트 구분
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("list", service.readForList("portalEvent.eventEntryList", paramMap)); //이벤트 현황목록
		model.addAttribute("count", service.readForObject("portalEvent.eventEntryCnt", paramMap)); //이벤트 총계

		return "/addservice/naming/voterList";
	}
	
	/**
	 * 부가메뉴 > 플랫폼 네이밍공모전 > 응모 현황 > 엑셀다운로드
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/voterExcelDown.do")
	public String voterExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"순번", "성명", "생년월일", "휴대폰번호", "투표작품", "응모날짜"};
		
		paramMap.put("event", "NAMINGPOLL"); //네이밍 공모전 이벤트 구분
		List<LinkedHashMap<String, Object>> list = service.readForLinkedList("portalEvent.voterExcelList", paramMap);
				
		modelMap.addAttribute("fileNm", "namingEvent_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);		
		return "excelView";
	}
}
