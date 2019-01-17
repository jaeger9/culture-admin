package kr.go.culture.magazine;

import java.util.HashMap;

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
public class RecomTest {

	@Resource(name="CkDatabaseService")
	CkDatabaseService service;

	@SuppressWarnings("unchecked")
//	@Test
	public void test() {
		
		HashMap<String , String> param = null;
		
		try {
			param = new HashMap<String , String>();
			param.put("oid", "105");
			
			HashMap<String , String> result = (HashMap<String , String>)service.readForObject("recom.textView", param);

			System.out.println(result.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	@Test
	public void iterateTest() { 
		HashMap<String , Object> param = new HashMap<String , Object>();
		
		param.put("approval" , "N");
		param.put("top_yn" , "N");
		param.put("uci" , "G7061412653819503");
		
		try {
			service.save("perform.approvalUpdate", param);	
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
