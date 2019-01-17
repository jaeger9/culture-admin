package kr.go.culture.pattern.service;

import java.util.HashMap;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("CodeManageDeleteService")
public class CodeManageDeleteService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;
	
	@Transactional(value="ckTransactionManager" , rollbackFor={Exception.class})
	public void delete (ParamMap paramMap) throws Exception { 
		
		String [] keys = paramMap.getArray("key");
		
		if(keys != null && keys.length > 0) {
			
			for(String key : keys) {
				HashMap<String , String> map = new HashMap<String , String>();
				
				String[] arr = key.split(":");
				
				map.put("cded_code", arr[0]);
				map.put("cded_pcde", arr[1]);
				ckDataBaseService.delete("code.manage.delete" , map);
			}
		}
	}

}
