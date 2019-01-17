package kr.go.culture.perform.service;

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

@Service("PerformRecomDisplayInsertService")
public class RecomDisplayInsertService {

	private static final Logger logger = LoggerFactory.getLogger(RecomDisplayInsertService.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void insert(ParamMap paramMap, MultipartFile[] multis) throws Exception {

		String fileName = null;

		if (multis != null && multis.length > 0) {
			fileName = fileService.writeFile(multis[0], "theme");
		}
		paramMap.put("file_sysname", fileName);

		Object pseq = ckDataBaseService.insert("theme.recomInsert", paramMap);
		int maxSeq = (Integer) ckDataBaseService.readForObject("theme.subMaxSeq", null);

		ckDataBaseService.insert("theme.recomSubInsertAll", getRecomSubList(paramMap, pseq, maxSeq));

	}

	// private List<RecomSub> getRecomSubList(ParamMap paramMap) {
	private List<HashMap<String, Object>> getRecomSubList(ParamMap paramMap, Object pseq, int maxSeq) throws Exception {
		int listSize = paramMap.getArray("s_seq").length;

		List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>(listSize);

		HashMap<String, Object> data = null;

		for (int index = 0; index < listSize; index++) {
			data = new HashMap<String, Object>();
			data.put("seq", maxSeq + index);
			data.put("pseq", pseq);
			data.put("s_seq", Array.get(paramMap.getArray("s_seq"), index));
			data.put("s_title", Array.get(paramMap.getArray("s_title"), index));
			data.put("s_thumb_url", Array.get(paramMap.getArray("s_thumb_url"), index));
			data.put("uci", Array.get(paramMap.getArray("uci"), index));
			data.put("place", Array.get(paramMap.getArray("place"), index));
			data.put("period", Array.get(paramMap.getArray("period"), index));

			list.add(data);
		}

		return list;
	}

}