package kr.go.culture.common.dao;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

@Repository("CultureDAO")
public class CultureDAO implements CommonDAO {
	private SqlMapClient sqlMapClient = null;

	@Autowired
	@Resource(name="sqlMapClient-culture")
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<Object> readForList(String strMapID, Object object)
			throws Exception {
		return sqlMapClient.queryForList(strMapID, object);
	}

	@Override
	public Object read(String strMapID, Object object) throws Exception {
		return sqlMapClient.queryForObject(strMapID, object);
	}

	@Override
	public int save(String strMapID, Object object) throws Exception {
		return sqlMapClient.update(strMapID, object);
	}

	@Override
	public int delete(String strMapID, Object object) throws Exception {
		return sqlMapClient.delete(strMapID, object);
	}
	
	@Override
	public Object insert(String strMapID , Object object) throws Exception {
		return sqlMapClient.insert(strMapID , object);
	}
}