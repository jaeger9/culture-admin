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

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.DateUtil;

/**
 * 부가메뉴 > 소득공제 이벤트
 *
 */
@RequestMapping("/addservice/incomeDeductionEvent")
@Controller
public class incomeDeductionEventController {
	
	private static final Logger logger = LoggerFactory.getLogger(incomeDeductionEventController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;
	
	@RequestMapping("/entryList.do")
	 public String entryList(HttpServletRequest request, ModelMap model) throws Exception {
		
		System.out.println("incomeDeductionEvent START::::");
		
	    ParamMap paramMap = new ParamMap(request);

	    if ((paramMap.get("event") == null) || (paramMap.get("event").equals(""))) {
	      paramMap.put("event", "incomeDeductionEvent");
	    }

	    model.addAttribute("paramMap", paramMap);
	    model.addAttribute("list", service.readForList("portalEvent.eventEntryList", paramMap));
	    model.addAttribute("count", service.readForObject("portalEvent.eventEntryCnt", paramMap));

	    System.out.println("incomeDeductionEvent END::::");
	    return "/addservice/incomeDeductionEvent/entryList";
	  }

	  @RequestMapping("/excelDown.do")
	  public String namingExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
	    ParamMap paramMap = new ParamMap(request);
	    String[] headerArr = { "순번", "성명", "참여정보", "생년월일", "휴대폰번호", "참여일자" };
	    String gubunNm = "";

	    if ((paramMap.get("event") == null) || (paramMap.get("event").equals(""))) {
	      paramMap.put("event", "incomeDeductionEvent");
	      gubunNm = "incomeDeductionEvent";
	    } else {
	      gubunNm = (String) paramMap.get("event");
	    }

	    List<LinkedHashMap<String, Object>> list = service.readForLinkedList("portalEvent.eventEntryExcelList_GoldenWeek", paramMap);

	    modelMap.addAttribute("fileNm", "소득공제 티켓 이벤트" + "_" + DateUtil.getDateTime("YMD"));
	    modelMap.addAttribute("headerArr", headerArr);
	    modelMap.addAttribute("excelList", list);
	    return "excelView";
	  }

	  @RequestMapping("/eventState.do")
	  public String eventState(HttpServletRequest request, ModelMap model) throws Exception {
	    ParamMap paramMap = new ParamMap(request);

	    if ((paramMap.get("event") == null) || (paramMap.get("event").equals(""))) {
	      paramMap.put("event", "incomeDeductionEvent");
	    }

	    model.addAttribute("paramMap", paramMap);
	    model.addAttribute("stateList", service.readForList("portalEvent.eventStateList", paramMap));
	    model.addAttribute("total", service.readForObject("portalEvent.eventTotal", paramMap));

	    return "/addservice/incomeDeductionEvent/eventState";
	  }
	
}
