package kr.go.culture.pattern.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service("DBApplyContentUpdateService")
public class DBApplyContentUpdateService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void update(ParamMap paramMap, MultipartFile multi) throws Exception {

		String fileName = fileService.writeFile(multi, "pattern_content");
		paramMap.put("file_sysname", fileName);

		ckDataBaseService.save("db.content.update", paramMap);

		/*
		 * if(paramMap.containsKey("imagedelete") && paramMap.get("imagedelete").toString().equals("Y"))
		 * fileService.deleteFile("show", paramMap.get("imagedelete").toString());
		 */

		/*
		 * paramMap.put("ecim_utid", session.getAttribute("ADMIN_ID"));
		 * paramMap.put("ecim_rgid", session.getAttribute("ADMIN_ID"));
		 */
		paramMap.put("ecim_utid", "admin");
		paramMap.put("ecim_rgid", "admin");

	}
}
