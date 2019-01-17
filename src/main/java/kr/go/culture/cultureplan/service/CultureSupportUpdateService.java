package kr.go.culture.cultureplan.service;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service("CultureSupportUpdateService")
public class CultureSupportUpdateService {

	private static final Logger logger = LoggerFactory.getLogger(CultureSupportUpdateService.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void recomUpdate(ParamMap paramMap, MultipartFile[] multis) throws Exception {

		ckDataBaseService.save("culture_support.recomUpdate", paramMap);
		List subList = ckDataBaseService.readForList("culture_support.recomSubList", paramMap);

		ckDataBaseService.delete("culture_support.recomSubDelete", paramMap);

		int maxSeq = (Integer) ckDataBaseService.readForObject("culture_support.subMaxSeq", null);

		ckDataBaseService.insert("culture_support.recomSubInsertAll", getRecomSubList(paramMap, subList, maxSeq, multis));
	}

	private List<HashMap<String, Object>> getRecomSubList(ParamMap paramMap, List subList, int maxSeq, MultipartFile[] multis) throws Exception {

		int listSize = paramMap.getArray("s_title").length;

		List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>(listSize);

		HashMap<String, Object> data = null;
		MultipartFile multi = null;
		String fileName = null;

		for (int index = 0; index < listSize; index++) {
			data = new HashMap<String, Object>();

			data.put("seq", maxSeq + index);
			data.put("pseq", paramMap.get("seq"));
			data.put("s_seq", 0);
			data.put("s_title", Array.get(paramMap.getArray("s_title"), index));
			data.put("url", Array.get(paramMap.getArray("url"), index));

			multi = multis[index];

			if (multi == null || multi.isEmpty() || "".equals(multi.getOriginalFilename())) {
				for (int i = 0; i < subList.size(); i++) {
					// System.out.println("array tmp_seq == " + Array.get(paramMap.getArray("tmp_seq"), index));
					// System.out.println("list seq == " + ((Map)subList.get(i)).get("seq").toString());
					// System.out.println("list img_name1 == " + ((Map)subList.get(i)).get("img_name1").toString());

					if (Array.get(paramMap.getArray("tmp_seq"), index).equals(((Map) subList.get(i)).get("seq").toString())) {
						data.put("img_name1", ((Map) subList.get(i)).get("img_name1").toString());
					}
				}
			} else {
				fileName = fileService.writeFile(multi, "theme");
				data.put("img_name1", fileName);
			}

			list.add(data);

		}

		return list;
	}

}