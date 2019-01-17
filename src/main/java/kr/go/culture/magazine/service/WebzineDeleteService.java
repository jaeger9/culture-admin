package kr.go.culture.magazine.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("WebzineDeleteService")
public class WebzineDeleteService {

	@Resource(name="CkDatabaseService")
	CkDatabaseService ckDatabaseService;
	
	@Transactional(value = "ckTransactionManager", rollbackFor = Exception.class)
	public void delete(ParamMap paramMap) throws Exception {
		
		ckDatabaseService.delete("webzine.delete", paramMap);
		
		ckDatabaseService.delete("webzine.deleteSub", paramMap);
	}
}
