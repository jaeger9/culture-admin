package kr.go.culture.magazine.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.KiissDataBaseService;
import kr.go.culture.magazine.service.CultureAgreeDeleteService;
import kr.go.culture.magazine.service.CultureAgreeInsertService;
import kr.go.culture.magazine.service.CultureAgreeUpdateService;
import kr.go.culture.magazine.service.MagazineTagsProcService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/magazine/recomCulture")
public class CultureRecommandController {

	private static final Logger logger = LoggerFactory.getLogger(CultureRecommandController.class);
	
		
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	@Resource(name = "CultureAgreeInsertService")
	private CultureAgreeInsertService cultureAgreeInsertService;

	@Resource(name = "CultureAgreeUpdateService")
	private CultureAgreeUpdateService cultureAgreeUpdateService;

	@Resource(name = "CultureAgreeDeleteService")
	private CultureAgreeDeleteService cultureAgreeDeleteService;
	
	@Resource(name = "MagazineTagsProcService")
	private MagazineTagsProcService mtmService;
	
	@Resource(name = "KiissDataBaseService")
	private KiissDataBaseService kiissDataBaseService;
	

	//태그내 사용될 매뉴타입 코드
	private String default_menu_type = "1";
	
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		
		
		paramMap.put("common_code_type", "VOD_TYPE");
		model.addAttribute("VodCateList" ,  ckDatabaseService.readForList("common.codeList", paramMap));
		
		
		if(request.getParameter("idx")!=null){
			paramMap.put("idx",request.getParameter("idx").toString() );
			
			
			CommonModel tempMap = (CommonModel)kiissDataBaseService.readForObject("culture.recommand.recomVodView", paramMap);
			String idx = "";
			String rec_mov_idx ="";
			
			if(tempMap.get("rec_mov_idx")==null){
				idx = "";
			}else{
				idx = tempMap.get("rec_mov_idx").toString();
				if(idx.contains(",")){
					String[] arr_idx = idx.split(",");
					for(int i=0 ; i < arr_idx.length ; i++){
						if(arr_idx[i].equals("")){
							continue;
						}else{
							rec_mov_idx += arr_idx[i] + ",";
						}
					}
					rec_mov_idx = rec_mov_idx.substring(0, rec_mov_idx.length()-1);
				}else{
					rec_mov_idx = idx;
				}
			}
						
			paramMap.put("rec_mov_idx",rec_mov_idx);
			
			String[] recom_live_start_time;
			String[] recom_live_end_time;
			String recom_live_start_hour=null;
			String recom_live_start_min=null;
			String recom_live_end_hour=null;
			String recom_live_end_min=null;
			
			
			if(tempMap.get("recom_live_start_time")!=null){
				recom_live_start_time = tempMap.get("recom_live_start_time").toString().split(":");
				recom_live_start_hour = recom_live_start_time[0];
				recom_live_start_min = recom_live_start_time[1];
			}
			if(tempMap.get("recom_live_end_time")!=null){
				recom_live_end_time = tempMap.get("recom_live_end_time").toString().split(":");
				recom_live_end_hour = recom_live_end_time[0];
				recom_live_end_min = recom_live_end_time[1];
			}
			
			
			
			paramMap.put("recom_live_start_hour",recom_live_start_hour);
			paramMap.put("recom_live_start_min",recom_live_start_min);
			paramMap.put("recom_live_end_hour",recom_live_end_hour);
			paramMap.put("recom_live_end_min",recom_live_end_min);
			
			model.addAttribute("view", kiissDataBaseService.readForObject("culture.recommand.recomVodView", paramMap));
			if(tempMap.get("rec_mov_idx")!=null){
				model.addAttribute("recomList", kiissDataBaseService.readForList("culture.recommand.recomDetailList", paramMap));
			}else{
				model.addAttribute("recomList","null");
			}
			
		}
		
