package kr.go.culture.main.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.annotation.Resource;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.springframework.stereotype.Service;

@Service("KeywordViewService")
public class KeywordViewService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	public CommonModel view(ParamMap paramMap) throws Exception{ 
		
		Object object = null;
		try {
			
			object = ckDatabaseService.readForObject("keyword.view", paramMap);
			
			return setKeywordList(object);
			
		} catch (Exception e) {
			throw e;
		} 
	}
	
	private CommonModel setKeywordList(Object object) throws Exception {
		
		CommonModel model = null;
		
		try {
			
			if(object instanceof CommonModel) { 
				
				model = (CommonModel)object;
				
				String keyword = (String)model.get("keyword");
				String[] keywords = keyword.split(",");
				
				model.put("keywords", Arrays.asList(keywords));
			}
			
			return model;
			
		} catch (Exception e) {
			throw e;
		}
	}
}
