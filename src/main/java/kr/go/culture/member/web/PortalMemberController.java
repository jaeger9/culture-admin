package kr.go.culture.member.web;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.DateUtil;
import kr.go.culture.common.util.MailUtil;
import kr.go.culture.common.util.SessionMessage;
import kr.go.culture.member.service.PortalMemberService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@RequestMapping("/member/portal")
@Controller
public class PortalMemberController {

	private static final Logger logger = LoggerFactory.getLogger(PortalMemberController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@Resource(name = "PortalMemberService")
	private PortalMemberService portalMemberService;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("portalMember.count", paramMap));
		model.addAttribute("list", service.readForList("portalMember.list", paramMap));

		return "/member/portal/list";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;

		// user_id가 null이 아닌 경우 조회해서 없을 경우 존재하지 않는 글
		if (paramMap.isNotBlank("user_id")) {
			resultMap = (CommonModel) service.readForObject("portalMember.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/member/portal/list.do";
			}
		} else {
			SessionMessage.empty(request);
			return "redirect:/member/portal/list.do";
		}

		portalMemberService.setMemberInfo(resultMap);
		portalMemberService.setMemberCategory(model);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		return "/member/portal/form";
	}

	@RequestMapping(value = "/form.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		CommonModel resultMap = null;

		if (paramMap.isNotBlank("user_id")) {
			resultMap = (CommonModel) service.readForObject("portalMember.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/member/portal/list.do";
			}

			// update
			service.save("portalMember.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			SessionMessage.empty(request);
			return "redirect:/member/portal/list.do";
		}

		return "redirect:/member/portal/form.do?user_id=" + paramMap.getString("user_id") + "&qs=" + paramMap.getQREnc();
	}

	@RequestMapping("/letterExcel.do")
	public String letterExcel(ModelMap model) throws Exception {
			
		String[] headerArr = {"번호", "아이디", "이름", "이메일"};
		
		List<LinkedHashMap<String, Object>> list = service.readForLinkedList("portalMember.listByLetterExcel", null);
				
		model.addAttribute("fileNm", "newsLetterMember_"+DateUtil.getDateTime("YMD"));
		model.addAttribute("headerArr", headerArr);
		model.addAttribute("excelList", list);	
		
		return "excelView";
	}

	@RequestMapping("/memberExcel.do")
	public String memberExcel(ModelMap model) throws Exception {

		String[] headerArr = {"번호", "아이디", "가입일", "가입구분", "이름", "성별", "출생년도", "휴대전화번호", "이메일", "뉴스레터 수신여부", "거주지역" ,"문화포털포인트"};
		
		List<LinkedHashMap<String, Object>> list = service.readForLinkedList("portalMember.listByMemberExcel", null);
				
		model.addAttribute("fileNm", "member_"+DateUtil.getDateTime("YMD"));
		model.addAttribute("headerArr", headerArr);
		model.addAttribute("excelList", list);	

		portalMemberService.setMemberCategory(model);
		return "excelView";
	}
	
	/**
	 * 홈 > 회원서비스 > 비밀번호 찾기 폼
	 * @param join
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	
	@RequestMapping(value="/sendMail.do")
	public String findPw(HttpServletRequest request,ModelMap model) 
		throws Exception{
		
		String url 		= "retUrl=/member/findPw.do&msg=";
		boolean pass 	= true;
		String encrypt = "";
		ParamMap paramMap = new ParamMap(request);
		
		//model.addAttribute("list", service.readForList("portalMember.dormancyList", paramMap));
		/**
		List commonResult = service.readForList("portalMember.dormancyList", paramMap);
		
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		System.out.println(commonResult.size());
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	
		for(int i=0; i < commonResult.size() ; i++){
			CommonModel tempMap = (CommonModel)commonResult.get(i);
			System.out.println("user_id:"+tempMap.get("user_id")+"/email:"+tempMap.get("email"));
			//메일발송
			/**
			MailUtil mail = new MailUtil();
			String[][] text = new String[2][2];
			text[0][0] = "<name>";
			text[0][1] = tempMap.get("user_id");
			text[1][0] = "<pwd>";
			text[1][1] = "password";
			
			mail.sendMail(tempMap.get("email"), "webmaster@culture.go.kr", "문화포털 임시 비밀번호를 안내해드립니다.", text,1);
			
			
			paramMap.put("user_id", tempMap.get("user_id"));
			service.save("portalMember.mailDateUpdate", paramMap);
			
			//메일발송
			}
		**/
		
		//메일발송
		
		MailUtil mail = new MailUtil();
		String[][] text = new String[2][2];
		text[0][0] = "<name>";
		text[0][1] = "kkaddus";
		text[1][0] = "<pwd>";
		text[1][1] = "password";
		
		mail.sendMail("kkaddus@naver.com", "webmaster@culture.go.kr", "문화포털 임시 비밀번호를 안내해드립니다.", text,1);
		
		
		paramMap.put("user_id", "kkaddus");
		service.save("portalMember.mailDateUpdate", paramMap);
		
		//메일발송
		
		
		
		url = url.concat(java.net.URLEncoder.encode("가입 시 등록한 메일주소 kkaddus@naver.com로 임시 비밀번호가 발송되었습니다.", "UTF-8"));
		url = "redirect:/alertRdirect.do?".concat(url);
			
		return "redirect:/member/portal/list.do";
			
	}
	
	
}