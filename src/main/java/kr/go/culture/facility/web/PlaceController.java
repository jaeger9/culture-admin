package kr.go.culture.facility.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.facility.service.PlaceInsertService;
import kr.go.culture.facility.service.PlaceUpdateService;
import kr.go.culture.facility.service.RentalApplyStatusUpdateService;
import kr.go.culture.facility.service.FacilityMobileUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/facility/place/")
@Controller("PlaceController")
public class PlaceController {

	private static final Logger logger = LoggerFactory.getLogger(PlaceController.class);

	// 시퐁
	private String[] grp1_code =	{"100","200","300","400","500","600","700","800"};
	private String[] grp1_name =	{"공연장","미술관","박물관","문화/복지/시군구회관","도서관","기타문화공간","영화관","문화재"};
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	@Resource(name = "PlaceInsertService")
	private PlaceInsertService placeInsertService;

	@Resource(name = "PlaceUpdateService")
	private PlaceUpdateService placeUpdateService;
	
	@Resource(name = "RentalApplyStatusUpdateService")
	private RentalApplyStatusUpdateService rentalApplyStatusUpdateService;

	@Resource(name = "FileService")
	private FileService fileService;
	
	
	@Resource(name = "FacilityMobileUpdateService")
	private FacilityMobileUpdateService FacilityMobileUpdateService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("grpCodeList" , getGrpCodeList());
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("place.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("place.list", paramMap));

//		return "/facility/place/list";
		return "thymeleaf/facility/place/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("genreList", ckDatabaseService.readForList("common.codeList", paramMap));
		
		if (paramMap.containsKey("cul_seq")) { 
			model.addAttribute("view",
					ckDatabaseService.readForObject("place.view", paramMap));
			model.addAttribute("rentalView",
					ckDatabaseService.readForObject("place.rentalView", paramMap));
		}

		return "/facility/place/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("place.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/facility/place/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request , ModelMap model ,  @RequestParam("uploadFile") MultipartFile multi , HttpSession session) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
			
			paramMap.put("admin_id", session.getAttribute("admin_id"));
			
			placeInsertService.insert(paramMap, multi);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);
		
		return "redirect:/facility/place/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request , ModelMap model ,@RequestParam("uploadFile") MultipartFile multi  , HttpSession session) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
			//이미지 삭제기능 추가
			if (paramMap.containsKey("imagedelete")) {
				fileService.deleteFile("place", paramMap.getString("file_delete"));
			}
			
			paramMap.put("admin_id", session.getAttribute("admin_id"));
			
			
			if ("Y".equals(paramMap.getString("mobile_yn"))) {
//				paramMap.put("gubun", "place");
				FacilityMobileUpdateService.Mupdate(paramMap);
			}else{
				FacilityMobileUpdateService.MdescUpdate(paramMap);
			}
			
//			FacilityMobileUpdateService.Mupdate(paramMap);
			
			placeUpdateService.update(paramMap, multi);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.update(request);
		
		return "redirect:/facility/place/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.delete("place.delete", paramMap);
			
			/*
			 * 2016.03.17
			 * GIS_FACILITY_INFO DELETE
			 * PCN Choi Won-Young
			 */
			ckDatabaseService.delete("place.deleteFacilityMapInfo", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.delete(request);
		
		return "redirect:/facility/place/list.do";
	}
	
	//Rental 
	
	@RequestMapping("rentalapplylist")
	public String rentalapplylist(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("place.rentalApplyListCnt", paramMap));
		model.addAttribute("list",ckDatabaseService.readForList("place.rentalApplyList", paramMap));
		if (paramMap.containsKey("cul_seq")) { 
			model.addAttribute("view",
					ckDatabaseService.readForObject("place.view", paramMap));
			model.addAttribute("rentalView",
					ckDatabaseService.readForObject("place.rentalView", paramMap));
		}
		return "/facility/place/rentalapplylist";
	}
	
	@RequestMapping("rentalStatusUpdate.do")
	public String rentalStatusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			model.addAttribute("paramMap", paramMap);
			rentalApplyStatusUpdateService.statusUpdate(paramMap);
			//ckDatabaseService.save("place.rentalStatusUpdate", paramMap);
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/facility/place/rentalapplylist.do";
	}
	
	private List<HashMap<String , String>> getGrpCodeList() throws Exception {
		List<HashMap<String , String>> list = new ArrayList<HashMap<String , String>>(); 
		
		try {

			
			int grpCodeSize = grp1_code.length;
			
			for(int index = 0 ; index < grpCodeSize ; index++ ) {
				HashMap<String , String> grpCodeMap = new HashMap<String , String>();
				grpCodeMap.put("value" , grp1_code[index]);
				grpCodeMap.put("name", grp1_name[index]);
				
				list.add(grpCodeMap);
			}
			
		} catch (Exception e) {
			throw e;
		}
		
		return list;
	}
}
