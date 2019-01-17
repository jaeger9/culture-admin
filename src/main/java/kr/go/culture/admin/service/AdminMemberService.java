package kr.go.culture.admin.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AdminMemberService {

	private static final Logger logger = LoggerFactory.getLogger(AdminMemberService.class);

	@Autowired
	private CkDatabaseService service;


	/**
	 * admin user insert
	 * 
	 * @param paramMap
	 *            request parameter
	 * @throws Exception
	 *             exception
	 */
	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void insert(ParamMap paramMap) throws Exception {

		service.insert("adminMember.insert", paramMap);
		insertAdminUserRole(paramMap);

	}

	/**
	 * admin user update
	 * 
	 * @param paramMap
	 *            request parameter
	 * @throws Exception
	 *             exception
	 */
	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void update(ParamMap paramMap) throws Exception {

		service.save("adminMember.update", paramMap);
		insertAdminUserRole(paramMap);

	}

	/**
	 * admin user role 설정
	 * 
	 * @param paramMap
	 *            request parameter
	 * @throws Exception
	 *             exception
	 */
	private void insertAdminUserRole(ParamMap paramMap) throws Exception {

		String[] role_ids = paramMap.getArray("role_ids");
		String user_id = null;

		ParamMap roleParam = null;
		Map<String, Object> tmpMap = null;
		List<Map<String, Object>> tmpList = null;

		if (paramMap.isNotBlank("user_id")) {
			user_id = paramMap.getString("user_id");

			roleParam = new ParamMap();
			roleParam.putArray("user_ids", new String[] { user_id });
			service.delete("adminMemberRole.deleteByUserId", roleParam);

			if (role_ids != null && role_ids.length > 0) {
				tmpList = new ArrayList<Map<String, Object>>();

				for (String role_id : role_ids) {
					tmpMap = new HashMap<String, Object>();
					tmpMap.put("role_id", role_id);
					tmpMap.put("user_id", user_id);

					tmpList.add(tmpMap);
				}

				paramMap.put("roleList", tmpList);
				service.insert("adminMemberRole.insertList", paramMap);
			}
		}
	}
}