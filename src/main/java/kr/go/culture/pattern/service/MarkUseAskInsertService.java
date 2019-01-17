package kr.go.culture.pattern.service;

import java.util.HashMap;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("MarkUseAskInsertService")
public class MarkUseAskInsertService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Transactional(value="ckTransactionManager" , rollbackFor={Exception.class})
	public void insert(ParamMap paramMap) throws Exception { 
		
		int seq = (Integer)ckDatabaseService.insert("ask.insert", paramMap);
		paramMap.put("seq", seq);
		
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
