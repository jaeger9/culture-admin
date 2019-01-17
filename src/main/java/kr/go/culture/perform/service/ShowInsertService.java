package kr.go.culture.perform.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service("ShowInsertService")
public class ShowInsertService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void insert(ParamMap paramMap, MultipartFile multi) throws Exception {
		String fileName = fileService.writeFile(multi, "show");
		paramMap.put("file_sysname", fileName);

		String uci = (String) ckDataBaseService.insert("show.insert", paramMap);
		paramMap.put("uci", uci);
		
		ckDataBaseService.save("show.updateShow", paramMap);	//공연정보(시도,군구) Update
	}

}