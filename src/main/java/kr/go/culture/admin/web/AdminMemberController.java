package kr.go.culture.admin.web;

import javax.servlet.http.HttpServletRequest;

import kr.go.culture.admin.service.AdminMemberService;
import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.MemberUtils;
import kr.go.culture.common.util.SessionMessage;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/admin/member")
@Controller
public class AdminMemberController {

	private static final Logger logger = LoggerFactory.getLogger(AdminMemberController.class);

	@Autowired
	private CkDatabaseService service;

	@Autowired
	private AdminMemberService adminMemberService;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("adminMember.count", paramMap));
		model.addAttribute("list", service.readForList("adminMember.list", paramMap));

		return "/admin/member/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("user_id")) {
			resultMap = (CommonModel) service.readForObject("adminMember.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/admin/member/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);
		model.addAttribute("adminRoleList", service.readForList("adminMemberRole.listByAdminRole", paramMap));

		return "/admin/member/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if (paramMap.isBlank("password")) {
			paramMap.remove("password");
		} else {
			paramMap.put("password", MemberUtils.pwdMD5incode(paramMap.getString("password")));
		}

		CommonModel resultMap = null;

		int count = 0;

		if (paramMap.isNotBlank("user_id")) {
			count = (Integer) service.readForObject("adminMember.countByUserId", paramMap.get("user_id"));
		}

		if (count > 0) {
			resultMap = (CommonModel) service.readForObject("adminMember.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/admin/member/list.do";
			}

			// update
			adminMemberService.update(paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			adminMemberService.insert(paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/admin/member/form.do?user_id=" + paramMap.getString("user_id") + "&qs=" + paramMap.getQREnc();
	}

	@RequestMapping(value = "/approval.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject approval(String[] user_ids, String active, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (user_ids == null || user_ids.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("active", active);
		paramMap.putArray("user_ids", user_ids);
		service.save("adminMember.updateApproval", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] user_ids, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (user_ids == null || user_ids.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("user_ids", user_ids);

		service.delete("adminMemberRole.deleteByUserId", paramMap); // admin_user_role 삭제
		service.delete("adminMember.deleteByUserId", paramMap); // admin_user 삭제

		jo.put("success", true);
		return jo;
	}

}