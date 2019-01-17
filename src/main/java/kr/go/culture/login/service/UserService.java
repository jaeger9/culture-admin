package kr.go.culture.login.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import kr.go.culture.common.dao.CkDAO;
import kr.go.culture.login.dao.LoginDAO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service("UserService")
public class UserService implements UserDetailsService {

	@Autowired
	@Resource(name = "LoginDAO")
	private LoginDAO loginDAO;
	
	public UserDetails loadUserByUsername(String username)
			throws UsernameNotFoundException {
		
		HashMap data = null;
		
		try {
			List<GrantedAuthority> authList = new ArrayList<GrantedAuthority>();

			data = getUser(username);
			
			boolean enabled = true;
			boolean accountNonExpired = true;
			boolean credentialsNonExpired = true;
			boolean accountNonLocked = true;

			
			return new User((String)data.get("USERNAME"), (String)data.get("PASSWORD"), enabled, accountNonExpired,
					credentialsNonExpired, accountNonLocked , getAuthList(username));

		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	
	private List<GrantedAuthority> getAuthList (String username) { 
		List<Object> list = null;
		List<GrantedAuthority> authList = new ArrayList<GrantedAuthority>();;
		
		HashMap data = null;
		
		try {
			list = loginDAO.readForList("login.getUserAuth", username);
			
			for(Object object : list) {
				data = (HashMap)object;
				authList.add(new SimpleGrantedAuthority((String)data.get("AUTHORITY")));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return authList;
	}
	
	private HashMap getUser(String username) {
		
		HashMap data = null;
		
		try {
			data = (HashMap)loginDAO.read("login.getUser", username);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return data;
	}

	public LoginDAO getLoginDAO() {
		return loginDAO;
	}

	public void setLoginDAO(LoginDAO loginDAO) {
		this.loginDAO = loginDAO;
	}
}
