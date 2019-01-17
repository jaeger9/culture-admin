package kr.go.culture.common.domain;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;

import oracle.sql.CLOB;

public class CommonModel extends HashMap<String , Object> {

	private static final long serialVersionUID = -8976899229879708006L;

	@Override
	public Object put(String key, Object value) {
		
		String strValue = null;

		if (value != null) {
			if(value instanceof oracle.sql.CLOB)
				strValue = clobToString((CLOB)value);
			else 
				strValue = value.toString();
		}
		
		super.put(key.toLowerCase(), strValue);
		
		return null;
	}
	
	private String clobToString (CLOB clob) { 
		BufferedReader br =  null;

		StringBuffer result = null;
		String readLine = null;
		
		try {
			
			br = new BufferedReader(clob.getCharacterStream());
			result = new StringBuffer();
			
			while((readLine = br.readLine()) != null)  
				result.append(readLine);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(br != null)
					br.close();
			} catch (IOException io) {
			}
		}
		
		return result.toString();
	}
}
