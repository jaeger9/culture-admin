package kr.go.culture.perform.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.perform.service.RecomDisplayInsertService;
import kr.go.culture.perform.service.RecomDisplayUpdateService;
import kr.go.culture.perform.service.RecomPlayInsertService;
import kr.go.culture.perform.service.RecomPlayUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/perform/recom/{menuType}")
@Controller("PerformRecomController")
public class RecomController {

	private static final Logger logger = LoggerFactory.getLogger(RecomController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	@Resource(name = "PerformRecomPlayInsertService")
	private RecomPlayInsertService playInsertService;

	@Resource(name = "PerformRecomPlayUpdateService")
	private RecomPlayUpdateService playUpdateService;

	@Resource(name = "PerformRecomDisplayInsertService")
	private RecomDisplayInsertService displayInsertService;

	@Resource(name = "PerformRecomDisplayUpdateService")
	private RecomDisplayUpdateService displayUpdateService;

	@Resource(name = "FileService")
	private FileService fileService;

	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model, @PathVariable("menuType") String menuType) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		setMenuCd(paramMap, menuType);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("theme.recomeListCnt", paramMap));
		model.addAttribute("list", ckDatabaseService.readForList("theme.recomeList", paramMap));

		return "/perform/recom/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model, @PathVariable("menuType") String menuType) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		setMenuCd(paramMap, menuType);

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("seq")) {
			model.addAttribute("view", ckDatabaseService.readForObject("theme.recomView", paramMap));
			model.addAttribute("subList", ckDatabaseService.readForList("theme.recomSubList", paramMap));
		}

		return "/perform/recom/" + menuType + "View";
	}

	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model, @PathVariable("menuType") String menuType) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		setMenuCd(paramMap, menuType);

		ckDatabaseService.save("theme.statusUpdate", paramMap);

		return "forward:/perform/recom/" + menuType + "/list.do";
	}

	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model, @PathVariable("menuType") String menuType, @RequestParam("uploadFile") MultipartFile[] multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		setMenuCd(paramMap, menuType);

		if (menuType.equals("play")) {
			playInsertService.insert(paramMap, multi);
		}

		if (menuType.equals("display")) {
			displayInsertService.insert(paramMap, multi);
		}

		SessionMessage.insert(request);

		return "redirect:/perform/recom/" + menuType + "/list.do";
	}

	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model, @PathVariable("menuType") String menuType, @RequestParam("uploadFile") MultipartFile[] multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		//이미지 삭제기능 추가
		if (paramMap.containsKey("imagedelete")) {
			fileService.deleteFile("theme", paramMap.getString("file_delete"));
		}

		setMenuCd(paramMap, menuType);

		if (menuType.equals("play")) {
			playUpdateService.update(paramMap, multi, (String) paramMap.get("seq"));
		}

		if (menuType.equals("display")) {
			displayUpdateService.update(paramMap, multi, (String) paramMap.get("seq"));
		}

		SessionMessage.update(request);

		return "redirect:/perform/recom/" + menuType + "/list.do";
	}

	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model, @PathVariable("menuType") String menuType) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		setMenuCd(paramMap, menuType);

		ckDatabaseService.delete("theme.delete", paramMap);
		ckDatabaseService.delete("theme.subDelete", paramMap);

		SessionMessage.delete(request);

		return "redirect:/perform/recom/" + menuType + "/list.do";
	}

	private void setMenuCd(ParamMap paramMap, String menuType) throws Exception {

		// java 1.6 이라 switch 문 쓰기가 거시기 허네...
		if (menuType.equals("play")) {
			paramMap.put("menu_cd", 1);
		} else if (menuType.equals("display")) {
			paramMap.put("menu_cd", 2);
		} else {
			throw new Exception("Menu Type Can not Support");
		}

		paramMap.put("menuType", menuType);
	}

}