package kr.go.culture.culturepro.web;

import java.util.LinkedHashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.util.DateUtil;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/culturepro/cultureMember")
@Controller("CultureMemberController")
public class CultureMemberController {
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "FileService")
	private FileService fileService;

	/**
	 * 앱회원관리 리스트
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("list.do")
	public String allList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("member.listCnt", paramMap));
		model.addAttribute("list", ckDatabaseService.readForList("member.list", paramMap));
		return "/culturepro/member/list";
	}
	
	/**
	 * 앱회원관리 엑셀 다운로드
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/excel.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
	
		String[] headerArr = {"번호", "ID/고유키", "성별", "생년월일", "ID타입", "디바이스", "문화공지", "주변알림",  "개인알림", "앱회원가입일"};		
		//List<LinkedHashMap<String, Object>> list = service.readForLinkedList("invitationPerson.listByExcel", paramMap);

		model.addAttribute("fileNm", "appUser_"+DateUtil.getDateTime("YMD"));
		model.addAttribute("headerArr", headerArr);
		//model.addAttribute("excelList", list);	

		return "excelView";
	}

}
