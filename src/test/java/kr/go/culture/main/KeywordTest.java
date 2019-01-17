package kr.go.culture.main;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.go.culture.common.service.CkDatabaseService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.junit.After;
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
public class KeywordTest {


	@Resource(name="CkDatabaseService")
	CkDatabaseService ckDatabaseService;
	

	@Test
	public void keywordList() {
		try {
			System.out.println(ckDatabaseService.readForObject("keyword.list", null));			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}