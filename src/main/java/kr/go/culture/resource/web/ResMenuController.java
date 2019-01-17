package kr.go.culture.resource.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.facility.web.PlaceController;
import kr.go.culture.resource.service.ResMenuService;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/resource/menu")
@Controller
public class ResMenuController {

	private static final Logger logger = LoggerFactory.getLogger(PlaceController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@Autowired
	private ResMenuService menuService;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		String pageTypes[] = {"A","B","C"};
		
		model.addAttribute("paramMap", paramMap);
		paramMap.putArray("page_type", pageTypes);
		//게시판형 리스트를 가져다 쓰려니 99999로 강제변경 해준다...
		paramMap.put("list_unit","9999999");
		model.addAttribute("pageList", service.readForList("resPage.list", paramMap));

		return "/resource/menu/list";
	}

	// , method = RequestMethod.GET
	@RequestMapping(value = "/menujson.do")
	@ResponseBody
	public Map<String, Object> menujson(String pseq, ModelMap model) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		ParamMap paramMap = new ParamMap();
		paramMap.put("pseq", pseq);
		
		result.put("menu", service.readForList("resMenu.listByTree", paramMap));
		return result;
	}


	@RequestMapping(value = "/insertjson.do")
	@ResponseBody
	public JSONObject insertjson(HttpServletRequest request, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		ParamMap paramMap = new ParamMap(request);
		paramMap.put("user_id", request.getSession().getAttribute("admin_id") == null ? "관리자" : request.getSession().getAttribute("admin_id"));

		if( "".equals(paramMap.get("seq")) || paramMap.get("seq") == null ){
			//seq가 없으면 insert
			service.insert("resMenu.insert", paramMap);
		}else{
			//seq가 없으면 update
			service.save("resMenu.update", paramMap);
		}

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/removejson.do")
	@ResponseBody
	public JSONObject removejson(String seq, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		ParamMap paramMap = new ParamMap();
		paramMap.put("seq", seq);

		// 삭제flag를 Y로 변경
		service.save("resMenu.delete", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/sortjson.do")
	@ResponseBody
	public JSONObject sortjson(HttpServletRequest request, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		ParamMap paramMap = new ParamMap(request);
		paramMap.put("user_id", request.getSession().getAttribute("admin_id") == null ? "관리자" : request.getSession().getAttribute("admin_id"));

		menuService.updateMenuSort(paramMap);

		jo.put("success", true);
		return jo;
	}
}