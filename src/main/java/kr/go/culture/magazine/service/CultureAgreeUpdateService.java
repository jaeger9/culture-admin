package kr.go.culture.magazine.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.springframework.stereotype.Service;

@Service("CultureAgreeUpdateService")
public class CultureAgreeUpdateService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	@Resource(name = "CultureAgreeDeleteService")
	CultureAgreeDeleteService cultureAgreeDeleteService;

	@Resource(name = "CultureAgreeInsertService")
	CultureAgreeInsertService cultureAgreeInsertService;

	public void update(ParamMap paramMap) throws Exception {
		/* MultipartFile[] recomUploadFile) throws Exception { */

		cultureAgreeDeleteService.deleteTypeData(paramMap);
		ckDatabaseService.save("culture.agree.update", paramMap);
		cultureAgreeInsertService.insertTypeData(paramMap, paramMap.getInt("type"));
	}

}