package kr.go.culture.perform.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.facility.web.PlaceController;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/perform/review")
@Controller("ReviewController")
public class ReviewController {

	private static final Logger logger = LoggerFactory.getLogger(PlaceController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		//나중에 enum 이던 property 던 빼라...
		paramMap.put("type", new String[]{"06" , "08"});
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count",
				(Integer) ckDatabaseService.readForObject("review.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("review.list", paramMap));

//		return "/perform/review/list";
		return "thymeleaf/perform/review/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		
		if (paramMap.containsKey("seq")) { 
			model.addAttribute("view",
					ckDatabaseService.readForObject("review.view", paramMap));
			model.addAttribute("commentList",
					ckDatabaseService.readForList("review.commentList", paramMap));
			model.addAttribute("commentListCnt",
					ckDatabaseService.readForObject("review.commentListCnt", paramMap));
			
		}

//		return "/perform/review/view";
		return "thymeleaf/perform/review/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("review.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/perform/review/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("review.update", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);
		
		return "redirect:/perform/review/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			ckDatabaseService.save("review.delete", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.delete(request);
		
		return "redirect:/perform/review/list.do";
	}
	
	@RequestMapping("commentdelete.do")
	public @ResponseBody JSONObject commentdelete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		JSONObject result = new JSONObject();
		
		try {
			
			ckDatabaseService.delete("review.reviewCommentDelete", paramMap);
		
			result.put("success", true);
			
			return result; 
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
	}
	
	@RequestMapping("answer/view.do")
	public String answerView(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		
		if (paramMap.containsKey("seq")) { 
			model.addAttribute("view",
					ckDatabaseService.readForObject("review.view", paramMap));
		}

//		return "/perform/review/answerView";
		return "thymeleaf/perform/review/answerView";
	}
	
	@RequestMapping("answer/insert.do")
	public String answerInsert(HttpServletRequest request , ModelMap model) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			ckDatabaseService.save("review.answerInsert" ,paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);
		
		return "redirect:/perform/review/list.do";
	}
}
