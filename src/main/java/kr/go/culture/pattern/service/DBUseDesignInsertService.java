package kr.go.culture.pattern.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service("DBUseDesignInsertService")
public class DBUseDesignInsertService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void insert(ParamMap paramMap, MultipartFile[] uploadFiles) throws Exception {

		setFileName(paramMap, uploadFiles);

		String usec_upid = ckDataBaseService.insert("db.design.insertUse", paramMap).toString();

		String[] UpctList = getUpctList(paramMap);

		if (UpctList != null) {
			paramMap.put("upct_upid", usec_upid);
			insertPwomupct(paramMap, UpctList);
		}
	}

	private void setFileName(ParamMap paramMap, MultipartFile[] uploadFiles) throws Exception {
		if (uploadFiles != null && uploadFiles.length > 0) {
			paramMap.put("usec_thum", fileService.writeFile(uploadFiles[0], "use_design"));
			
			if (uploadFiles.length > 1) {
				paramMap.put("usec_file", fileService.writeFile(uploadFiles[1], "use_design_80"));
			}
		}
	}

	private String[] getUpctList(ParamMap paramMap) {
		String usec_ctid = paramMap.getString("usec_ctid");

		if (usec_ctid != null)
			return usec_ctid.split(",");
		else
			return null;
	}

	private void insertPwomupct(ParamMap paramMap, String[] UpctList) throws Exception {

		for (String upct_ctid : UpctList) {
			paramMap.put("upct_ctid", upct_ctid);
			ckDataBaseService.insert("db.design.insertUpct", paramMap);
		}
	}
}
