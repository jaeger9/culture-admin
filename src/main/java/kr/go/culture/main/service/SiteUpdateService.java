package kr.go.culture.main.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service("SiteUpdateService")
public class SiteUpdateService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void update(ParamMap paramMap, MultipartFile multi) throws Exception {

		if (paramMap.containsKey("imagedelete") && paramMap.get("imagedelete").toString().equals("Y"))
			fileService.deleteFile("site", paramMap.get("site_img").toString());

		String fileName = fileService.writeFile(multi, "site");
		paramMap.put("file_sysname", fileName);

		ckDataBaseService.save("site.update", paramMap);
	}

}