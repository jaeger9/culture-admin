package kr.go.culture.culturepro.web;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.util.CommonUtil;
import kr.go.culture.common.util.SessionMessage;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;


@RequestMapping("/culturepro/cultureCal")
@Controller("CultureCalController")
public class CultureCalController extends CultureCommonController{
	
	@RequestMapping("list.do")
	public String allList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		List<HashMap<String, Object>> list = ckDatabaseService.readForListMap("culture_cal.list", paramMap);
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer)ckDatabaseService.readForObject("culture_cal.listCnt", paramMap));
		model.addAttribute("list", list);
		
		return "/culturepro/cultureCal/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		modelMap.addAttribute("paramMap", paramMap);
		if (paramMap.containsKey("seq")) {
			ckDatabaseService.insert("culture_cal.viewCnt", paramMap);
			modelMap.addAttribute("view", ckDatabaseService.readForObject("culture_cal.view", paramMap));
		}
		
		return "/culturepro/cultureCal/view";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		ckDatabaseService.insert("culture_cal.insert", paramMap);		
		
		SessionMessage.insert(request);
		
		return "redirect:/culturepro/cultureCal/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		ckDatabaseService.insert("culture_cal.update", paramMap);
		modelMap.addAttribute("paramMap", paramMap);
		SessionMessage.update(request);
		
		return "redirect:/culturepro/cultureCal/view.do?seq=" + request.getParameter("seq");
	}
	
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		ckDatabaseService.insert("culture_cal.insert", paramMap);		
		
		SessionMessage.insert(request);
		
		return "redirect:/culturepro/cultureCal/list.do";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		ckDatabaseService.insert("culture_cal.statusUpdate", paramMap);
		modelMap.addAttribute("paramMap", paramMap);
		SessionMessage.update(request);
		
		return "forward:/culturepro/cultureCal/list.do";
	}
}
