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

@Service("RecomCultureAgreeUpdateService")
public class RecomCultureAgreeUpdateService {

	private static final Logger logger = LoggerFactory
			.getLogger(RecomCultureAgreeUpdateService.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService FileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void update(ParamMap paramMap) throws Exception {

		ckDataBaseService.save("theme.recomUpdate", paramMap);

		List<HashMap<String, Object>> subList = getRecomSubList(paramMap);

		for (Object object : subList)
			ckDataBaseService.save("theme.recomSubUpdate", object);

	}

	// private List<RecomSub> getRecomSubList(ParamMap paramMap) {
	private List<HashMap<String, Object>> getRecomSubList(ParamMap paramMap) {

		int listSize = paramMap.getArray("s_seq").length;

		List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>(
				listSize);

		for (int index = 0; index < listSize; index++) {
			HashMap<String, Object> data = new HashMap<String, Object>();

			data.put("s_seq", Array.get(paramMap.getArray("s_seq"), index));
			data.put("s_title", Array.get(paramMap.getArray("s_title"), index));
			data.put("s_thumb_url",
					Array.get(paramMap.getArray("s_thumb_url"), index));
			
			data.put("seq", Array.get(paramMap.getArray("tmp_seq"), index));

			list.add(data);
		}

		return list;
	}

}
