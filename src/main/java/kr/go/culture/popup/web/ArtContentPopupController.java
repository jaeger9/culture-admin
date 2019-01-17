package kr.go.culture.popup.web;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.addservice.service.ArtContentService;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/popup/artContent")
@Controller
public class ArtContentPopupController {

	private static final Logger logger = LoggerFactory.getLogger(ArtContentPopupController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@Autowired
	private ArtContentService artContentService;

	@Autowired
	private FileService fileService;

	private String getMessageURL(String message) throws UnsupportedEncodingException {
		return "redirect:/popup/message.do?message=" + URLEncoder.encode(message, "UTF-8");
	}

	// 파일
	@RequestMapping(value = "/file/form.do", method = RequestMethod.GET)
	public String fileForm(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		return "/popup/artContentFile";
	}

	@RequestMapping(value = "/file/form.do", method = RequestMethod.POST)
	public String fileInsert(HttpServletRequest request, ModelMap model, @RequestParam("vmi_file") MultipartFile vmi_file, @RequestParam("vmi_file_sub") MultipartFile vmi_file_sub) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		String fileName = null;
		// vmi_file_size
		// vmi_file_name
		// vmi_file_name_sub

		if (!vmi_file.isEmpty()) {
			fileName = fileService.writeFile(vmi_file, "knowledge_artContentDetailFile");

			paramMap.put("vmi_file", vmi_file.getBytes());
			paramMap.put("vmi_file_size", vmi_file.getSize());
			paramMap.put("vmi_file_name", fileName);
		} else {
			paramMap.put("vmi_file", null);
		}

		if (!vmi_file_sub.isEmpty()) {
			fileName = fileService.writeFile(vmi_file_sub, "knowledge_artContentDetailFile");

			paramMap.put("vmi_file_sub", vmi_file_sub.getBytes());
			paramMap.put("vmi_file_name_sub", fileName);
		} else {
			paramMap.put("vmi_file_sub", null);
		}

		service.insert("artContent.insertByDetailFile", paramMap);

		model.clear();
		return getMessageURL("파일 정보가 등록되었습니다.");
	}

	// 매핑
	@RequestMapping(value = "/map/form.do", method = RequestMethod.GET)
	public String mapForm(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("artContent.getInfViewMapListCnt", paramMap));
		model.addAttribute("list", service.readForList("artContent.getInfViewMapList", paramMap));

		return "/popup/artContentMap";
	}

	@RequestMapping(value = "/map/form.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> mapInsert(HttpServletRequest request) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		ParamMap paramMap = new ParamMap(request);

		service.insert("artContent.insertByDetailMapping", paramMap);

		result.put("success", true);
		return result;
	}

	// 사이트
	@RequestMapping(value = "/site/form.do", method = RequestMethod.GET)
	public String siteForm(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		model.addAttribute("paramMap", paramMap);
		return "/popup/artContentSite";
	}

	@RequestMapping(value = "/site/form.do", method = RequestMethod.POST)
	public String siteInsert(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		service.insert("artContent.insertByDetailSite", paramMap);

		model.clear();
		return getMessageURL("사이트 정보가 등록되었습니다.");
	}

}