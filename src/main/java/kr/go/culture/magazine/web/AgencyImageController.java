package kr.go.culture.magazine.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;

import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.CuldataDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.magazine.service.AgencyImageDeleteService;
import kr.go.culture.magazine.service.AgencyImageInsertService;
import kr.go.culture.magazine.service.AgencyImageStatusUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/magazine/agency")
@Controller("AgencyImageController")
public class AgencyImageController {

	private static final Logger logger = LoggerFactory
			.getLogger(CultureImageTagController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "CuldataDatabaseService")
	private CuldataDatabaseService culdataService;

	@Resource(name = "AgencyImageStatusUpdateService")
	private AgencyImageStatusUpdateService agencyImageStatusUpdateService;

	@Resource(name = "AgencyImageDeleteService")
	private AgencyImageDeleteService agencyImageDeleteService;

	@Resource(name = "AgencyImageInsertService")
	private AgencyImageInsertService agencyImageInsertService;
	
	private String[] CREATOR_CD = {"ORG01", "ORG02", "ORG03", "ORG04", "ORG05", "ORG06", "ORG07"};

	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		List<Map<String, Object>> creatorList = new ArrayList<Map<String,Object>>();
		Map<String, Object> creatorMap;
		for(String str: CREATOR_CD) {
			creatorMap = new HashMap<String, Object>();
			creatorMap.put("creatorCd", str);
			
			Map<String, Object> creatorData = getCreatorDataMap(str);
			String creator = creatorData.get("creator").toString();
			creatorMap.put("creator", creator);
			creatorList.add(creatorMap);
		}
		String paramCreator = (String)paramMap.get("creatorCd");
		
		if(paramCreator == null || "".equals(paramCreator)) paramCreator = "";
		else paramMap.put("creatorCd", paramCreator);
		
		Map<String, Object> creatorData = getCreatorDataMap(paramCreator);
		String jobGroupId = creatorData.get("jobGroupId").toString();
		String jobId = creatorData.get("jobId").toString();
		String type = creatorData.get("type").toString();
		
		String[] jobGroupIds = jobGroupId.split(",");
		String[] jobIds = jobId.split(",");
		String[] types = type.split(",");
		
		if(jobGroupIds.length > 1) {
			paramMap.put("jobGroupIds", jobGroupIds);
		} else {
			paramMap.put("jobGroupId", jobGroupId);
		}
		if(jobIds.length > 1) {
			paramMap.put("jobIds", jobIds);
		} else {
			paramMap.put("jobId", jobId);
		}
		if(types.length > 1) {
			paramMap.put("jobGroupIds", jobGroupIds);
		} else {
			paramMap.put("jobGroupIds", jobGroupIds);
		}
		
		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("creatorList", creatorList);

		model.addAttribute("count", (Integer) culdataService.readForObject(
				"agency.image.listCnt", paramMap));

		model.addAttribute("list",
				culdataService.readForList("agency.image.list", paramMap));

		return "/magazine/agencyimage/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {

		return "/magazine/agencyimage/view";
	}

	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {

			agencyImageStatusUpdateService.statusUpdate(paramMap);

		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		return "forward:/magazine/agency/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model,
			@RequestParam("uploadFile") MultipartFile uploadFile)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {

			agencyImageInsertService.insert(paramMap , uploadFile);

		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		SessionMessage.insert(request);
		
		return "redirect:/magazine/agency/list.do";
	}

	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {

			agencyImageDeleteService.delete(paramMap);

		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		SessionMessage.delete(request);
		
		return "redirect:/magazine/agency/list.do";
	}
	
	/**
	 * 기관정보
	 * @param orgCd
	 * @return
	 */
	private Map<String, Object> getCreatorDataMap(String orgCd) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> creatorMap = new HashMap<String, Object>();

		creatorMap.put("ORG01", new String[] {"강원문화재단", "GRP88", "JOB524", "C02002"});
		creatorMap.put("ORG02", new String[] {"국악방송", "GRP5", "JOB756", "B06034"});
		creatorMap.put("ORG03", new String[] {"예술경영지원센터", "GRP26", "JOB90", "A06011"});
		creatorMap.put("ORG04", new String[] {"한국문화정보원", "GRP9", "JOB43", "C02002"});
		creatorMap.put("ORG05", new String[] {"한국정책방송원", "GRP7", "JOB830,JOB829,JOB831,JOB503,JOB37", "B07021,B07021,B07021,C05005,C05005"});
		creatorMap.put("ORG06", new String[] {"한국체육산업개발", "GRP23", "JOB427", "H01001"});
		creatorMap.put("ORG07", new String[] {"한국출판문화산업진흥원", "GRP59", "JOB259", "F02015"});
		
		if(orgCd != "") {
			String[] values = (String[]) creatorMap.get(orgCd);
			resultMap.put("creator", values[0]);
			resultMap.put("jobGroupId", values[1]);
			resultMap.put("jobId", values[2]);
			resultMap.put("type", values[3]);
		} else {
			String creators = "";
			String jobGroupIds = "";
			String jobIds = "";
			String types = "";
			
			for(int i=1 ; i <= 7 ; i++){
				String[] values = (String[]) creatorMap.get("ORG0"+i);
				creators += values[0] + ",";
				jobGroupIds += values[1] + ",";
				jobIds += values[2] + ",";
				types += values[3] + ",";
			}
			resultMap.put("creator", creators);
			resultMap.put("jobGroupId", jobGroupIds);
			resultMap.put("jobId", jobIds);
			resultMap.put("type", types);
		}
		
		return resultMap;
	}
}
