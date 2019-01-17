package kr.go.culture.popup.web;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.addservice.service.ArchiveService;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.apache.commons.lang.StringUtils;
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

@RequestMapping("/popup/archive")
@Controller
public class ArchivePopupController {

	private static final Logger logger = LoggerFactory.getLogger(ArchivePopupController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@Autowired
	private ArchiveService archiveService;

	@Autowired
	private FileService fileService;

	private String getMessageURL(String message) throws UnsupportedEncodingException {
		return "redirect:/popup/message.do?message=" + URLEncoder.encode(message, "UTF-8");
	}

	// content
	@RequestMapping(value = "/content/form.do", method = RequestMethod.GET)
	public String contentForm(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		model.addAttribute("paramMap", paramMap);
		return "/popup/archiveContent";
	}

	@RequestMapping(value = "/content/form.do", method = RequestMethod.POST)
	public String contentInsert(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		archiveService.insertAddContents(paramMap);

		model.clear();
		return getMessageURL("추가 내용이 등록되었습니다.");
	}

	// 파일
	@RequestMapping(value = "/file/form.do", method = RequestMethod.GET)
	public String fileForm(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		model.addAttribute("paramMap", paramMap);
		return "/popup/archiveFile";
	}

	@RequestMapping(value = "/file/form.do", method = RequestMethod.POST)
	public String fileInsert(HttpServletRequest request, ModelMap model, @RequestParam("amd_file") MultipartFile amd_file, @RequestParam("amd_file_sub") MultipartFile amd_file_sub) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		String fileName = null;

		if (!amd_file.isEmpty()) {
			fileName = fileService.writeFile(amd_file, "addservice_archive");

			paramMap.put("amd_file", amd_file.getBytes());
			paramMap.put("amd_file_size", amd_file.getSize());
			paramMap.put("amd_file_name", fileName);
		} else {
			paramMap.put("amd_file", null);
		}

		if (!amd_file_sub.isEmpty()) {
			fileName = fileService.writeFile(amd_file_sub, "addservice_archive");

			paramMap.put("amd_file_sub", amd_file_sub.getBytes());
			paramMap.put("amd_file_name_sub", fileName);
		} else {
			paramMap.put("amd_file_sub", null);
		}

		service.insert("archive.insertByFile", paramMap);

		model.clear();
		return getMessageURL("파일 정보가 등록되었습니다.");
	}

	// 매핑
	@RequestMapping(value = "/map/form.do", method = RequestMethod.GET)
	public String mapForm(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		model.addAttribute("paramMap", paramMap);

		String stype = paramMap.getString("stype");

		if (StringUtils.isNotBlank(stype)) {
			if ("ARC".equals(stype)) {
				model.addAttribute("count", service.readForList("archive.getMapListForArchiveCnt", paramMap));
				model.addAttribute("list", service.readForList("archive.getMapListForArchive", paramMap));

			} else if ("PET".equals(stype)) {
				model.addAttribute("count", service.readForList("archive.getMapListForPerformCnt", paramMap));
				model.addAttribute("list", service.readForList("archive.getMapListForPerform", paramMap));

			} else {
				model.addAttribute("count", service.readForList("archive.getMapListCnt", paramMap));
				model.addAttribute("list", service.readForList("archive.getMapList", paramMap));
			}
		}

		return "/popup/archiveMap";
	}

	@RequestMapping(value = "/map/form.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> mapInsert(HttpServletRequest request) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		ParamMap paramMap = new ParamMap(request);

		service.insert("archive.insertByMap", paramMap);

		result.put("success", true);
		return result;
	}

	// index
	@RequestMapping(value = "/index/form.do", method = RequestMethod.GET)
	public String indexForm(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		model.addAttribute("paramMap", paramMap);

		model.addAttribute("selectList", service.readForList("archive.getArchiveIdxPopSelectList", paramMap));

		String arc_idx_id = paramMap.getString("arc_idx_id");

		if (StringUtils.isNotBlank(arc_idx_id)) {
			model.addAttribute("count", service.readForList("archive.getArchiveIdxPopListCnt", paramMap));
			model.addAttribute("list", service.readForList("archive.getArchiveIdxPopList", paramMap));
		}

		return "/popup/archiveIndex";
	}

	@RequestMapping(value = "/index/form.do", method = RequestMethod.POST)
	public String indexInsert(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		service.insert("archive.insertByIndex", paramMap);

		model.clear();
		return getMessageURL("색인 정보가 등록되었습니다.");
	}

}