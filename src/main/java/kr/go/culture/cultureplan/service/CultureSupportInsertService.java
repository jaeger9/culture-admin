package kr.go.culture.cultureplan.service;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service("CultureSupportInsertService")
public class CultureSupportInsertService {

	private static final Logger logger = LoggerFactory.getLogger(CultureSupportInsertService.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void recomInsert(ParamMap paramMap, MultipartFile[] multis) throws Exception {

		Object pseq = ckDataBaseService.insert("culture_support.recomInsert", paramMap);
		int maxSeq = (Integer) ckDataBaseService.readForObject("culture_support.subMaxSeq", null);

		ckDataBaseService.insert("culture_support.recomSubInsertAll", getRecomSubList(paramMap, pseq, maxSeq, multis));
	}

	private List<HashMap<String, Object>> getRecomSubList(ParamMap paramMap, Object pseq, int maxSeq, MultipartFile[] multis) throws Exception {

		int listSize = paramMap.getArray("s_title").length;

		List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>(listSize);

		HashMap<String, Object> data = null;
		String fileName = null;

		for (int index = 0; index < listSize; index++) {
			data = new HashMap<String, Object>();

			fileName = fileService.writeFile(multis[index], "theme");

			data.put("seq", maxSeq + index);
			data.put("pseq", pseq);
			data.put("s_seq", 0);
			data.put("s_title", Array.get(paramMap.getArray("s_title"), index));
			data.put("url", Array.get(paramMap.getArray("url"), index));
			data.put("img_name1", fileName);

			list.add(data);

		}

		return list;
	}

}