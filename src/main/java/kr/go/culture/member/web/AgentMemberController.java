package kr.go.culture.member.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.MemberUtils;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.member.service.PortalMemberService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@RequestMapping("/member/agent")
@Controller
public class AgentMemberController {

	private static final Logger logger = LoggerFactory.getLogger(AgentMemberController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@Resource(name = "PortalMemberService")
	private PortalMemberService portalMemberService;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("agentMember.count", paramMap));
		model.addAttribute("list", service.readForList("agentMember.list", paramMap));

		return "/member/agent/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		// user_id가 null이 아닌 경우 조회해서 없을 경우 존재하지 않는 글
		if (paramMap.isNotBlank("user_id")) {
			resultMap = (CommonModel) service.readForObject("agentMember.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/member/agent/list.do";
			}
		}

		portalMemberService.setMemberInfo(resultMap);
		portalMemberService.setMemberCategory(model);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		return "/member/agent/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if (paramMap.isBlank("pwd")) {
			paramMap.remove("pwd");
		} else {
			paramMap.put("pwd", MemberUtils.pwdMD5incode(paramMap.getString("pwd")));
		}

		CommonModel resultMap = null;

		int count = 0;

		if (paramMap.isNotBlank("user_id")) {
			count = (Integer) service.readForObject("portalMember.countByUserId", paramMap.get("user_id"));
		}

		if (count > 0) {
			resultMap = (CommonModel) service.readForObject("agentMember.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/member/agent/list.do";
			}

			// update
			service.save("agentMember.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.save("agentMember.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/member/agent/form.do?user_id=" + paramMap.getString("user_id") + "&qs=" + paramMap.getQREnc();
	}

}