package kr.go.culture.magazine.web;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.UrlConnectionService;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.magazine.service.MagazineTagsProcService;
import kr.go.culture.magazine.service.WebzineDeleteService;
import kr.go.culture.magazine.service.WebzineInsertService;
import kr.go.culture.magazine.service.WebzineUpdateService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/magazine/webzine")
@Controller("WebzineController")
public class WebzineController {
	
	private static final Logger logger = LoggerFactory.getLogger(RecomCultureAgreeController.class);
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "WebzineInsertService")
	private WebzineInsertService webzineInsertService;
	
	@Resource(name = "WebzineUpdateService")
	private WebzineUpdateService webzineUpdateService;
	
	@Resource(name = "WebzineDeleteService")
	private WebzineDeleteService webzineDeleteService;

	@Resource(name = "UrlConnectionService")
	private UrlConnectionService urlConnectionService;
	
	@Resource(name = "MagazineTagsProcService")
	private MagazineTagsProcService mtmService;

	//태그내 사용될 매뉴타입 코드
	private static final String MENU_TYPE = "662";
	
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		//태그에 사용될 메뉴코드 추가
		paramMap.put("menuType", MENU_TYPE);
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("webzine.listCnt", paramMap));

		model.addAttribute("list",ckDatabaseService.readForList("webzine.list", paramMap));

		return "/magazine/webzine/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		//태그에 사용될 메뉴코드 추가
		paramMap.put("menuType", MENU_TYPE);
		
		model.addAttribute("paramMap", paramMap);

		paramMap.put("common_code_type", "PHONE");
		model.addAttribute("phoneList", ckDatabaseService.readForList("common.codeListSort", paramMap));

		paramMap.put("common_code_type", "TEMPLATE_TYPE");
		model.addAttribute("templateTypeList", ckDatabaseService.readForList("common.codeListSort", paramMap));


		if (paramMap.containsKey("seq")) {

			Map viewMap = new HashMap();

			viewMap = (Map) ckDatabaseService.readForObject("webzine.view", paramMap);

			String phone1 = "";
			String phone2 = "";
			String phone3 = "";

			if(viewMap.get("phone") != null) {
				phone1 = String.valueOf(viewMap.get("phone")).split("-")[0];
				phone2 = String.valueOf(viewMap.get("phone")).split("-")[1];
				phone3 = String.valueOf(viewMap.get("phone")).split("-")[2];
			}

			viewMap.put("phone1",phone1);
			viewMap.put("phone2",phone2);
			viewMap.put("phone3",phone3);
			System.out.println("viewMap = " + viewMap);
			model.addAttribute("view", viewMap);
			model.addAttribute("subList", ckDatabaseService.readForList("webzine.subList", paramMap));
			
			paramMap.put("menu_cd", "9");
			
			model.addAttribute("commentList", ckDatabaseService.readForList(
					"reply.list", paramMap));
			model.addAttribute("commentListCnt", ckDatabaseService.readForObject(
					"reply.listCnt", paramMap));

			//태그명 가져오기
			model.addAttribute("tagName", mtmService.selectTagMap(paramMap));
		} else {
			paramMap.put("common_code_type", "WEBZINE");
			
			model.addAttribute("emptyView", ckDatabaseService.readForObject(
					"webzine.emptyView", paramMap));
			
			model.addAttribute("emptySubList", ckDatabaseService.readForList("common.codeListSort", paramMap));
		}

		return "/magazine/webzine/view";
	}

	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			ckDatabaseService.save("webzine.statusUpdate", paramMap);

		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		return "forward:/magazine/webzine/list.do";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap model ,  @RequestParam("uploadFile") MultipartFile multi,  @RequestParam("uploadFileEvent") MultipartFile multiEvent)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);
		String phone = paramMap.getString("phone1")+"-"+paramMap.getString("phone2")+"-"+paramMap.getString("phone3");

		paramMap.put("phone",phone);
		try {
			
			webzineInsertService.insert(paramMap , multi, multiEvent);

			//태그 등록 프로세스 추가
			mtmService.insertTagMap(paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		SessionMessage.insert(request);
		
		return "redirect:/magazine/webzine/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap model ,  @RequestParam("uploadFile") MultipartFile multi,  @RequestParam("uploadFileEvent") MultipartFile multiEvent)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);
		String phone = paramMap.getString("phone1")+"-"+paramMap.getString("phone2")+"-"+paramMap.getString("phone3");

		paramMap.put("phone",phone);
		try {
			
			webzineUpdateService.update(paramMap , multi, multiEvent);

			//태그 등록 프로세스 추가
			mtmService.insertTagMap(paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		SessionMessage.update(request);
		
		return "redirect:/magazine/webzine/list.do";
	}
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);

		try {
			
			webzineDeleteService.delete(paramMap );
			
			
			

			//태그삭제 프로세스 추가
			if(paramMap.getArray("seqs")!=null || paramMap.getArray("array.boardSeq")!=null)
				mtmService.deleteTagMap(paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}

		SessionMessage.delete(request);
		
		return "redirect:/magazine/webzine/list.do";
	}
	
	@RequestMapping("html.do")
	public void html(HttpServletRequest request, HttpServletResponse response ) throws Exception { 
		
		ParamMap paramMap = new ParamMap(request);
		
		String html = "";
		html = urlConnectionService.readData("https://www.culture.go.kr/magazine/webzinePreview.do?seq=" + paramMap.getString("seq"), null);
//		response.setContentType("application/x-msdownload; charset=UTF-8");
		response.setContentType("application/octet-stream; charset=UTF-8");
		
		
		response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode("webzine.html", "UTF-8") + ";");
		
		
		/*
		System.out.println("html:" + html);
		PrintWriter printwriter = response.getWriter();
		printwriter.write(html);
		printwriter.flush();
		printwriter.close();
		*/
		OutputStreamWriter out = null;
		try {
			out = new OutputStreamWriter(response.getOutputStream(), "EUC-KR");
			// BufferedInputStream in2 = new BufferedInputStream((BufferedInputStream)in);

			// IOUtil.copy(hconn.getInputStream(), response.getOutputStream());

			out.write(html.toString());
			out.flush();
		} catch (IOException ie) {
			// nextStep = this.returnErrorPageEx("파일 다운로드 에러");
			System.out.println(ie);
			throw new RuntimeException(ie);
		} finally {
			if (out != null)
				try {
					out.close();
				} catch (IOException ie) {
				}
		}
	}
	
	@RequestMapping("mail.do")
	public String mail(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		if (paramMap.containsKey("seq")) { 
			model.addAttribute("mailbody", urlConnectionService.readData("https://www.culture.go.kr/magazine/webzinePreview.do?seq=" + paramMap.getString("seq"), null));
			model.addAttribute("view", ckDatabaseService.readForObject("webzine.view", paramMap));
			model.addAttribute("list",ckDatabaseService.readForList("portalMember.listByLetterExcel", paramMap));
		}
		model.addAttribute("paramMap", paramMap);

		return "/magazine/webzine/mail";
	}
	
}
