package kr.go.culture.login.dao;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

@Repository("LoginDAO")
public class LoginDAO {
	
	private SqlMapClient sqlMapClient = null;

	@Autowired
	@Resource(name="sqlMapClient-ck")
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	public List<Object> readForList(String strMapID, Object object)
			throws Exception {
		return sqlMapClient.queryForList(strMapID, object);
	}

	public Object read(String strMapID, Object object) throws Exception {
		return sqlMapClient.queryForObject(strMapID, object);
	}

	public int save(String strMapID, Object object) throws Exception {
		return sqlMapClient.update(strMapID, object);
	}

	public int delete(String strMapID, Object object) throws Exception {
		return sqlMapClient.delete(strMapID, object);
	}
	
	public int insert(String strMapID , Object object) throws Exception {
		return (Integer) sqlMapClient.insert(strMapID , object);
	}


}
