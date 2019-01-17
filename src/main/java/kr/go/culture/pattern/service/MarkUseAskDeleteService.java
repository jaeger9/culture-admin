package kr.go.culture.pattern.service;

import java.util.HashMap;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("MarkUseAskDeleteService")
public class MarkUseAskDeleteService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Transactional(value="ckTransactionManager" , rollbackFor={Exception.class})
	public void delete(ParamMap paramMap) throws Exception { 
		
		ckDatabaseService.delete("ask.deleteUseMark", paramMap);
		
		ckDatabaseService.save("ask.delete" , paramMap);
		
	}
	
}
