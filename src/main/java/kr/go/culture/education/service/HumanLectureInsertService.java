package kr.go.culture.education.service;

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

@Service("HumanLectureInsertService")
public class HumanLectureInsertService {

	private static final Logger logger = LoggerFactory.getLogger(HumanLectureInsertService.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void insert(ParamMap paramMap, MultipartFile multi) throws Exception {
		Object pseq = ckDataBaseService.insert("human_lecture.recomInsert", paramMap);
		int maxSeq = (Integer) ckDataBaseService.readForObject("human_lecture.subMaxSeq", null);

		ckDataBaseService.insert("human_lecture.recomSubInsert", getRecomSubList(paramMap, pseq, maxSeq, multi).get(0));
	}

	private List<HashMap<String, Object>> getRecomSubList(ParamMap paramMap, Object pseq, int maxSeq, MultipartFile multi) throws Exception {

		List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>(1);
		String fileName = fileService.writeFile(multi, "theme");

		HashMap<String, Object> data = new HashMap<String, Object>();
		data.put("seq", maxSeq);
		data.put("pseq", pseq);
		data.put("s_seq", 0);
		data.put("s_title", paramMap.get("title"));
		data.put("url", paramMap.get("url"));
		data.put("img_name1", fileName);

		list.add(data);

		return list;
	}

}