package kr.go.culture.login;

import kr.go.culture.common.util.MemberUtils;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.encoding.BaseDigestPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class MD5MessageDigestPasswordEncoder extends BaseDigestPasswordEncoder {

	public String encodePassword(String rawPass, Object salt) {
		return MemberUtils.pwdMD5incode(rawPass);
	}

	public boolean isPasswordValid(String encPass, String rawPass, Object salt) {
		String password1 = encPass;
		String password2 = encodePassword(rawPass, salt);
		boolean login = false;

		if (password1.trim().equals(password2)) {
			login = true;
		} else {
			throw new BadCredentialsException("아이디 또는 비밀번호가 올바르지 않습니다.");
		}

		return login;
	}

}