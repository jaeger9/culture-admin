package kr.go.culture.common.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("RequestService")
public class RequestService {

	private static final Logger logger = LoggerFactory
			.getLogger(RequestService.class);

	public HashMap<String, Object> getParam(HttpServletRequest request) {

		HashMap<String, Object> paramMap = null;
		Iterator<String> iter = null;

		try {
			paramMap = new HashMap<String, Object>();
			iter = request.getParameterMap().keySet().iterator();

			while (iter.hasNext()) {
				String key = (String) iter.next();
				String[] value = request.getParameterValues(key);

				System.out.println("key:" + key + "\t value :" + value.toString());
				
				if(value == null) { 
					
				} else { 
					
				}
/*				if (paramMap.containsKey(key)) {
					if (paramMap.get(key) instanceof java.lang.String) {
						List<Object> multiParams = new ArrayList<Object>();
						multiParams.add(paramMap.get(key));
						multiParams.add(value);

						paramMap.put(key, multiParams);
					} else if (paramMap.get(key) instanceof java.util.ArrayList) {
						Arrays.asList(paramMap.get(key)).add(value);
					}

				}*/
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return null;
	}
	
	public void getMultiNameParam(HttpServletRequest request) { 
		
	}
}
