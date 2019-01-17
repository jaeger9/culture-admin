package kr.go.culture.microsite.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("MicrositeMenuService")
public class MicrositeMenuService {

	private static final Logger logger = LoggerFactory.getLogger(MicrositeMenuService.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@SuppressWarnings("unchecked")
	public List<Object> getMenuList(String site_id) throws Exception {
		ParamMap paramMap = new ParamMap();
		paramMap.put("site_id", site_id);

		List<Object> menuList = service.readForList("micrositeMenu.listByTree", paramMap);
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

				menuView = "" + tmp.get("menu_name") + " (" + tmp.get("menu_path") + ")" + ("Y".equals(tmp.get("menu_approval")) ? "" : " (미승인)");

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
				tmp.put("site_id", paramMap.get("nodes[" + i + "][site_id]"));
				tmp.put("menu_id", paramMap.get("nodes[" + i + "][menu_id]"));
				tmp.put("menu_pid", paramMap.get("nodes[" + i + "][menu_pid]"));
				tmp.put("menu_sort", paramMap.get("nodes[" + i + "][menu_sort]"));
				tmp.put("menu_name", paramMap.get("nodes[" + i + "][menu_name]"));
				tmp.put("menu_path", paramMap.get("nodes[" + i + "][menu_path]"));
				tmp.put("menu_url", paramMap.get("nodes[" + i + "][menu_url]"));
				tmp.put("menu_desc", paramMap.get("nodes[" + i + "][menu_desc]"));
				tmp.put("menu_approval", paramMap.get("nodes[" + i + "][menu_approval]"));
				tmp.put("user_id", paramMap.getString("user_id", "관리자"));

				service.insert("micrositeMenu.merge", tmp);
			}
		}

	}

	public void updateMenuSort(ParamMap paramMap) throws Exception {
		// service.save("micrositeMenu.merge", paramMap);

		int nodeCount = paramMap.getInt("count");
		ParamMap tmp = null;

		if (nodeCount > 0) {
			for (int i = 0; i < nodeCount; i++) {
				tmp = new ParamMap();
				tmp.put("menu_id", paramMap.get("nodes[" + i + "][menu_id]"));
				tmp.put("menu_pid", paramMap.get("nodes[" + i + "][menu_pid]"));
				tmp.put("menu_sort", paramMap.get("nodes[" + i + "][menu_sort]"));
				tmp.put("user_id", paramMap.getString("user_id", "관리자"));

				service.save("micrositeMenu.updateMenuSort", tmp);
			}
		}
	}

}