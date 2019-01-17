package kr.go.culture.admin.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AdminRoleService {

	private static final Logger logger = LoggerFactory.getLogger(AdminRoleService.class);

	@Autowired
	private CkDatabaseService service;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public boolean regist(String role_id, String[] url_ids) throws Exception {

		if (StringUtils.isBlank(role_id)) {
			return false;
		}

		// delete
		ParamMap paramMap = new ParamMap();
		paramMap.putArray("role_ids", new String[] { role_id });

		service.delete("adminUrlRole.deleteByRoleId", paramMap);

		// insert, update
		paramMap = new ParamMap();

		Map<String, Object> tmpMap = null;
		List<Map<String, Object>> tmpList = null;
		Set<String> tmpSet = null;

		if (url_ids != null && url_ids.length > 0) {
			tmpList = new ArrayList<Map<String, Object>>();
			tmpSet = new HashSet<String>();

			for (String url_id : url_ids) {
				if (tmpSet.contains(url_id)) {
					continue;
				}
				tmpSet.add(url_id);

				tmpMap = new HashMap<String, Object>();
				tmpMap.put("role_id", role_id);
				tmpMap.put("url_id", url_id);

				tmpList.add(tmpMap);
			}
		}

		if (tmpList != null && tmpList.size() > 0) {
			paramMap.put("urlRoleList", tmpList);
			//service.insert("adminUrlRole.insertList", paramMap);
			service.insert("adminUrlRole.insertIntoList", paramMap);
		}

		return true;
	}

}