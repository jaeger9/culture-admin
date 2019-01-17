package kr.go.culture.magazine.service;

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

@Service("RecomCultureAgreeInsertService")
public class RecomCultureAgreeInsertService {

	private static final Logger logger = LoggerFactory
			.getLogger(RecomCultureAgreeInsertService.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void insert(ParamMap paramMap) throws Exception {

		Object pseq = ckDataBaseService.insert("theme.recomInsert", paramMap);
		int maxSeq = (Integer) ckDataBaseService.readForObject(
				"theme.subMaxSeq", null);

		ckDataBaseService.insert("theme.recomSubInsertAll",
				getRecomSubList(paramMap, pseq, maxSeq));

	}

	// private List<RecomSub> getRecomSubList(ParamMap paramMap) {
	private List<HashMap<String, Object>> getRecomSubList(ParamMap paramMap,
			Object pseq, int maxSeq) {

		int listSize = paramMap.getArray("s_seq").length;

		List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>(
				listSize);

		for (int index = 0; index < listSize; index++) {
			HashMap<String, Object> data = new HashMap<String, Object>();

			if (Array.get(paramMap.getArray("s_seq"), index).toString() == null
					|| Array.get(paramMap.getArray("s_seq"), index).toString()
							.equals(""))
				continue;

			data.put("seq", maxSeq + index);
			data.put("pseq", pseq);
			data.put("s_seq", Array.get(paramMap.getArray("s_seq"), index));
			data.put("s_title", Array.get(paramMap.getArray("s_title"), index));
			data.put("s_thumb_url",
					Array.get(paramMap.getArray("s_thumb_url"), index));

			list.add(data);
		}

		System.out.println("list :" + list.toString());
		return list;
	}

}
