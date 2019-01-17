package kr.go.culture.magazine.service;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("CultureAgreeInsertService")
public class CultureAgreeInsertService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = Exception.class)
	public void insert(ParamMap paramMap) throws Exception {
		int type = paramMap.getInt("type");
		paramMap.put("parent_seq", insertRecomData(paramMap));
		insertTypeData(paramMap, type);
	}

	private int insertRecomData(ParamMap paramMap) throws Exception {
		int seq = (Integer) ckDatabaseService.insert("culture.agree.insert", paramMap);
		return seq;
	}

	protected void insertTypeData(ParamMap paramMap, int type) throws Exception {
		String queryId = getQueryId(type);

		if (queryId != null) {
			List<HashMap<String, Object>> data = getInsertTypeData(type, paramMap);

			for (Object object : data)
				ckDatabaseService.insert(queryId, object);
		}

		if (type == 3)
			return;

		// writeImageFile(recomUploadFile);
	}

	private List<HashMap<String, Object>> getInsertTypeData(int type, ParamMap paramMap) {

		/*
		 * switch (type) {
		 * case 1 :
		 * return getRecomImgData(paramMap, recomUploadFile);
		 * case 2:
		 * return getRecomTextData(paramMap);
		 * default :
		 * return null;
		 * }
		 */
		/*
		 * if (type == 1)
		 * return getRecomImgData(paramMap, recomUploadFile);
		 * else
		 */
		if (type == 3)
			return getRecomTextData(paramMap);
		else
			return null;
	}

	private List<HashMap<String, Object>> getRecomTextData(ParamMap paramMap) {

		int listSize = paramMap.getArray("text_title").length;

		List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>(listSize);

		for (int index = 0; index < listSize; index++) {
			HashMap<String, Object> data = new HashMap<String, Object>();

			data.put("parent_seq", paramMap.get("parent_seq"));
			data.put("text_title", Array.get(paramMap.getArray("text_title"), index));
			data.put("text_content", Array.get(paramMap.getArray("text_content"), index));
			data.put("text_url", Array.get(paramMap.getArray("text_url"), index));

			list.add(data);
		}

		return list;
	}

	private String getQueryId(int type) throws Exception {
		switch (type) {

		case 1:
			return "culture.agree.imgInsert";
		case 2:
			return null;
		case 3:
			return "culture.agree.textInsert";
		default:
			throw new Exception("Can't support type");
		}

	}

}