package kr.go.culture.member.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/member/portalDormancy")
@Controller
public class PortalDormancyMemberController {

	private static final Logger logger = LoggerFactory.getLogger(PortalWithdrawMemberController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("portalDormancyMember.count", paramMap));
		model.addAttribute("list", service.readForList("portalDormancyMember.list", paramMap));
		model.addAttribute("batchUpdateDate", service.readForObject("portalDormancyMember.batchUpdateDate", paramMap));

		//return "/member/portalDormancy/list";
		return "thymeleaf/member/portalDormancy/list";
	}

}