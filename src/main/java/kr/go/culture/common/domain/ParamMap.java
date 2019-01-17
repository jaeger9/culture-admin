package kr.go.culture.common.domain;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

public class ParamMap extends HashMap<String, Object> {

	private static final long serialVersionUID = 7434436874765081011L;

	private final String ARRAY = "array";
	private final String PAGE_NO = "page_no";
	private final String LIST_UNIT = "list_unit";
	private final String QS = "qs";
	private final String QR = "qr";
	private final String QR_ENC = "qr_enc";
	private final String QR_DEC = "qr_dec";
	private final String SESSION_ADMIN_ID = "session_admin_id";

	private void setDefaultParameter() {
		this.put(ARRAY, new HashMap<String, String[]>());
		this.put(PAGE_NO, 1);
		this.put(LIST_UNIT, 10);
		this.put(QS, "");
		this.put(QR, "");
		this.put(QR_ENC, "");
		this.put(QR_DEC, "");
	}

	public ParamMap() {
		setDefaultParameter();
	}

	public ParamMap(HttpServletRequest request) {
		this();
		setRequestParameter(request);
	}

	@SuppressWarnings({ "rawtypes" })
	public void setRequestParameter(HttpServletRequest request) {
		// this
		Enumeration em = null;
		String key = null;
		String[] values = null;

		// querystring
		String queryString = null;
		String queryResult = null;

		if (request != null) {
			// this
			em = request.getParameterNames();

			while (em.hasMoreElements()) {
				key = (String) em.nextElement();
				values = request.getParameterValues(key);

				if (values != null) {
					this.putArray(key, values);
					this.put(key, values[0]);
				}
			}

			// querystring
			queryString = request.getQueryString();

			if (queryString != null && !"".equals(queryString)) {
				try {
					this.put(QS, URLEncoder.encode(queryString.replace("&", "&amp;"), "UTF-8"));
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				}
			}

			queryResult = request.getParameter(QS);

			if (queryResult != null && !"".equals(queryResult)) {
				try {
					this.put(QR, queryResult);
					this.put(QR_ENC, URLEncoder.encode(queryResult.replace("&", "&amp;"), "UTF-8"));
					this.put(QR_DEC, URLDecoder.decode(queryResult, "UTF-8"));
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				}
			}

			this.put(SESSION_ADMIN_ID, request.getSession().getAttribute("admin_id"));
		}

		System.out.println("Url = " + request.getRequestURI());
		System.out.println("Querystring = " + request.getQueryString());
		System.out.println("ParamMap = " + this.toJSON());
	}

	@SuppressWarnings("unchecked")
	public String[] getArray(String key) {
		if (this.get(ARRAY) == null) {
			return null;
		}
		return ((HashMap<String, String[]>) this.get(ARRAY)).get(key);
	}

	@SuppressWarnings("unchecked")
	public void putArray(String key, String[] values) {
		if (this.get(ARRAY) == null) {
			this.put(ARRAY, new HashMap<String, String[]>());
		}
		((HashMap<String, String[]>) this.get(ARRAY)).put(key, values);
	}

	public int getPageNo() {
		return getInt(PAGE_NO);
	}

	public void putPageNo(int value) {
		this.put(PAGE_NO, value);
	}

	public int getListUnit() {
		return getInt(LIST_UNIT);
	}

	public void putListUnit(int value) {
		this.put(LIST_UNIT, value);
	}

	public String getQS() {
		return getString(QS);
	}

	public void putQS(String value) {
		this.put(QS, value);
	}

	public String getQR() {
		return getString(QR);
	}

	public void putQR(String value) {
		this.put(QR, value);
	}

	public String getQREnc() {
		return getString(QR_ENC);
	}

	public void putQREnc(String value) {
		this.put(QR_ENC, value);
	}

	public String getQRDec() {
		return getString(QR_DEC);
	}

	public void putQRDec(String value) {
		this.put(QR_DEC, value);
	}

	//

	public boolean isNull(String key) {
		return this.get(key) == null;
	}

	public boolean isNotNull(String key) {
		return !this.isNull(key);
	}

	public boolean isBlank(String key) {
		if (this.get(key) == null || "".equals(this.get(key).toString().trim())) {
			return true;
		}
		return false;
	}

	public boolean isNotBlank(String key) {
		return !this.isBlank(key);
	}

	public String getString(String key) {
		return getString(key, "");
	}

	public String getString(String key, String defaultValue) {
		if (this.get(key) != null && !"".equals(this.get(key))) {
			return this.get(key).toString();
		}
		return defaultValue;
	}

	public int getInt(String key) {
		return getInt(key, 0);
	}

	public int getInt(String key, int defaultValue) {
		if (this.get(key) != null) {
			try {
				// return (Integer) this.get(key);
				return Integer.parseInt(this.get(key).toString());
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}
		}
		return defaultValue;
	}

	public float getFloat(String key) {
		return getFloat(key, 0);
	}

	public float getFloat(String key, float defaultValue) {
		if (this.get(key) != null) {
			try {
				return Float.parseFloat(this.get(key).toString());
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}
		}
		return defaultValue;
	}

	public double getDouble(String column) {
		return getDouble(column, 0);
	}

	public double getDouble(String key, double defaultValue) {
		if (this.get(key) != null) {
			try {
				return Double.parseDouble(this.get(key).toString());
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}
		}
		return defaultValue;
	}

	public long getLong(String key) {
		return getLong(key, 0);
	}

	public long getLong(String key, long defaultValue) {
		if (this.get(key) != null) {
			try {
				// return (Long) this.get(key);
				return Long.parseLong(this.get(key).toString());
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}
		}
		return defaultValue;
	}

	public String toJSON() {
		return JSONObject.fromObject(this).toString(4);
	}

}