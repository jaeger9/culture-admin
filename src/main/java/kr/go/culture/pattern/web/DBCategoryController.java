package kr.go.culture.pattern.web;

import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/pattern/db/category")
@Controller("DBCategoryController")
public class DBCategoryController {

	private static final Logger logger = LoggerFactory
			.getLogger(DBCategoryController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		
		model.addAttribute("paramMap", paramMap);
		
		if(!paramMap.containsKey("parentId"))paramMap.put("parentId", 2);
		
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject(
				"db.category.listCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("db.category.list", paramMap));
		
		ParamMap categoryMap = new ParamMap();
		categoryMap.put("parentId", 2);
		model.addAttribute("categoryList",
				ckDatabaseService.readForList("db.category.list", categoryMap));

		return "/pattern/db/category/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("id")) {
			model.addAttribute("view", ckDatabaseService.readForObject(
					"db.category.view", paramMap));
		}

		ParamMap categoryMap = new ParamMap();
		categoryMap.put("parentId", 2);
		model.addAttribute("categoryList",
				ckDatabaseService.readForList("db.category.list", categoryMap));
		
		return "/pattern/db/category/view";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("dcollectionguid", UUID.randomUUID().toString());

		model.addAttribute("paramMap", paramMap);
		ckDatabaseService.insert("db.category.insert", paramMap);
		
		SessionMessage.insert(request);
		
		return "redirect:/pattern/db/category/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		ckDatabaseService.insert("db.category.update", paramMap);
		
		SessionMessage.update(request);
		
		return "redirect:/pattern/db/category/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		ckDatabaseService.insert("db.category.delete", paramMap);
		
		SessionMessage.delete(request);
		
		return "redirect:/pattern/db/category/list.do";
	}
}
