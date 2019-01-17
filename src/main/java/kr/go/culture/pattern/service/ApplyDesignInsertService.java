package kr.go.culture.pattern.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service("ApplyDesignInsertService")
public class ApplyDesignInsertService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void insert(ParamMap paramMap, MultipartFile[] uploadFiles) throws Exception {

		setFileName(paramMap, uploadFiles);

		ckDataBaseService.insert("apply.design.insert", paramMap);
	}

	private void setFileName(ParamMap paramMap, MultipartFile[] uploadFiles) throws Exception {
		if (uploadFiles != null && uploadFiles.length > 0) {
			paramMap.put("thumbnail_name", fileService.writeFile(uploadFiles[0], "apply_design"));

			if (uploadFiles.length > 1) {
				paramMap.put("image_name", fileService.writeFile(uploadFiles[1], "apply_design"));
			}
		}
	}

}