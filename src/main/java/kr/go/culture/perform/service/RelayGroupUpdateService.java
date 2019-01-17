package kr.go.culture.perform.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service("RelayGroupUpdateService")
public class RelayGroupUpdateService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void update(ParamMap paramMap, MultipartFile multi) throws Exception {

		String fileName = fileService.writeFile(multi, "relay");

		paramMap.put("file_sysname", fileName);

		ckDataBaseService.save("relay_gourp.update", paramMap);

		/*
		 * if(paramMap.containsKey("imagedelete") && paramMap.get("imagedelete").toString().equals("Y"))
		 * fileService.deleteFile("show", paramMap.get("imagedelete").toString());
		 */

	}

}