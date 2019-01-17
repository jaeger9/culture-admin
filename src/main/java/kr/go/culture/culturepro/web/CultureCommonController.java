package kr.go.culture.culturepro.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.util.SessionMessage;

import org.apache.commons.lang.StringUtils;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
@Controller("CultureCommonController")
public class CultureCommonController {
	protected static final Logger logger = LoggerFactory.getLogger(CultureQnaController.class);
	
	@Resource(name = "CkDatabaseService")
	protected CkDatabaseService ckDatabaseService;
	
	@Resource(name = "FileService")
	protected FileService fileService;
	
	protected ModelAndView JsonView(HashMap<String, Object> map) throws JsonGenerationException, JsonMappingException, IOException {
		return new ModelAndView("jsonView", map);
	}
	

	/**
	 * 관리자 페이지 위치 찾기 
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/popup/findLocation.do")
	public String findLocation(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.put("paramMap", paramMap);
		return "/culturepro/common/popup/findLocation";
	}
	
	@RequestMapping("/popup/ajax/findLocation.do")
	@ResponseBody
	public Map getLocation(HttpServletRequest request, ModelMap modelMap) throws Exception{
		ParamMap paramMap = new ParamMap(request);
		logger.debug("########go fineLocation");
		Map<String, List> map = new HashMap();
		map.put("ziplist", ckDatabaseService.readForList("zipcode_.list", paramMap));
		return map;
	}
	
	
	@RequestMapping(value = "/popup/pro/fileupload.do", method = RequestMethod.GET)
	public String fileUpload(String menu_type, String file_type, ModelMap model) throws Exception {

		logger.debug(">>>>> file_type : "+file_type);
		
		if (StringUtils.isBlank(menu_type)) {
			model.addAttribute("valid", "0");
			return "/popup/fileupload";
		}

		model.addAttribute("valid", "1");
		model.addAttribute("menu_type", menu_type);
		model.addAttribute("full_file_path", "");
		model.addAttribute("file_path", "");
		model.addAttribute("file_type", file_type);

		return "/popup/fileupload";
	}
}
