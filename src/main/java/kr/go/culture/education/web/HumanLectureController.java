package kr.go.culture.education.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.education.service.HumanLectureDeleteService;
import kr.go.culture.education.service.HumanLectureInsertService;
import kr.go.culture.education.service.HumanLectureUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/education/humanLecture")
@Controller("HumanLectureController")
public class HumanLectureController {

	private static final Logger logger = LoggerFactory
			.getLogger(HumanLectureController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "HumanLectureInsertService")
	private HumanLectureInsertService humanLectureInsertService;
	
	@Resource(name = "HumanLectureUpdateService")
	private HumanLectureUpdateService humanLectureUpdateService;
	
	@Resource(name = "HumanLectureDeleteService")
	private HumanLectureDeleteService humanLectureDeleteService;
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("menu_cd", 9);
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject(
				"human_lecture.recomeListCnt", paramMap));
		model.addAttribute("list",
				ckDatabaseService.readForList("human_lecture.recomeList", paramMap));
		
		return "/education/humanLecture/list";
	}
	
	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("menu_cd", 9);

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("seq")) {
			model.addAttribute("view", ckDatabaseService.readForObject(
					"human_lecture.recomView", paramMap));

			model.addAttribute("subList", ckDatabaseService.readForList(
					"human_lecture.recomSubList", paramMap));

		}

		return "/education/humanLecture/view";
	}

	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("menu_cd", 9);

		ckDatabaseService.save("human_lecture.statusUpdate", paramMap);

		return "forward:/education/humanLecture/list.do";
	}

	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model,
			@RequestParam("uploadFile") MultipartFile multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("menu_cd", 9);

		humanLectureInsertService.insert(paramMap, multi);

		return "redirect:/education/humanLecture/list.do";
	}

	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model,
			@RequestParam("uploadFile") MultipartFile multi) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("menu_cd", 9);

		humanLectureUpdateService.update(paramMap, multi);
		
		return "redirect:/education/humanLecture/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("menu_cd", 9);

		humanLectureDeleteService.delete(paramMap);

		return "redirect:/education/humanLecture/list.do";
	}
}
