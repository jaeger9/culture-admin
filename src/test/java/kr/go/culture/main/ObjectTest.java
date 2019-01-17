package kr.go.culture.main;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.junit.After;
import org.junit.Test;

public class ObjectTest {

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void test() {
		HashMap<String , Object> param = new HashMap<String , Object>();
		
		
		try {
			List b = new ArrayList();
			b.add("b1");
			b.add("b2");
			
			param.put("a", "aaaaaaaaaaa");
			param.put("b", b);
			
			if(param.get("b") instanceof java.util.ArrayList){ 
				System.out.println("array");
			}
			
			System.out.println(param.get("a").getClass());
			System.out.println(param.get("b").getClass());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
