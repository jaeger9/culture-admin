package kr.go.culture.festival.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.go.culture.common.service.FileService;

@Service("FestivalEventUpdateService")
public class EventUpdateService {
	/*
	 * @Resource(name = "CkDatabaseService") private CkDatabaseService
	 * ckDataBaseService;
	 */

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public String update(MultipartFile multi) throws Exception {

		String fileName = fileService.writeFile(multi, "show");
		return fileName;
		/*
		 * paramMap.put(sys_filename, fileName);
		 * 
		 * ckDataBaseService.save("festival.event.update", paramMap);
		 */

		/*
		 * if(paramMap.containsKey("imagedelete") && paramMap.get("imagedelete").toString().equals("Y"))
		 * fileService.deleteFile("show", paramMap.get("imagedelete").toString());
		 */

	}

}