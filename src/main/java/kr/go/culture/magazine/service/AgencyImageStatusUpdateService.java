package kr.go.culture.magazine.service;

import java.util.HashMap;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CuldataDatabaseService;

@Service("AgencyImageStatusUpdateService")
public class AgencyImageStatusUpdateService {

	@Resource(name = "CuldataDatabaseService")
	private CuldataDatabaseService culdataService;

	@Transactional(value="ckTransactionManager" , rollbackFor={Exception.class})
	public void statusUpdate(ParamMap paramMap) throws Exception {
			
		String[] seqs = paramMap.getArray("seq");
		String updateStatus =  paramMap.getString("updateStatus");
		
		for(String key : seqs) {
			statusUpdate(key , updateStatus);
		}
	}
	
	private void statusUpdate(String key , String updateStatus) throws Exception { 
		HashMap<String , String> data = new HashMap<String , String>();
		
		data.put("updateStatus", updateStatus);
		data.put("seq", key);
		
		culdataService.save("agency.image.updateStatusPublicMovForRdf", data);
	}
}
