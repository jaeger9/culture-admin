package kr.go.culture.perform.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.perform.service.RelayLeafletDistributeService;
import kr.go.culture.perform.service.RelayLeafletSearchService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/perform/relay/leaflet/")
@Controller("RelayLeafletController")
public class RelayLeafletController {

	private static final Logger logger = LoggerFactory.getLogger(RelayLeafletController.class);
	
	@Resource(name = "RelayLeafletSearchService")
	private RelayLeafletSearchService relayLeafletSearchService;
	
	@Resource(name = "RelayLeafletDistributeService")
	private RelayLeafletDistributeService relayLeafletDistributeService;
	
	@Resource(name = "FileService")
	private FileService fileService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {

		try {
			
			relayLeafletSearchService.list(model);
			
		} catch (Exception e) {
			logger.error(e.getLocalizedMessage());
		}

		return "/perform/relay/leaflet/list";
	}
	
	@RequestMapping("distribute.do")
	public String distribute(HttpServletRequest request, ModelMap model , @RequestParam("uploadFile") MultipartFile multi)
			throws Exception {

		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			relayLeafletDistributeService.distribute(multi, paramMap);
			
		} catch (Exception e) {
			logger.error(e.getLocalizedMessage());
		}

		return "redirect:/perform/relay/leaflet/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model)
			throws Exception {

		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			fileService.deleteFile("leaflet" , paramMap.get("gubun") + ".jpg");
			
		} catch (Exception e) {
			logger.error(e.getLocalizedMessage());
		}

		SessionMessage.delete(request);
		
		return "redirect:/perform/relay/leaflet/list.do";
	}
}
