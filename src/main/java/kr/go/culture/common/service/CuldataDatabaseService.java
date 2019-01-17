package kr.go.culture.common.service;

import java.util.LinkedHashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.go.culture.common.dao.CuldataDAO;
import kr.go.culture.common.domain.ParamMap;

@Service("CuldataDatabaseService")
public class CuldataDatabaseService {

	@Resource(name = "CuldataDAO")
	private CuldataDAO dao;
	
	public int save(String strMapID, Object object) throws Exception {
		return dao.save(strMapID, object);
	}
	
	public void save(String strQueryMapID,
		List<Object> DataList) throws Exception {
	
		for ( Object object : DataList)
			dao.save(strQueryMapID, object);
	}
	
	public Object insert(String strMapID , Object object) throws Exception { 
		return dao.insert(strMapID, object);
	}
	
	public List<Object> readForList(String strMapID , Object object) throws Exception{
		return dao.readForList(strMapID, object);
	}
	
	public Object readForObject(String strMapID , Object object) throws Exception{
		return dao.read(strMapID, object);
	}
	
	public int delete(String strMapID, Object object) throws Exception {
		return dao.delete(strMapID, object);
	}

	public int delete(String strMapID, List<Object> list) throws Exception {
		
		if(list == null){
			Object object = null;
			return dao.delete(strMapID, object);
		}
		return dao.delete(strMapID, list);
	}

	public List<LinkedHashMap<String, Object>> readForLinkedList(String strMapID, ParamMap object) throws Exception {
		return dao.readForLinkedList(strMapID, object);
	}
}
