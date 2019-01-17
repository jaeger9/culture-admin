package kr.go.culture.event.web;

import java.util.LinkedHashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.DateUtil;

@Controller
@RequestMapping("/event/rumor")
public class RumorController {

	@Autowired
	private CkDatabaseService ckService;
	
	@RequestMapping("/user/list.do")
	public String entryUserList(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		modelMap.addAttribute("count", ckService.readForObject("rumor.user.listCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("rumor.user.list", paramMap));
		
		return "event/rumor/user/list";
	}
	
	@RequestMapping("/user/excelDown.do")
	public String userExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"이름", "내용", "공유 URL", "휴대폰번호", "등록일"};
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("rumor.user.excelList", paramMap);
				
		modelMap.addAttribute("fileNm", "rumor_user_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);		
		return "excelView";
	}
	
}
