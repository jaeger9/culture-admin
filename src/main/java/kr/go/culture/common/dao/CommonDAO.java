package kr.go.culture.common.dao;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

public interface CommonDAO {

	public int save(String strMapID, Object object) throws Exception;
	public int delete(String strMapID, Object object) throws Exception;
	public Object insert(String strMapID , Object object) throws Exception;
	
	public List<Object> readForList(String strMapID, Object object) throws Exception;
	public Object read(String strMapID, Object object) throws Exception;
}
