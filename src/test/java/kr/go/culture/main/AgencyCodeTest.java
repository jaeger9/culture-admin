package kr.go.culture.main;

import static org.junit.Assert.fail;

import org.junit.After;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { 
//			"classpath*:/META-INF/spring/quartz-context.xml"
		"file:src/main/webapp/WEB-INF/spring/appServlet/admin-datasource.xml", 
		"file:src/main/webapp/WEB-INF/spring/appServlet/admin-sqlmap.xml", 
		"file:src/main/webapp/WEB-INF/spring/appServlet/admin-context.xml", 
})
public class AgencyCodeTest {

	@Value("${file.upload.base.location}")
	private String filUploadBaseLocation;
	
	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void test() {
		System.out.println("filUploadBaseLocation:" + filUploadBaseLocation);
	}

}
