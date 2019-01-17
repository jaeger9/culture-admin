package kr.go.culture.admin.web;

import javax.servlet.http.HttpServletRequest;

import kr.go.culture.admin.service.AdminRoleService;
import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
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

@RequestMapping("/admin/role")
@Controller
public class AdminRoleController {

	private static final Logger logger = LoggerFactory.getLogger(AdminRoleController.class);

	@Autowired
	private CkDatabaseService service;

	@Autowired
	private AdminRoleService adminRoleService;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("adminRole.count", paramMap));
		model.addAttribute("list", service.readForList("adminRole.list", paramMap));

		return "/admin/role/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("role_id")) {
			resultMap = (CommonModel) service.readForObject("adminRole.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/admin/role/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		return "/admin/role/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		int count = 0;

		if (paramMap.isNotBlank("role_id")) {
			count = (Integer) service.readForObject("adminRole.countByRoleId", paramMap.get("role_id"));
		}

		if (count > 0) {
			resultMap = (CommonModel) service.readForObject("adminRole.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/admin/role/list.do";
			}

			// update
			service.save("adminRole.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("adminRole.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/admin/role/form.do?role_id=" + paramMap.getString("role_id") + "&qs=" + paramMap.getQREnc();
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] role_ids, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (role_ids == null || role_ids.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("role_ids", role_ids);

		service.delete("adminMemberRole.deleteByRoleId", paramMap); // admin_user_role
		service.delete("adminUrlRole.deleteByRoleId", paramMap); // admin_url_role
		service.delete("adminRole.deleteByRoleId", paramMap); // admin_role

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = { "/url.do" }, method = RequestMethod.GET)
	public String urlView(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if (paramMap.isBlank("role_id")) {
			SessionMessage.invalid(request);
			return "redirect:/admin/role/list.do";
		}

		CommonModel resultMap = (CommonModel) service.readForObject("adminRole.view", paramMap);

		if (resultMap == null) {
			SessionMessage.invalid(request);
			return "redirect:/admin/role/list.do";
		}

		model.addAttribute("view", resultMap);
		model.addAttribute("urlList", service.readForList("adminUrlRole.listByRoleId", paramMap));

		return "/admin/role/url";
	}

	@RequestMapping(value = { "/url.do" }, method = RequestMethod.POST)
	@ResponseBody
	public JSONObject urlRegist(String role_id, String[] url_ids, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();
		jo.put("success", adminRoleService.regist(role_id, url_ids));
		return jo;
	}
}