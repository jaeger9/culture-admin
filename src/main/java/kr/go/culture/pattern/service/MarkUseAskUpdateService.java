package kr.go.culture.pattern.service;

import java.util.HashMap;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("MarkUseAskUpdateService")
public class MarkUseAskUpdateService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Transactional(value="ckTransactionManager" , rollbackFor={Exception.class})
	public void update(ParamMap paramMap) throws Exception { 
		
		ckDatabaseService.delete("ask.deleteUseMark", paramMap);
		
		ckDatabaseService.save("ask.update" , paramMap);
		
		insertUserMark(paramMap);
	}
	
	private void insertUserMark(ParamMap paramMap) throws Exception { 
		
		String[] dids = paramMap.getArray("did");
		String[] gubuns = paramMap.getArray("pattern_gubun");
		
		int cnt = 0;
		for(String did : dids) {
			HashMap<String, Object> map = new HashMap<String , Object>();
			
			map.put("seq", paramMap.get("seq"));
			map.put("pattern_code", did);
			map.put("pattern_gubun", gubuns[cnt]);
			cnt++;
			
			ckDatabaseService.insert("ask.insertUseMark", map);
		}
	}
}
