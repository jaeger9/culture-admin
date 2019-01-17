package kr.go.culture.resource.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ResPageUpdateService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;
	

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void update(ParamMap paramMap, MultipartFile multi) throws Exception {

		if( multi.getSize() > 0 ){
			String fileName = fileService.writeFile(multi, "resource_page");
			paramMap.put("image", fileName);
		}
		
		service.save("resPage.update", paramMap);

	}

}