		model.addAttribute("paramMap", paramMap);
		return "/magazine/recomCulture/update";
	}
	
	
	@RequestMapping("recomList.do") // 추천 조회
	public String recomList(HttpServletRequest request, ModelMap model) throws Exception {
		
		
		ParamMap paramMap = new ParamMap(request);
		try {
			
			
			if(request.getParameter("menu_type")==null || request.getParameter("menu_type").equals("")){
				paramMap.put("menu_type", default_menu_type);
			}else{
				paramMap.put("menu_type", request.getParameter("menu_type").toString());
			}
			
			if(request.getParameter("keyword")==null || request.getParameter("keyword").equals("")){
				paramMap.put("keyword", "");
			}else{
				paramMap.put("keyword", request.getParameter("keyword").toString());
			}
			
			if(request.getParameter("searchGubun")==null || request.getParameter("searchGubun").equals("")){
				paramMap.put("searchGubun", "");
			}else{
				paramMap.put("searchGubun", request.getParameter("searchGubun").toString());
			}
			
			
			paramMap.put("common_code_type", "VOD_TYPE");
			model.addAttribute("VodCateList" ,  ckDatabaseService.readForList("common.codeList", paramMap));
			model.addAttribute("paramMap", paramMap);
			
			
			setPagingNum(paramMap);
			
			
			model.addAttribute("list", kiissDataBaseService.readForList("culture.recommand.recomVodList", paramMap));
			model.addAttribute("count", kiissDataBaseService.readForObject("culture.recommand.recomVodListCnt", paramMap));
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return "/magazine/recomCulture/recomList";
	}
	
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model)
	throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		if(request.getParameterValues("seq")!=null){
			String param_rec_mov_idx[] = request.getParameterValues("seq");
			String rec_mov_idx="";
			for(int i=0; i < param_rec_mov_idx.length ; i++){
				rec_mov_idx +=param_rec_mov_idx[i]+",";
			}
			rec_mov_idx = rec_mov_idx.substring(0, rec_mov_idx.length()-1);
			paramMap.put("rec_mov_idx", rec_mov_idx);
		}
		
		
		String menu_type = request.getParameter("menu_type").toString() ;
		if(request.getParameter("menu_type")==null || request.getParameter("menu_type").equals("")){
			menu_type = default_menu_type;
		}else{
			menu_type = request.getParameter("menu_type").toString();
		}
		
		if(request.getParameter("recom_live_start_hour")!=null){
			paramMap.put("recom_live_start_time", request.getParameter("recom_live_start_hour").toString()+":"+request.getParameter("recom_live_start_min").toString());
			paramMap.put("recom_live_end_time", request.getParameter("recom_live_end_hour").toString()+":"+request.getParameter("recom_live_end_min").toString());
		}
		
		
		
				
		int idx = (Integer)kiissDataBaseService.readForObject("culture.recommand.incrementIdx",paramMap);
		paramMap.put("idx", idx);
		
				
		if(request.getSession().getAttribute("admin_id")!=null){
			paramMap.put("user_name", request.getSession().getAttribute("admin_id").toString());
		}
		
		setUccParamMap(paramMap);
		setPagingNum(paramMap);
		
		model.addAttribute("paramMap", paramMap);
		
		// 수정 
		if(request.getParameter("formstatus")!=null && !request.getParameter("formstatus").toString().equals("")){
			paramMap.put("idx", request.getParameter("idx").toString());
			kiissDataBaseService.save("culture.recommand.recomUpdate", paramMap);
			
		}
		// 등록
		else{
			kiissDataBaseService.save("culture.recommand.recomInsert", paramMap);
			
		}
		
		
		return "redirect:/magazine/recomCulture/recomList.do?menu_type="+menu_type;
	}
	
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model)
	throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		String param_rec_mov_idx[] = request.getParameterValues("seq");
		String rec_mov_idx="";
		for(int i=0; i < param_rec_mov_idx.length ; i++){
			rec_mov_idx +=param_rec_mov_idx[i]+",";
		}
		rec_mov_idx = rec_mov_idx.substring(0, rec_mov_idx.length()-1);
		
		String menu_type = request.getParameter("menu_type").toString() ;
		if(request.getParameter("menu_type")==null || request.getParameter("menu_type").equals("")){
			menu_type = default_menu_type;
		}else{
			menu_type = request.getParameter("menu_type").toString();
		}
		
		if(request.getParameter("idx")!=null){
			paramMap.put("rec_mov_idx", request.getParameter("idx").toString());
		}else{
			paramMap.put("rec_mov_idx", rec_mov_idx);
		}
		
					
		setUccParamMap(paramMap);
		setPagingNum(paramMap);
		
		model.addAttribute("paramMap", paramMap);
		
		kiissDataBaseService.delete("culture.recommand.recomDelete", paramMap);
			
		return "redirect:/magazine/recomCulture/recomList.do?menu_type="+menu_type;
	}
	
	@RequestMapping("approval.do")
	public String approval(HttpServletRequest request, ModelMap model)
	throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		String param_rec_mov_idx[] = request.getParameterValues("seq");
		String rec_mov_idx="";
		for(int i=0; i < param_rec_mov_idx.length ; i++){
			rec_mov_idx +=param_rec_mov_idx[i]+",";
		}
		rec_mov_idx = rec_mov_idx.substring(0, rec_mov_idx.length()-1);
		
		String menu_type = request.getParameter("menu_type").toString() ;
		if(request.getParameter("menu_type")==null || request.getParameter("menu_type").equals("")){
			menu_type = default_menu_type;
		}else{
			menu_type = request.getParameter("menu_type").toString();
		}
		
		paramMap.put("rec_mov_idx", rec_mov_idx);
		
				
				
		setUccParamMap(paramMap);
		setPagingNum(paramMap);
		
		if(request.getParameter("updateStatus")!=null){
			paramMap.put("approval_yn", request.getParameter("updateStatus").toString());
		}
		
		model.addAttribute("paramMap", paramMap);
		
		kiissDataBaseService.save("culture.recommand.approvalUpdate", paramMap);
		
		return "redirect:/magazine/recomCulture/recomList.do?menu_type="+menu_type;
	}
	
	
	private void setUccParamMap(ParamMap paramMap ) throws Exception { 
		String area_group = null;
		String culture_review = null;
		String job30 = null;
		String culture100 = null;
		String human_lecture = null;
			
		String menu_type = paramMap.getString("menu_type");
		
		//국내외영상 : 1/ 국내영상 : 2 / 국외영상 : 3 / 문화TV : 4 / 문화직업30 : 5 / 한국문화100 : 6 / 인문학강연 : 7
		if ("1".equals(menu_type)) {
			area_group="total";
		}else if ("2".equals(menu_type)) {
			area_group="0";
		}else if ("3".equals(menu_type)) {
			area_group="1";
		}else if ("4".equals(menu_type)) {
			culture_review="Y";
		}else if ("5".equals(menu_type)) {
			job30="Y";
		}else if ("6".equals(menu_type)) {
			culture100="Y";
		}else if ("7".equals(menu_type)) {
			human_lecture="Y";
		}
		
		
		paramMap.put("area_group", area_group);
		paramMap.put("culture_review", culture_review);
		paramMap.put("job30", job30);
		paramMap.put("culture100", culture100);
		paramMap.put("human_lecture", human_lecture);
	}
	
	
	private void setPagingNum(ParamMap paramMap) { 
		int pageNo = paramMap.getInt("page_no");
		int listUnit = paramMap.getInt("list_unit");
		
		paramMap.put("snum", (pageNo - 1) * listUnit + 1);
		paramMap.put("enum", pageNo * listUnit);
	}
}
