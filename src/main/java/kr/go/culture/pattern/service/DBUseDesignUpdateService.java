package kr.go.culture.pattern.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service("DBUseDesignUpdateService")
public class DBUseDesignUpdateService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	private String[] menuTypes = { "use_design", "use_design_80" };

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void update(ParamMap paramMap, MultipartFile[] uploadFiles) throws Exception {

		setFileName(paramMap, uploadFiles);

		ckDataBaseService.save("db.design.update", paramMap);

		String[] UpctList = getUpctList(paramMap);

		if (UpctList != null) {
			updatePwomupct(paramMap, UpctList);
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

	private void updatePwomupct(ParamMap paramMap, String[] UpctList) throws Exception {

		ckDataBaseService.delete("db.design.deleteUpct", paramMap.getString("usec_upid"));
		paramMap.put("upct_upid", paramMap.get("usec_upid"));

		for (String upct_ctid : UpctList) {
			paramMap.put("upct_ctid", upct_ctid);
			ckDataBaseService.insert("db.design.insertUpct", paramMap);
		}
	}

}
