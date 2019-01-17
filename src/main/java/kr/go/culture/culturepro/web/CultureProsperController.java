package kr.go.culture.culturepro.web;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.CommonUtil;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.magazine.web.CultureAgreeController;


@RequestMapping("/culturepro")
@Controller("CultureProperController")
public class CultureProsperController {

	private static final Logger logger = LoggerFactory.getLogger(CultureAgreeController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	/**
	 * 문화융성앱 전체시설정보  목록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("facility/list.do")
	public String allList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("gubunList", ckDatabaseService.readForList("culturepro.gubunList", paramMap));
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("culturepro.facilitylistCnt", paramMap));
		model.addAttribute("list", ckDatabaseService.readForList("culturepro.facilitylist", paramMap));
		
		return "/culturepro/facility/list";
	}

	@RequestMapping("manage/syncMapping2.do")
	public String syncMapping2(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		
		ckDatabaseService.save("culturepro.syncInit2", paramMap);
		
		model.addAttribute("paramMap", paramMap);
		SessionMessage.update(request);

		return "redirect:/culturepro/manage/list.do";
	}
	
	/**
	 * 문화융성앱 게시시설관리 정보 업데이트
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("manage/syncMapping.do")
	public String syncMapping(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		
		ckDatabaseService.save("culturepro.syncInit", paramMap);
		ckDatabaseService.save("culturepro.syncMappingInit", paramMap);
		
		List<Object> list = ckDatabaseService.readForList("culturepro.syncMappingList", paramMap);
		String prev_facility_name = "";
		int g_seq = 0;
		
		for(Object object : list) {
			CommonModel data = (CommonModel)object;

			if (!prev_facility_name.equals(data.get("facility_name").toString())) {
				g_seq = (Integer) ckDatabaseService.insert("culturepro.insert", paramMap);
			}
			
			if(g_seq > 0){
				paramMap.put("g_seq", g_seq);
				paramMap.put("type_code", data.get("type_code").toString());
				paramMap.put("facility_name", data.get("facility_name").toString());
				paramMap.put("gps_lat", data.get("gps_lat").toString());
				paramMap.put("gps_lng", data.get("gps_lng").toString());
				
				ckDatabaseService.insert("culturepro.mappingInsert", paramMap);
			}
			
			prev_facility_name = data.get("facility_name").toString();
		}
		paramMap.put("g_seq", "");
		paramMap.put("keyword", "");
		ckDatabaseService.save("culturepro.syncMappingGps", paramMap);
		
		model.addAttribute("paramMap", paramMap);
		SessionMessage.update(request);

		return "redirect:/culturepro/manage/list.do";
	}
	
	/**
	 * 문화융성앱 게시시설관리 컨텐츠 목록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("manage/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("del_yn", CommonUtil.nullStr(request.getParameter("del_yn"), "N"));
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("culturepro.listCnt", paramMap));
		model.addAttribute("list", ckDatabaseService.readForList("culturepro.list", paramMap));
//		String mappingYn = paramMap.getString("mapping_yn");
//		if(StringUtils.isEmpty(mappingYn) || "Y".equals(mappingYn)){
//			model.addAttribute("count", (Integer) ckDatabaseService.readForObject("culturepro.listCnt", paramMap));
//			model.addAttribute("list", ckDatabaseService.readForList("culturepro.list", paramMap));
//		}else{
//			model.addAttribute("count", (Integer) ckDatabaseService.readForObject("culturepro.NoMappingListCnt", paramMap));
//			model.addAttribute("list", ckDatabaseService.readForList("culturepro.noMappingList", paramMap));
//		}
		
		return "/culturepro/manage/list";
	}
	
	/**
	 * 문화융성앱 게시시설관리  상세
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("manage/view.do")
	public String view(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		modelMap.addAttribute("paramMap", paramMap);
		
		List<Object> list = ckDatabaseService.readForList("culturepro.viewlist", paramMap);
		String info,title, desc, date = "";
		for (Object object : list) {
			CommonModel model = (CommonModel) object;
			info = (String) model.get("type_info");
			title = info.split("@@@---")[0];
			desc = info.split("@@@---")[1];
			date = info.split("@@@---")[2];
			model.put("title", title);
			model.put("desc", desc);
			model.put("date", date);
		}
		modelMap.addAttribute("view", ckDatabaseService.readForObject("culturepro.view", paramMap));
		modelMap.addAttribute("viewlist", list);
		
		return "/culturepro/manage/view";
	}
	
	/**
	 * 문화융성앱 게시시설관리 연결설정
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("manage/form.do")
	public String form(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		List<Object> list = ckDatabaseService.readForList("culturepro.viewlist", paramMap);
		String info,title, desc, date = "";
		for (Object object : list) {
			CommonModel model = (CommonModel) object;
			info = (String) model.get("type_info");
			title = info.split("@@@---")[0];
			desc = info.split("@@@---")[1];
			date = info.split("@@@---")[2];
			model.put("title", title);
			model.put("desc", desc);
			model.put("date", date);
		}
		
		modelMap.addAttribute("paramMap", paramMap);
		
		modelMap.addAttribute("formlist", list);
		
		return "/culturepro/manage/form";
	}

	/**
	 * 문화융성앱 게시시설관리 시설 목록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("manage/popup/facilityList.do")
	public String facilityList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("culturepro.facilitylistCnt", paramMap));
		model.addAttribute("list", ckDatabaseService.readForList("culturepro.facilitylist", paramMap));
		
		return "/culturepro/manage/popup/facilityList";
	}
	
	/**
	 * 문화융성앱 게시시설관리 추가 연결
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("manage/mappingInsert.do")
	public String mappingInsert(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));		
//		ckDatabaseService.insert("culturepro.mappingInsert", paramMap);
		ckDatabaseService.save("culturepro.mappingUpdate", paramMap);
		
		model.addAttribute("paramMap", paramMap);
		
		return "redirect:/culturepro/manage/form.do?g_seq=" + request.getParameter("g_seq");
	}
	
	/**
	 * 문화융성앱 게시시설관리 연결해제
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("manage/mappingRelease.do")
	public String mappingRelease(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));	

		int new_g_seq = (Integer) ckDatabaseService.insert("culturepro.insert", paramMap);
		
		HashMap<String , Object> param = new HashMap<String, Object>();
		param.put("new_g_seq", new_g_seq);
		param.put("g_seq", request.getParameter("g_seq"));
		param.put("m_seq", request.getParameter("m_seq"));
		param.put("reg_id", request.getSession().getAttribute("admin_id"));
		
		ckDatabaseService.save("culturepro.mappingRelease", param);
		
		model.addAttribute("paramMap", paramMap);

		return "redirect:/culturepro/manage/form.do";
	}
	
	/**
	 * 문화융성앱 게시시설관리 연결해제
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("manage/delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		
		int new_g_seq = 0;
		String facility_seq[] = request.getParameterValues("facility_seq");
		
		for(int i=0; i<facility_seq.length; i++){
			HashMap<String , Object> param = new HashMap<String, Object>();
			
			new_g_seq = (Integer) ckDatabaseService.insert("culturepro.insert", paramMap);
									
			param.put("new_g_seq", new_g_seq);
			param.put("g_seq", request.getParameter("g_seq"));
			param.put("m_seq", facility_seq[i]);
			param.put("reg_id", request.getSession().getAttribute("admin_id"));
						
			ckDatabaseService.save("culturepro.mappingRelease", param);
		}
		
		ckDatabaseService.delete("culturepro.delete", paramMap);
		
		return "redirect:/culturepro/manage/list.do";
	}
	
	/**
	 * 문화융성앱 게시시설관리 컨텐츠 상태 변경
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("manage/statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		String[] seqArr = paramMap.getArray("seq");
		for (String seq : seqArr) {
			paramMap.put("key", seq);
			ckDatabaseService.save("culturepro.statusUpdate", paramMap);
		}

		SessionMessage.update(request);

		if( "Y".equals(request.getParameter("targetView")) ){
			model.addAttribute("paramMap", paramMap);
			return "forward:/culturepro/manage/view.do";
		}
		
		return "forward:/culturepro/manage/list.do";
	}
	
	
	// ===========================================================
	// 문화 소식 관리
	// ===========================================================
	

}
