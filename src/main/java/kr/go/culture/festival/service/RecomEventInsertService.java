package kr.go.culture.festival.service;

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

@Service("RecomEventInsertService")
public class RecomEventInsertService {

	private static final Logger logger = LoggerFactory.getLogger(RecomEventInsertService.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void insert(ParamMap paramMap, MultipartFile[] multis) throws Exception {

		String fileName = null;

		paramMap.put("file_sysname", fileName);

		Object pseq = ckDataBaseService.insert("theme.recomInsert", paramMap);
		int maxSeq = (Integer) ckDataBaseService.readForObject("theme.subMaxSeq", null);

		ckDataBaseService.insert("theme.recomSubInsert", getRecomSubList(paramMap, pseq, maxSeq, multis).get(0));

	}

	// private List<RecomSub> getRecomSubList(ParamMap paramMap) {
	private List<HashMap<String, Object>> getRecomSubList(ParamMap paramMap, Object pseq, int maxSeq, MultipartFile[] multis) throws Exception {
		int imageIndex = 1;
		int listSize = paramMap.getArray("s_seq").length;

		List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>(listSize);

		HashMap<String, Object> data = null;
		String fileName = null;

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

			for (MultipartFile multi : multis) {
				fileName = fileService.writeFile(multi, "theme");
				data.put("img_name" + imageIndex, fileName); // img_name1, img_name2, img_name3

				imageIndex++;
			}
			list.add(data);

		}

		return list;
	}

}