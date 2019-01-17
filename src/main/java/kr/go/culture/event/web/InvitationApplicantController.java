package kr.go.culture.event.web;

import java.util.LinkedHashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.DateUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/event/invitationApplicant")
@Controller
public class InvitationApplicantController {

	private static final Logger logger = LoggerFactory.getLogger(InvitationApplicantController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/excel.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		if(request.getParameter("win_yn").equals("Y")){
			paramMap.put("win_yn", "Y");
			//model.addAttribute("win_yn", "Y");
			model.addAttribute("fileNm", "이벤트당첨자목록_"+DateUtil.getDateTime("YMD"));
		}else{
			paramMap.put("win_yn", null);
			model.addAttribute("fileNm", "이벤트참여자목록_"+DateUtil.getDateTime("YMD"));
		}
		
		String[] headerArr = {"번호", "당첨횟수", "회원명", "회원아이디", "연락처", "내용", "이메일", "거주지역", "포인트", "등록일"};	
		List<LinkedHashMap<String, Object>> list = service.readForLinkedList("invitationPerson.listByExcel", paramMap);

		model.addAttribute("headerArr", headerArr);
		model.addAttribute("excelList", list);	

		return "excelView";
	}

}