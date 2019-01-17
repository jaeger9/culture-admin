package kr.go.culture.pattern.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.springframework.stereotype.Service;

@Service("DBUseDesignDeleteService")
public class DBUseDesignDeleteService {
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	public void delete(ParamMap paramMap) throws Exception {
		
		ckDatabaseService.delete("db.design.deleteUse", paramMap);
		
		String[] usec_upids = paramMap.getArray("usec_upid");
		
		for(String usec_upid : usec_upids) {
			ckDatabaseService.delete("db.design.deleteUpct", usec_upid);
		}
		
	}
}
