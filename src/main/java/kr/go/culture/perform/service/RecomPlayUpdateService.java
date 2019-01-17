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

@Service("PerformRecomPlayUpdateService")
public class RecomPlayUpdateService {

	private static final Logger logger = LoggerFactory.getLogger(RecomPlayUpdateService.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void update(ParamMap paramMap, MultipartFile[] multi, String pseq) throws Exception {

		String fileName = "";
		int maxSeq = 0;
		int rowNum = 0;
		
		if (multi != null && multi.length > 0) {
			fileName = fileService.writeFile(multi[0], "theme");
		}

		paramMap.put("file_sysname", fileName);

		ckDataBaseService.save("theme.recomUpdate", paramMap);

		List<HashMap<String, Object>> subList = getRecomSubList(paramMap);

		for (Object object : subList) {
			@SuppressWarnings("unchecked")
			HashMap<String, Object> h = (HashMap<String, Object>) object;
			if( "".equals( h.get("seq") ) ){
				maxSeq = (Integer) ckDataBaseService.readForObject("theme.subMaxSeq", null);

				ckDataBaseService.insert("theme.recomSubInsertAll", getRecomSubListInsert(paramMap, pseq, maxSeq, rowNum));
			}else{
				ckDataBaseService.save("theme.recomSubUpdate", object);
			}
			rowNum++;
		}
	}

	// private List<RecomSub> getRecomSubList(ParamMap paramMap) {
	private List<HashMap<String, Object>> getRecomSubList(ParamMap paramMap) {

		int listSize = paramMap.getArray("s_seq").length;

		List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>(listSize);
		HashMap<String, Object> data = null;

		for (int index = 0; index < listSize; index++) {
			data = new HashMap<String, Object>();
			data.put("s_seq", Array.get(paramMap.getArray("s_seq"), index));
			data.put("s_title", Array.get(paramMap.getArray("s_title"), index));
			data.put("s_thumb_url", Array.get(paramMap.getArray("s_thumb_url"), index));
			data.put("uci", Array.get(paramMap.getArray("uci"), index));
			data.put("period", Array.get(paramMap.getArray("period"), index));
			data.put("place", Array.get(paramMap.getArray("place"), index));
			data.put("seq", Array.get(paramMap.getArray("tmp_seq"), index));

			list.add(data);
		}

		return list;
	}


	// private List<RecomSub> getRecomSubList(ParamMap paramMap) {
	private List<HashMap<String, Object>> getRecomSubListInsert(ParamMap paramMap, Object pseq, int maxSeq, int rowNum) {

		int listSize = paramMap.getArray("s_seq").length;

		List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>(listSize);
		HashMap<String, Object> data = null;

		for (int index = 0; index < listSize; index++) {
			if( index == rowNum ){
				data = new HashMap<String, Object>();
	
				if (Array.get(paramMap.getArray("s_seq"), index).toString() == null || Array.get(paramMap.getArray("s_seq"), index).toString().equals(""))
					continue;
	
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
		}

		// System.out.println("list :" + list.toString());
		return list;
	}
}