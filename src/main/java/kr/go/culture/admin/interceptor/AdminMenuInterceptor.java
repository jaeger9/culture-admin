package kr.go.culture.admin.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.go.culture.admin.domain.AdminMenu;
import kr.go.culture.admin.service.AdminMenuService;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.util.CommonUtil;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class AdminMenuInterceptor extends HandlerInterceptorAdapter {

	private static final Logger logger = LoggerFactory.getLogger(AdminMenuInterceptor.class);

	@Autowired
	private AdminMenuService adminMenuService;

	private final String ADMIN_MENU = "admin_menu";

	@SuppressWarnings("unchecked")
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		String uri = null;
		String[] urls = null;
		ParamMap paramMap = null;

		// all menu tree
		List<AdminMenu> menuTree = null;

		// current menu
		AdminMenu currentMenu = null;
		boolean bDep2 = true;
		boolean bDep3 = true;

		// user session
		HttpSession session = request.getSession();

		String adminId = (String) session.getAttribute("admin_id");
		String clientIp = CommonUtil.getClientIP(request);
		String requestURI = request.getRequestURI();
		String queryString = request.getQueryString();
		// 관리자 활동 기록
		logger.info("^|^"+adminId+"^|^"+clientIp+"^|^"+requestURI+"^|^"+queryString);
		
		ParamMap logParam = new ParamMap();
		logParam.put("adminId", adminId);
		logParam.put("clientIp", clientIp);
		logParam.put("requestURI", requestURI);
		logParam.put("queryString", getParamString(queryString));
		
		//관리자 로그 insert
		adminMenuService.adminLogInsert(logParam);
				
		try {

			urls = request.getRequestURI().split("/");

			if (urls != null && urls.length > 0) {
				for (String s : urls) {
					if (StringUtils.isBlank(s)) {
						continue;
					}

					if (uri == null) {
						uri = "/" + s;
					} else {
						uri += "/" + s;
					}
				}
			}

			if (uri == null) {
				uri = request.getRequestURI();
			}

			paramMap = new ParamMap(request);

			if (session.getAttribute(ADMIN_MENU) != null) {
				menuTree = (List<AdminMenu>) session.getAttribute(ADMIN_MENU);
			} else {
				menuTree = adminMenuService.getMenuTree(paramMap);
				session.setAttribute(ADMIN_MENU, menuTree);
			}

			if (menuTree != null && menuTree.size() > 0) {
				// dep1 current
				for (AdminMenu dep1 : menuTree) {
					if (dep1.isIncludeUrl(uri) && bDep2 && bDep3) {
						currentMenu = new AdminMenu(dep1);
					}
					if (dep1.getChildMenuList() != null) {
						// dep2 current
						for (AdminMenu dep2 : dep1.getChildMenuList()) {
							if (dep2.isIncludeUrl(uri) && bDep3) {
								currentMenu = new AdminMenu(dep2);
								bDep2 = false;
							}
							if (dep2.getChildMenuList() != null) {
								// dep3 current
								for (AdminMenu dep3 : dep2.getChildMenuList()) {
									if (dep3.isIncludeUrl(uri)) {
										currentMenu = new AdminMenu(dep3);
										bDep3 = false;
									}
								}
								// dep3 current end
							}
						}
						// dep2 current end
					}
				}
				// dep1 current end
			}

		} catch (Exception e) {
			logger.error(e.toString());
		}

		request.setAttribute("allMenuTree", menuTree);
		request.setAttribute("currentMenu", currentMenu);

		if (currentMenu != null) {
			request.setAttribute("menu_id", currentMenu.getMenu_id());
		}

		// if (logger.isInfoEnabled()) {
		// logger.info("AdminMenuInterceptor start -----------------------------------------------------------------------------------");
		// logger.info("requestURI : " + uri);
		// if (currentMenu != null) {
		// logger.info("currentMenu : " + JSONObject.fromObject(currentMenu).toString(4));
		// } else {
		// logger.info("currentMenu : " + null);
		// }
		// logger.info("AdminMenuInterceptor end -----------------------------------------------------------------------------------");
		// }

		return super.preHandle(request, response, handler);
	}
	
	
	private String getParamString(String queryString){
		
		String result = "";
		
		if(queryString != null){
			String[] params = queryString.split("&");
			
			for(String param : params){
				String[] arr = param.split("=");
				if(result.equals("")){
					result += "[param] ";
				}else{
					result += ", ";
				}
				
				if(arr.length == 1){
					result += arr[0] + " : ";
				}
				if(arr.length > 1){
					result += arr[0] + " : " + arr[1];
				}
			}
		}

		return result;
	}

}