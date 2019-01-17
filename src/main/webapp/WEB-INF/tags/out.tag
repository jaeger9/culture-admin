<%@
	tag body-content="scriptless" pageEncoding="UTF-8" dynamic-attributes="like, sure"
%><%@
	attribute name="text" required="true" type="java.lang.String" rtexprvalue="true"
%><%@
	attribute name="defaultValue" type="java.lang.String" rtexprvalue="true"
%><%@
	attribute name="prefix" type="java.lang.String" rtexprvalue="true"
%><%@
	attribute name="suffix" type="java.lang.String" rtexprvalue="true"
%><%@
	attribute name="ellipsis" type="java.lang.String" rtexprvalue="true"
%><%@
	attribute name="byteLength" type="java.lang.Integer" rtexprvalue="true"
%><%@
	attribute name="escapeXml" type="java.lang.Boolean" rtexprvalue="true"
%><%@
	attribute name="removeXml" type="java.lang.Boolean" rtexprvalue="true"
%><%@
	attribute name="replaceLfCr" type="java.lang.Boolean" rtexprvalue="true"
%><%@
	attribute name="removeXml2" type="java.lang.Boolean" rtexprvalue="true"
%><%@
	attribute name="removeXml3" type="java.lang.Boolean" rtexprvalue="true"
%><%!
	public boolean isBlank(String sValue) {
		if (sValue == null) {
			return true;
		}
		sValue = String.valueOf(sValue).trim();
		return ("null".equalsIgnoreCase(sValue) || "".equals(sValue));
	}

	public String cutByteLength(String sValue, int nLength, String ellipsis) {
		if (sValue == null) {
			return sValue;
		}

		if (nLength < 1) {
			return sValue;
		}

		if (ellipsis == null) {
			ellipsis = "";
		}

		StringBuffer sb = new StringBuffer(nLength);
		int i = 0;

		for (char c : sValue.toCharArray()) {
			i += String.valueOf(c).getBytes().length;
			if (i > nLength) {
				sb.append(ellipsis);
				break;
			}
			sb.append(c);
		}
		return sb.toString();
	}

	public String escapeXml(String sValue) {
		if (isBlank(sValue)) {
			return "";
		}
		sValue = sValue.replace("&", "&amp;");
		sValue = sValue.replace("<", "&lt;");
		sValue = sValue.replace(">", "&gt;");
		sValue = sValue.replace("\"", "&#034;");
		sValue = sValue.replace("'", "&#039;");
		return sValue;
	}
%><%

	if (defaultValue == null) {
		defaultValue = "";
	}
	if (byteLength == null) {
		byteLength = 0;
	}
	if (escapeXml == null) {
		escapeXml = false;
	}
	if (replaceLfCr == null) {
		replaceLfCr = false;
	}
	if (removeXml == null) {
		removeXml = false;
	}
	if (removeXml2 == null) {
		removeXml2 = false;
	}
	if (removeXml3 == null) {
		removeXml3 = false;
	}

	String result = String.valueOf(text).trim();

	if (removeXml) { // xml 모두 제거 후 글자 수 제한
		result = result.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replaceAll("<!--.*-->", "").trim();
	}

	if (isBlank(result)) {
		if (!isBlank(defaultValue)) {
			result = defaultValue;
		}
	} else {
		
		if (!isBlank(prefix)) {
			result = prefix + result;
		}

		if (!isBlank(suffix)) {
			result = result + suffix;
		}

		if (escapeXml) { // 글자 수 제한 후 xml replace
			result = escapeXml(result);
		}

		if (replaceLfCr) { // 글자수 제한 후 lfcr replace
			result = result.replaceAll("\\r?\\n", "<br />");
		}
		
		if (removeXml2) {
			result = result.replace("<", "&lt;");
			result = result.replace(">", "&gt;");
		}
		
		if (removeXml3) {
			result = result.replace("&lt;", "<");
			result = result.replace("&gt;", ">");
			result = result.replace("&amp;", "");
			result = result.replace("&nbsp;", "");
			result = result.replace("nbsp;", "");
			result = result.replaceAll("\\<.*?\\>","");
			result = result.replace("<", "&lt;");
			result = result.replace(">", "&gt;");
		}
		
		if (byteLength > 0) {
			result = cutByteLength(result, byteLength, ellipsis);
		}

	}

	result = result.trim();

	out.print(result);
%>