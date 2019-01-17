package kr.go.culture.main.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("ContentDeleteService")
public class ContentDeleteService {


	@Resource(name="CkDatabaseService")
	CkDatabaseService ckDatabaseService;
	
	@Transactional(value="ckTransactionManager" , rollbackFor={Exception.class})
	public void delete(ParamMap paramMap) throws Exception {
		
		ckDatabaseService.delete("content.delete", paramMap);
		ckDatabaseService.delete("content.deleteContentSub", paramMap);
	}
	
	
}
