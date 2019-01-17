package kr.go.culture.magazine.web;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.KiissDataBaseService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/magazine/tag")
@Controller("CultureImageTagController")
public class CultureImageTagController {

	private static final Logger logger = LoggerFactory.getLogger(CultureImageTagController.class);

	@Resource(name="KiissDataBaseService")
	KiissDataBaseService kiissDataBaseService;

	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("list_unit", 30);
		
		model.addAttribute("paramMap", paramMap);
		setPagingNum(paramMap);
		
		model.addAttribute("count", (Integer) kiissDataBaseService.readForObject(
				"tag.listCnt", paramMap));

		model.addAttribute("list",
				kiissDataBaseService.readForList("tag.list", paramMap));
		model.addAttribute("recomTagLibList",
				kiissDataBaseService.readForList("tag.recomTagLibList", paramMap));
		
		
		return "/magazine/tag/list";
	}
	
	@RequestMapping("pdlist.do")
	public String pdlist(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		setPagingNum(paramMap);
		model.addAttribute("paramMap", paramMap);
		
		model.addAttribute("count", (Integer) kiissDataBaseService.readForObject(
				"tag.culturePdListCnt", paramMap));

		model.addAttribute("list",
				kiissDataBaseService.readForList("tag.culturePdList", paramMap));
		model.addAttribute("tagView",
				kiissDataBaseService.readForObject("tag.view", paramMap));
		
		
		return "/magazine/tag/pdList";
	}
	
	@RequestMapping("pdview.do")
	public String pdview(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		model.addAttribute("paramMap", paramMap);

		model.addAttribute("view",
				kiissDataBaseService.readForObject("tag.culturePdView", paramMap));
		
		model.addAttribute("tags",
				kiissDataBaseService.readForList("tag.culturePdTags", paramMap));
		model.addAttribute("site",
				kiissDataBaseService.readForObject("tag.culturePdSite", paramMap));
		model.addAttribute("cmntList",
				kiissDataBaseService.readForObject("tag.cmntList", paramMap));
		
		return "/magazine/tag/pdView";
	}
	
	@RequestMapping("selectedTagInfo.do") 
	public @ResponseBody List<Object> selectedTagInfo (HttpServletRequest request) throws Exception  {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.putArray("seq", paramMap.getArray("seq[]"));
		
		return kiissDataBaseService.readForList("tag.selectedTagInfo", paramMap);
	}
	
	@RequestMapping("distribute.do") 
	public String distribute(HttpServletRequest request, ModelMap model) throws Exception  {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("recomeYn", "N");
		kiissDataBaseService.save("tag.updateTagLibRecome" , paramMap);
		
		paramMap.put("recomeYn", "Y");
		kiissDataBaseService.save("tag.updateTagLibRecome" , paramMap);
		
//		updateTagLibRecome
		return "redirect:/magazine/tag/list.do";
	}
	
	@RequestMapping("updateTagName.do")
	public @ResponseBody HashMap<String , String> updateTagName(HttpServletRequest request) throws Exception  {
		
		ParamMap paramMap = new ParamMap(request);
		HashMap<String , String> rData = new HashMap<String , String>();
		
		kiissDataBaseService.save("tag.updateTagName" , paramMap);
		
		rData.put("success", "Y");
		
		return rData;
	}
	
	private void setPagingNum(ParamMap paramMap) { 
		int pageNo = paramMap.getInt("page_no");
		int listUnit = paramMap.getInt("list_unit");
		
		paramMap.put("snum", (pageNo - 1) * listUnit + 1);
		paramMap.put("enum", pageNo * listUnit);
	}
}
