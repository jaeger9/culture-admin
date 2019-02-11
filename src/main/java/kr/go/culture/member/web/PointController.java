package kr.go.culture.member.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.MemberUtils;
import kr.go.culture.common.util.SessionMessage;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/member/point")
@Controller
public class PointController {

	private static final Logger logger = LoggerFactory.getLogger(PointController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("point.count", paramMap));
		model.addAttribute("list", service.readForList("point.list", paramMap));

		return "/member/point/list";
	}
	
	@RequestMapping("/policy/list.do")
	public String policyList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("point.policyCount", paramMap));
		model.addAttribute("list", service.readForList("point.policyList", paramMap));

		return "/member/point/policy/list";
	}
	
	@RequestMapping(value = "/policy/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;
		
		int maxCountForRegistration=0;

		// policy_coded가 null이 아닌 경우 조회해서 없을 경우 존재하지 않는 글
		if (paramMap.isNotBlank("policy_code")) {
			resultMap = (CommonModel) service.readForObject("point.policyView", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/member/point/policy/list.do";
			}
		}else {
			maxCountForRegistration=(Integer)service.readForObject("point.policyCountForMax", paramMap);
		}
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("maxCountForRegistration",maxCountForRegistration);
		model.addAttribute("view", resultMap);

		return "/member/point/policy/form";
	}

	@RequestMapping(value = "/policy/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		CommonModel resultMap = null;

		if (paramMap.isNotBlank("policy_code")) {
			resultMap = (CommonModel) service.readForObject("point.policyView", paramMap);

			if (resultMap != null) {
				// update
				service.save("point.policyUpdate", paramMap);
				SessionMessage.update(request);
			}
		} else {
			// insert
			resultMap = (CommonModel) service.readForObject("point.policyView", paramMap);
			if(resultMap==null) {
				service.insert("point.policyInsert", paramMap);
				
				SessionMessage.insert(request);
				
			}else {
				SessionMessage.empty(request);
				return "redirect:/member/point/policy/list.do";				
			}
		}

		//추후 수정
		return "redirect:/member/point/policy/list.do";
	}
	
	@RequestMapping(value = "/policy/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] policyCodes, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (policyCodes == null || policyCodes.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("policyCodes", policyCodes);
		service.delete("point.policyDelete", paramMap);

		jo.put("success", true);
		return jo;
	}
	

}