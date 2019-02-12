package kr.go.culture.festival.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.go.culture.common.service.FileService;

@Service("FestivalEventInsertService")
public class EventInsertService {

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

		//ckDataBaseService.save("festival.event.insert", paramMap);

	}

}