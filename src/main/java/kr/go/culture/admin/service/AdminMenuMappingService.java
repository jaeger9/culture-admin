package kr.go.culture.admin.service;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdminMenuMappingService {

	private static final Logger logger = LoggerFactory.getLogger(AdminMenuMappingService.class);

	@Autowired
	private CkDatabaseService service;

	public void mergeMapping(ParamMap paramMap) throws Exception {

		service.delete("adminMenuMapping.deleteByMenuId", paramMap);

		int nodeCount = paramMap.getInt("count");
		ParamMap tmp = null;

		if (nodeCount > 0) {
			for (int i = 0; i < nodeCount; i++) {
				tmp = new ParamMap();
				tmp.put("menu_id", paramMap.get("menu_id"));
				tmp.put("url_id", paramMap.get("nodes[" + i + "][url_id]"));
				tmp.put("link_yn", paramMap.get("nodes[" + i + "][link_yn]"));
				tmp.put("user_id", paramMap.getString("user_id", "관리자"));

				service.insert("adminMenuMapping.insert", tmp);
			}
		}
	}

}