package kr.go.culture.login.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.go.culture.common.util.SessionMessage;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller("LoginController")
public class LoginController {

	@RequestMapping("/login.do")
	public String login(HttpServletRequest request, HttpServletResponse response) {
		return "login/login";
	}

	@RequestMapping("/logout.do")
	public String logout(HttpSession session) {
		session.removeAttribute("admin_id");
		session.removeAttribute("userDetails");
		session.removeAttribute("admin_menu");
		if(session.getAttribute("fail_cnt") != null){
			session.setAttribute("fail_cnt", 0);
		}

		return "login/login";
	}

	@RequestMapping("/loginfailed.do")
	public String loginfailed(HttpServletRequest request) {
		HttpSession session = request.getSession();
		if(session.getAttribute("fail_cnt") != null){
			session.setAttribute("fail_cnt", (Integer)session.getAttribute("fail_cnt")+1);
		}else{
			session.setAttribute("fail_cnt", 1);
		}
		session.removeAttribute("admin_id");
		session.removeAttribute("userDetails");
		session.removeAttribute("admin_menu");
		
		if((Integer)session.getAttribute("fail_cnt") >= 3){
			SessionMessage.message(request, "비밀번호를 3회 이상 잘못 입력하셨습니다."
					+ "                                        "
					+ "시스템 관리자에게 문의해주시기 바랍니다.");
		}else{
			SessionMessage.message(request, "로그인 처리가 실패되었습니다.");
		}
		return "login/login";
	}

	@RequestMapping("/loginaccessdenied.do")
	public String loginaccessdenied(HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.removeAttribute("admin_id");
		session.removeAttribute("userDetails");
		session.removeAttribute("admin_menu");

		SessionMessage.message(request, "접근 권한이 없습니다. 다시 로그인 해주세요.");
		return "login/login";
	}

}