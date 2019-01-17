package kr.go.culture.education.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("HumanLectureDeleteService")
public class HumanLectureDeleteService {

	private static final Logger logger = LoggerFactory.getLogger(HumanLectureDeleteService.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;
	
	
	@Transactional(value="ckTransactionManager" , rollbackFor={Exception.class})
	public void delete(ParamMap paramMap) throws Exception{ 
		
		try {
			
			ckDataBaseService.delete("human_lecture.recomDelete", paramMap);
			ckDataBaseService.delete("human_lecture.recomSubDelete", paramMap);
			
		} catch (Exception e) {
			logger.error("HumanLectureDeleteService[delete]", e);
			throw e;
		}
	}
}
