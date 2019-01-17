package kr.go.culture.festival.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.festival.service.RecomEventInsertService;
import kr.go.culture.festival.service.RecomEventUpdateService;
import kr.go.culture.festival.service.RecomFestivalInsertService;
import kr.go.culture.festival.service.RecomFestivalUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/festival/recom/{menuType}")
@Controller("FestivalRecomController")
public class RecomController {

	private static final Logger logger = LoggerFactory.getLogger(RecomController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	@Resource(name = "RecomFestivalInsertService")
	private RecomFestivalInsertService recomFestivalInsertService;

	@Resource(name = "RecomFestivalUpdateService")
	private RecomFestivalUpdateService recomFestivalUpdateService;

	@Resource(name = "RecomEventInsertService")
	private RecomEventInsertService recomEventInsertService;

	@Resource(name = "RecomEventUpdateService")
	private RecomEventUpdateService recomEventUpdateService;

	@Resource(name = "FileService")
	private FileService fileService;

	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model, @PathVariable("menuType") String menuType) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		setMenuCd(paramMap, menuType);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("theme.recomeListCnt", paramMap));
		model.addAttribute("list", ckDatabaseService.readForList("theme.recomeList", paramMap));

		return "/festival/recom/list";
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

		return "/festival/recom/" + menuType + "View";
	}

	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model, @PathVariable("menuType") String menuType) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		setMenuCd(paramMap, menuType);

		ckDatabaseService.save("theme.statusUpdate", paramMap);

		return "forward:/festival/recom/" + menuType + "/list.do";
	}

	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model, @PathVariable("menuType") String menuType, @RequestParam("uploadFile") MultipartFile[] multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		setMenuCd(paramMap, menuType);

		if (menuType.equals("festival")) {
			recomFestivalInsertService.insert(paramMap, multi);
		}

		if (menuType.equals("event")) {
			recomEventInsertService.insert(paramMap, multi);
		}

		SessionMessage.insert(request);

		return "redirect:/festival/recom/" + menuType + "/list.do";
	}

	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model, @PathVariable("menuType") String menuType, @RequestParam("uploadFile") MultipartFile[] multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		setMenuCd(paramMap, menuType);

		if (menuType.equals("festival")) {
			//이미지 삭제기능 추가
			if (paramMap.containsKey("imagedelete")) {
				fileService.deleteFile("theme", paramMap.getString("file_delete"));
			}
			
			recomFestivalUpdateService.update(paramMap, multi, (String) paramMap.get("seq"));
		}

		if (menuType.equals("event")) {
			recomEventUpdateService.update(paramMap, multi);
		}

		SessionMessage.update(request);

		return "redirect:/festival/recom/" + menuType + "/list.do";
	}

	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model, @PathVariable("menuType") String menuType) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		setMenuCd(paramMap, menuType);

		ckDatabaseService.delete("theme.delete", paramMap);
		ckDatabaseService.delete("theme.subDelete", paramMap);

		SessionMessage.delete(request);

		return "redirect:/festival/recom/" + menuType + "/list.do";
	}

	private void setMenuCd(ParamMap paramMap, String menuType) throws Exception {

		// java 1.6 이라 switch 문 쓰기가 거시기 허네...
		if (menuType.equals("festival")) {
			paramMap.put("menu_cd", 3);
		} else if (menuType.equals("event")) {
			paramMap.put("menu_cd", 4);
		} else {
			throw new Exception("Menu Type Can not Support");
		}

		paramMap.put("menuType", menuType);

	}

}
