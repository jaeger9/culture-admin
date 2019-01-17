package kr.go.culture.common.util;

import javax.servlet.http.HttpServletRequest;

public class SessionMessage {

	public static void message(HttpServletRequest request, String message) {
		request.getSession().setAttribute("SESSION_MESSAGE", message);
	}

	public static void invalid(HttpServletRequest request) {
		request.getSession().setAttribute("SESSION_MESSAGE", "요청값이 올바르지 않습니다.");
	}

	public static void empty(HttpServletRequest request) {
		request.getSession().setAttribute("SESSION_MESSAGE", "존재하지 않는 글입니다.");
	}

	public static void insert(HttpServletRequest request) {
		request.getSession().setAttribute("SESSION_MESSAGE", "등록이 완료되었습니다.");
	}

	public static void update(HttpServletRequest request) {
		request.getSession().setAttribute("SESSION_MESSAGE", "수정이 완료되었습니다.");
	}

	public static void delete(HttpServletRequest request) {
		request.getSession().setAttribute("SESSION_MESSAGE", "삭제가 완료되었습니다.");
	}

}