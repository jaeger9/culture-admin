package kr.go.culture.magazine.service;

import java.util.HashMap;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("AgencyImageDeleteService")
public class AgencyImageDeleteService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	@Transactional(value="ckTransactionManager" , rollbackFor={Exception.class})
	public void delete(ParamMap paramMap) throws Exception {
		
		
		String[] seqs = paramMap.getArray("seq");
		
		for(String str : seqs) { 
		
			String[] data = str.split(":");
			
			if(data.length == 2) { 
				String key = data[0];
				String type = data[1];
				
				System.out.println("key:" + key + "\t type:" + type);
			
				delete(key , type );
			}
			
			
		}
	}
	
	private void delete(String key , String type) throws Exception { 
		
		if(type.equals("1")) { 
			ckDatabaseService.delete("agency.image.deletePublicMovForRdf", key);
		} else if (type.equals("2")) {
			ckDatabaseService.delete("agency.image.deleteStatusPublicMov", key);
		}
	}
}
