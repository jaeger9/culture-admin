package kr.go.culture.resource.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.facility.web.PlaceController;
import kr.go.culture.resource.service.ResPageInsertService;
import kr.go.culture.resource.service.ResPageUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/resource/page")
@Controller
public class ResPageController {

	private static final Logger logger = LoggerFactory.getLogger(PlaceController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@Autowired
	private ResPageUpdateService pageUpdateService;
	
	@Autowired
	private ResPageInsertService pageInsertService;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("resPage.count", paramMap));
		model.addAttribute("list", service.readForList("resPage.list", paramMap));

		return "/resource/page/list";
	}


	@RequestMapping(value = "/form.do")
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;
		model.addAttribute("paramMap", paramMap);

		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) service.readForObject("resPage.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/resource/page/list";
			}
			model.addAttribute("view", resultMap);
		}

		return "/resource/page/form";
	}

	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model,  @RequestParam("uploadFile") MultipartFile multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		
		try {
			pageInsertService.insert(paramMap, multi);
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);
		
		return "redirect:/resource/page/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model,  @RequestParam("uploadFile") MultipartFile multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		try {
			pageUpdateService.update(paramMap, multi);
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);

		return "redirect:/resource/page/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		try {
			if( paramMap.isNotBlank("chkSeq") ){
				paramMap.putArray("seq", paramMap.getArray("chkSeq"));
			}
			service.delete("resPage.delete", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.delete(request);
		
		return "redirect:/resource/page/list.do";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		try {
			if( paramMap.isNotBlank("chkSeq") ){
				paramMap.putArray("seq", paramMap.getArray("chkSeq"));
			}
			service.delete("resPage.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);
		
		return "redirect:/resource/page/list.do";
	}
	
	@RequestMapping("isMenuYn.do")
	@ResponseBody
	public String isMenuYn(HttpServletRequest request) throws Exception {
		int menuCnt = 0;
		String rtnVal = "N";
		try {
			menuCnt = (Integer) service.readForObject("resPage.isMenuYn", request.getParameter("pseq"));
			
			System.out.println("????????????????????"+menuCnt);
			
			if( menuCnt > 0 ){
				rtnVal = "Y";
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);
		
		return rtnVal;
	}
}