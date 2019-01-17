package kr.go.culture.common.util;

import java.security.MessageDigest;

public class MemberUtils {

	@SuppressWarnings("restriction")
	public static String pwdMD5incode(String password) {
		byte[] inputBytes = null;
		byte[] digest = null;

		MessageDigest md5 = null;
		sun.misc.BASE64Encoder encoder = null;

		String passwordMD5 = "";

		if (password != null && password.trim().length() > 0) {
			byte sec1[] = password.getBytes();
			for (int i = 1; i < sec1.length; i++) {
				password += " " + sec1[i];
			}

			try {
				inputBytes = password.getBytes("UTF8");

				md5 = MessageDigest.getInstance("MD5");
				md5.update(inputBytes);

				digest = md5.digest();
				encoder = new sun.misc.BASE64Encoder();

				passwordMD5 = encoder.encode(digest);
				md5.reset();

			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			passwordMD5 = null;
		}

		return passwordMD5;
	}

}