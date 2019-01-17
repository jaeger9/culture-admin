package kr.go.culture.customer.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("OpenapiService")
public class OpenapiService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void regist(ParamMap paramMap) throws Exception {
		ParamMap tmpMap = null;

		// 삭제
		String[] deleteIds = null;
		if (paramMap.isNotBlank("delete_ids")) {
			deleteIds = paramMap.getString("delete_ids").split(",");
		}
		if (deleteIds != null && deleteIds.length > 0) {
			tmpMap = new ParamMap();
			tmpMap.putArray("ids", deleteIds);
			service.delete("openapiOperation.delete", tmpMap);
		}

		// 등록,수정
		String[] openapi_id = null;
		String[] id = null;
		String[] name = null;
		String[] description = null;
		String[] format = null;
		String[] url = null;
		String[] filename = null;

		if (paramMap.isNotBlank("openapi_id")) {
			openapi_id = paramMap.getArray("openapi_id");
			id = paramMap.getArray("id");
			name = paramMap.getArray("name");
			description = paramMap.getArray("description");
			format = paramMap.getArray("format");
			url = paramMap.getArray("url");
			filename = paramMap.getArray("filename");

			if (openapi_id != null && openapi_id.length > 0) {
				for (int i = 0; i < openapi_id.length; i++) {
					tmpMap = new ParamMap();
					tmpMap.put("openapi_id", openapi_id[i]);
					tmpMap.put("id", id[i]);
					tmpMap.put("name", name[i]);
					tmpMap.put("description", description[i]);
					tmpMap.put("format", format[i]);
					tmpMap.put("url", url[i]);

					// fileService (openapi)
					// if (tmpMap.isNotBlank("filename")) {
					// tmpMap.put("filename", filename);
					// }

					if (tmpMap.isNotBlank("id") && service.readForObject("openapiOperation.exist", tmpMap) != null) {
						service.insert("openapiOperation.update", tmpMap);
					} else {
						service.insert("openapiOperation.insert", tmpMap);
					}
				}
			}

		}
	}

}