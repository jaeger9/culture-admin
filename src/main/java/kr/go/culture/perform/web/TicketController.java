package kr.go.culture.perform.web;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.DateUtil;
import kr.go.culture.common.util.SessionMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@RequestMapping("/perform/ticket/")
@Controller("TicketController")
public class TicketController {

	private static final Logger logger = LoggerFactory.getLogger(TicketController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("ticket.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("ticket.list", paramMap));

		return "/perform/ticket/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("genreList", ckDatabaseService.readForList("common.codeList", paramMap));
		
		if (paramMap.containsKey("seq")) {
			
			HashMap<String, String> viewMap= (HashMap<String , String>)ckDatabaseService.readForObject("ticket.view", paramMap);
			
			model.addAttribute("view",viewMap);
			
			String uci = viewMap.get("uci");
			
			if(uci != null){
				paramMap.put("uci", uci);
				model.addAttribute("showView",ckDatabaseService.readForObject("show.view", paramMap));
			}
		}
		
		return "/perform/ticket/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("ticket.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/perform/ticket/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("ticket.insert", paramMap);

		SessionMessage.insert(request);
		
		return "redirect:/perform/ticket/list.do";
	}

	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model,
			RedirectAttributes redirectAttributes) throws Exception {
		ParamMap paramMap = new ParamMap(request);

//		service.readForObject("commoncode.del", paramMap);
		ckDatabaseService.delete("ticket.delete", paramMap);
		
		redirectAttributes.addFlashAttribute("paramMap", paramMap);
		
		SessionMessage.delete(request);
		
		return "redirect:/perform/ticket/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model,
			RedirectAttributes redirectAttributes) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("ticket.update", paramMap);
		
		redirectAttributes.addFlashAttribute("paramMap", paramMap);
		
		SessionMessage.update(request);
		
		return "redirect:/perform/ticket/list.do";
	}
	
	@RequestMapping("excelDownload.do")
	public String excelDownload(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"번호", "제목", "할인기간", "다운수"};

		List<LinkedHashMap<String, Object>> list = ckDatabaseService.readForLinkedList("ticket.excelList", paramMap);
				
		model.addAttribute("fileNm", "performTicket_"+DateUtil.getDateTime("YMD"));
		model.addAttribute("headerArr", headerArr);
		model.addAttribute("excelList", list);		
		return "excelView";
	}
}
