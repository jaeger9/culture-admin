package kr.go.culture;

import javax.annotation.Resource;

import kr.go.culture.common.service.CkDatabaseService;
import net.sf.json.JSONObject;

import org.junit.After;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.google.gson.Gson;



/**
 * 
 * @author CYS
 * junit test 시 admin-datasource.xml db 정보 담고 있는 property location 파일 real 또는 dev 파일 읽도록 수정 해야 함
 * 
 * 샘플의 경우 DB 조회만 함 ㅋㅋ
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { 
//			"classpath*:/META-INF/spring/quartz-context.xml"
		"file:src/main/webapp/WEB-INF/spring/appServlet/admin-datasource.xml", 
		"file:src/main/webapp/WEB-INF/spring/appServlet/admin-sqlmap.xml", 
		"file:src/main/webapp/WEB-INF/spring/appServlet/admin-context.xml", 
})
public class Sample {

	@Resource(name="CkDatabaseService")
	CkDatabaseService service;

	@Test
	public void test() {
		try {
			service.readForList("login.getUrlResourceAll", null);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
