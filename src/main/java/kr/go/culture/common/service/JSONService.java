package kr.go.culture.common.service;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.map.SerializationConfig;

import org.springframework.stereotype.Service;

@Service("JSONService")
public class JSONService {

	/**
	 * 
	 * <pre>
	 * 개요: json 데이타 beautifier
	 * 내용: json 데이타 beautifier
	 * </pre>
	 * @method beautifier
	 * @param str
	 * @return
	 * @return String
	 */
	public static String beautifier(String str) {
		String org = null;
		String result = null;

		ObjectMapper objectMapper = null;

		JsonNode tree = null;

		try {
			objectMapper = new ObjectMapper();
			objectMapper.configure(SerializationConfig.Feature.INDENT_OUTPUT,
					true);

			tree = objectMapper.readTree(str);
			result = objectMapper.writeValueAsString(tree);

		} catch (Exception e) {
			result = str.toString();
		}
		return result;
	}

	/**
	 * 
	 * <pre>
	 * 개요: json 데이타 beautifier
	 * 내용: json 데이타 beautifier
	 * </pre>
	 * @method beautifier
	 * @param hm
	 * @return
	 * @return String
	 */
	public static String beautifier(HashMap hm) {
		String org = null;
		String result = null;

		ObjectMapper objectMapper = null;

		JsonNode tree = null;

		try {
			objectMapper = new ObjectMapper();
			objectMapper.configure(SerializationConfig.Feature.INDENT_OUTPUT,
					true);

			org = JSONObject.fromObject(hm).toString();
			tree = objectMapper.readTree(org);
			result = objectMapper.writeValueAsString(tree);

		} catch (Exception e) {
			result = hm.toString();
		}
		return result;
	}

	/**
	 * 
	 * <pre>
	 * 개요: json 데이타 beautifier
	 * 내용: json 데이타 beautifier
	 * </pre>
	 * @method beautifier
	 * @param tree
	 * @return
	 * @return String
	 */
	public static String beautifier(JsonNode tree) {
		String result = null;

		ObjectMapper objectMapper = null;

		try {
			objectMapper = new ObjectMapper();
			objectMapper.configure(SerializationConfig.Feature.INDENT_OUTPUT,
					true);

			result = objectMapper.writeValueAsString(tree);

		} catch (Exception e) {
			result = tree.toString();
		}

		return result;
	}
}
