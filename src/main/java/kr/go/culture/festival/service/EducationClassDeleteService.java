package kr.go.culture.festival.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("EducationClassDeleteService")
public class EducationClassDeleteService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Transactional(value="ckTransactionManager" , rollbackFor={Exception.class})
	public void delete(ParamMap paramMap) throws Exception { 
		
		ckDatabaseService.delete("education.class.delete", paramMap);
		ckDatabaseService.delete("education.apply.deletePseqOne", paramMap);
		
	}
}
