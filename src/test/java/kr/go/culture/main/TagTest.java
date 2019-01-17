package kr.go.culture.main;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.KiissDataBaseService;

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
public class TagTest {

	@Resource(name="KiissDataBaseService")
	KiissDataBaseService kiissDataBaseService;
	
	@Test
	public void test() {
		ParamMap data = new ParamMap();
		
		try {
			data.put("snum", 1);
			data.put("enum", 10);
			System.out.println("tag List :" + kiissDataBaseService.readForList("tag.list" , data).toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
