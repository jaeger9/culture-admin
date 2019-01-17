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
 * 부가메뉴 > 2018_추석 이벤트
 *
 */
@RequestMapping("/addservice/chuseokEvent")
@Controller
public class ChuseokEventController {
	
	private static final Logger logger = LoggerFactory.getLogger(ChuseokEventController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;
	
	@RequestMapping("/entryList.do")
	 public String entryList(HttpServletRequest request, ModelMap model) throws Exception {
		
		System.out.println("ChuseokEvent START::::");
		
	    ParamMap paramMap = new ParamMap(request);

	    if ((paramMap.get("event") == null) || (paramMap.get("event").equals(""))) {
	      paramMap.put("event", "chuseokEvent");
	    }

	    model.addAttribute("paramMap", paramMap);
	    model.addAttribute("list", service.readForList("portalEvent.eventEntryList", paramMap));
	    model.addAttribute("count", service.readForObject("portalEvent.eventEntryCnt", paramMap));

	    System.out.println("ChuseokEvent END::::");
	    return "/addservice/chuseokEvent/entryList";
	  }

	  @RequestMapping("/excelDown.do")
	  public String namingExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
	    ParamMap paramMap = new ParamMap(request);
	    String[] headerArr = { "순번", "성명", "참여정보", "생년월일", "휴대폰번호", "참여일자" };
	    String gubunNm = "";

	    if ((paramMap.get("event") == null) || (paramMap.get("event").equals(""))) {
	      paramMap.put("event", "chuseokEvent");
	      gubunNm = "chuseokEvent";
	    } else {
	      gubunNm = (String) paramMap.get("event");
	    }

	    List<LinkedHashMap<String, Object>> list = service.readForLinkedList("portalEvent.eventEntryExcelList_GoldenWeek", paramMap);

	    modelMap.addAttribute("fileNm", "추석이벤트" + "_" + DateUtil.getDateTime("YMD"));
	    modelMap.addAttribute("headerArr", headerArr);
	    modelMap.addAttribute("excelList", list);
	    return "excelView";
	  }

	  @RequestMapping("/eventState.do")
	  public String eventState(HttpServletRequest request, ModelMap model) throws Exception {
	    ParamMap paramMap = new ParamMap(request);

	    if ((paramMap.get("event") == null) || (paramMap.get("event").equals(""))) {
	      paramMap.put("event", "chuseokEvent");
	    }

	    model.addAttribute("paramMap", paramMap);
	    model.addAttribute("stateList", service.readForList("portalEvent.eventStateList", paramMap));
	    model.addAttribute("total", service.readForObject("portalEvent.eventTotal", paramMap));

	    return "/addservice/chuseokEvent/eventState";
	  }
	
}
