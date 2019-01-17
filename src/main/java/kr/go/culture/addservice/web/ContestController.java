package kr.go.culture.addservice.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.addservice.service.ContestService;
import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.MemberUtils;
import kr.go.culture.common.util.SessionMessage;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/addservice/contest")
@Controller
public class ContestController {

	private static final Logger logger = LoggerFactory.getLogger(ContestController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@Resource(name = "ContestService")
	private ContestService contestService;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("contest.count", paramMap));
		model.addAttribute("list", service.readForList("contest.list", paramMap));

		return "/addservice/contest/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		// seq가 null이 아닌 경우 조회해서 없을 경우 존재하지 않는 글
		if (paramMap.isNotBlank("seq")) {
			resultMap = contestService.getView(paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/addservice/contest/list.do";
			}

		} else {
			SessionMessage.empty(request);
			return "redirect:/addservice/contest/list.do";
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		return "/addservice/contest/form";
	}

	@RequestMapping("/excel.do")
	public String excel(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		model.addAttribute("list", contestService.getExcelList(paramMap));
		return "/addservice/contest/excel";
	}

	@RequestMapping(value = "/password.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject password(String seq, String pwd, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (StringUtils.isBlank(seq) || StringUtils.isBlank(pwd)) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("seq", seq);
		paramMap.put("pwd", MemberUtils.pwdMD5incode(pwd));

		service.save("contest.updatePassword", paramMap);

		jo.put("success", true);
		return jo;
	}

}