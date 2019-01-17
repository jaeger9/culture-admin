package kr.go.culture.resource.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.springframework.stereotype.Service;

@Service
public class ResMenuService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;


	public void updateMenuSort(ParamMap paramMap) throws Exception {
		int nodeCount = paramMap.getInt("count");
		ParamMap tmp = null;

		if (nodeCount > 0) {
			for (int i = 0; i < nodeCount; i++) {
				tmp = new ParamMap();
				tmp.put("seq", paramMap.get("nodes[" + i + "][seq]"));
				tmp.put("sort", paramMap.get("nodes[" + i + "][sort]"));

				service.save("resMenu.updateMenuSort", tmp);
			}
		}
	}
}