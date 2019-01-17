package kr.go.culture.magazine.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.springframework.stereotype.Service;

@Service("CultureAgreeDeleteService")
public class CultureAgreeDeleteService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	public void delete(ParamMap paramMap) throws Exception { 
		
		// 
		ckDatabaseService.delete("culture.agree.delete", paramMap);
		
		deleteTypeData(paramMap);
	}
	
	protected void deleteTypeData(ParamMap paramMap) throws Exception{ 
		ckDatabaseService.delete("culture.agree.deleteCultureImg", paramMap);
		ckDatabaseService.delete("culture.agree.deleteCultureText", paramMap);		
	}
}
