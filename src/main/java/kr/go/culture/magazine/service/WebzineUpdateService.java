package kr.go.culture.magazine.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service("WebzineUpdateService")
public class WebzineUpdateService {

	@Resource(name = "CkDatabaseService")
	CkDatabaseService ckDatabaseService;

	@Resource(name = "FileService")
	FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = Exception.class)
	public void update(ParamMap paramMap, MultipartFile multi, MultipartFile multiEvent) throws Exception {
		List<HashMap<String, Object>> paramList = null;
		String fileName = "";
		String filePath = "";
		String filePathEvent = "";
		
		if(multi.getSize() > 0){
			fileName = fileService.writeFile(multi, "webzine");
			filePath = "/upload/webzine/"+fileName;
		}
		
		if(multiEvent.getSize() > 0){
			fileName = fileService.writeFile(multiEvent, "webzine");
			filePathEvent = "/upload/webzine/"+fileName;
		}

		ckDatabaseService.save("webzine.update", paramMap);
		
		paramList = setParamData(paramMap, filePath, filePathEvent);

		for (HashMap<String, Object> param : paramList) {
			ckDatabaseService.insert("webzine.updateSub", param);
		}
	}

	public List<HashMap<String, Object>> setParamData(ParamMap paramMap, String filePath, String filePathEvent) throws Exception {
		List<HashMap<String, Object>> paramList = new ArrayList<HashMap<String, Object>>();

		int data_count = paramMap.getArray("url").length;

		for (int index = 0; index < data_count; index++) {
			HashMap<String, Object> param = new HashMap<String, Object>();

			param.put("title", paramMap.getArray("subTitle")[index]);
			if(index == 0) {
				if(filePath.equals("") && paramMap.getArray("file_name")[index]!="") {
					param.put("file_name", paramMap.getArray("file_name")[index]);
				}else {
					param.put("file_name", filePath);
				}
			} else if(index != 0 && "588".equals( paramMap.getArray("type")[index] )){	//이벤트는 실제 업로드된 파일경로를 등록한다.
				if(filePathEvent.equals("") && paramMap.getArray("file_name")[index]!="" && paramMap.get("template_type").equals("D")) {
					param.put("file_name", paramMap.getArray("file_name")[index]);
				}else {
					param.put("file_name", filePathEvent);
				}
			}else {
				if(paramMap.get("template_type").equals("P")){
					param.put("file_name", null);
				}else {
					param.put("file_name", paramMap.getArray("file_name")[index]);
				}
			}
			param.put("content", paramMap.getArray("content")[index]);
			param.put("url", paramMap.getArray("url")[index]);
			param.put("type", paramMap.getArray("type")[index]);
			param.put("seq", paramMap.getArray("subSeq")[index]);

			paramList.add(param);
		}

		return paramList;
	}
}
