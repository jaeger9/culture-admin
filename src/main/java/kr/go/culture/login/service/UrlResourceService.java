package kr.go.culture.login.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.go.culture.common.dao.CkDAO;
import kr.go.culture.login.dao.LoginDAO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.access.SecurityConfig;
import org.springframework.stereotype.Service;

@Service("urlResourceService")
public class UrlResourceService {

	@Autowired
	@Resource(name = "LoginDAO")
	private LoginDAO loginDAO;
	
	public Map<String, Collection<ConfigAttribute>> getResource()
			throws Exception {

		try {
			List<Object> lResource = null;

			lResource = getResourceData();

			return convertUrlResourceCollection(lResource);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}

	}

	private List<Object> getResourceData() throws Exception {
		return loginDAO.readForList("login.getUrlResourceAll", null);
	}

	private Map<String, Collection<ConfigAttribute>> convertUrlResourceCollection(
			List<Object> lResource) {
		Map<String, Collection<ConfigAttribute>> result = null;

		Collection<ConfigAttribute> att = null;

		String currUrlString = null;
		String nextUrlString = null;

		String roleID = null;
		List<SecurityConfig> lSecurityConfig = null;
		List<String> lUrlString = null;
		
		int lSize = 0;

		try {
			lSize = lResource.size();
			lSecurityConfig = new ArrayList<SecurityConfig>();
			lUrlString = new ArrayList<String>();
			
			result = new HashMap<String, Collection<ConfigAttribute>>();

			for (int index = 0; index < lSize; index++) {

				HashMap map = (HashMap) lResource.get(index);

				currUrlString = (String) map.get("URL_STRING");
				roleID = (String) map.get("ROLE_ID");

				lSecurityConfig.add(new SecurityConfig(roleID));

				if (index < lSize - 1) {
					nextUrlString = (String) ((HashMap) lResource
							.get(index + 1)).get("URL_STRING");
				} else {
					nextUrlString = "";
				}

				if (!currUrlString.equals(nextUrlString)) {

					att = new ArrayList<ConfigAttribute>();
					
					for (SecurityConfig securityConfig : lSecurityConfig) {
						

						att.add(securityConfig);
					}

					result.put(currUrlString, att);

					lSecurityConfig = new ArrayList<SecurityConfig>();
					lUrlString = new ArrayList<String>();

				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	public LoginDAO getLoginDAO() {
		return loginDAO;
	}

	public void setLoginDAO(LoginDAO loginDAO) {
		this.loginDAO = loginDAO;
	}
}
