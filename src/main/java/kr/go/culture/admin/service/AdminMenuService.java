package kr.go.culture.admin.service;

import java.util.ArrayList;
import java.util.List;

import kr.go.culture.admin.domain.AdminMenu;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdminMenuService {

	private static final Logger logger = LoggerFactory.getLogger(AdminMenuService.class);

	@Autowired
	private CkDatabaseService service;

	private static List<AdminMenu> menuTree;

	// 계층형 구조에서 가장 깊은 dep level을 구함 (oracle에서 level에 해당)
	private int getMaxDep(List<AdminMenu> menuList) throws Exception {
		int maxDep = 0;
		for (AdminMenu menu : menuList) {
			if (menu != null && maxDep < menu.getMenu_level()) {
				maxDep = menu.getMenu_level();
			}
		}
		return maxDep;
	}

	// 부모의 메뉴의 child로 add
	private void addChildMenu(List<AdminMenu> parentList, List<AdminMenu> childList) throws Exception {
		if (parentList != null && parentList.size() > 0 && childList != null && childList.size() > 0) {
			for (AdminMenu child : childList) {
				for (AdminMenu parent : parentList) {
					if (child.getMenu_pid().equals(parent.getMenu_id())) { // child.pid = parent.id 인 경우
						parent.addMenu(child);
					}
				}
			}
		}
	}

	// 계층형 list - AdminMenu > menuList
	private List<AdminMenu> getTreeList(List<AdminMenu> menuList) throws Exception {
		if (menuList == null || menuList.size() == 0) {
			return null;
		}

		// 계층형 구조에서 가장 깊은 dep level을 구함 (oracle에서 level에 해당)
		int maxDep = getMaxDep(menuList);

		// dep level 별 list 생성 및 add
		// ex)
		// dep1 = treeList.get(0)
		// dep2 = treeList.get(1) ...
		List<List<AdminMenu>> treeList = new ArrayList<List<AdminMenu>>();

		for (int i = 0; i < maxDep; i++) {
			treeList.add(new ArrayList<AdminMenu>());
		}

		for (AdminMenu menu : menuList) {
			if (menu == null) {
				continue;
			}

			treeList.get(menu.getMenu_level() - 1).add(menu);
		}

		// 하위 dep에서 부모 dep의 childMenuList로 add
		// ex)
		// dep1 == treeList.get(0) 이므로 > 가장 상위 dep이므로 처리하지 않음
		// dep2 == treeList.get(1) 이므로 > get(1)과 get(0)
		// dep3 == treeList.get(2) 이므로 > get(2)와 get(1)
		for (int i = maxDep - 1; i > 0; i--) {
			addChildMenu(treeList.get(i - 1), treeList.get(i));
		}

		return treeList.get(0);
	}

	public void emptyMenuTree() throws Exception {
		menuTree = null;
	}

	public List<AdminMenu> getMenuTree(ParamMap paramMap) throws Exception {
		if (paramMap == null || paramMap.isBlank("session_admin_id")) {
			return null;
		}

		List<Object> orgList = service.readForList("adminMenu.listByAdminUserTree", paramMap);
		List<AdminMenu> tarList = null;

		if (orgList != null && orgList.size() > 0) {
			tarList = new ArrayList<AdminMenu>();

			for (Object o : orgList) {
				tarList.add((AdminMenu) o);
			}
		}

		return getTreeList(tarList);
	}

	
	/**
	 * 관리자 로그 insert 
	 * @param paramMap
	 * @throws Exception
	 */
	public void adminLogInsert(ParamMap paramMap)throws Exception { 
		service.insert("adminMenu.adminLogInsert", paramMap);
	}
}