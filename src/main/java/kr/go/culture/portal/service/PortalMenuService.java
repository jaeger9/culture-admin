package kr.go.culture.portal.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class PortalMenuService {

	private static final Logger logger = LoggerFactory.getLogger(PortalMenuService.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@SuppressWarnings("unchecked")
	public List<Object> getMenuList() throws Exception {

		List<Object> menuList = service.readForList("portalMenu.listByTree", null);
		HashMap<String, Object> tmp = null;
		String menuView = null;

		if (menuList != null && menuList.size() > 0) {
			for (Object o : menuList) {
				tmp = (HashMap<String, Object>) o;

				// if (tmp != null) {
				// for (String s : tmp.keySet()) {
				// tmp.put(s, tmp.get(s) == null ? "" : tmp.get(s));
				// }
				// }

				menuView = "" + tmp.get("menu_name") + ("Y".equals(tmp.get("menu_approval")) ? "" : " (미승인)");

				tmp.put("menu_view", menuView);
				tmp.put("org_menu_pid", tmp.get("menu_pid"));
				tmp.put("org_menu_sort", tmp.get("menu_sort"));
				tmp.put("open", true);
			}
		}

		return menuList;
	}

	public void mergeMenu(ParamMap paramMap) throws Exception {

		int nodeCount = paramMap.getInt("count");
		ParamMap tmp = null;

		if (nodeCount > 0) {
			for (int i = 0; i < nodeCount; i++) {
				tmp = new ParamMap();
				tmp.put("menu_id", paramMap.get("nodes[" + i + "][menu_id]"));
				tmp.put("menu_pid", paramMap.get("nodes[" + i + "][menu_pid]"));
				tmp.put("menu_sort", paramMap.get("nodes[" + i + "][menu_sort]"));
				tmp.put("menu_name", paramMap.get("nodes[" + i + "][menu_name]"));
				tmp.put("menu_desc", paramMap.get("nodes[" + i + "][menu_desc]"));
				tmp.put("menu_approval", paramMap.get("nodes[" + i + "][menu_approval]"));
				tmp.put("user_id", paramMap.getString("user_id", "관리자"));

				service.insert("portalMenu.merge", tmp);
			}
		}
	}

	public void updateMenuSort(ParamMap paramMap) throws Exception {
		int nodeCount = paramMap.getInt("count");
		ParamMap tmp = null;

		if (nodeCount > 0) {
			for (int i = 0; i < nodeCount; i++) {
				tmp = new ParamMap();
				tmp.put("menu_id", paramMap.get("nodes[" + i + "][menu_id]"));
				tmp.put("menu_pid", paramMap.get("nodes[" + i + "][menu_pid]"));
				tmp.put("menu_sort", paramMap.get("nodes[" + i + "][menu_sort]"));
				tmp.put("user_id", paramMap.getString("user_id", "관리자"));

				service.save("portalMenu.updateMenuSort", tmp);
			}
		}
	}
}