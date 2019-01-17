package kr.go.culture.portal.service;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

/**
 * TODO UXUI 메뉴구성 임시로 사용
 * @author nakser
 *
 */
@Service
public class PortalSampleMenuMappingService {

	private static final Logger logger = LoggerFactory.getLogger(PortalSampleMenuMappingService.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	public void mergeMapping(ParamMap paramMap) throws Exception {

		service.delete("portalSampleMenuMapping.deleteByMenuId", paramMap);

		int nodeCount = paramMap.getInt("count");
		ParamMap tmp = null;

		if (nodeCount > 0) {
			for (int i = 0; i < nodeCount; i++) {
				tmp = new ParamMap();
				tmp.put("menu_id", paramMap.get("menu_id"));
				tmp.put("url_id", paramMap.get("nodes[" + i + "][url_id]"));
				tmp.put("link_yn", paramMap.get("nodes[" + i + "][link_yn]"));
				tmp.put("user_id", paramMap.getString("user_id", "관리자"));

				service.insert("portalSampleMenuMapping.insert", tmp);
			}
		}
	}
	
}
