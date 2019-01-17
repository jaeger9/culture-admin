package kr.go.culture.addservice.web;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.DateUtil;
import kr.go.culture.common.util.MailUtil;
import kr.go.culture.common.util.SessionMessage;

@RequestMapping("/addservice/culturecok")
@Controller
public class CultureCokEventController {

	private static final Logger logger = LoggerFactory.getLogger(CultureCokEventController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;
	
	/**
	 * 부가메뉴 > 문화융성앱 이벤트 > 이벤트 현황
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/eventState.do")
	public String eventState(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if(paramMap.get("gubun") == null || paramMap.get("gubun").equals("")){
			paramMap.put("gubun", "A"); //이벤트 구분 : 앱인증이벤트(A), 홍보인증이벤트(S)
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("stateList", service.readForList("culturecok.eventStateList", paramMap)); //이벤트 현황목록
		model.addAttribute("total", service.readForObject("culturecok.eventTotal", paramMap)); //이벤트 총계
		model.addAttribute("eventCnt", service.readForObject("culturecok.eventCnt", paramMap)); //오늘 참여자 수 , 전체 누적 수

		return "/addservice/culturecok/eventState";
	}
	
	/**
	 * 부가메뉴 > 문화융성앱 이벤트 > 이벤트 응모현황
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/eventEntry.do")
	public String eventEntry(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if(paramMap.get("gubun") == null || paramMap.get("gubun").equals("")){
			paramMap.put("gubun", "A"); //이벤트 구분 : 앱인증이벤트(A), 홍보인증이벤트(S)
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("culturecok.eventEntryCnt", paramMap));
		model.addAttribute("list", service.readForList("culturecok.eventEntryList", paramMap));

		return "/addservice/culturecok/eventEntry";
	}
	
	/**
	 * 부가메뉴 > 문화융성앱 이벤트 > 이벤트 응모현황 > 첨부이미지 팝업
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/imgPopup.do")
	public String imgPopup(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("imgUrl", "/upload/culturecok/"+paramMap.get("img"));
		
		return "/addservice/culturecok/popupImg";
	}
	
	/**
	 * 부가메뉴 > 문화융성앱 이벤트 > 이벤트 응모현황 > 엑셀다운로드
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/eventEntryExcelDownload.do")
	public String eventEntryExcelDownload(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		String[] headerArr = {"번호", "응모일", "한줄내용", "이름", "연락처", "이메일", "파일이름", "공유 URL", "이벤트구분"};
		
		List<LinkedHashMap<String, Object>> list = service.readForLinkedList("culturecok.eventEntryExcelList", paramMap);
				
		model.addAttribute("fileNm", "culturecokEvent_"+DateUtil.getDateTime("YMD"));
		model.addAttribute("headerArr", headerArr);
		model.addAttribute("excelList", list);		
		return "excelView";
	}
	
	/**
	 * 부가메뉴 > 문화융성앱 이벤트 > 헬프 데스크 목록
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/eventHelpList.do")
	public String eventHelpList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("culturecok.eventHelpCnt", paramMap));
		model.addAttribute("list", service.readForList("culturecok.eventHelpList", paramMap));

		return "/addservice/culturecok/eventHelpList";
	}
	
	/**
	 * 부가메뉴 > 문화융성앱 이벤트 > 헬프 데스크 > 엑셀다운로드
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/eventHelpExcelDownload.do")
	public String eventHelpExcelDownload(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		String[] headerArr = {"번호", "접수일", "제목", "이름", "연락처", "이메일", "파일이름", "접수상태", "답변일", "답변내용"};
		
		List<LinkedHashMap<String, Object>> list = service.readForLinkedList("culturecok.eventHelpExcelList", paramMap);
				
		model.addAttribute("fileNm", "culturecokEvent_"+DateUtil.getDateTime("YMD"));
		model.addAttribute("headerArr", headerArr);
		model.addAttribute("excelList", list);		
		return "excelView";
	}
	
	
	/**
	 * 부가메뉴 > 문화융성앱 이벤트 > 헬프 데스크 상세
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/eventHelpForm.do", method = RequestMethod.GET)
	public String eventHelpForm(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if(paramMap.get("seq") != null && paramMap.get("seq") != ""){
			model.addAttribute("view", service.readForObject("culturecok.eventHelpView", paramMap));
		}
		model.addAttribute("paramMap", paramMap);
		
		return "/addservice/culturecok/eventHelpForm";
	}
	
	
	/**
	 * 부가메뉴 > 문화융성앱 이벤트 > 헬프 데스크 등록, 저장
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/eventHelpForm.do", method = RequestMethod.POST)
	public String eventHelpMerge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) service.readForObject("culturecok.eventHelpView", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/culturecok/eventHelpList.do";
			}

			// update
			service.save("culturecok.eventHelpUpdate", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("culturecok.eventHelpInsert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/addservice/culturecok/eventHelpList.do";
	}
	
	/**
	 * 부가메뉴 > 문화융성앱 이벤트 > 헬프 데스크 답변메일보내기
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/eventHelpMail.do", method = RequestMethod.POST)
	public String eventHelpMail(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if (paramMap.isNotBlank("seq")) {
			// update
			service.save("culturecok.eventHelpUpdate", paramMap);
			
			String content = (String) paramMap.get("content");
			content = content.replace("\r\n", "<br>");
			
			String reply_content = (String) paramMap.get("reply_content");
			reply_content = reply_content.replace("\r\n", "<br>");
			
			//메일발송
			MailUtil mail = new MailUtil();
			String[][] text = new String[4][4];
			text[0][0] = "<t_content>";
			text[0][1] = content;
			text[1][0] = "<t_name>";
			text[1][1] = (String) paramMap.get("name");
			text[2][0] = "<t_email>";
			text[2][1] = (String) paramMap.get("email");
			text[3][0] = "<t_reply_content>";
			text[3][1] = reply_content;
			
			mail.sendMail((String) paramMap.get("email"), "portal@kcisa.kr", "문의주신 사항에 대한 답변드립니다.", text, 6);	
			request.getSession().setAttribute("SESSION_MESSAGE", "답변 메일발송이 완료되었습니다.");
		}
		
		return "redirect:/addservice/culturecok/eventHelpList.do";
	}
	
	
	/**
	 * 문화콕 앱 이벤트 > 이벤트 응모현황 > 당첨자 추첨 팝업
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/winnerPopup.do", method=RequestMethod.GET)
	public String winnerPopup(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if(paramMap.get("gubun") == null || paramMap.get("gubun").equals("")){
			paramMap.put("gubun", "A"); //이벤트 구분 : 앱인증이벤트(A), 홍보인증이벤트(S)
		}

		List<Object> winnerList = service.readForList("culturecok.winnerList", paramMap);
		model.addAttribute("winnerList", winnerList);
		model.addAttribute("paramMap", paramMap);

		return "/addservice/culturecok/winnerPopup";
	}
	
	/**
	 * 문화콕 앱 이벤트 > 이벤트 응모현황 > 당첨자 추첨
	 * @param request
	 * @param redirectAttributes
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/winnerPopup.do", method=RequestMethod.POST)
	public String winnerPopupPost(HttpServletRequest request, RedirectAttributes redirectAttributes,  ModelMap modelMap) throws Exception {
				
		ParamMap paramMap = new ParamMap(request);	
		
		int max =  Integer.parseInt((String)paramMap.get("lottery_number"));				
		for(int i=0; i<max ; i++){//당첨자 max명(추첨건수)까지
			List<Object> list = service.readForList("culturecok.winnerPotentialList", paramMap); // 당청 가능한 사람 목록
			if (!list.isEmpty()) {				
				Collections.shuffle(list);
				int lotNum = (int) (Math.random() * list.size());
				Map<String, Object> winner = (Map<String, Object>) list.get(lotNum);

				service.insert("culturecok.winnerInsert", winner); //당첨자 당첨테이블에 insert
			}else{
				redirectAttributes.addFlashAttribute("msg", "당첨가능한 사람이 없습니다.");
			}
		}
		
		return "redirect:/addservice/culturecok/winnerPopup.do?gubun="+paramMap.get("gubun");
	}
	

	/**
	 * 문화콕 앱 이벤트 > 이벤트 응모현황 > 당첨자 삭제
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/winnerDelete.do", method=RequestMethod.POST)
	public String winnerDelete(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		service.delete("culturecok.winnerDelete", paramMap);
		return "redirect:/addservice/culturecok/winnerPopup.do?gubun="+paramMap.get("gubun");
	}
	
	

	/**
	 * 문화콕 앱 이벤트 > 이벤트 응모현황 > 당첨자 엑셀다운로드
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/winnerExcelDown.do")
	public String winnerExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		

		List<LinkedHashMap<String, Object>> list = null;
		
		//이벤트 구분 : 앱인증이벤트(A), 홍보인증이벤트(S), 문화콕앱스탬프 이벤트(T)
		if(paramMap.get("gubun").equals("T")){
			
			String[] headerArr = {"당첨구분", "번호", "이름", "아이디", "휴대폰번호", "이메일"};
			modelMap.addAttribute("headerArr", headerArr);
			
			list = service.readForLinkedList("culturecok.winnerExcelList2", paramMap);
		}else{
			
			String[] headerArr = {"순번", "성명", "휴대폰번호", "이메일", "한줄 메모", "등록일", "공유 URL"};
			modelMap.addAttribute("headerArr", headerArr);
			
			list = service.readForLinkedList("culturecok.winnerExcelList", paramMap);
		}
				
		modelMap.addAttribute("fileNm", "culturecokEvent_"+DateUtil.getDateTime("YMD"));
		
		modelMap.addAttribute("excelList", list);		
		return "excelView";
	}
}
