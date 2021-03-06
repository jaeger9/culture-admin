package kr.go.culture.perform.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.go.culture.common.service.FileService;

@Service("ShowInsertService")
public class ShowInsertService {
	/*
	 * @Resource(name = "CkDatabaseService") private CkDatabaseService
	 * ckDataBaseService;
	 */

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public String insert(MultipartFile multi) throws Exception {
		String fileName = fileService.writeFile(multi, "show");
		return fileName;
		/*paramMap.put(sys_filename, fileName);

		String uci = (String) ckDataBaseService.insert("show.insert", paramMap);
		paramMap.put("uci", uci);
		
		ckDataBaseService.save("show.updateShow", paramMap);	*///공연정보(시도,군구) Update
	}

}