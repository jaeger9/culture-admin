package kr.go.culture.festival.web;

import java.util.Enumeration;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.festival.service.EventInsertService;
import kr.go.culture.festival.service.EventUpdateService;
import kr.go.culture.festival.service.FestivalMobileUpdateService;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;


@RequestMapping("/festival/event/")
@Controller("FestivalEventController")
public class EventController {

	private static final Logger logger = LoggerFactory.getLogger(EventController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "FestivalEventInsertService")
	private EventInsertService eventInsertService;
	
	@Resource(name = "FestivalEventUpdateService")
	private EventUpdateService eventUpdateService;

	@Resource(name = "FileService")
	private FileService fileService;
	
	@Resource(name = "FestivalMobileUpdateService")
	private FestivalMobileUpdateService FestivalMobileUpdateService;
	
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		//나중에 enum 이던 property 던 빼라...
		paramMap.put("type", new String[]{"50"});
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("officeList" , ckDatabaseService.readForList("show.officeList", paramMap));
		model.addAttribute("count",
				(Integer) ckDatabaseService.readForObject("festival.event.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("festival.event.list", paramMap));

		return "/festival/event/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("common_code_type", "LOCATION");
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("locationList", ckDatabaseService.readForList("common.codeList", paramMap));
		
		if (paramMap.containsKey("uci"))
			model.addAttribute("view",
					ckDatabaseService.readForObject("festival.event.view", paramMap));

		return "/festival/event/view";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("festival.event.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/festival/event/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request , ModelMap model ,  @RequestParam("uploadFile") MultipartFile multi,
			@RequestParam("styurl1") MultipartFile styurl1,
			@RequestParam("styurl2") MultipartFile styurl2,
			@RequestParam("styurl3") MultipartFile styurl3,
			@RequestParam("styurl4") MultipartFile styurl4

			) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("creator", request.getSession().getAttribute("admin_id"));
		try {
			//이것도 어디 밖아두고 써라 나중에..
			paramMap.put("type", "50");
			
			eventInsertService.insert(paramMap, multi,"file_sysname");
			eventInsertService.insert(paramMap, styurl1,"styurl1");
			eventInsertService.insert(paramMap, styurl2,"styurl2");
			eventInsertService.insert(paramMap, styurl3,"styurl3");
			eventInsertService.insert(paramMap, styurl4,"styurl4");
			
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.insert(request);
		
		return "redirect:/festival/event/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request , ModelMap model ,@RequestParam("uploadFile") MultipartFile multi,
			@RequestParam("styurl1") MultipartFile styurl1,
			@RequestParam("styurl2") MultipartFile styurl2,
			@RequestParam("styurl3") MultipartFile styurl3,
			@RequestParam("styurl4") MultipartFile styurl4) throws Exception { 
	
		ParamMap paramMap = new ParamMap(request);
		
		try {
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
			


			
			//FestivalMobileUpdateService.Mupdate(paramMap);
			if ("Y".equals(paramMap.getString("mobile_yn"))) {
				FestivalMobileUpdateService.Mupdate(paramMap);
			}else{
				FestivalMobileUpdateService.MdescUpdate(paramMap);
			}
			
			eventUpdateService.update(paramMap, multi,"file_sysname");
			eventUpdateService.update(paramMap, styurl1,"styurl1");
			eventUpdateService.update(paramMap, styurl2,"styurl2");
			eventUpdateService.update(paramMap, styurl3,"styurl3");
			eventUpdateService.update(paramMap, styurl4,"styurl4");
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		SessionMessage.update(request);
		
		return "redirect:/festival/event/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			

	        if("view".equals(paramMap.getString("mode"))){ 
	        	if(!"".equals(paramMap.getString("file_delete"))){
	        		fileService.deleteFile("show", paramMap.getString("file_delete"));
	        	}
	        }else{
	        	listFileDelte(request);
	        }
			
			ckDatabaseService.delete("show.delete", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		SessionMessage.delete(request);
		
		return "redirect:/festival/event/list.do";
	}
	
	/*
	 * 축제/행사 list  파일 삭제 추가
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
							HashMap<String , Object> map =  (HashMap) ckDatabaseService.readForObject("festival.event.view", paramMap);
//							System.out.println(":::::parameters[i]::::"+parameters[i]+":::file:::"+(String)map.get("reference_identifier_org"));
							if(map.get("reference_identifier_org") !=null){
//								System.out.println(":::file not null:::"+(String)map.get("reference_identifier_org"));
								fileService.deleteFile("show", (String)map.get("reference_identifier_org"));
							}
						}
					}
			
				} 
			} 
	}
	
	
	
}
