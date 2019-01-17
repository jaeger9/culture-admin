package kr.go.culture.admin.domain;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

public class AdminMenu {

	private String menu_id;
	private String menu_pid;
	private Integer menu_sort;
	private String menu_name;
	private String menu_desc;

	private String approval;
	private String user_id;
	private Date reg_date;
	private Date upt_date;

	//
	private boolean menu_current;
	private Integer menu_level;
	private String menu_ids;
	private String menu_names;
	private List<AdminUrlRepository> urlList;
	private List<AdminMenu> childMenuList;

	public AdminMenu() {
	}

	public AdminMenu(AdminMenu m) {
		menu_id = m.getMenu_id();
		menu_pid = m.getMenu_pid();
		menu_sort = m.getMenu_sort();
		menu_name = m.getMenu_name();
		menu_desc = m.getMenu_desc();

		approval = m.getApproval();
		user_id = m.getUser_id();
		reg_date = m.getReg_date();
		upt_date = m.getUpt_date();

		//
		menu_current = m.isMenu_current();
		menu_level = m.getMenu_level();
		menu_ids = m.getMenu_ids();
		menu_names = m.getMenu_names();

		urlList = null;
		if (m.getUrlList() != null) {
			urlList = new ArrayList<AdminUrlRepository>();
			for (AdminUrlRepository u : m.getUrlList()) {
				urlList.add(new AdminUrlRepository(u));
			}
		}

		childMenuList = null;
		if (m.getChildMenuList() != null) {
			childMenuList = new ArrayList<AdminMenu>();
			for (AdminMenu childMenu : m.getChildMenuList()) {
				childMenuList.add(new AdminMenu(childMenu));
			}
		}
	}

	// 메뉴에 맵핑된 n개의 URL 중 포함 여부
	public boolean isIncludeUrl(String url) throws Exception {
		if (url == null) {
			return false;
		}
		if (urlList != null && urlList.size() > 0) {
			for (AdminUrlRepository ur : urlList) {
				if (url.indexOf(ur.getUrl_string()) > -1) {
					return true;
				}
			}
		}
		return false;
	}

	// 자식 노드로 메뉴 추가
	public void addMenu(AdminMenu childMenu) throws Exception {
		if (childMenuList == null) {
			childMenuList = new ArrayList<AdminMenu>();
		}
		childMenuList.add(childMenu);
	}

	// 계층형일 경우 가장 최상단위 menu_id 값
	public String getParentTopMenuId() throws Exception {
		if (menu_ids == null) {
			return null;
		}
		return menu_ids.split(">")[0];
	}

	// 메뉴에 맵핑된 n개의 URL 중 Link로 사용 될 값
	public String getFirstUrl() throws Exception {
		if (urlList == null || urlList.size() == 0) {
			return "#not_exist_" + menu_id;
		}
		for (AdminUrlRepository u : urlList) {
			if ("Y".equals(u.getUrl_link_yn())) {
				return u.getUrl_string();
			}
		}
		return urlList.get(0).getUrl_string();
	}

	// 계층형일 경우 상위 메뉴들의 menu_name List
	public List<String> getParentMenuNameList() {
		if (menu_names == null) {
			return null;
		}
		return Arrays.asList(menu_names.split(">"));
	}

	// // 계층형일 경우 상위 메뉴들의 menu_id List
	// public List<String> getParentMenuIdList() {
	// if (menu_ids == null) {
	// return null;
	// }
	// return Arrays.asList(menu_ids.split(">"));
	// }

	// // 계층형일 경우 상위 메뉴들의 menu_id List 강제 세팅
	// public void setParentMenuIdList(List<String> parentMenuIdList) {
	// if (parentMenuIdList != null && parentMenuIdList.size() > 0) {
	// menu_ids = null;
	// for (String mid : parentMenuIdList) {
	// if (menu_ids == null) {
	// menu_ids = mid;
	// } else {
	// menu_ids += ">" + mid;
	// }
	// }
	// }
	// }

	//

	public String getMenu_id() {
		return menu_id;
	}

	public void setMenu_id(String menu_id) {
		this.menu_id = menu_id;
	}

	public String getMenu_pid() {
		return menu_pid;
	}

	public void setMenu_pid(String menu_pid) {
		this.menu_pid = menu_pid;
	}

	public Integer getMenu_sort() {
		return menu_sort;
	}

	public void setMenu_sort(Integer menu_sort) {
		this.menu_sort = menu_sort;
	}

	public String getMenu_name() {
		return menu_name;
	}

	public void setMenu_name(String menu_name) {
		this.menu_name = menu_name;
	}

	public String getMenu_desc() {
		return menu_desc;
	}

	public void setMenu_desc(String menu_desc) {
		this.menu_desc = menu_desc;
	}

	public String getApproval() {
		return approval;
	}

	public void setApproval(String approval) {
		this.approval = approval;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public Date getReg_date() {
		return reg_date;
	}

	public void setReg_date(Date reg_date) {
		this.reg_date = reg_date;
	}

	public Date getUpt_date() {
		return upt_date;
	}

	public void setUpt_date(Date upt_date) {
		this.upt_date = upt_date;
	}

	public boolean isMenu_current() {
		return menu_current;
	}

	public void setMenu_current(boolean menu_current) {
		this.menu_current = menu_current;
	}

	public Integer getMenu_level() {
		return menu_level;
	}

	public void setMenu_level(Integer menu_level) {
		this.menu_level = menu_level;
	}

	public String getMenu_ids() {
		return menu_ids;
	}

	public void setMenu_ids(String menu_ids) {
		this.menu_ids = menu_ids;
	}

	public String getMenu_names() {
		return menu_names;
	}

	public void setMenu_names(String menu_names) {
		this.menu_names = menu_names;
	}

	public List<AdminUrlRepository> getUrlList() {
		return urlList;
	}

	public void setUrlList(List<AdminUrlRepository> urlList) {
		this.urlList = urlList;
	}

	public List<AdminMenu> getChildMenuList() {
		return childMenuList;
	}

	public void setChildMenuList(List<AdminMenu> childMenuList) {
		this.childMenuList = childMenuList;
	}

}