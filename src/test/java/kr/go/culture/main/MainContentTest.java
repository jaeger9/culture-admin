package kr.go.culture.main;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.go.culture.common.service.CkDatabaseService;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { 
//			"classpath*:/META-INF/spring/quartz-context.xml"
		"file:src/main/webapp/WEB-INF/spring/appServlet/admin-datasource.xml", 
		"file:src/main/webapp/WEB-INF/spring/appServlet/admin-sqlmap.xml", 
		"file:src/main/webapp/WEB-INF/spring/appServlet/admin-context.xml", 
})
public class MainContentTest {
	
	@Resource(name="CkDatabaseService")
	CkDatabaseService ckDatabaseService;

	@Test
	public void mainContentView() {
		List<Object> list = null;
		
		HashMap<String , String> param = new HashMap<String , String>();
		
		try {
			param.put("seq", "3");
			
			list = ckDatabaseService.readForList("maincontent.view", param);
			grouping(list);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@SuppressWarnings("unchecked")
	public void grouping(List<Object> list) throws Exception {
		Map<String, List<HashMap<String , String>>> groupMap = new HashMap<String, List<HashMap<String , String>>>();
		HashMap<String , String> data = null;
		String name = null;
		
		for(Object obj : list) { 
			data = (HashMap<String , String>)obj;
			name = data.get("name");
			
			if(groupMap.containsKey(name)){
				List<HashMap<String , String>> groupList = groupMap.get(name);
				groupList.add(data);
		    }else{
		    	List<HashMap<String , String>> groupList = new ArrayList<HashMap<String , String>>();
		    	groupList.add(data);
		    	groupMap.put(name, groupList);
		    }
		}
		
		System.out.println("Group Map :" + groupMap.toString());
	}
}
