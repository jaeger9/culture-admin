package kr.go.culture.cultureplan.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("CultureSupportDeleteService")
public class CultureSupportDeleteService {

	private static final Logger logger = LoggerFactory.getLogger(CultureSupportDeleteService.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;
	
	
	@Transactional(value="ckTransactionManager" , rollbackFor={Exception.class})
	public void recomDelete(ParamMap paramMap) throws Exception{ 
		
		try {
			
			ckDataBaseService.delete("culture_support.recomDelete", paramMap);
			ckDataBaseService.delete("culture_support.recomSubDelete", paramMap);
			
		} catch (Exception e) {
			logger.error("CultureSupportDeleteService[delete]", e);
			throw e;
		}
	}
}
