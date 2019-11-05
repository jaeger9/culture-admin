package kr.go.culture.perform.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/perform/relay/discount/")
@Controller("RelayDiscountController")
public class RelayDiscountController {

	private static final Logger logger = LoggerFactory.getLogger(RelayDiscountController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("relay_discount.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("relay_discount.list", paramMap));

		//return "/perform/relay/discount/list";
		return "thymeleaf/perform/relay/discount/list";
	}

	
	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		
		
		
		if (paramMap.containsKey("seq")) 
			model.addAttribute("view",ckDatabaseService.readForObject("relay_discount.view", paramMap));
		
		//return "/perform/relay/discount/view";
		return "thymeleaf/perform/relay/discount/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("relay_discount.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/perform/relay/discount/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request , ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		//임시
				if("Y".equals(paramMap.get("img_yn"))){
					paramMap.put("img_yn", "N");
					paramMap.put("img_url", "http://culture.go.kr/upload/rdf/"+paramMap.get("img_file"));
				}

		ckDatabaseService.save("relay_discount.insert", paramMap);

		SessionMessage.insert(request);
		
		return "redirect:/perform/relay/discount/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request , ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		//임시
				if("Y".equals(paramMap.get("img_yn"))){
					paramMap.put("img_yn", "N");
					paramMap.put("img_url", "http://culture.go.kr/upload/rdf/"+paramMap.get("img_file"));
				}
		
		ckDatabaseService.save("relay_discount.update", paramMap);

		SessionMessage.update(request);
		
		return "redirect:/perform/relay/discount/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request , ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.delete("relay_discount.delete", paramMap);

		SessionMessage.delete(request);
		
		return "redirect:/perform/relay/discount/list.do";
	}
}
