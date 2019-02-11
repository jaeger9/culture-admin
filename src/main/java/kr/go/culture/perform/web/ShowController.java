package kr.go.culture.perform.web;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.main.web.SiteController;
import kr.go.culture.perform.service.ShowInsertService;
import kr.go.culture.perform.service.ShowUpdateService;
import kr.go.culture.perform.service.MobileUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/perform/show")
@Controller("ShowController")
public class ShowController {

	private static final Logger logger = LoggerFactory.getLogger(SiteController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	@Resource(name = "ShowInsertService")
	private ShowInsertService showInsertService;

	@Resource(name = "ShowUpdateService")
	private ShowUpdateService showUpdateService;
	
	@Resource(name = "MobileUpdateService")
	private MobileUpdateService MobileUpdateService;

	@Resource(name = "FileService")
	private FileService fileService;

	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		// 나중에 enum 이던 property 던 빼라...
		paramMap.put("type", new String[] { "06", "08" });

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("officeList", ckDatabaseService.readForList("show.officeList", paramMap));
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("show.listCnt", paramMap));
		model.addAttribute("list", ckDatabaseService.readForList("show.list", paramMap));

		return "/perform/show/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("common_code_type", "GENRE");

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("genreList", ckDatabaseService.readForList("common.codeList", paramMap));

		if (paramMap.containsKey("uci")) {
			model.addAttribute("view", ckDatabaseService.readForObject("show.view", paramMap));
		}

		return "/perform/show/view";
	}

	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckDatabaseService.save("show.statusUpdate", paramMap);

		return "forward:/perform/show/list.do";
	}

	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model, @RequestParam("uploadFile") MultipartFile multi,
			@RequestParam("styurl1") MultipartFile styurl1,
			@RequestParam("styurl2") MultipartFile styurl2,
			@RequestParam("styurl3") MultipartFile styurl3,
			@RequestParam("styurl4") MultipartFile styurl4) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("type", "06");

		showInsertService.insert(paramMap, multi,"file_sysname");
		showInsertService.insert(paramMap, styurl1,"styurl1");
		showInsertService.insert(paramMap, styurl2,"styurl2");
		showInsertService.insert(paramMap, styurl3,"styurl3");
		showInsertService.insert(paramMap, styurl4,"styurl4");
		

		SessionMessage.insert(request);

		return "redirect:/perform/show/list.do";
	}

	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model, @RequestParam("uploadFile") MultipartFile multi,
			@RequestParam("styurl1") MultipartFile styurl1,
			@RequestParam("styurl2") MultipartFile styurl2,
			@RequestParam("styurl3") MultipartFile styurl3,
			@RequestParam("styurl4") MultipartFile styurl4) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		//이미지 삭제기능 추가
		if (paramMap.containsKey("imagedelete")) {
			fileService.deleteFile("show", paramMap.getString("file_delete"));
		}
		if (paramMap.containsKey("imagedelete_styurl1")) {
			fileService.deleteFile("show", paramMap.getString("file_delete_styurl1"));
		}
		if (paramMap.containsKey("imagedelete_styurl2")) {
			fileService.deleteFile("show", paramMap.getString("file_delete_styurl2"));
		}
		if (paramMap.containsKey("imagedelete_styurl3")) {
			fileService.deleteFile("show", paramMap.getString("file_delete_styurl3"));
		}
		if (paramMap.containsKey("imagedelete_styurl4")) {
			fileService.deleteFile("show", paramMap.getString("file_delete_styurl4"));
		}
		
		/** 추가**/
		//String desc = request.getParameter("description");
		//String uci = request.getParameter("uci");
		//MobileUpdateService.Mupdate(desc,uci);
//		System.out.println(":::::paramMap.getString(mobile_yn):::"+paramMap.getString("mobile_yn"));
		if ("Y".equals(paramMap.getString("mobile_yn"))) {
			MobileUpdateService.Mupdate(paramMap);
		}else{
			MobileUpdateService.MdescUpdate(paramMap);
		}
		
		showUpdateService.update(paramMap, multi,"file_sysname");
		showUpdateService.update(paramMap, styurl1,"styurl1");
		showUpdateService.update(paramMap, styurl2,"styurl2");
		showUpdateService.update(paramMap, styurl3,"styurl3");
		showUpdateService.update(paramMap, styurl4,"styurl4");

		SessionMessage.update(request);

		return "redirect:/perform/show/list.do";
	}

	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		
        if("view".equals(paramMap.getString("mode"))){ 
        	if(!"".equals(paramMap.getString("file_delete"))){
        		fileService.deleteFile("show", paramMap.getString("file_delete"));
        	}
        }else{
        	listFileDelte(request);
        }
        
		ckDatabaseService.delete("show.delete", paramMap);

		SessionMessage.delete(request);

		return "redirect:/perform/show/list.do";
	}
	/*
	 *  공연/전시 리스트 파일 삭제
	 */
	
	public void listFileDelte(HttpServletRequest request) throws Exception {
		 ParamMap paramMap = new ParamMap(request);
		 Enumeration enums = request.getParameterNames();
		 while(enums.hasMoreElements()){ 
				String paramName = (String)enums.nextElement(); 
				String[] parameters = request.getParameterValues(paramName); 
				// Parameter가 배열일 경우 
				if(parameters.length > 1){ 
					for(int i= 0; i<parameters.length;i++){
						if(!parameters[i].isEmpty()){
							paramMap.put("uci", parameters[i].replaceAll("%2b","+"));
							HashMap<String , Object> map =  (HashMap) ckDatabaseService.readForObject("show.view", paramMap);
//							System.out.println(":::::parameters[i]::::"+parameters[i]+":::file:::"+(String)map.get("reference_identifier_org"));
							if(map.get("reference_identifier_org") !=null){
//								System.out.println(":::file not null:::"+(String)map.get("reference_identifier_org"));
								fileService.deleteFile("show", (String)map.get("reference_identifier_org"));
							}
						}
					}
			
				} 
			} 
	}//end listFileDelte
	
	/** mobile Thumbnail 생성
	 * 2017.10.20
	 */
	
}