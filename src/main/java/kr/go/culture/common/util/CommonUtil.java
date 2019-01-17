package kr.go.culture.common.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public class CommonUtil {

	public static boolean isEmpty(String target) {
		return ((target == null) || (target.length() == 0));
	}

	public static boolean isEmptyTrim(String target) {
		return ((target == null) || (target.trim().length() == 0));
	}

	public static boolean isNotEmpty(String target) {
		return (!(isEmpty(target)));
	}

	public static boolean isNotEmptyTrim(String target) {
		return (!(isEmptyTrim(target)));
	}
	
	public static String nullStr(String target, String defaultValue) {
		String rtnStr = "";
		if (isEmpty(target))
			rtnStr = defaultValue;
		else {
			rtnStr = target;
		}
		return rtnStr;
	}

	public static String replaceStr(String target, String search, String change) {
		StringBuffer str = new StringBuffer("");
		int end = 0;
		int begin = 0;
		if ((target == null) || (target.equals("")))
			return target;
		while (true) {
			end = target.indexOf(search, begin);
			if (end == -1) {
				end = target.length();
				str.append(target.substring(begin, end));
				break;
			}
			str.append(target.substring(begin, end) + change);
			begin = end + search.length();
		}
		return str.toString();
	}	
	
	public static String replaceBR(String target) {
		String rtnValue = "";
		try {
			rtnValue = target.replaceAll("\r\n", "<br/>");
			rtnValue = target.replaceAll("\r", "<br/>");
			rtnValue = target.replaceAll("\n", "<br/>");
		} catch (Exception e) {
			rtnValue = "";
		}
		return rtnValue;
	}

	public static String replaceNotBR(String target) {
		if (isEmpty(target))
			return "";
		target = target.replaceAll("\r", "").replaceAll("\n", "")
				.replaceAll("\"", "'");
		return target;
	}

	public static String removeHtml(String target) {
		String result = target;
		return result.replaceAll(
				"<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
	}

	public static String banHtmlTag(String target) {
		String result = target;
		return result.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
	}
	
	/**
	 * HttpURLConnection
	 * @param strUrl
	 * @return
	 * @throws Exception
	 */
	public static Map<String, Object> getURLConnection(String strUrl) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		String status = "fail";		
		String res = "";
		String msg = "";
		int responseCode = 0;

		HttpURLConnection httpURLConn = null;
		
		try {
			URL url = new URL(strUrl);
			httpURLConn = (HttpURLConnection) url.openConnection();
			responseCode = httpURLConn.getResponseCode();
			msg = httpURLConn.getResponseMessage();
			
			if(responseCode == HttpURLConnection.HTTP_OK) {
				InputStream inputStream = httpURLConn.getInputStream();
				BufferedReader bufferReder = new BufferedReader(new InputStreamReader(inputStream));
				StringBuffer sb = new StringBuffer();
				String tmpStr = "";
				char lf = '\n';
				while ((tmpStr = bufferReder.readLine()) != null) {
					sb.append(tmpStr+lf);				
				}
				status = "success";
				res = sb.toString();
			}			
		} catch (Exception e) {
			e.printStackTrace();
			msg = e.getMessage();
		} finally {
			if(httpURLConn != null) {
				httpURLConn.disconnect();
			}
		}
		
		map.put("status", status);
		map.put("msg", msg);
		map.put("res", res);
		
		return map;
	}
	
	public static String getClientIP(HttpServletRequest request) {
		String ip = request.getHeader("X-FORWARDED-FOR");
		if (ip == null || ip.length() == 0) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0) {
			ip = request.getHeader("WL-Proxy-Client-IP");  // 웹로직
		}
		if (ip == null || ip.length() == 0) {
			ip = request.getRemoteAddr() ;
		}
		return ip;
	}
	
}
